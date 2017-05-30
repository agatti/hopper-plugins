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

#import "FRBHopperCommon.h"

static NSString *const kSignedSizeErrorFormat =
    @"Internal error: invalid signed value size %zu";

void InitialiseDisasmStruct(DisasmStruct *disasmStruct) {
  memset(&disasmStruct->instruction, 0x00, sizeof(DisasmInstruction));

  for (int index = 0; index < DISASM_MAX_OPERANDS; index++) {
    memset(&disasmStruct->operand[index], 0x00, sizeof(DisasmOperand));
    disasmStruct->operand[index].type = DISASM_OPERAND_NO_OPERAND;
  }
  memset(disasmStruct->implicitlyReadRegisters, 0x00,
         sizeof(disasmStruct->implicitlyReadRegisters));
  memset(disasmStruct->implicitlyWrittenRegisters, 0x00,
         sizeof(disasmStruct->implicitlyWrittenRegisters));
}

int64_t SignedValue(NSNumber *value, size_t size) {
  if (size > 32) {
    @throw [NSException
        exceptionWithName:FRBHopperExceptionName
                   reason:[NSString
                              stringWithFormat:kSignedSizeErrorFormat, size]
                 userInfo:nil];
  }

  uint32_t sizeMask = (uint32_t)((1 << size) - 1);
  uint32_t negativeBitMask = (uint32_t)(1 << (size - 1));

  int64_t output = (int64_t)(value.unsignedLongLongValue & sizeMask);
  return (output & negativeBitMask) ? output - (1 << size) : output;
}

void SetDefaultFormatForArgument(NSObject<HPDisassembledFile> *file,
                                 Address address, int argument,
                                 ArgFormat format) {

  if ([file formatForArgument:(NSUInteger)argument atVirtualAddress:address] !=
      Format_Default) {
    return;
  }

  [file setFormat:format
           forArgument:(NSUInteger)argument
      atVirtualAddress:address];
}

void AddInlineCommentIfEmpty(NSObject<HPDisassembledFile> *_Nonnull file,
                             Address address, NSString *_Nonnull comment) {
  if ([file inlineCommentAtVirtualAddress:address]) {
    return;
  }

  [file setInlineComment:comment
        atVirtualAddress:address
                  reason:CCReason_Automatic];
}

NSString *_Nullable ResolveNameForAddress(
    NSObject<HPDisassembledFile> *_Nonnull file, Address address) {
  NSString *_Nullable name = [file nameForVirtualAddress:address];
  if (name == nil) {
    NSObject<HPProcedure> *_Nullable procedure = [file procedureAt:address];
    if (procedure != nil) {
      name = [procedure localLabelAtAddress:address];
    }
  }

  return name;
}
