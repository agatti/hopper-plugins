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

#import "FRBBase6502.h"

#import "FRBHopperCommon.h"
#import "FRBCPUSupport.h"
#import "FRBOperandFormatter.h"

@interface ItFrobHopper6502Base6502 ()

@property (strong) NSArray *formats;

@end

@implementation ItFrobHopper6502Base6502

@synthesize name;

- (instancetype)init {
    if (self = [super init]) {
        _formats = @[
                     @"%s    %@",       // FRBAddressModeAbsolute
                     @"%s    %@,X",     // FRBAddressModeAbsoluteIndexedX
                     @"%s    %@,Y",     // FRBAddressModeAbsoluteIndexedY
                     @"%s    #%@",      // FRBAddressModeImmediate
                     @"%s    A",        // FRBAddressModeAccumulator
                     @"%s",             // FRBAddressModeImplied
                     @"%s",             // FRBAddressModeStack
                     @"%s    (%@)",     // FRBAddressModeAbsoluteIndirect
                     @"%s    %@",       // FRBAddressModeProgramCounterRelative
                     @"%s    %@",       // FRBAddressModeZeroPage
                     @"%s    %@,X",     // FRBAddressModeZeroPageIndexedX
                     @"%s    %@,Y",     // FRBAddressModeZeroPageIndexedY
                     @"%s    (%@,X)",   // FRBAddressModeZeroPageIndexedIndirect
                     @"%s    (%@),Y",   // FRBAddressModeZeroPageIndirectIndexedY
                     @"%s    (%@)",     // FRBAddressModeZeroPageIndirect
                     @"%s    (%@,X)",   // FRBAddressModeAbsoluteIndexedIndirect
                     @"%s    %@,%@",    // FRBAddressModeZeroPageProgramCounterRelative
                     @"%s    %@,%@,%@", // FRBAddressModeBlockTransfer
                     @"%s    %@,%@",    // FRBAddressModeImmediateZeroPage
                     @"%s    %@,%@,X",  // FRBAddressModeImmediateZeroPageX
                     @"%s    %@,%@",    // FRBAddressModeImmediateAbsolute
                     @"%s    %@,%@,X",  // FRBAddressModeImmediateAbsoluteX
                     @"%s    (%@),X",   // FRBAddressModeZeroPageIndirectIndexedX
                     @"%s    %@,%@,%@", // FRBAddressModeBitsProgramCounterAbsolute
                     @"%s    \\%@"      // FRBAddressModeSpecialPage
                     ];
    }

    return self;
}

- (int)processStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {

    InitialiseDisasmStruct(structure);
    structure->instruction.pcRegisterValue = structure->virtualAddr;
    const uint8_t byte = [file readUInt8AtVirtualAddress:structure->virtualAddr];
    const FRBInstruction instruction = [self instructionForByte:byte];
    structure->instruction.userData = byte;
    if (instruction.opcode->addressMode == FRBAddressModeUnknown) {
        return DISASM_UNKNOWN_OPCODE;
    }
    structure->instruction.branchType = instruction.mnemonic->branchType;
    strcpy(structure->instruction.mnemonic, instruction.mnemonic->name);
    strcpy(structure->instruction.unconditionalMnemonic, instruction.mnemonic->name);
    structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = instruction.opcode->readRegisters;
    structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = instruction.opcode->writtenRegisters;
    structure->instruction.length = FRBOpcodeLength[instruction.opcode->addressMode];

    [self updateFlags:structure
       forInstruction:&instruction];

    if (instruction.mnemonic->branchType == DISASM_BRANCH_NONE) {
        [self decodeNonBranch:structure
               forInstruction:&instruction
                       inFile:file];
    } else {
        [self decodeBranch:structure
            forInstruction:&instruction
                    inFile:file];
    }
    
    return structure->instruction.length;
}

- (BOOL)haltsExecutionFlow:(const DisasmStruct *)structure {
    return [self instructionForByte:structure->instruction.userData].mnemonic->haltsFlow;
}

- (void)formatInstruction:(DisasmStruct *)structure
                   onFile:(id<HPDisassembledFile>)file
             withServices:(id<HPHopperServices>)services {
    NSMutableArray *strings = [NSMutableArray new];

    for (int index = 0; index < DISASM_MAX_OPERANDS; index++) {
        if (structure->operand[index].type == DISASM_OPERAND_NO_OPERAND) {
            break;
        }

        NSNumber *number;
        if (structure->operand[index].size == 64 && structure->operand[index].immediateValue < 0) {
            // TODO: Check this!
            number = [NSNumber numberWithUnsignedLongLong:(structure->operand[index].immediateValue - 18446744073709551615ULL) - 1ULL];
        } else {
            number = [NSNumber numberWithLongLong:structure->operand[index].immediateValue];
        }

        ArgFormat format = [file formatForArgument:index
                                  atVirtualAddress:structure->virtualAddr];
        [strings addObject:FormatValue(number, structure, format, structure->operand[index].size, services)];
    }

    const FRBInstruction instruction = [self instructionForByte:structure->instruction.userData];
    
    NSString *format = self.formats[instruction.opcode->addressMode];
    NSString *result;

    switch (instruction.opcode->addressMode) {
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
            result = [NSString stringWithFormat:format, instruction.mnemonic->name, strings[0]];
            break;

        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            result = [NSString stringWithFormat:format, instruction.mnemonic->name];
            break;

        case FRBAddressModeZeroPageProgramCounterRelative:
        case FRBAddressModeImmediateZeroPage:
        case FRBAddressModeImmediateZeroPageX:
        case FRBAddressModeImmediateAbsolute:
        case FRBAddressModeImmediateAbsoluteX:
            result = [NSString stringWithFormat:format, instruction.mnemonic->name, strings[0], strings[1]];
            break;

        case FRBAddressModeBlockTransfer:
        case FRBAddressModeBitsProgramCounterAbsolute:
            result = [NSString stringWithFormat:format, instruction.mnemonic->name, strings[0], strings[1], strings[2]];
            break;

        default:
            @throw [NSException exceptionWithName:FRBHopperExceptionName
                                           reason:[NSString stringWithFormat:@"Internal error: opcode at address $%04llX with invalid address mode %lu found", structure->virtualAddr, instruction.opcode->addressMode]
                                         userInfo:nil];
    }

    strcpy(structure->completeInstructionString, result.UTF8String);
}

#pragma mark - Overloadable methods

- (FRBInstruction)instructionForByte:(uint8_t)byte {
    FRBInstruction instruction;
    instruction.opcode = [self opcodeForByte:byte];
    instruction.mnemonic = &FRBMnemonics[instruction.opcode->type];

    return instruction;
}

- (const FRBOpcode *)opcodeForByte:(uint8_t)byte {
    @throw [NSException exceptionWithName:FRBHopperExceptionName
                                   reason:[NSString stringWithFormat:@"Forgot to override %s", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (void)updateFlags:(DisasmStruct *)structure
     forInstruction:(const FRBInstruction *)instruction {

    switch (instruction->opcode->type) {
        case FRBOpcodeTypeCLC:
            structure->instruction.eflags.CF_flag = DISASM_EFLAGS_RESET;
            break;

        case FRBOpcodeTypeCLD:
            structure->instruction.eflags.DF_flag = DISASM_EFLAGS_RESET;
            break;

        case FRBOpcodeTypeCLI:
            structure->instruction.eflags.IF_flag = DISASM_EFLAGS_RESET;
            break;

        case FRBOpcodeTypeCLV:
            structure->instruction.eflags.OF_flag = DISASM_EFLAGS_RESET;
            break;

        case FRBOpcodeTypeSEC:
            structure->instruction.eflags.CF_flag = DISASM_EFLAGS_SET;
            break;

        case FRBOpcodeTypeSED:
            structure->instruction.eflags.DF_flag = DISASM_EFLAGS_SET;
            break;

        case FRBOpcodeTypeSEI:
            structure->instruction.eflags.IF_flag = DISASM_EFLAGS_SET;
            break;

        default:
            break;
    }
}

- (void)decodeNonBranch:(DisasmStruct *)structure
         forInstruction:(const FRBInstruction *)instruction
                 inFile:(id<HPDisassembledFile>)file {
    switch (instruction->opcode->addressMode) {
        case FRBAddressModeAbsolute:
        case FRBAddressModeAbsoluteIndirect:
            SetAddressOperand(file, structure, 0, 16, 16, 1, 0);
            break;

        case FRBAddressModeAbsoluteIndexedX:
            SetAddressOperand(file, structure, 0, 16, 16, 1, FRBRegisterX);
            break;

        case FRBAddressModeAbsoluteIndexedY:
            SetAddressOperand(file, structure, 0, 16, 16, 1, FRBRegisterY);
            break;

        case FRBAddressModeImmediate:
            SetConstantOperand(file, structure, 0, 8, 1);
            break;

        case FRBAddressModeZeroPageIndirect:
        case FRBAddressModeZeroPage:
            SetAddressOperand(file, structure, 0, 8, 16, 1, 0);
            break;

        case FRBAddressModeZeroPageIndexedIndirect:
        case FRBAddressModeZeroPageIndexedX:
        case FRBAddressModeZeroPageIndirectIndexedX:
            SetAddressOperand(file, structure, 0, 8, 16, 1, FRBRegisterX);
            break;

        case FRBAddressModeZeroPageIndexedY:
        case FRBAddressModeZeroPageIndirectIndexedY:
            SetAddressOperand(file, structure, 0, 8, 16, 1, FRBRegisterY);
            break;

        case FRBAddressModeBlockTransfer:
            SetAddressOperand(file, structure, 0, 16, 16, 1, 0);
            SetAddressOperand(file, structure, 1, 16, 16, 1 + sizeof(uint16_t), 0);
            SetConstantOperand(file, structure, 2, 16, 1 + sizeof(uint16_t) * 2);
            break;

        case FRBAddressModeImmediateZeroPage:
            SetConstantOperand(file, structure, 0, 8, 1);
            SetAddressOperand(file, structure, 1, 8, 16, 1 + sizeof(uint8_t), 0);
            break;

        case FRBAddressModeImmediateZeroPageX:
            SetConstantOperand(file, structure, 0, 8, 1);
            SetAddressOperand(file, structure, 1, 8, 16, 1 + sizeof(uint8_t), FRBRegisterX);
            break;

        case FRBAddressModeImmediateAbsolute:
            SetConstantOperand(file, structure, 0, 8, 1);
            SetAddressOperand(file, structure, 1, 16, 16, 1 + sizeof(uint8_t), 0);
            break;

        case FRBAddressModeImmediateAbsoluteX:
            SetConstantOperand(file, structure, 0, 8, 1);
            SetAddressOperand(file, structure, 1, 16, 16, 1 + sizeof(uint8_t), FRBRegisterX);
            break;

        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;

        default:
            @throw [NSException exceptionWithName:FRBHopperExceptionName
                                           reason:[NSString stringWithFormat:@"Internal error: non-branch opcode at address $%04llX with address mode %lu found", structure->virtualAddr, instruction->opcode->addressMode]
                                         userInfo:nil];
    }

    switch (instruction->opcode->addressMode) {
        case FRBAddressModeImmediate:
        case FRBAddressModeProgramCounterRelative:
        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;
            
        default: {
            [self setMemoryFlags:structure
                  forInstruction:instruction];
            break;
        }
    }
}

- (void)decodeBranch:(DisasmStruct *)structure
      forInstruction:(const FRBInstruction *)instruction
              inFile:(id<HPDisassembledFile>)file {
    switch (instruction->opcode->addressMode) {
        case FRBAddressModeAbsolute:
        case FRBAddressModeAbsoluteIndirect:
        case FRBAddressModeAbsoluteIndexedIndirect:
        case FRBAddressModeSpecialPage:
            structure->instruction.addressValue = SetAddressOperand(file, structure, 0, 16, 16, 1, 0);
            break;

        case FRBAddressModeProgramCounterRelative: {
            structure->instruction.addressValue = SetRelativeAddressOperand(file, structure, 0, 8, 16, 1);
            break;
        }

        case FRBAddressModeZeroPageProgramCounterRelative: {
            SetAddressOperand(file, structure, 0, 8, 16, 1, 0);
            structure->instruction.addressValue = SetRelativeAddressOperand(file, structure, 1, 8, 16, 1 + sizeof(uint8_t));
            break;
        }

        case FRBAddressModeBitsProgramCounterAbsolute:
            SetAddressOperand(file, structure, 0, 16, 16, 1, 0);
            SetConstantOperand(file, structure, 1, 8, 1 + sizeof(uint16_t));
            structure->instruction.addressValue = SetRelativeAddressOperand(file, structure, 2, 8, 16, 1 + sizeof(uint16_t) + sizeof(uint8_t));
            break;

        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;

        default:
            @throw [NSException exceptionWithName:FRBHopperExceptionName
                                           reason:[NSString stringWithFormat:@"Internal error: branch opcode at address $%04llX with address mode %lu found", structure->virtualAddr, instruction->opcode->addressMode]
                                         userInfo:nil];
    }
}

- (void)setMemoryFlags:(DisasmStruct *)structure
        forInstruction:(const FRBInstruction *)instruction {

    switch (instruction->mnemonic->category) {
        case FRBOpcodeCategoryLoad:
        case FRBOpcodeCategoryComparison:
        case FRBOpcodeCategoryLogical:
        case FRBOpcodeCategoryArithmetic:
            structure->operand[0].accessMode = DISASM_ACCESS_READ;
            break;

        case FRBOpcodeCategoryStore:
        case FRBOpcodeCategoryIncrementDecrement:
        case FRBOpcodeCategoryShifts:
            structure->operand[0].accessMode = DISASM_ACCESS_WRITE;
            break;

        case FRBOpcodeCategoryBlockTransfer:
            structure->operand[0].accessMode = DISASM_ACCESS_READ;
            structure->operand[1].accessMode = DISASM_ACCESS_WRITE;
            break;

        default:
            break;
    }
}

@end
