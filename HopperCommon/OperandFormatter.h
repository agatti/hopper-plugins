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

/*!
 * Formats the given value using the given information.
 *
 * @param value    the value to format.
 * @param source   the disassembled instruction source information.
 * @param format   the output format.
 * @param size     the size of the value in bits.
 * @param services a reference to HPHopperService for resolving addresses.
 *
 * @return the formatted value.
 */
NSString *FormatValue(NSNumber *value, const DisasmStruct *source,
                      ArgFormat format, size_t size,
                      id<HPHopperServices> services);

NSString *FormatHexadecimal(NSNumber *value, size_t size, BOOL isSigned,
                            BOOL fillZeroes, BOOL negate);

NSString *FormatDecimal(NSNumber *value, size_t size, BOOL isSigned,
                        BOOL negate);

NSString *FormatOctal(NSNumber *value, size_t size, BOOL isSigned, BOOL negate);

NSString *FormatBinary(NSNumber *value, size_t size, BOOL fillZeroes,
                       BOOL negate);

NSString *FormatCharacters(NSNumber *value, size_t size);

NSString *ConvertToBinary(uint64_t value, size_t size);

NSString *EscapeWithQuotes(NSString *content, unichar marker);
