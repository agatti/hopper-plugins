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
#import "FRBCPUSupport.h"
#import "FRBOperandFormatter.h"

// HopperCommon library imports

#import "FRBHopperCommon.h"

/*!
 *	Opcode instruction string formats.
 */
static const NSArray *kOpcodeFormats;

/*!
 *	CPU type and subtype model handler.
 */
static const ItFrobHopper6502ModelHandler *kModelHandler;

@interface ItFrobHopper6502Context () {
    id<CPUDefinition> _cpu;
    id<HPDisassembledFile> _file;
    id<FRBProvider> _provider;
    id<HPHopperServices> _services;
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
@end

@implementation ItFrobHopper6502Context

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
                              @"%@    #%@",      // FRBAddressModeImmediate
                              @"%@    A",        // FRBAddressModeAccumulator
                              @"%@",             // FRBAddressModeImplied
                              @"%@",             // FRBAddressModeStack
                              @"%@    (%@)",     // FRBAddressModeAbsoluteIndirect
                              @"%@    %@",       // FRBAddressModeProgramCounterRelative
                              @"%@    %@",       // FRBAddressModeZeroPage
                              @"%@    %@,X",     // FRBAddressModeZeroPageIndexedX
                              @"%@    %@,Y",     // FRBAddressModeZeroPageIndexedY
                              @"%@    (%@,X)",   // FRBAddressModeZeroPageIndexedIndirect
                              @"%@    (%@),Y",   // FRBAddressModeZeroPageIndirectIndexedY
                              @"%@    (%@)",     // FRBAddressModeZeroPageIndirect
                              @"%@    (%@,X)",   // FRBAddressModeAbsoluteIndexedIndirect
                              @"%@    %@,%@",    // FRBAddressModeZeroPageProgramCounterRelative
                              @"%@    %@,%@,%@", // FRBAddressModeBlockTransfer
                              @"%@    %@,%@",    // FRBAddressModeImmediateZeroPage
                              @"%@    %@,%@,X",  // FRBAddressModeImmediateZeroPageX
                              @"%@    %@,%@",    // FRBAddressModeImmediateAbsolute
                              @"%@    %@,%@,X",  // FRBAddressModeImmediateAbsoluteX
                              @"%@    (%@),X",   // FRBAddressModeZeroPageIndirectIndexedX
                              @"%@    %@,%@,%@", // FRBAddressModeBitsProgramCounterAbsolute
                              @"%@    \\%@",     // FRBAddressModeSpecialPage
                              nil];
            kModelHandler = [ItFrobHopper6502ModelHandler sharedModelHandler];
        });

        _provider = [kModelHandler providerForName:[kModelHandler providerNameForFamily:file.cpuFamily
                                                                           andSubFamily:file.cpuSubFamily]];

        if (!_provider) {
            return nil;
        }
    }
    return self;
}

#pragma mark CPUContext methods

- (id<CPUDefinition>)cpuDefinition {
    return _cpu;
}

- (int)disassembleSingleInstruction:(DisasmStruct *)disasm
                 usingProcessorMode:(NSUInteger)mode {
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

    if (![_provider processOpcode:opcode
                        forDisasm:disasm]) {

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
    }

    return disasm->instruction.length;
}

- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
    return [_provider haltsExecutionFlow:[_provider opcodeForByte:disasm->instruction.userData]];
}

- (void)buildInstructionString:(DisasmStruct *)disasm
                    forSegment:(id<HPSegment>)segment
                populatingInfo:(id<HPFormattedInstructionInfo>)formattedInstructionInfo {
    strcat(disasm->completeInstructionString, [self formatInstruction:disasm].UTF8String);
}

#pragma mark Extra methods

- (void)handleNonBranchOpcode:(const struct FRBOpcode *)opcode
                    forDisasm:(DisasmStruct *)disasm {

    switch (opcode->addressMode) {
        case FRBAddressModeAbsolute:
        case FRBAddressModeAbsoluteIndirect:
            SetAddressOperand(_file, disasm, 0, 16, 16, 1, 0);
            break;

        case FRBAddressModeAbsoluteIndexedX:
            SetAddressOperand(_file, disasm, 0, 16, 16, 1, FRBRegisterX);
            break;

        case FRBAddressModeAbsoluteIndexedY:
            SetAddressOperand(_file, disasm, 0, 16, 16, 1, FRBRegisterY);
            break;

        case FRBAddressModeImmediate:
            SetConstantOperand(_file, disasm, 0, 8, 1);
            break;

        case FRBAddressModeZeroPageIndirect:
        case FRBAddressModeZeroPage:
            SetAddressOperand(_file, disasm, 0, 8, 16, 1, 0);
            break;

        case FRBAddressModeZeroPageIndexedIndirect:
        case FRBAddressModeZeroPageIndexedX:
        case FRBAddressModeZeroPageIndirectIndexedX:
            SetAddressOperand(_file, disasm, 0, 8, 16, 1, FRBRegisterX);
            break;

        case FRBAddressModeZeroPageIndexedY:
        case FRBAddressModeZeroPageIndirectIndexedY:
            SetAddressOperand(_file, disasm, 0, 8, 16, 1, FRBRegisterY);
            break;

        case FRBAddressModeBlockTransfer:
            SetAddressOperand(_file, disasm, 0, 16, 16, 1, 0);
            SetAddressOperand(_file, disasm, 1, 16, 16, 1 + sizeof(uint16_t), 0);
            SetConstantOperand(_file, disasm, 2, 16, 1 + sizeof(uint16_t) * 2);
            break;

        case FRBAddressModeImmediateZeroPage:
            SetConstantOperand(_file, disasm, 0, 8, 1);
            SetAddressOperand(_file, disasm, 1, 8, 16, 1 + sizeof(uint8_t), 0);
            break;

        case FRBAddressModeImmediateZeroPageX:
            SetConstantOperand(_file, disasm, 0, 8, 1);
            SetAddressOperand(_file, disasm, 1, 8, 16, 1 + sizeof(uint8_t), FRBRegisterX);
            break;

        case FRBAddressModeImmediateAbsolute:
            SetConstantOperand(_file, disasm, 0, 8, 1);
            SetAddressOperand(_file, disasm, 1, 16, 16, 1 + sizeof(uint8_t), 0);
            break;

        case FRBAddressModeImmediateAbsoluteX:
            SetConstantOperand(_file, disasm, 0, 8, 1);
            SetAddressOperand(_file, disasm, 1, 16, 16, 1 + sizeof(uint8_t), FRBRegisterX);
            break;

        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;

        default:
            @throw [NSException exceptionWithName:@"InternalErrorExcepton"
                                           reason:[NSString stringWithFormat:@"Internal error: non-branch opcode at address $%04llX with address mode %lu found", disasm->virtualAddr, opcode->addressMode]
                                         userInfo:nil];
    }

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
    switch (opcode->addressMode) {
        case FRBAddressModeAbsolute:
        case FRBAddressModeAbsoluteIndirect:
        case FRBAddressModeAbsoluteIndexedIndirect:
        case FRBAddressModeSpecialPage:
            disasm->instruction.addressValue = SetAddressOperand(_file, disasm, 0, 16, 16, 1, 0);
            break;

        case FRBAddressModeProgramCounterRelative: {
            disasm->instruction.addressValue = SetRelativeAddressOperand(_file, disasm, 0, 8, 16, 1);
            break;
        }

        case FRBAddressModeZeroPageProgramCounterRelative: {
            SetAddressOperand(_file, disasm, 0, 8, 16, 1, 0);
            disasm->instruction.addressValue = SetRelativeAddressOperand(_file, disasm, 1, 8, 16, 1 + sizeof(uint8_t));
            break;
        }

        case FRBAddressModeBitsProgramCounterAbsolute:
            SetAddressOperand(_file, disasm, 0, 16, 16, 1, 0);
            SetConstantOperand(_file, disasm, 1, 8, 1 + sizeof(uint16_t));
            disasm->instruction.addressValue = SetRelativeAddressOperand(_file, disasm, 2, 8, 16, 1 + sizeof(uint16_t) + sizeof(uint8_t));
            break;

        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;

        default:
            @throw [NSException exceptionWithName:@"InternalErrorExcepton"
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
        [strings addObject:FormatValue(number, source, format,
                                       source->operand[index].size, _services)];
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
            disasm->operand[0].accessMode = DISASM_ACCESS_READ;
            disasm->operand[0].accessMode = DISASM_ACCESS_WRITE;
            break;

        default:
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
        case FRBAddressModeAbsoluteIndexedY:
        case FRBAddressModeImmediate:
        case FRBAddressModeAbsoluteIndirect:
        case FRBAddressModeProgramCounterRelative:
        case FRBAddressModeZeroPage:
        case FRBAddressModeZeroPageIndexedX:
        case FRBAddressModeZeroPageIndexedY:
        case FRBAddressModeZeroPageIndexedIndirect:
        case FRBAddressModeZeroPageIndirectIndexedY:
        case FRBAddressModeZeroPageIndirect:
        case FRBAddressModeAbsoluteIndexedIndirect:
        case FRBAddressModeZeroPageIndirectIndexedX:
            return [NSString stringWithFormat:format, opcode, operands[0]];

        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            return [NSString stringWithFormat:format, opcode];

        case FRBAddressModeZeroPageProgramCounterRelative:
        case FRBAddressModeImmediateZeroPage:
        case FRBAddressModeImmediateZeroPageX:
        case FRBAddressModeImmediateAbsolute:
        case FRBAddressModeImmediateAbsoluteX:
            return [NSString stringWithFormat:format, opcode, operands[0],
                    operands[1]];

        case FRBAddressModeBlockTransfer:
        case FRBAddressModeBitsProgramCounterAbsolute:
            return [NSString stringWithFormat:format, opcode, operands[0],
                    operands[1], operands[2]];

        default:
            return nil;
    }
}

@end