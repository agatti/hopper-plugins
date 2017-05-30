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

#import "FRBBase6502.h"
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

  const FRBInstruction instruction =
      [self instructionForByte:(uint8_t)disasm->instruction.userData];
  switch (instruction.opcode->addressMode) {
  case FRBAddressModeAbsolute:
  case FRBAddressModeProgramCounterRelative:
  case FRBAddressModeZeroPage:
    return [self buildOperandString:disasm
                    forOperandIndex:0
                             inFile:file
                                raw:raw
                       withServices:services];

  case FRBAddressModeAbsoluteIndexedX:
  case FRBAddressModeZeroPageIndexedX: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@",X"];

    return line;
  }

  case FRBAddressModeAbsoluteIndexedY:
  case FRBAddressModeZeroPageIndexedY: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@",Y"];

    return line;
  }

  case FRBAddressModeImmediate: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];

    return line;
  }

  case FRBAddressModeAccumulator:
  case FRBAddressModeImplied:
  case FRBAddressModeStack:
    return [services blankASMLine];

  case FRBAddressModeAbsoluteIndirect:
  case FRBAddressModeZeroPageIndirect: {
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

  case FRBAddressModeZeroPageIndexedIndirect:
  case FRBAddressModeAbsoluteIndexedIndirect: {
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

  case FRBAddressModeZeroPageIndirectIndexedY: {
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

  case FRBAddressModeZeroPageProgramCounterRelative:
  case FRBAddressModeImmediateZeroPage:
  case FRBAddressModeImmediateAbsolute: {
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

  case FRBAddressModeBlockTransfer:
  case FRBAddressModeBitsProgramCounterAbsolute: {
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

  case FRBAddressModeImmediateZeroPageX:
  case FRBAddressModeImmediateAbsoluteX: {
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

  case FRBAddressModeZeroPageIndirectIndexedX: {
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

  case FRBAddressModeSpecialPage: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line appendRawString:@"\\"];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];

    return line;
  }

  case FRBAddressModeUnknown:
  default:
    return nil;
  }
}

- (int)processStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

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
  strcpy(structure->instruction.unconditionalMnemonic,
         instruction.mnemonic->name);
  structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      instruction.opcode->readRegisters;
  structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      instruction.opcode->writtenRegisters;
  structure->instruction.length =
      (uint8_t)FRBOpcodeLength[instruction.opcode->addressMode];

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

- (FRBInstruction)instructionForByte:(uint8_t)byte {
  FRBInstruction instruction;
  instruction.opcode = [self opcodeForByte:byte];
  instruction.mnemonic = &FRBMnemonics[instruction.opcode->type];

  return instruction;
}

- (const FRBOpcode *_Nonnull)opcodeForByte:(uint8_t)byte {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (void)updateFlags:(DisasmStruct *_Nonnull)structure
     forInstruction:(const FRBInstruction *_Nonnull)instruction {

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

- (void)decodeNonBranch:(DisasmStruct *_Nonnull)structure
         forInstruction:(const FRBInstruction *_Nonnull)instruction
                 inFile:(NSObject<HPDisassembledFile> *)file {
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
    SetAddressOperand(file, structure, 1, 8, 16, 1 + sizeof(uint8_t),
                      FRBRegisterX);
    break;

  case FRBAddressModeImmediateAbsolute:
    SetConstantOperand(file, structure, 0, 8, 1);
    SetAddressOperand(file, structure, 1, 16, 16, 1 + sizeof(uint8_t), 0);
    break;

  case FRBAddressModeImmediateAbsoluteX:
    SetConstantOperand(file, structure, 0, 8, 1);
    SetAddressOperand(file, structure, 1, 16, 16, 1 + sizeof(uint8_t),
                      FRBRegisterX);
    break;

  case FRBAddressModeAccumulator:
  case FRBAddressModeImplied:
  case FRBAddressModeStack:
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
  case FRBAddressModeImmediate:
  case FRBAddressModeProgramCounterRelative:
  case FRBAddressModeAccumulator:
  case FRBAddressModeImplied:
  case FRBAddressModeStack:
    break;

  default: {
    [self setMemoryFlags:structure forInstruction:instruction];
    break;
  }
  }
}

- (void)decodeBranch:(DisasmStruct *_Nonnull)structure
      forInstruction:(const FRBInstruction *_Nonnull)instruction
              inFile:(NSObject<HPDisassembledFile> *)file {

  switch (instruction->opcode->addressMode) {
  case FRBAddressModeAbsolute:
  case FRBAddressModeAbsoluteIndirect:
  case FRBAddressModeAbsoluteIndexedIndirect:
  case FRBAddressModeSpecialPage:
    structure->operand[0].immediateValue =
        [file readUInt16AtVirtualAddress:structure->virtualAddr + 1];
    structure->operand[0].isBranchDestination = YES;
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 16;
    structure->instruction.addressValue =
        (Address)structure->operand[0].immediateValue;
    break;

  case FRBAddressModeProgramCounterRelative: {
    structure->instruction.addressValue =
        SetRelativeAddressOperand(file, structure, 0, 8, 16, 1);
    structure->operand[0].isBranchDestination = YES;
    break;
  }

  case FRBAddressModeZeroPageProgramCounterRelative: {
    SetAddressOperand(file, structure, 0, 8, 16, 1, 0);
    structure->instruction.addressValue = SetRelativeAddressOperand(
        file, structure, 1, 8, 16, 1 + sizeof(uint8_t));
    structure->operand[1].isBranchDestination = YES;

    break;
  }

  case FRBAddressModeBitsProgramCounterAbsolute:
    SetAddressOperand(file, structure, 0, 16, 16, 1, 0);
    SetConstantOperand(file, structure, 1, 8, 1 + sizeof(uint16_t));
    structure->instruction.addressValue = SetRelativeAddressOperand(
        file, structure, 2, 8, 16, 1 + sizeof(uint16_t) + sizeof(uint8_t));
    structure->operand[2].isBranchDestination = YES;
    break;

  case FRBAddressModeStack:
    break;

  case FRBAddressModeImplied:
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
        forInstruction:(const FRBInstruction *_Nonnull)instruction {

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

#pragma mark - Custom hexadecimal formatting methods

static NSString *_Nonnull const kValueTooLarge = @"Invalid bits count (%d)";

- (NSString *_Nonnull)formatHexadecimalValue:(int64_t)value
                                    isSigned:(BOOL)isSigned
                            hasLeadingZeroes:(BOOL)hasLeadingZeroes
                                     andSize:(uint32_t)size {

  NSString *formattedValue = FormatHexadecimalValue(value, isSigned, hasLeadingZeroes, size);

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
