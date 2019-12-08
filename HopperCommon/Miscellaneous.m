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

#import "Miscellaneous.h"
#import "HopperCommon.h"

NSString *_Nonnull ItFrobHopperCommonHopperPluginExceptionName =
    @"it.frob.hopper.internalexception";

static NSString *const kSignedSizeErrorFormat =
    @"Internal error: invalid signed value size %zu";

@implementation ItFrobHopperCommonHopperUtilities

+ (void)initialiseStructure:(DisasmStruct *_Nonnull)structure {
  memset(&structure->instruction, 0x00, sizeof(DisasmInstruction));

  for (NSUInteger index = 0; index < DISASM_MAX_OPERANDS; index++) {
    memset(&structure->operand[index], 0x00, sizeof(DisasmOperand));
    structure->operand[index].type = DISASM_OPERAND_NO_OPERAND;
  }
  memset(structure->implicitlyReadRegisters, 0x00,
         sizeof(structure->implicitlyReadRegisters));
  memset(structure->implicitlyWrittenRegisters, 0x00,
         sizeof(structure->implicitlyWrittenRegisters));
}

+ (void)setDefaultFormat:(ArgFormat)format
             forArgument:(NSUInteger)argument
               atAddress:(Address)address
                  inFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  if ([file formatForArgument:argument
             atVirtualAddress:address] != Format_Default) {
    return;
  }

  [file setFormat:format forArgument:argument atVirtualAddress:address];
}

+ (void)addInlineCommentIfEmpty:(NSString *_Nonnull)comment
                      atAddress:(Address)address
                         inFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  if ([file inlineCommentAtVirtualAddress:address]) {
    return;
  }

  [file setInlineComment:comment
        atVirtualAddress:address
                  reason:CCReason_Automatic];
}

+ (NSString *_Nullable)
    resolveNameForAddress:(Address)address
                   inFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  NSString *_Nullable name = [file nameForVirtualAddress:address];
  if (name == nil) {
    NSObject<HPProcedure> *_Nullable procedure = [file procedureAt:address];
    if (procedure != nil) {
      name = [procedure localLabelAtAddress:address];
    }
  }

  return name;
}

@end

int64_t SignedValue(NSNumber *value, size_t size) {
  if (size > 32) {
    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
                   reason:[NSString
                              stringWithFormat:kSignedSizeErrorFormat, size]
                 userInfo:nil];
  }

  uint32_t sizeMask = (uint32_t)((1 << size) - 1);
  uint32_t negativeBitMask = (uint32_t)(1 << (size - 1));

  int64_t output = (int64_t)(value.unsignedLongLongValue & sizeMask);
  return (output & negativeBitMask) ? output - (1 << size) : output;
}
