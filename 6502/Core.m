/*
 Copyright (c) 2014-2017, Alessandro Gatti - frob.it
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

#import "Core.h"
#import "FRB65xxHelpers.h"
#import "FRBHopperCommon.h"

@interface ItFrobHopper6502Base6502 ()

- (NSString *_Nonnull)formatHexadecimalValue:(int64_t)value
                                    isSigned:(BOOL)isSigned
                            hasLeadingZeroes:(BOOL)hasLeadingZeroes
                                     andSize:(uint32_t)size;

- (NSObject<HPASMLine> *_Nonnull)
formatHexadecimal:(const DisasmOperand *_Nonnull)operand
           inLine:(NSObject<HPASMLine> *_Nonnull)line
         isSigned:(BOOL)isSigned
 hasLeadingZeroes:(BOOL)hasLeadingZeroes;

- (NSObject<HPASMLine> *_Nonnull)formatAddress:(Address)address
                                        inLine:
                                            (NSObject<HPASMLine> *_Nonnull)line;
@end

@implementation ItFrobHopper6502Base6502

+ (NSString *_Nonnull)family {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (NSString *_Nonnull)model {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (BOOL)exported {
  return NO;
}

+ (int)addressSpaceWidth {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (NSObject<HPASMLine> *_Nonnull)
buildMnemonicString:(DisasmStruct *_Nonnull)disasm
             inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
       withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  NSObject<HPASMLine> *line = [services blankASMLine];
  [line appendMnemonic:@(disasm->instruction.mnemonic)];
  return line;
}

- (NSObject<HPASMLine> *_Nullable)
buildOperandString:(DisasmStruct *_Nonnull)disasm
   forOperandIndex:(NSUInteger)operandIndex
            inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               raw:(BOOL)raw
      withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  if ((operandIndex >= DISASM_MAX_OPERANDS) ||
      (disasm->operand[operandIndex].type == DISASM_OPERAND_NO_OPERAND)) {
    return nil;
  }

  NSObject<HPASMLine> *line = [services blankASMLine];
  ArgFormat format = [file formatForArgument:operandIndex
                            atVirtualAddress:disasm->virtualAddr];

  if (disasm->operand[operandIndex].type & DISASM_OPERAND_CONSTANT_TYPE) {
    uint64_t value;

    if (disasm->operand[operandIndex].isBranchDestination) {
      value = disasm->instruction.addressValue;
      format = (format == Format_Default) ? Format_Address : format;
    } else {
      value = (uint64_t)disasm->operand[operandIndex].immediateValue;
      [line appendRawString:@"#"];
    }

    switch (RAW_FORMAT(format)) {
    case Format_Address:
      if (ResolveNameForAddress(file, disasm->instruction.addressValue)) {
        [line append:[file formatNumber:value
                                     at:disasm->virtualAddr
                            usingFormat:format
                             andBitSize:disasm->operand[operandIndex].size]];
      } else {
        [line append:[self formatAddress:value inLine:[services blankASMLine]]];
      }
      break;

    case Format_Hexadecimal:
    case Format_Default:
      [line append:[self formatHexadecimal:&disasm->operand[operandIndex]
                                    inLine:[services blankASMLine]
                                  isSigned:FORMAT_IS_SIGNED(format)
                          hasLeadingZeroes:FORMAT_HAS_LEADING_ZEROES(format)]];
      break;

    default:
      [line append:[file formatNumber:value
                                   at:disasm->virtualAddr
                          usingFormat:format
                           andBitSize:disasm->operand[operandIndex].size]];
    }

    [line setIsOperand:operandIndex startingAtIndex:0];

    return line;
  }

  if (disasm->operand[operandIndex].type & DISASM_OPERAND_MEMORY_TYPE) {
    uint64_t value;

    if (disasm->operand[operandIndex].isBranchDestination) {
      value = disasm->instruction.addressValue;
      format = (format == Format_Default) ? Format_Address : format;
    } else {
      value = (uint64_t)disasm->operand[operandIndex].immediateValue;
    }

    switch (RAW_FORMAT(format)) {
    case Format_Address:
      if (ResolveNameForAddress(file, disasm->instruction.addressValue)) {
        [line append:[file formatNumber:value
                                     at:disasm->virtualAddr
                            usingFormat:format
                             andBitSize:disasm->operand[operandIndex].size]];
      } else {
        [line append:[self formatAddress:value inLine:[services blankASMLine]]];
      }
      break;

    case Format_Hexadecimal:
    case Format_Default:
      [line append:[self formatHexadecimal:&disasm->operand[operandIndex]
                                    inLine:[services blankASMLine]
                                  isSigned:FORMAT_IS_SIGNED(format)
                          hasLeadingZeroes:FORMAT_HAS_LEADING_ZEROES(format)]];
      break;

    default:
      [line append:[file formatNumber:value
                                   at:disasm->virtualAddr
                          usingFormat:format
                           andBitSize:disasm->operand[operandIndex].size]];
    }

    [line setIsOperand:operandIndex startingAtIndex:0];

    return line;
  }

  NSLog(@"Unhandled operand type 0x%llu at virtual address 0x%llu",
        disasm->operand[operandIndex].type, disasm->virtualAddr);
  return nil;
}

- (NSObject<HPASMLine> *_Nullable)
buildCompleteOperandString:(DisasmStruct *_Nonnull)disasm
                    inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                       raw:(BOOL)raw
              withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  const Instruction instruction =
      [self instructionForByte:(uint8_t)disasm->instruction.userData];
  switch (instruction.opcode->addressMode) {
  case AddressModeAbsolute:
  case AddressModeProgramCounterRelative:
  case AddressModeZeroPage:
    return [self buildOperandString:disasm
                    forOperandIndex:0
                             inFile:file
                                raw:raw
                       withServices:services];

  case AddressModeAbsoluteIndexedX:
  case AddressModeZeroPageIndexedX: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@",X"];

    return line;
  }

  case AddressModeAbsoluteIndexedY:
  case AddressModeZeroPageIndexedY: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@",Y"];

    return line;
  }

  case AddressModeImmediate: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];

    return line;
  }

  case AddressModeAccumulator:
  case AddressModeImplied:
  case AddressModeStack:
    return [services blankASMLine];

  case AddressModeAbsoluteIndirect:
  case AddressModeZeroPageIndirect: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line appendRawString:@"("];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@")"];

    return line;
  }

  case AddressModeZeroPageIndexedIndirect:
  case AddressModeAbsoluteIndexedIndirect: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line appendRawString:@"("];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@",X)"];

    return line;
  }

  case AddressModeZeroPageIndirectIndexedY: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line appendRawString:@"("];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@"),Y"];

    return line;
  }

  case AddressModeZeroPageProgramCounterRelative:
  case AddressModeImmediateZeroPage:
  case AddressModeImmediateAbsolute: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@","];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:1
                                   inFile:file
                                      raw:raw
                             withServices:services]];

    return line;
  }

  case AddressModeBlockTransfer:
  case AddressModeBitsProgramCounterAbsolute: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@","];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:1
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@","];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:1
                                   inFile:file
                                      raw:raw
                             withServices:services]];

    return line;
  }

  case AddressModeImmediateZeroPageX:
  case AddressModeImmediateAbsoluteX: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@","];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:1
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@",X"];

    return line;
  }

  case AddressModeZeroPageIndirectIndexedX: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line appendRawString:@"("];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@"),X"];

    return line;
  }

  case AddressModeSpecialPage: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line appendRawString:@"\\"];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];

    return line;
  }

  case AddressModeUnknown:
  default:
    return nil;
  }
}

- (int)processStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  InitialiseDisasmStruct(structure);
  structure->instruction.pcRegisterValue = structure->virtualAddr;
  const uint8_t byte = [file readUInt8AtVirtualAddress:structure->virtualAddr];
  const Instruction instruction = [self instructionForByte:byte];
  structure->instruction.userData = byte;
  if (instruction.opcode->addressMode == AddressModeUnknown) {
    return DISASM_UNKNOWN_OPCODE;
  }
  structure->instruction.branchType = instruction.mnemonic->branchType;
  strcpy(structure->instruction.mnemonic, instruction.mnemonic->name);
  strcpy(structure->instruction.unconditionalMnemonic,
         instruction.mnemonic->name);
  structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      instruction.opcode->readRegisters;
  structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      instruction.opcode->writtenRegisters;
  structure->instruction.length =
      (uint8_t)kOpcodeLengths[instruction.opcode->addressMode];

  [self updateFlags:structure forInstruction:&instruction];

  if (instruction.mnemonic->branchType == DISASM_BRANCH_NONE) {
    [self decodeNonBranch:structure forInstruction:&instruction inFile:file];
  } else {
    [self decodeBranch:structure forInstruction:&instruction inFile:file];
  }

  return structure->instruction.length;
}

- (BOOL)haltsExecutionFlow:(const DisasmStruct *_Nonnull)structure {
  return [self instructionForByte:(uint8_t)structure->instruction.userData]
      .mnemonic->haltsFlow;
}

#pragma mark - Overloadable methods

- (Instruction)instructionForByte:(uint8_t)byte {
  Instruction instruction;
  instruction.opcode = [self opcodeForByte:byte];
  instruction.mnemonic = &kMnemonics[instruction.opcode->type];

  return instruction;
}

- (const Opcode *_Nonnull)opcodeForByte:(uint8_t)byte {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (void)updateFlags:(DisasmStruct *_Nonnull)structure
     forInstruction:(const Instruction *_Nonnull)instruction {

  switch (instruction->opcode->type) {
  case OpcodeCLC:
    structure->instruction.eflags.CF_flag = DISASM_EFLAGS_RESET;
    break;

  case OpcodeCLD:
    structure->instruction.eflags.DF_flag = DISASM_EFLAGS_RESET;
    break;

  case OpcodeCLI:
    structure->instruction.eflags.IF_flag = DISASM_EFLAGS_RESET;
    break;

  case OpcodeCLV:
    structure->instruction.eflags.OF_flag = DISASM_EFLAGS_RESET;
    break;

  case OpcodeSEC:
    structure->instruction.eflags.CF_flag = DISASM_EFLAGS_SET;
    break;

  case OpcodeSED:
    structure->instruction.eflags.DF_flag = DISASM_EFLAGS_SET;
    break;

  case OpcodeSEI:
    structure->instruction.eflags.IF_flag = DISASM_EFLAGS_SET;
    break;

  default:
    break;
  }
}

- (void)decodeNonBranch:(DisasmStruct *_Nonnull)structure
         forInstruction:(const Instruction *_Nonnull)instruction
                 inFile:(NSObject<HPDisassembledFile> *_Nonnull)file {
  switch (instruction->opcode->addressMode) {
  case AddressModeAbsolute:
  case AddressModeAbsoluteIndirect:
    SetAddressOperand(file, structure, 0, 16, 16, 1, 0);
    break;

  case AddressModeAbsoluteIndexedX:
    SetAddressOperand(file, structure, 0, 16, 16, 1, RegisterX);
    break;

  case AddressModeAbsoluteIndexedY:
    SetAddressOperand(file, structure, 0, 16, 16, 1, RegisterY);
    break;

  case AddressModeImmediate:
    SetConstantOperand(file, structure, 0, 8, 1);
    break;

  case AddressModeZeroPageIndirect:
  case AddressModeZeroPage:
    SetAddressOperand(file, structure, 0, 8, 16, 1, 0);
    break;

  case AddressModeZeroPageIndexedIndirect:
  case AddressModeZeroPageIndexedX:
  case AddressModeZeroPageIndirectIndexedX:
    SetAddressOperand(file, structure, 0, 8, 16, 1, RegisterX);
    break;

  case AddressModeZeroPageIndexedY:
  case AddressModeZeroPageIndirectIndexedY:
    SetAddressOperand(file, structure, 0, 8, 16, 1, RegisterY);
    break;

  case AddressModeBlockTransfer:
    SetAddressOperand(file, structure, 0, 16, 16, 1, 0);
    SetAddressOperand(file, structure, 1, 16, 16, 1 + sizeof(uint16_t), 0);
    SetConstantOperand(file, structure, 2, 16, 1 + sizeof(uint16_t) * 2);
    break;

  case AddressModeImmediateZeroPage:
    SetConstantOperand(file, structure, 0, 8, 1);
    SetAddressOperand(file, structure, 1, 8, 16, 1 + sizeof(uint8_t), 0);
    break;

  case AddressModeImmediateZeroPageX:
    SetConstantOperand(file, structure, 0, 8, 1);
    SetAddressOperand(file, structure, 1, 8, 16, 1 + sizeof(uint8_t),
                      RegisterX);
    break;

  case AddressModeImmediateAbsolute:
    SetConstantOperand(file, structure, 0, 8, 1);
    SetAddressOperand(file, structure, 1, 16, 16, 1 + sizeof(uint8_t), 0);
    break;

  case AddressModeImmediateAbsoluteX:
    SetConstantOperand(file, structure, 0, 8, 1);
    SetAddressOperand(file, structure, 1, 16, 16, 1 + sizeof(uint8_t),
                      RegisterX);
    break;

  case AddressModeAccumulator:
  case AddressModeImplied:
  case AddressModeStack:
    break;

  default: {
    NSString *exceptionFormat = @"Internal error: non-branch opcode at address "
                                @"$%04llX with address mode %ld found";
    @throw [NSException
        exceptionWithName:FRBHopperExceptionName
                   reason:[NSString stringWithFormat:exceptionFormat,
                                                     structure->virtualAddr,
                                                     (unsigned long)instruction
                                                         ->opcode->addressMode]
                 userInfo:nil];
  }
  }

  switch (instruction->opcode->addressMode) {
  case AddressModeImmediate:
  case AddressModeProgramCounterRelative:
  case AddressModeAccumulator:
  case AddressModeImplied:
  case AddressModeStack:
    break;

  default: {
    [self setMemoryFlags:structure forInstruction:instruction];
    break;
  }
  }
}

- (void)decodeBranch:(DisasmStruct *_Nonnull)structure
      forInstruction:(const Instruction *_Nonnull)instruction
              inFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  switch (instruction->opcode->addressMode) {
  case AddressModeAbsolute:
  case AddressModeAbsoluteIndirect:
  case AddressModeAbsoluteIndexedIndirect:
  case AddressModeSpecialPage:
    structure->operand[0].immediateValue =
        [file readUInt16AtVirtualAddress:structure->virtualAddr + 1];
    structure->operand[0].isBranchDestination = YES;
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 16;
    structure->instruction.addressValue =
        (Address)structure->operand[0].immediateValue;
    break;

  case AddressModeProgramCounterRelative: {
    structure->instruction.addressValue =
        SetRelativeAddressOperand(file, structure, 0, 8, 16, 1);
    structure->operand[0].isBranchDestination = YES;
    break;
  }

  case AddressModeZeroPageProgramCounterRelative: {
    SetAddressOperand(file, structure, 0, 8, 16, 1, 0);
    structure->instruction.addressValue = SetRelativeAddressOperand(
        file, structure, 1, 8, 16, 1 + sizeof(uint8_t));
    structure->operand[1].isBranchDestination = YES;

    break;
  }

  case AddressModeBitsProgramCounterAbsolute:
    SetAddressOperand(file, structure, 0, 16, 16, 1, 0);
    SetConstantOperand(file, structure, 1, 8, 1 + sizeof(uint16_t));
    structure->instruction.addressValue = SetRelativeAddressOperand(
        file, structure, 2, 8, 16, 1 + sizeof(uint16_t) + sizeof(uint8_t));
    structure->operand[2].isBranchDestination = YES;
    break;

  case AddressModeStack:
    break;

  case AddressModeImplied:
  default: {
    NSString *exceptionFormat = @"Internal error: branch opcode at address "
                                @"$%04llX with address mode %ld found (%s)";
    @throw [NSException
        exceptionWithName:FRBHopperExceptionName
                   reason:[NSString
                              stringWithFormat:exceptionFormat,
                                               structure->virtualAddr,
                                               (unsigned long)instruction
                                                   ->opcode->addressMode,
                                               instruction->mnemonic->name]
                 userInfo:nil];
  }
  }
}

- (void)setMemoryFlags:(DisasmStruct *_Nonnull)structure
        forInstruction:(const Instruction *_Nonnull)instruction {

  switch (instruction->mnemonic->category) {
  case OpcodeCategoryLoad:
  case OpcodeCategoryComparison:
  case OpcodeCategoryLogical:
  case OpcodeCategoryArithmetic:
    structure->operand[0].accessMode = DISASM_ACCESS_READ;
    break;

  case OpcodeCategoryStore:
  case OpcodeCategoryIncrementDecrement:
  case OpcodeCategoryShifts:
    structure->operand[0].accessMode = DISASM_ACCESS_WRITE;
    break;

  case OpcodeCategoryBlockTransfer:
    structure->operand[0].accessMode = DISASM_ACCESS_READ;
    structure->operand[1].accessMode = DISASM_ACCESS_WRITE;
    break;

  default:
    break;
  }
}

#pragma mark - Custom hexadecimal formatting methods

static NSString *_Nonnull const kValueTooLarge = @"Invalid bits count (%d)";

- (NSString *_Nonnull)formatHexadecimalValue:(int64_t)value
                                    isSigned:(BOOL)isSigned
                            hasLeadingZeroes:(BOOL)hasLeadingZeroes
                                     andSize:(uint32_t)size {

  NSString *formattedValue =
      FormatHexadecimalValue(value, isSigned, hasLeadingZeroes, size);

  if (!formattedValue) {
    @throw [NSException
        exceptionWithName:FRBHopperExceptionName
                   reason:[NSString stringWithFormat:kValueTooLarge, size]
                 userInfo:nil];
  }

  return formattedValue;
}

- (NSObject<HPASMLine> *_Nonnull)
formatHexadecimal:(const DisasmOperand *_Nonnull)operand
           inLine:(NSObject<HPASMLine> *_Nonnull)line
         isSigned:(BOOL)isSigned
 hasLeadingZeroes:(BOOL)hasLeadingZeroes {

  [line
      appendFormattedNumber:[self formatHexadecimalValue:operand->immediateValue
                                                isSigned:isSigned
                                        hasLeadingZeroes:hasLeadingZeroes
                                                 andSize:operand->size]
                  withValue:@(operand->immediateValue)];
  return line;
}

- (NSObject<HPASMLine> *_Nonnull)formatAddress:(Address)address
                                        inLine:(NSObject<HPASMLine> *_Nonnull)
                                                   line {

  [line appendFormattedAddress:[self formatHexadecimalValue:address
                                                   isSigned:NO
                                           hasLeadingZeroes:NO
                                                    andSize:16]
                     withValue:address];
  return line;
}

@end
