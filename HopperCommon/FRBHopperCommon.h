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
#import <Hopper/Hopper.h>

static NSString *FRBHopperExceptionName = @"it.frob.hopper.internalexception";

/*!
 * Initialises the given DisasmStruct structure.
 *
 * @param disasmStruct the structure to initialise.
 */
void InitialiseDisasmStruct(DisasmStruct *disasmStruct);

/*!
 * Extracts a signed value out of the given NSNumber instance.
 *
 * A value is assumed as negative if and only if the value returned by
 * NSNumber has the most significant bit set to 1.
 *
 * @param value the number to get a signed representation of.
 * @param size  the size of the value in bits.
 *
 * @return the signed value representation of the given NSNumber instance.
 */
int64_t SignedValue(NSNumber *value, size_t size);

/*!
 * Changes format for the given argument, if it is still set as default.
 *
 * @param file    the file to operate on.
 * @param address the instruction address.
 * @param operand the index of the argument to change.
 * @param format  the new format for the argument.
 */
void SetDefaultFormatForArgument(id<HPDisassembledFile> file, Address address,
                                 int argument, ArgFormat format);
