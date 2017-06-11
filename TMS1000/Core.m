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
#import "FRBHopperCommon.h"

static const uint8_t kFlipped4BitsTable[16] = {
    0b0000, 0b1000, 0b0100, 0b1100, 0b0010, 0b1010, 0b0110, 0b1110,
    0b0001, 0b1001, 0b0101, 0b1101, 0b0011, 0b1011, 0b0111, 0b1111};

static const uint8_t kFlipped2BitsTable[4] = {0b00, 0b10, 0b01, 0b11};

static const uint8_t kFlipped3BitsTable[8] = {0b000, 0b100, 0b010, 0b110,
                                              0b001, 0b101, 0b011, 0b111};

@interface Core ()

- (uint8_t)flip2Bits:(uint8_t)bits;

- (uint8_t)flip3Bits:(uint8_t)bits;

- (uint8_t)flip4Bits:(uint8_t)bits;

@end

@implementation Core

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

- (int)processStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  uint8_t opcodeByte = [file readUInt8AtVirtualAddress:structure->virtualAddr];
  const Instruction instruction = [self instructionForByte:opcodeByte];
  const Opcode *opcode = &kMnemonics[instruction.opcode];

  InitialiseDisasmStruct(structure);
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
      AddInlineCommentIfEmpty(
          file, structure->virtualAddr,
          [NSString stringWithFormat:@"Jumping out of mapped memory (%X)",
                                     (unsigned int)
                                         structure->instruction.addressValue]);

      structure->operand[0].isBranchDestination = NO;
    } else {
      structure->operand[0].isBranchDestination = YES;
    }
    break;

  case InstructionEncodingII:
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 4;
    structure->operand[0].immediateValue =
        [self flip4Bits:(uint8_t)(opcodeByte & 0x0F)];
    break;

  case InstructionEncodingIII:
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 2;
    structure->operand[0].immediateValue =
        [self flip2Bits:(uint8_t)(opcodeByte & 0x03)] & 0x03;
    break;

  case InstructionEncodingIV:
    break;

  case InstructionEncodingV:
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].size = 2;
    structure->operand[0].immediateValue =
        [self flip3Bits:(uint8_t)(opcodeByte & 0x07)] & 0x07;
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

  if (disasm->operand[0].type != DISASM_OPERAND_NO_OPERAND) {
    return [self buildOperandString:disasm
                    forOperandIndex:0
                             inFile:file
                                raw:raw
                       withServices:services];
  } else {
    return [services blankASMLine];
  }

  return nil;
}

- (uint8_t)flip2Bits:(uint8_t)bits {
  return kFlipped2BitsTable[bits & 0x03];
}

- (uint8_t)flip3Bits:(uint8_t)bits {
  return kFlipped3BitsTable[bits & 0x07];
}

- (uint8_t)flip4Bits:(uint8_t)bits {
  return kFlipped4BitsTable[bits & 0x0F];
}

- (Instruction)instructionForByte:(uint8_t)byte {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

@end
