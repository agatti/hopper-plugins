/*
 Copyright (c) 2014-2015, Alessandro Gatti - frob.it
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
- (NSString *)format:(Mode)addressMode
              opcode:(const char *)opcode
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
                              @"%s    %@",       // ModeAbsolute
                              @"%s    %@,X",     // ModeAbsoluteIndexedX
                              @"%s    %@,Y",     // ModeAbsoluteIndexedY
                              @"%s    %@",       // ModeAbsoluteLong
                              @"%s    %@,X",     // ModeAbsoluteLongIndexed
                              @"%s    #%@",      // ModeImmediate
                              @"%s    A",        // ModeAccumulator
                              @"%s",             // ModeImplied
                              @"%s",             // ModeStack
                              @"%s    (%@)",     // ModeAbsoluteIndirect
                              @"%s    %@",       // ModeProgramCounterRelative
                              @"%s    %@",       // ModeProgramCounterRelativeLong
                              @"%s    %@",       // ModeDirect
                              @"%s    %@,X",     // ModeDirectIndexedX
                              @"%s    %@,Y",     // ModeDirectIndexedY
                              @"%s    (%@,X)",   // ModeDirectIndexedIndirect
                              @"%s    (%@,Y)",   // ModeDirectIndirectIndexedY
                              @"%s    (%@)",     // ModeDirectIndirect
                              @"%s    [%@]",     // ModeDirectIndirectLong
                              @"%s    [%@],Y",   // ModeDirectIndirectLongIndexed
                              @"%s    (%@,X)",   // ModeAbsoluteIndexedIndirect
                              @"%s    %@,S",     // ModeStackRelative
                              @"%s    (%@,S),Y", // ModeStackRelativeIndirectIndexed
                              @"%s    %@,%@",    // ModeBlockMove
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
    if (opcode->addressMode == ModeUnknown) {
        return DISASM_UNKNOWN_OPCODE;
    }

    disasm->instruction.branchType = instruction.branchType;

    strcpy(disasm->instruction.mnemonic, instruction.name);
    strcpy(disasm->instruction.unconditionalMnemonic, instruction.name);

    if (instruction.category == CategoryStatusFlagChanges) {
        switch (opcode->type) {
            case OpcodeCLC:
                disasm->instruction.eflags.CF_flag = DISASM_EFLAGS_RESET;
                break;

            case OpcodeCLD:
                disasm->instruction.eflags.DF_flag = DISASM_EFLAGS_RESET;
                break;

            case OpcodeCLI:
                disasm->instruction.eflags.IF_flag = DISASM_EFLAGS_RESET;
                break;

            case OpcodeCLV:
                disasm->instruction.eflags.OF_flag = DISASM_EFLAGS_RESET;
                break;

            case OpcodeSEC:
                disasm->instruction.eflags.CF_flag = DISASM_EFLAGS_SET;
                break;

            case OpcodeSED:
                disasm->instruction.eflags.DF_flag = DISASM_EFLAGS_SET;
                break;

            case OpcodeSEI:
                disasm->instruction.eflags.IF_flag = DISASM_EFLAGS_SET;
                break;

            default:
                break;
        }
    } else {
        if (opcode->type == OpcodeCOP) {
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
        case OpcodeASL:
            disasm->operand[0].shiftMode = DISASM_SHIFT_LSL;
            disasm->operand[0].shiftAmount = 1;
            break;

        case OpcodeLSR:
            disasm->operand[0].shiftMode = DISASM_SHIFT_LSR;
            disasm->operand[0].shiftAmount = 1;
            break;
            
        case OpcodeROL:
            disasm->operand[0].shiftMode = DISASM_SHIFT_ROR;
            disasm->operand[0].shiftMode = -1;
            break;

        case OpcodeROR:
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
        case ModeAbsolute:
        case ModeAbsoluteIndirect:
            SetAddressOperand(_file, disasm, 0, 16, 24, 1, 0);
            break;

        case ModeProgramCounterRelativeLong: {
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

        case ModeAbsoluteLong:
        case ModeAbsoluteLongIndexed:
            SetAddressOperand(_file, disasm, 0, 24, 24, 1, 0);
            break;

        case ModeAbsoluteIndexedX:
            SetAddressOperand(_file, disasm, 0, 16, 24, 1, RegisterX);
            break;

        case ModeAbsoluteIndexedY:
            SetAddressOperand(_file, disasm, 0, 16, 24, 1, RegisterY);
            break;

        case ModeImmediate:
            SetConstantOperand(_file, disasm, 0, 8, 1);
            break;

        case ModeDirectIndexedX:
        case ModeDirectIndexedIndirect:
            SetAddressOperand(_file, disasm, 0, 8, 24, 1, RegisterX);
            break;

        case ModeDirect:
        case ModeDirectIndirect:
        case ModeStackRelative:
        case ModeStackRelativeIndirectIndexed:
        case ModeDirectIndirectLong:
        case ModeDirectIndirectLongIndexed:
            SetAddressOperand(_file, disasm, 0, 8, 24, 1, 0);
            break;

        case ModeDirectIndexedY:
        case ModeDirectIndirectIndexedY:
            SetAddressOperand(_file, disasm, 0, 8, 24, 1, RegisterY);
            break;

        case ModeBlockMove:
            SetConstantOperand(_file, disasm, 0, 8, 1);
            SetConstantOperand(_file, disasm, 1, 8, 1 + sizeof(uint8_t));
            break;

        case ModeAccumulator:
        case ModeImplied:
        case ModeStack:
            break;

        default:
            @throw [NSException exceptionWithName:FRBHopperExceptionName
                                           reason:[NSString stringWithFormat:@"Internal error: non-branch opcode with address mode %lu found", opcode->addressMode]
                                         userInfo:nil];
    }

    disasm->operand[0].accessMode = DISASM_ACCESS_NONE;
    const struct FRBInstruction instruction = FRBInstructions[opcode->type];

    switch (opcode->addressMode) {
        case ModeImmediate:
        case ModeProgramCounterRelative:
        case ModeAccumulator:
        case ModeImplied:
        case ModeStack:
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
    switch (opcode->addressMode) {

        case ModeAbsoluteLong:
            disasm->instruction.addressValue = SetAddressOperand(_file, disasm, 0, 24, 24, 1, 0);
            break;

        case ModeDirectIndirect:
            disasm->instruction.addressValue = SetAddressOperand(_file, disasm, 0, 8, 24, 1, 0);
            break;

        case ModeAbsolute:
        case ModeAbsoluteIndirect:
        case ModeAbsoluteIndexedIndirect:
            disasm->instruction.addressValue = SetAddressOperand(_file, disasm, 0, 16, 24, 1, 0);
            break;

        case ModeProgramCounterRelative:
            disasm->instruction.addressValue = SetRelativeAddressOperand(_file, disasm, 0, 8, 24, 1);
            break;

        case ModeProgramCounterRelativeLong: {
            Address address = SignedValue(@([_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1]), 16) +
                disasm->instruction.pcRegisterValue + disasm->instruction.length;

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

        case ModeImplied:
        case ModeStack:
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
                 opcode:FRBInstructions[opcode->type].name
               operands:strings];
}

- (void)setMemoryFlags:(DisasmStruct *)disasm
        forInstruction:(const struct FRBInstruction *)instruction {

    switch (instruction->category) {
        case CategoryLoad:
        case CategoryComparison:
        case CategoryLogical:
        case CategoryArithmetic:
            disasm->operand[0].accessMode = DISASM_ACCESS_READ;
            break;

        case CategoryStore:
        case CategoryIncrementDecrement:
        case CategoryShifts:
            disasm->operand[0].accessMode = DISASM_ACCESS_WRITE;
            break;

        case CategoryBlockTransfer:
        case CategoryJumps:
        case CategoryStack:
        case CategorySystem:
        case CategoryBranches:
        case CategoryRegisterTransfers:
        case CategoryStatusFlagChanges:
        case CategoryUnknown:
            break;
    }
}

- (NSString *)format:(Mode)addressMode
              opcode:(const char *)opcode
            operands:(NSArray *)operands {

    NSString *format = kOpcodeFormats[addressMode];

    switch (addressMode) {
        case ModeAbsolute:
        case ModeAbsoluteIndexedX:
        case ModeAbsoluteLongIndexed:
        case ModeAbsoluteLong:
        case ModeAbsoluteIndexedY:
        case ModeImmediate:
        case ModeDirect:
        case ModeDirectIndirectLong:
        case ModeDirectIndexedIndirect:
        case ModeAbsoluteIndirect:
        case ModeStackRelative:
        case ModeProgramCounterRelative:
        case ModeProgramCounterRelativeLong:
        case ModeDirectIndexedX:
        case ModeDirectIndexedY:
        case ModeDirectIndirectIndexedY:
        case ModeDirectIndirect:
        case ModeDirectIndirectLongIndexed:
        case ModeStackRelativeIndirectIndexed:
        case ModeAbsoluteIndexedIndirect:
            return [NSString stringWithFormat:format, opcode, operands[0]];

        case ModeAccumulator:
        case ModeImplied:
        case ModeStack:
            return [NSString stringWithFormat:format, opcode];

        case ModeBlockMove:
            return [NSString stringWithFormat:format, opcode, operands[0],
                    operands[1]];

        case ModeUnknown:
        default:
            return nil;
    }
}

@end
