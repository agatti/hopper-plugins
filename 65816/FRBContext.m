/*
 Copyright (c) 2014, Alessandro Gatti - frob.it
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "FRBBase.h"
#import "FRBContext.h"
#import "FRBDefinition.h"
#import "FRBModelHandler.h"
#import "FRBProvider.h"
#import "FRBOperandFormatter.h"

// 65xxCommon library imports

#import "FRBCPUSupport.h"

// HopperCommon library imports

#import "FRBHopperCommon.h"
#import "FRBOperandFormatter.h"

static const NSArray *kOpcodeFormats;
static const ItFrobHopper65816ModelHandler *kModelHandler;

@interface ItFrobHopper65816Context () {
    id<CPUDefinition> _cpu;
    id<HPDisassembledFile> _file;
    id<HPHopperServices> _services;
    id<FRBProvider> _provider;
}

- (void)handleNonBranchOpcode:(const struct FRBOpcode *)opcode
                    forDisasm:(DisasmStruct *)disasm;
- (void)handleBranchOpcode:(const struct FRBOpcode *)opcode
                 forDisasm:(DisasmStruct *)disasm;
- (NSString *)formatInstruction:(DisasmStruct *)source;
- (void)setMemoryFlags:(DisasmStruct *)disasm
        forInstruction:(const struct FRBInstruction *)instruction;
- (NSString *)format:(FRBAddressMode)addressMode
              opcode:(NSString *)opcode
            operands:(NSArray *)operands;
- (void)updateShifts:(DisasmStruct *)disasm
           forOpcode:(const struct FRBOpcode *)opcode;

@end

@implementation ItFrobHopper65816Context

- (instancetype)initWithCPU:(id<CPUDefinition>)cpu
                    andFile:(id<HPDisassembledFile>)file
               withServices:(id<HPHopperServices>)services {
    if (self = [super init]) {
        _cpu = cpu;
        _file = file;
        _services = services;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kOpcodeFormats = [NSArray arrayWithObjects:
                              @"%@    %@",       // FRBAddressModeAbsolute
                              @"%@    %@,X",     // FRBAddressModeAbsoluteIndexedX
                              @"%@    %@,Y",     // FRBAddressModeAbsoluteIndexedY
                              @"%@    %@",       // FRBAddressModeAbsoluteLong
                              @"%@    %@,X",     // FRBAddressModeAbsoluteLongIndexed
                              @"%@    #%@",      // FRBAddressModeImmediate
                              @"%@    A",        // FRBAddressModeAccumulator
                              @"%@",             // FRBAddressModeImplied
                              @"%@",             // FRBAddressModeStack
                              @"%@    (%@)",     // FRBAddressModeAbsoluteIndirect
                              @"%@    %@",       // FRBAddressModeProgramCounterRelative
                              @"%@    %@",       // FRBAddressModeProgramCounterRelativeLong
                              @"%@    %@",       // FRBAddressModeDirect
                              @"%@    %@,X",     // FRBAddressModeDirectIndexedX
                              @"%@    %@,Y",     // FRBAddressModeDirectIndexedY
                              @"%@    (%@,X)",   // FRBAddressModeDirectIndexedIndirect
                              @"%@    (%@,Y)",   // FRBAddressModeDirectIndirectIndexedY
                              @"%@    (%@)",     // FRBAddressModeDirectIndirect
                              @"%@    [%@]",     // FRBAddressModeDirectIndirectLong
                              @"%@    [%@],Y",   // FRBAddressModeDirectIndirectLongIndexed
                              @"%@    (%@,X)",   // FRBAddressModeAbsoluteIndexedIndirect
                              @"%@    %@,S",     // FRBAddressModeStackRelative
                              @"%@    (%@,S),Y", // FRBAddressModeStackRelativeIndirectIndexed
                              @"%@    %@,%@",    // FRBAddressModeBlockMove
                              nil
                              ];
            kModelHandler = [ItFrobHopper65816ModelHandler sharedModelHandler];
        });

        NSString *providerName = [kModelHandler providerNameForFamily:file.cpuFamily
                                                         andSubFamily:file.cpuSubFamily];
        _provider = [kModelHandler providerForName:providerName];

        if (!_provider) {
            return nil;
        }
    }
    return self;
}

- (id<CPUDefinition>)cpuDefinition {
    return _cpu;
}

- (int)disassembleSingleInstruction:(DisasmStruct *)disasm
                 usingProcessorMode:(NSUInteger)mode {
    InitialiseDisasmStruct(disasm);

    disasm->instruction.pcRegisterValue = disasm->virtualAddr;
    uint8_t opcodeByte = [_file readUInt8AtVirtualAddress:disasm->virtualAddr];
    const struct FRBOpcode *opcode = [_provider opcodeForByte:opcodeByte];
    struct FRBInstruction instruction = FRBInstructions[opcode->type];
    disasm->instruction.userData = opcodeByte;
    if (opcode->addressMode == FRBAddressModeUnknown) {
        return DISASM_UNKNOWN_OPCODE;
    }

    disasm->instruction.branchType = instruction.branchType;

    strcpy(disasm->instruction.mnemonic, instruction.name);
    strcpy(disasm->instruction.unconditionalMnemonic, instruction.name);

    if (instruction.category == FRBOpcodeCategoryStatusFlagChanges) {
        switch (opcode->type) {
            case FRBOpcodeTypeCLC:
                disasm->instruction.eflags.CF_flag = DISASM_EFLAGS_RESET;
                break;

            case FRBOpcodeTypeCLD:
                disasm->instruction.eflags.DF_flag = DISASM_EFLAGS_RESET;
                break;

            case FRBOpcodeTypeCLI:
                disasm->instruction.eflags.IF_flag = DISASM_EFLAGS_RESET;
                break;

            case FRBOpcodeTypeCLV:
                disasm->instruction.eflags.OF_flag = DISASM_EFLAGS_RESET;
                break;

            case FRBOpcodeTypeSEC:
                disasm->instruction.eflags.CF_flag = DISASM_EFLAGS_SET;
                break;

            case FRBOpcodeTypeSED:
                disasm->instruction.eflags.DF_flag = DISASM_EFLAGS_SET;
                break;

            case FRBOpcodeTypeSEI:
                disasm->instruction.eflags.IF_flag = DISASM_EFLAGS_SET;
                break;

            default:
                break;
        }
    } else {
        if (opcode->type == FRBOpcodeTypeCOP) {
            disasm->instruction.eflags.DF_flag = DISASM_EFLAGS_RESET;
        }
    }

    disasm->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = opcode->readRegisters;
    disasm->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = opcode->writtenRegisters;
    disasm->instruction.length = FRBOpcodeLength[opcode->addressMode];

    if (instruction.branchType == DISASM_BRANCH_NONE) {
        [self handleNonBranchOpcode:opcode
                          forDisasm:disasm];
    } else {
        [self handleBranchOpcode:opcode
                       forDisasm:disasm];
    }

    [self updateShifts:disasm
             forOpcode:opcode];

    return disasm->instruction.length;
}

- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
    return [_provider haltsExecutionFlow:[_provider opcodeForByte:disasm->instruction.userData]];
}

- (void)buildInstructionString:(DisasmStruct *)disasm
                    forSegment:(NSObject<HPSegment> *)segment
                populatingInfo:(NSObject<HPFormattedInstructionInfo> *)formattedInstructionInfo {
    strcat(disasm->completeInstructionString, [self formatInstruction:disasm].UTF8String);
}

#pragma mark Extra methods

- (void)updateShifts:(DisasmStruct *)disasm
           forOpcode:(const struct FRBOpcode *)opcode {

    switch (opcode->type) {
        case FRBOpcodeTypeASL:
            disasm->operand[0].shiftMode = DISASM_SHIFT_LSL;
            disasm->operand[0].shiftAmount = 1;
            break;

        case FRBOpcodeTypeLSR:
            disasm->operand[0].shiftMode = DISASM_SHIFT_LSR;
            disasm->operand[0].shiftAmount = 1;
            break;

//        case FRBOpcodeTypeROL:
//            disasm->operand[0].shiftMode = DISASM_SHIFT_ROL;
//            disasm->operand[0].shiftAmount = 1;
//            break;

        case FRBOpcodeTypeROR:
            disasm->operand[0].shiftMode = DISASM_SHIFT_ROR;
            disasm->operand[0].shiftAmount = 1;
            break;

    

        default:
            break;
    }
}

- (void)handleNonBranchOpcode:(const struct FRBOpcode *)opcode
                    forDisasm:(DisasmStruct *)disasm {

    switch (opcode->addressMode) {
        case FRBAddressModeAbsolute:
        case FRBAddressModeAbsoluteIndirect:
            SetAddressOperand(_file, disasm, 0, 16, 24, 1, 0);
            break;

        case FRBAddressModeProgramCounterRelativeLong: {
            Address address = SignedValue(@([_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1]), 16);
            address += disasm->instruction.pcRegisterValue + disasm->instruction.length;

            disasm->operand[0].memory.baseRegister = 0;
            disasm->operand[0].memory.indexRegister = 0;
            disasm->operand[0].memory.scale = 1;
            disasm->operand[0].memory.displacement = 0;
            disasm->operand[0].type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand[0].size = 24;
            disasm->operand[0].immediateValue = address;
            [_file setFormat:Format_Address
                 forArgument:0
            atVirtualAddress:disasm->virtualAddr];
            break;
        }

        case FRBAddressModeAbsoluteLong:
        case FRBAddressModeAbsoluteLongIndexed:
            SetAddressOperand(_file, disasm, 0, 24, 24, 1, 0);
            break;

        case FRBAddressModeAbsoluteIndexedX:
            SetAddressOperand(_file, disasm, 0, 16, 24, 1, FRBRegisterX);
            break;

        case FRBAddressModeAbsoluteIndexedY:
            SetAddressOperand(_file, disasm, 0, 16, 24, 1, FRBRegisterY);
            break;

        case FRBAddressModeImmediate:
            SetConstantOperand(_file, disasm, 0, 8, 1);
            break;

        case FRBAddressModeDirectIndexedX:
        case FRBAddressModeDirectIndexedIndirect:
            SetAddressOperand(_file, disasm, 0, 8, 24, 1, FRBRegisterX);
            break;

        case FRBAddressModeDirect:
        case FRBAddressModeDirectIndirect:
        case FRBAddressModeStackRelative:
        case FRBAddressModeStackRelativeIndirectIndexed:
        case FRBAddressModeDirectIndirectLong:
        case FRBAddressModeDirectIndirectLongIndexed:
            SetAddressOperand(_file, disasm, 0, 8, 24, 1, 0);
            break;

        case FRBAddressModeDirectIndexedY:
        case FRBAddressModeDirectIndirectIndexedY:
            SetAddressOperand(_file, disasm, 0, 8, 24, 1, FRBRegisterY);
            break;

        case FRBAddressModeBlockMove:
            SetConstantOperand(_file, disasm, 0, 8, 1);
            SetConstantOperand(_file, disasm, 1, 8, 1 + sizeof(uint8_t));
            break;

        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;

        default:
            @throw [NSException exceptionWithName:FRBHopperExceptionName
                                           reason:[NSString stringWithFormat:@"Internal error: non-branch opcode with address mode %lu found", opcode->addressMode]
                                         userInfo:nil];
    }

    disasm->operand[0].accessMode = DISASM_ACCESS_NONE;
    const struct FRBInstruction instruction = FRBInstructions[opcode->type];

    switch (opcode->addressMode) {
        case FRBAddressModeImmediate:
        case FRBAddressModeProgramCounterRelative:
        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;

        default: {
            [self setMemoryFlags:disasm
                  forInstruction:&instruction];
            break;
        }
    }
}

- (void)handleBranchOpcode:(const struct FRBOpcode *)opcode
                 forDisasm:(DisasmStruct *)disasm {
    //uint16_t operand = 0;

    switch (opcode->addressMode) {

        case FRBAddressModeAbsoluteLong:
            disasm->instruction.addressValue = SetAddressOperand(_file, disasm, 0, 24, 24, 1, 0);
            break;

        case FRBAddressModeDirectIndirect:
            disasm->instruction.addressValue = SetAddressOperand(_file, disasm, 0, 8, 24, 1, 0);
            break;

        case FRBAddressModeAbsolute:
        case FRBAddressModeAbsoluteIndirect:
        case FRBAddressModeAbsoluteIndexedIndirect:
            disasm->instruction.addressValue = SetAddressOperand(_file, disasm, 0, 16, 24, 1, 0);
            break;

        case FRBAddressModeProgramCounterRelative:
            disasm->instruction.addressValue = SetRelativeAddressOperand(_file, disasm, 0, 8, 24, 1);
            break;

        case FRBAddressModeProgramCounterRelativeLong: {
            Address address = SignedValue(@([_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1]), 16);
            address += disasm->instruction.pcRegisterValue + disasm->instruction.length;

            disasm->operand[0].memory.baseRegister = 0;
            disasm->operand[0].memory.indexRegister = 0;
            disasm->operand[0].memory.scale = 1;
            disasm->operand[0].memory.displacement = 0;
            disasm->operand[0].type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand[0].size = 24;
            disasm->operand[0].immediateValue = address;
            [_file setFormat:Format_Address
                 forArgument:0
            atVirtualAddress:disasm->virtualAddr];
            break;
        }

        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;

        default:
            @throw [NSException exceptionWithName:FRBHopperExceptionName
                                           reason:[NSString stringWithFormat:@"Internal error: branch opcode with address mode %lu found", opcode->addressMode]
                                         userInfo:nil];
    }
}

- (NSString *)formatInstruction:(DisasmStruct *)source {

    NSMutableArray *strings = [NSMutableArray new];

    for (int index = 0; index < DISASM_MAX_OPERANDS; index++) {
        if (source->operand[index].type == DISASM_OPERAND_NO_OPERAND) {
            break;
        }

        NSNumber *number;
        if (source->operand[index].size == 64 && source->operand[index].immediateValue < 0) {
            // TODO: Check this!
            number = [NSNumber numberWithUnsignedLongLong:(source->operand[index].immediateValue - 18446744073709551615ULL) - 1ULL];
        } else {
            number = [NSNumber numberWithLongLong:source->operand[index].immediateValue];
        }

        ArgFormat format = [_file formatForArgument:index
                                   atVirtualAddress:source->virtualAddr];
        [strings addObject:FormatValue(number, source, format, source->operand[index].size, _services)];
    }

    const struct FRBOpcode *opcode = [_provider opcodeForByte:source->instruction.userData];
    return [self format:opcode->addressMode
                 opcode:[NSString stringWithUTF8String:FRBInstructions[opcode->type].name]
               operands:strings];
}

- (void)setMemoryFlags:(DisasmStruct *)disasm
        forInstruction:(const struct FRBInstruction *)instruction {

    switch (instruction->category) {
        case FRBOpcodeCategoryLoad:
        case FRBOpcodeCategoryComparison:
        case FRBOpcodeCategoryLogical:
        case FRBOpcodeCategoryArithmetic:
            disasm->operand[0].accessMode = DISASM_ACCESS_READ;
            break;

        case FRBOpcodeCategoryStore:
        case FRBOpcodeCategoryIncrementDecrement:
        case FRBOpcodeCategoryShifts:
            disasm->operand[0].accessMode = DISASM_ACCESS_WRITE;
            break;

        case FRBOpcodeCategoryBlockTransfer:
        case FRBOpcodeCategoryJumps:
        case FRBOpcodeCategoryStack:
        case FRBOpcodeCategorySystem:
        case FRBOpcodeCategoryBranches:
        case FRBOpcodeCategoryRegisterTransfers:
        case FRBOpcodeCategoryStatusFlagChanges:
        case FRBOpcodeCategoryUnknown:
            break;
    }
}

- (NSString *)format:(FRBAddressMode)addressMode
              opcode:(NSString *)opcode
            operands:(NSArray *)operands {

    NSString *format = kOpcodeFormats[addressMode];

    switch (addressMode) {
        case FRBAddressModeAbsolute:
        case FRBAddressModeAbsoluteIndexedX:
        case FRBAddressModeAbsoluteLongIndexed:
        case FRBAddressModeAbsoluteLong:
        case FRBAddressModeAbsoluteIndexedY:
        case FRBAddressModeImmediate:
        case FRBAddressModeDirect:
        case FRBAddressModeDirectIndirectLong:
        case FRBAddressModeDirectIndexedIndirect:
        case FRBAddressModeAbsoluteIndirect:
        case FRBAddressModeStackRelative:
        case FRBAddressModeProgramCounterRelative:
        case FRBAddressModeProgramCounterRelativeLong:
        case FRBAddressModeDirectIndexedX:
        case FRBAddressModeDirectIndexedY:
        case FRBAddressModeDirectIndirectIndexedY:
        case FRBAddressModeDirectIndirect:
        case FRBAddressModeDirectIndirectLongIndexed:
        case FRBAddressModeStackRelativeIndirectIndexed:
        case FRBAddressModeAbsoluteIndexedIndirect:
            return [NSString stringWithFormat:format, opcode, operands[0]];

        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            return [NSString stringWithFormat:format, opcode];

        case FRBAddressModeBlockMove:
            return [NSString stringWithFormat:format, opcode, operands[0],
                    operands[1]];

        case FRBAddressModeUnknown:
        default:
            return nil;
    }
}

@end
