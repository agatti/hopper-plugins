/*
 Copyright (c) 2014-2018, Alessandro Gatti - frob.it
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
#import "HopperCommon.h"

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
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (NSString *_Nonnull)model {
  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (BOOL)exported {
  return NO;
}

+ (int)addressSpaceWidth {
  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (NSObject<HPASMLine> *_Nonnull)
    buildMnemonicString:(DisasmStruct *_Nonnull)disasm
                 inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
           withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  NSObject<HPASMLine> *line = [services blankASMLine];
  [line appendMnemonic:@(disasm->instruction.mnemonic)
                isJump:disasm->instruction.branchType != DISASM_BRANCH_NONE];
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
      if ([HopperUtilities
              resolveNameForAddress:disasm->instruction.addressValue
                             inFile:file]) {
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
      if ([HopperUtilities
              resolveNameForAddress:disasm->instruction.addressValue
                             inFile:file]) {
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
  case ModeAbsolute:
  case ModeProgramCounterRelative:
  case ModeZeroPage:
    return [self buildOperandString:disasm
                    forOperandIndex:0
                             inFile:file
                                raw:raw
                       withServices:services];

  case ModeAbsoluteIndexedX:
  case ModeZeroPageIndexedX: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@",X"];

    return line;
  }

  case ModeAbsoluteIndexedY:
  case ModeZeroPageIndexedY: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];
    [line appendRawString:@",Y"];

    return line;
  }

  case ModeImmediate: {
    NSObject<HPASMLine> *line = [services blankASMLine];
    [line append:[self buildOperandString:disasm
                          forOperandIndex:0
                                   inFile:file
                                      raw:raw
                             withServices:services]];

    return line;
  }

  case ModeAccumulator:
  case ModeImplied:
  case ModeStack:
    return [services blankASMLine];

  case ModeAbsoluteIndirect:
  case ModeZeroPageIndirect: {
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

  case ModeZeroPageIndexedIndirect:
  case ModeAbsoluteIndexedIndirect: {
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

  case ModeZeroPageIndirectIndexedY: {
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

  case ModeZeroPageProgramCounterRelative:
  case ModeImmediateZeroPage:
  case ModeImmediateAbsolute: {
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

  case ModeBlockTransfer:
  case ModeBitsProgramCounterAbsolute: {
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

  case ModeImmediateZeroPageX:
  case ModeImmediateAbsoluteX: {
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

  case ModeZeroPageIndirectIndexedX: {
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

  case ModeUnknown:
  default:
    return nil;
  }
}

- (int)processStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file {
  [HopperUtilities initialiseStructure:structure];
  structure->instruction.pcRegisterValue = structure->virtualAddr;
  const uint8_t byte = [file readUInt8AtVirtualAddress:structure->virtualAddr];
  const Instruction instruction = [self instructionForByte:byte];
  structure->instruction.userData = byte;
  if (instruction.opcode->addressMode == ModeUnknown) {
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
    if (!
        [self decodeBranch:structure forInstruction:&instruction inFile:file]) {
      return DISASM_UNKNOWN_OPCODE;
    }
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
      exceptionWithName:HopperPluginExceptionName
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

- (BOOL)decodeNonBranch:(DisasmStruct *_Nonnull)structure
         forInstruction:(const Instruction *_Nonnull)instruction
                 inFile:(NSObject<HPDisassembledFile> *_Nonnull)file {
  switch (instruction->opcode->addressMode) {
  case ModeAbsolute:
  case ModeAbsoluteIndirect:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:structure
                                   withSize:16
                           andEffectiveSize:16
                                 withOffset:1
                    usingIndexRegistersMask:0];
    break;

  case ModeAbsoluteIndexedX:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:structure
                                   withSize:16
                           andEffectiveSize:16
                                 withOffset:1
                    usingIndexRegistersMask:RegisterX];
    break;

  case ModeAbsoluteIndexedY:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:structure
                                   withSize:16
                           andEffectiveSize:16
                                 withOffset:1
                    usingIndexRegistersMask:RegisterY];
    break;

  case ModeImmediate:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:structure
                                    withSize:8
                                   andOffset:1];
    break;

  case ModeZeroPageIndirect:
  case ModeZeroPage:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:structure
                                   withSize:8
                           andEffectiveSize:16
                                 withOffset:1
                    usingIndexRegistersMask:0];
    break;

  case ModeZeroPageIndexedIndirect:
  case ModeZeroPageIndexedX:
  case ModeZeroPageIndirectIndexedX:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:structure
                                   withSize:8
                           andEffectiveSize:16
                                 withOffset:1
                    usingIndexRegistersMask:RegisterX];
    break;

  case ModeZeroPageIndexedY:
  case ModeZeroPageIndirectIndexedY:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:structure
                                   withSize:8
                           andEffectiveSize:16
                                 withOffset:1
                    usingIndexRegistersMask:RegisterY];
    break;

  case ModeBlockTransfer:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:structure
                                   withSize:16
                           andEffectiveSize:16
                                 withOffset:1
                    usingIndexRegistersMask:0];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:structure
                                   withSize:16
                           andEffectiveSize:16
                                 withOffset:3
                    usingIndexRegistersMask:0];
    [Hopper65xxUtilities fillConstantOperand:2
                                      inFile:file
                                   forStruct:structure
                                    withSize:16
                                   andOffset:5];
    break;

  case ModeImmediateZeroPage:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:structure
                                    withSize:8
                                   andOffset:1];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:structure
                                   withSize:8
                           andEffectiveSize:16
                                 withOffset:2
                    usingIndexRegistersMask:0];
    break;

  case ModeImmediateZeroPageX:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:structure
                                    withSize:8
                                   andOffset:1];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:structure
                                   withSize:8
                           andEffectiveSize:16
                                 withOffset:2
                    usingIndexRegistersMask:RegisterX];
    break;

  case ModeImmediateAbsolute:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:structure
                                    withSize:8
                                   andOffset:1];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:structure
                                   withSize:16
                           andEffectiveSize:16
                                 withOffset:2
                    usingIndexRegistersMask:0];
    break;

  case ModeImmediateAbsoluteX:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:structure
                                    withSize:8
                                   andOffset:1];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:structure
                                   withSize:16
                           andEffectiveSize:16
                                 withOffset:2
                    usingIndexRegistersMask:RegisterX];
    break;

  case ModeAccumulator:
  case ModeImplied:
  case ModeStack:
    break;

  default: {
    NSString *exceptionFormat = @"Internal error: non-branch opcode at address "
                                @"$%04llX with address mode %ld found";

    NSLog(exceptionFormat, structure->virtualAddr,
          (unsigned long)instruction->opcode->addressMode,
          instruction->mnemonic->name);
    return NO;
  }
  }

  switch (instruction->opcode->addressMode) {
  case ModeImmediate:
  case ModeProgramCounterRelative:
  case ModeAccumulator:
  case ModeImplied:
  case ModeStack:
    break;

  default: {
    [self setMemoryFlags:structure forInstruction:instruction];
    break;
  }
  }

  return YES;
}

- (BOOL)decodeBranch:(DisasmStruct *_Nonnull)structure
      forInstruction:(const Instruction *_Nonnull)instruction
              inFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  switch (instruction->opcode->addressMode) {
  case ModeAbsolute:
  case ModeAbsoluteIndirect:
  case ModeAbsoluteIndexedIndirect:
    structure->operand[0].immediateValue =
        [file readUInt16AtVirtualAddress:structure->virtualAddr + 1];
    structure->operand[0].isBranchDestination = YES;
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 16;
    structure->instruction.addressValue =
        (Address)structure->operand[0].immediateValue;
    break;

  case ModeProgramCounterRelative: {
    structure->instruction.addressValue =
        [Hopper65xxUtilities fillRelativeAddressOperand:0
                                                 inFile:file
                                              forStruct:structure
                                               withSize:8
                                       andEffectiveSize:16
                                             withOffset:1];
    structure->operand[0].isBranchDestination = YES;
    break;
  }

  case ModeZeroPageProgramCounterRelative: {
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:structure
                                   withSize:8
                           andEffectiveSize:16
                                 withOffset:1
                    usingIndexRegistersMask:0];
    structure->instruction.addressValue =
        [Hopper65xxUtilities fillRelativeAddressOperand:1
                                                 inFile:file
                                              forStruct:structure
                                               withSize:8
                                       andEffectiveSize:16
                                             withOffset:2];
    structure->operand[1].isBranchDestination = YES;

    break;
  }

  case ModeBitsProgramCounterAbsolute:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:structure
                                   withSize:16
                           andEffectiveSize:16
                                 withOffset:1
                    usingIndexRegistersMask:0];
    [Hopper65xxUtilities fillConstantOperand:1
                                      inFile:file
                                   forStruct:structure
                                    withSize:8
                                   andOffset:3];
    structure->instruction.addressValue =
        [Hopper65xxUtilities fillRelativeAddressOperand:2
                                                 inFile:file
                                              forStruct:structure
                                               withSize:8
                                       andEffectiveSize:16
                                             withOffset:4];
    structure->operand[2].isBranchDestination = YES;
    break;

  case ModeZeroPageIndirect:
    structure->instruction.addressValue =
        [Hopper65xxUtilities fillAddressOperand:0
                                         inFile:file
                                      forStruct:structure
                                       withSize:8
                               andEffectiveSize:8
                                     withOffset:1
                        usingIndexRegistersMask:0];
    structure->operand[0].isBranchDestination = YES;
    break;

  case ModeStack:
    break;

  case ModeImplied:
  default: {
    NSString *exceptionFormat = @"Internal error: branch opcode at address "
                                @"$%04llX with address mode %ld found (%s)";
    NSLog(exceptionFormat, structure->virtualAddr,
          (unsigned long)instruction->opcode->addressMode,
          instruction->mnemonic->name);
    return NO;
  }
  }

  return YES;
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
      [Hopper65xxUtilities formatHexadecimalValue:value
                                    displaySigned:isSigned
                                showLeadingZeroes:hasLeadingZeroes
                                       usingWidth:size];

  if (!formattedValue) {
    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
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
