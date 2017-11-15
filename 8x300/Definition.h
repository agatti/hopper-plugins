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

@protocol ItFrobHopper8x300InstructionFormatter;

#import "HopperCommon/HopperCommon.h"
#import <Hopper/Hopper.h>

#import "Common.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

/**
 * Available syntaxes for instruction output.
 */
typedef NS_ENUM(NSUInteger, SyntaxType) {

  /** Output syntax follows AS Macro Assembler's. */
  SyntaxTypeAS = 0,

  /** Output syntax follows Signetics' MCCAP. */
  SyntaxTypeMCCAP,

  /** How many syntaxes are available. */
  SyntaxTypeCount
};

/**
 * CPU Definition class for the 8x300 disassembler plugin.
 */
@interface ItFrobHopper8x300Definition
    : ItFrobHopperBaseDefinition <CPUDefinition>

/**
 * Returns the appropriate instruction formatter for the given syntax type.
 *
 * @param[in] syntaxType the syntax type to get a formatter for.
 *
 * @return an object implementing FRBInstructionFormatter or nil if the syntax
 * type is invalid.
 */
- (NSObject<ItFrobHopper8x300InstructionFormatter> *_Nullable)
formatterForSyntax:(SyntaxType)syntaxType;

@end

#pragma clang diagnostic pop
