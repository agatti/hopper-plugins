/*
 Copyright (c) 2014-2015, Alessandro Gatti - frob.it
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

#import <Foundation/Foundation.h>

#import "FRBBase.h"

/*!
 * Protocol for CPU providers.
 */
@protocol FRBProvider <NSObject>

/*!
 * Provider name.
 */
@property (strong, nonatomic, readonly) NSString *name;

/*!
 * Looks up the opcode mapped to the tiven byte.
 *
 * @param byte the byte to get an opcode for.
 *
 * @return the mapped opcode structure.
 */
- (const struct FRBOpcode *)opcodeForByte:(uint8_t)byte;

/*!
 * Performs some additional or alternative processing of the given opcode.
 *
 * @param opcode the opcode to process.
 * @param disasm the instruction details.
 *
 * @return YES if no more processing must be performed, NO otherwise.
 */
- (BOOL)processOpcode:(const struct FRBOpcode *)opcode
            forDisasm:(DisasmStruct *)disasm;

/*!
 * Checks if the given opcode halts execution flow or not.
 *
 * @param opcode the opcode to check.
 *
 * @return YES if the opcode halts the execution flow, NO otherwise.
 */
- (BOOL)haltsExecutionFlow:(const struct FRBOpcode *)opcode;

@end
