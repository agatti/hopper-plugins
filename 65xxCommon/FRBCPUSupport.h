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

@import Foundation;

#import <Hopper/Hopper.h>

@protocol HPHopperServices;

/*
 * @todo: See if this whole project can be removed from the workspace.
 */

Address SetAddressOperand(NSObject<HPDisassembledFile> *_Nonnull file,
                          DisasmStruct *_Nonnull disasm, NSUInteger operand,
                          uint32_t size, uint32_t effectiveSize,
                          uint32_t offset, uint32_t indexRegisters);

Address SetRelativeAddressOperand(NSObject<HPDisassembledFile> *_Nonnull file,
                                  DisasmStruct *_Nonnull disasm,
                                  NSUInteger operand, uint32_t size,
                                  uint32_t effectiveSize, uint32_t offset);

void SetConstantOperand(NSObject<HPDisassembledFile> *_Nonnull file,
                        DisasmStruct *_Nonnull disasm, int operand,
                        uint32_t size, uint32_t offset);

/**
 * Calculates the signed displacement for the given branch target value.
 *
 * @param[in] target the branch target value extracted from the opcode.
 *
 * @return the calculated relative displacement.
 */
int64_t CalculateRelativeJumpTarget(int64_t target);
