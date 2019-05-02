/*
 Copyright (c) 2014-2019, Alessandro Gatti - frob.it
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

static const uint8_t kFlippedBitsTable[16] = {
    0b0000, 0b1000, 0b0100, 0b1100, 0b0010, 0b1010, 0b0110, 0b1110,
    0b0001, 0b1001, 0b0101, 0b1101, 0b0011, 0b1011, 0b0111, 0b1111};

#define FLIPPED4BITS(index) (kFlippedBitsTable[index & 0x0F])
#define FLIPPED3BITS(index) (kFlippedBitsTable[index & 0x07] >> 1)
#define FLIPPED2BITS(index) (kFlippedBitsTable[index & 0x03] >> 2)

@implementation ItFrobHopperTMS1000Core

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

- (int)processStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  uint8_t opcodeByte = [file readUInt8AtVirtualAddress:structure->virtualAddr];
  const Instruction instruction = [self instructionForByte:opcodeByte];
  const Opcode *opcode = &kMnemonics[instruction.opcode];

  [HopperUtilities initialiseStructure:structure];
  structure->instruction.pcRegisterValue = structure->virtualAddr;

  structure->instruction.branchType = opcode->branchType;
  structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      (uint32_t)opcode->readRegisters;
  structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      (uint32_t)opcode->writtenRegisters;
  strcpy(structure->instruction.mnemonic, opcode->name);
  strcpy(structure->instruction.unconditionalMnemonic, opcode->name);
  structure->instruction.length = 1;

  switch (instruction.encoding) {
  case InstructionEncodingI:
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 6;
    structure->operand[0].immediateValue = opcodeByte & 0x3F;
    structure->instruction.addressValue =
        (Address)structure->operand[0].immediateValue;

    if ([file segmentForVirtualAddress:structure->instruction.addressValue] ==
        nil) {
      [HopperUtilities
          addInlineCommentIfEmpty:
              [NSString stringWithFormat:@"Jumping out of mapped memory (%X)",
                                         (unsigned int)structure->instruction
                                             .addressValue]
                        atAddress:structure->virtualAddr
                           inFile:file];

      structure->operand[0].isBranchDestination = NO;
    } else {
      structure->operand[0].isBranchDestination = YES;
    }
    break;

  case InstructionEncodingII:
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 4;
    structure->operand[0].immediateValue = FLIPPED4BITS(opcodeByte);
    break;

  case InstructionEncodingIII:
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 2;
    structure->operand[0].immediateValue = FLIPPED2BITS(opcodeByte);
    break;

  case InstructionEncodingIV:
    break;

  case InstructionEncodingV:
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 3;
    structure->operand[0].immediateValue = FLIPPED3BITS(opcodeByte);
    break;
  }

  return 1;
}

- (BOOL)haltsExecutionFlow:(const DisasmStruct *_Nonnull)structure {
  return NO;
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

  format = (format == Format_Default)
               ? disasm->operand[operandIndex].isBranchDestination
                     ? Format_Address
                     : Format_Decimal
               : format;

  [line append:[file formatNumber:(uint64_t)disasm->operand[operandIndex]
                                      .immediateValue
                               at:disasm->virtualAddr
                      usingFormat:format
                       andBitSize:disasm->operand[operandIndex].size]];
  [line setIsOperand:operandIndex startingAtIndex:0];

  return line;
}

- (NSObject<HPASMLine> *_Nullable)
    buildCompleteOperandString:(DisasmStruct *_Nonnull)disasm
                        inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                           raw:(BOOL)raw
                  withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  return disasm->operand[0].type != DISASM_OPERAND_NO_OPERAND
             ? [self buildOperandString:disasm
                        forOperandIndex:0
                                 inFile:file
                                    raw:raw
                           withServices:services]
             : [services blankASMLine];
}

- (Instruction)instructionForByte:(uint8_t)byte {
  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

@end
