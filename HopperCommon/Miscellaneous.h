/*
 Copyright (c) 2014-2018, Alessandro Gatti - frob.it
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

/**
 * Macro for calculating the amount of items contained in an array.
 *
 * @param[in] array the array to get the amount of items for.
 */
#define ARRAY_SIZE(array) (sizeof(array) / sizeof(array[0]))

/**
 * Macro for extracting the format type, ignoring modifiers.
 *
 * @param[in] format the format to get the type for.
 */
#define RAW_FORMAT(format) ((format)&FORMAT_TYPE_MASK)

#define FORMAT_MODIFIERS(format) ((format) & ~FORMAT_TYPE_MASK)
#define FORMAT_IS_SIGNED(format) (((format)&Format_Signed) == Format_Signed)
#define FORMAT_IS_NEGATED(format) (((format)&Format_Negated) == Format_Negated)
#define FORMAT_HAS_LEADING_ZEROES(format)                                      \
  (((format)&Format_LeadingZeroes) == Format_LeadingZeroes)

/**
 * Internal exception identifier.
 */
extern NSString *_Nonnull ItFrobHopperCommonHopperPluginExceptionName;

@interface ItFrobHopperCommonHopperUtilities : NSObject

/**
 * Initialises the given DisasmStruct structure.
 *
 * @param[in] structure the structure to initialise.
 */
+ (void)initialiseStructure:(DisasmStruct *_Nonnull)structure;

/**
 * Changes format for the given argument, if it is still set as default.
 *
 * @param[in] file     the file to operate on.
 * @param[in] address  the instruction address.
 * @param[in] argument the index of the argument to change.
 * @param[in] format   the new format for the argument.
 */
+ (void)setDefaultFormat:(ArgFormat)format
             forArgument:(NSUInteger)argument
               atAddress:(Address)address
                  inFile:(NSObject<HPDisassembledFile> *_Nonnull)file;

/**
 * Adds an inline comment at the given address if none is already present.
 *
 * @param[in] file    the file to operate on
 * @param[in] address the instruction address.
 * @param[in] comment the comment contents.
 */
+ (void)addInlineCommentIfEmpty:(NSString *_Nonnull)comment
                      atAddress:(Address)address
                         inFile:(NSObject<HPDisassembledFile> *_Nonnull)file;

/**
 * Resolves the name assigned to the given address, regardless of whether it is
 * local or global.
 *
 * @param[in] file    the file to operate on.
 * @param[in] address the address to examine.
 *
 * @return the assigned name if any is present, or nil otherwise.
 */
+ (NSString *_Nullable)
    resolveNameForAddress:(Address)address
                   inFile:(NSObject<HPDisassembledFile> *_Nonnull)file;

@end

/**
 * Extracts a signed value out of the given NSNumber instance.
 *
 * A value is assumed as negative if and only if the value returned by
 * NSNumber has the most significant bit set to 1.
 *
 * @param[in] value the number to get a signed representation of.
 * @param[out] size  the size of the value in bits.
 *
 * @return the signed value representation of the given NSNumber instance.
 */
int64_t SignedValue(NSNumber *_Nonnull value, size_t size);
