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

#import "ASFormat.h"

@implementation ItFrobHopper8x300ASFormat

- (NSString *_Nonnull)name {
  return @"AS Macro Assembler";
}

- (NSObject<HPASMLine> *_Nullable)
formatOperand:(DisasmStruct *_Nonnull)disasm
      atIndex:(NSUInteger)operandIndex
       inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
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
      format = (RAW_FORMAT(format) == Format_Default)
                   ? (FORMAT_MODIFIERS(format) | Format_Address)
                   : format;
    } else {
      value = (uint64_t)disasm->operand[operandIndex].immediateValue;
    }

    [line append:[file formatNumber:value
                                 at:disasm->virtualAddr
                        usingFormat:format
                         andBitSize:disasm->operand[operandIndex].size]];

    [line setIsOperand:operandIndex startingAtIndex:0];

    return line;
  }

  if (disasm->operand[operandIndex].type & DISASM_OPERAND_REGISTER_TYPE) {
    [line
        appendRegister:[file.cpuDefinition
                           registerIndexToString:(NSUInteger)disasm
                                                     ->operand[operandIndex]
                                                     .immediateValue
                                         ofClass:RegClass_GeneralPurposeRegister
                                     withBitSize:disasm->operand[operandIndex]
                                                     .size
                                        position:DISASM_LOWPOSITION
                                  andSyntaxIndex:0]
               ofClass:RegClass_GeneralPurposeRegister
              andIndex:disasm->operand[operandIndex].userData[0]];
    [line setIsOperand:operandIndex startingAtIndex:0];

    return line;
  }

#if defined(DEBUG) && (DEBUG == 1)

  static NSString *errorFormat =
      @"Unhandled operand type 0x%llu at virtual address 0x%llu";

  [services
      logMessage:[NSString stringWithFormat:errorFormat,
                                            disasm->operand[operandIndex].type,
                                            disasm->virtualAddr]];

#endif /* DEBUG && (DEBUG == 1) */

  return nil;
}

- (NSObject<HPASMLine> *_Nullable)
formatInstruction:(DisasmStruct *_Nonnull)disasm
           inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
     withServices:(NSObject<HPHopperServices> *_Nonnull)services
      andEncoding:(EncodingType)encoding {

  NSObject<HPASMLine> *line = [services blankASMLine];

  switch (encoding) {

  case EncodingSingle: {
    GET_OPERAND(first, disasm, 0, file, services);
    [line append:first];
    break;
  }

  case EncodingWithRotation: {
    GET_OPERAND(first, disasm, 0, file, services);
    [line append:first];
    GET_OPERAND(second, disasm, 1, file, services);
    if (disasm->operand[1].immediateValue != 0) {
      [line appendRawString:@"("];
      [line append:second];
      [line appendRawString:@"),"];
    } else {
      [line appendRawString:@","];
    }
    GET_OPERAND(third, disasm, 2, file, services);
    [line append:third];
    break;
  }

  case EncodingWithLength: {
    GET_OPERAND(first, disasm, 0, file, services);
    [line append:first];
    [line appendRawString:@","];
    GET_OPERAND(second, disasm, 1, file, services);
    if (disasm->operand[1].immediateValue != 0) {
      [line append:second];
      [line appendRawString:@","];
    }
    GET_OPERAND(third, disasm, 2, file, services);
    [line append:third];
    break;
  }

  case EncodingAssignment: {
    GET_OPERAND(first, disasm, 0, file, services);
    [line append:first];
    [line appendRawString:@","];
    GET_OPERAND(second, disasm, 1, file, services);
    [line append:second];
    break;
  }

  case EncodingOffsetWithLength: {
    GET_OPERAND(first, disasm, 0, file, services);
    [line append:first];
    [line appendRawString:@"("];
    GET_OPERAND(second, disasm, 1, file, services);
    [line append:second];
    if (disasm->operand[2].immediateValue != 0) {
      [line appendRawString:@"),"];
      GET_OPERAND(third, disasm, 2, file, services);
      [line append:third];
    } else {
      [line appendRawString:@")"];
    }
    break;
  }

  case EncodingAssignmentWithLength: {
    GET_OPERAND(first, disasm, 0, file, services);
    [line append:first];
    [line appendRawString:@","];
    GET_OPERAND(second, disasm, 1, file, services);
    [line append:second];
    if (disasm->operand[2].immediateValue != 0) {
      [line appendRawString:@","];
      GET_OPERAND(third, disasm, 2, file, services);
      [line append:third];
    }
    break;
  }

  case EncodingImplicit:
    break;

  default:
    return nil;
  }

  return line;
}

@end
