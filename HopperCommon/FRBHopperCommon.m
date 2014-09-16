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

#import "FRBHopperCommon.h"

void InitialiseDisasmStruct(DisasmStruct *disasmStruct) {
    bzero(disasmStruct->completeInstructionString, sizeof(disasmStruct->completeInstructionString));
    bzero(&disasmStruct->instruction, sizeof(DisasmInstruction));
    for (int index = 0; index < DISASM_MAX_OPERANDS; index++) {
        bzero(&disasmStruct->operand[index], sizeof(DisasmOperand));
        disasmStruct->operand[index].type = DISASM_OPERAND_NO_OPERAND;
    }
    bzero(disasmStruct->implicitlyReadRegisters, sizeof(disasmStruct->implicitlyReadRegisters));
    bzero(disasmStruct->implicitlyWrittenRegisters, sizeof(disasmStruct->implicitlyWrittenRegisters));
}

int64_t SignedValue(NSNumber *value, size_t size) {
    if (size > 32) {
        @throw [NSException exceptionWithName:@"InternalErrorExcepton"
                                       reason:[NSString stringWithFormat:@"Internal error: invalid signed value size %zu", size]
                                     userInfo:nil];
    }

    uint32_t sizeMask = (1 << size) - 1;
    uint32_t negativeBitMask = 1 << (size - 1);

    int64_t output = (int64_t)(value.unsignedLongLongValue & sizeMask);
    return (output & negativeBitMask) ? output - (1 << size) : output;
}

void SetDefaultFormatForArgument(id<HPDisassembledFile> file, Address address,
                                 int argument, ArgFormat format) {
    ArgFormat currentArgument = [file formatForArgument:argument
                                       atVirtualAddress:address];
    if (currentArgument == Format_Default) {
        [file setFormat:format
            forArgument:argument
       atVirtualAddress:address];
    }
}
