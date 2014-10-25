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

#ifndef FRBBase_h
#define FRBBase_h

/*!
 *	Assembler syntax variant.
 */
static NSString * const kSyntaxVariant = @"Generic";

/*!
 *	CPU mode.
 */
static NSString * const kCPUMode = @"generic";

/*!
 *	CPU opcode names.
 */
static const char *kOpcodeNames[8] = {
    "MOVE", "ADD ", "AND ", "XOR ", "XEC ", "NZT ", "XMIT", "JMP "
};

typedef NS_ENUM(NSUInteger, FRBOpcodes) {
    FRBOpcodeMOVE,
    FRBOpcodeADD,
    FRBOpcodeAND,
    FRBOpcodeXOR,
    FRBOpcodeXEC,
    FRBOpcodeNZT,
    FRBOpcodeXMIT,
    FRBOpcodeJMP,

    FRBOpcodeLast
};

static const NSUInteger FRB8x300OpcodesCount = FRBOpcodeLast;

/*!
 *	CPU register names.
 */
static const char *kRegisterNames[32] = {
    "AUX",    "R1",   "R2",   "R3",   "R4",   "R5",   "R6",  "IVL",
    "OVF",   "R11",  "R12",  "R13",  "R14",  "R15",  "R16",  "IVR",
    "LIV0", "LIV1", "LIV2", "LIV3", "LIV4", "LIV5", "LIV6", "LIV7",
    "RIV0", "RIV1", "RIV2", "RIV3", "RIV4", "RIV5", "RIV6", "RIV7",
};

typedef NS_ENUM(NSUInteger, FRB8x300Register) {
    FRB8x300RegisterAUX = 0,
    FRB8x300RegisterR1,
    FRB8x300RegisterR2,
    FRB8x300RegisterR3,
    FRB8x300RegisterR4,
    FRB8x300RegisterR5,
    FRB8x300RegisterR6,
    FRB8x300RegisterIVL,
    FRB8x300RegisterOVF,
    FRB8x300RegisterR11,
    FRB8x300RegisterR12,
    FRB8x300RegisterR13,
    FRB8x300RegisterR14,
    FRB8x300RegisterR15,
    FRB8x300RegisterR16,
    FRB8x300RegisterIVR,
    FRB8x300RegisterLIV0,
    FRB8x300RegisterLIV1,
    FRB8x300RegisterLIV2,
    FRB8x300RegisterLIV3,
    FRB8x300RegisterLIV4,
    FRB8x300RegisterLIV5,
    FRB8x300RegisterLIV6,
    FRB8x300RegisterLIV7,
    FRB8x300RegisterRIV0,
    FRB8x300RegisterRIV1,
    FRB8x300RegisterRIV2,
    FRB8x300RegisterRIV3,
    FRB8x300RegisterRIV4,
    FRB8x300RegisterRIV5,
    FRB8x300RegisterRIV6,
    FRB8x300RegisterRIV7,

    FRB8x300RegisterLast
};

static const NSUInteger FRB8x300RegisterCount = FRB8x300RegisterLast;

typedef NS_OPTIONS(NSUInteger, FRB8x300RegisterFlags) {
    FRB8x300RegisterFlagAUX  = 1 << FRB8x300RegisterAUX,
    FRB8x300RegisterFlagR1   = 1 << FRB8x300RegisterR1,
    FRB8x300RegisterFlagR2   = 1 << FRB8x300RegisterR2,
    FRB8x300RegisterFlagR3   = 1 << FRB8x300RegisterR3,
    FRB8x300RegisterFlagR4   = 1 << FRB8x300RegisterR4,
    FRB8x300RegisterFlagR5   = 1 << FRB8x300RegisterR5,
    FRB8x300RegisterFlagR6   = 1 << FRB8x300RegisterR6,
    FRB8x300RegisterFlagIVL  = 1 << FRB8x300RegisterIVL,
    FRB8x300RegisterFlagOVF  = 1 << FRB8x300RegisterOVF,
    FRB8x300RegisterFlagR11  = 1 << FRB8x300RegisterR11,
    FRB8x300RegisterFlagR12  = 1 << FRB8x300RegisterR12,
    FRB8x300RegisterFlagR13  = 1 << FRB8x300RegisterR13,
    FRB8x300RegisterFlagR14  = 1 << FRB8x300RegisterR14,
    FRB8x300RegisterFlagR15  = 1 << FRB8x300RegisterR15,
    FRB8x300RegisterFlagR16  = 1 << FRB8x300RegisterR16,
    FRB8x300RegisterFlagIVR  = 1 << FRB8x300RegisterIVR,
    FRB8x300RegisterFlagLIV0 = 1 << FRB8x300RegisterLIV0,
    FRB8x300RegisterFlagLIV1 = 1 << FRB8x300RegisterLIV1,
    FRB8x300RegisterFlagLIV2 = 1 << FRB8x300RegisterLIV2,
    FRB8x300RegisterFlagLIV3 = 1 << FRB8x300RegisterLIV3,
    FRB8x300RegisterFlagLIV4 = 1 << FRB8x300RegisterLIV4,
    FRB8x300RegisterFlagLIV5 = 1 << FRB8x300RegisterLIV5,
    FRB8x300RegisterFlagLIV6 = 1 << FRB8x300RegisterLIV6,
    FRB8x300RegisterFlagLIV7 = 1 << FRB8x300RegisterLIV7,
    FRB8x300RegisterFlagRIV0 = 1 << FRB8x300RegisterRIV0,
    FRB8x300RegisterFlagRIV1 = 1 << FRB8x300RegisterRIV1,
    FRB8x300RegisterFlagRIV2 = 1 << FRB8x300RegisterRIV2,
    FRB8x300RegisterFlagRIV3 = 1 << FRB8x300RegisterRIV3,
    FRB8x300RegisterFlagRIV4 = 1 << FRB8x300RegisterRIV4,
    FRB8x300RegisterFlagRIV5 = 1 << FRB8x300RegisterRIV5,
    FRB8x300RegisterFlagRIV6 = 1 << FRB8x300RegisterRIV6,
    FRB8x300RegisterFlagRIV7 = 1 << FRB8x300RegisterRIV7,
};

#endif
