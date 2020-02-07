/*
 Copyright (c) 2014-2020, Alessandro Gatti - frob.it
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

#import "65R02.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Opcode kOpcodeTable[256];

@implementation ItFrobHopperSunplus650265R02

+ (NSString *_Nonnull)family {
  return @"Sunplus";
}

+ (NSString *_Nonnull)model {
  return @"65R02";
}

+ (BOOL)exported {
  return YES;
}

+ (int)addressSpaceWidth {
  return 16;
}

- (const Opcode *_Nonnull)opcodeForByte:(uint8_t)byte {
  return &kOpcodeTable[byte];
}

@end

#define A RegisterFlagsA
#define X RegisterFlagsX
#define Y FRBRegisterFlagsY
#define S RegisterFlagsS
#define P RegisterFlagsP

#define _NO OpcodeUndocumented
#define _NA ModeUnknown
#define _NR RegisterFlagsNone

#define _                                                                      \
  { _NO, _NA, _NR, _NR }

static const Opcode kOpcodeTable[256] = {
    {OpcodeBRK, ModeStack, _NR, S | P},
    _,
    {OpcodeRTI, ModeStack, _NR, _NR},
    _,
    _,
    {OpcodeORA, ModeZeroPage, A, A},
    _,
    {OpcodeEOR, ModeZeroPage, A, A},
    {OpcodeBPL, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBVC, ModeProgramCounterRelative, _NR, _NR},
    _,
    _,
    _,
    _,
    {OpcodeEOR, ModeZeroPageIndexedX, A | X, A},
    {OpcodeJSR, ModeAbsolute, _NR, _NR},
    {OpcodeBIT, ModeZeroPage, A, _NR},
    {OpcodeRTS, ModeStack, _NR, _NR},
    _,
    _,
    {OpcodeAND, ModeZeroPage, A, A},
    _,
    {OpcodeADC, ModeZeroPage, A, A},
    {OpcodeBMI, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBVS, ModeProgramCounterRelative, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeSTA, ModeZeroPage, A, _NR},
    _,
    {OpcodeCMP, ModeZeroPage, A, _NR},
    {OpcodeBCC, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBNE, ModeProgramCounterRelative, _NR, _NR},
    _,
    _,
    {OpcodeSTA, ModeZeroPageIndexedX, A | X, _NR},
    _,
    {OpcodeCMP, ModeZeroPageIndexedX, A | X, _NR},
    _,
    _,
    {OpcodeCPX, ModeImmediate, X, _NR},
    {OpcodeCPX, ModeZeroPage, X, _NR},
    {OpcodeLDA, ModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDA, ModeZeroPage, _NR, A},
    _,
    {OpcodeSBC, ModeZeroPage, A, A},
    {OpcodeBCS, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBEQ, ModeProgramCounterRelative, _NR, _NR},
    _,
    _,
    {OpcodeLDA, ModeZeroPageIndexedX, X, A},
    _,
    _,
    {OpcodePHP, ModeStack, P | S, S},
    _,
    {OpcodePHA, ModeStack, A | S, S},
    {OpcodeJMP, ModeAbsolute, _NR, _NR},
    {OpcodeORA, ModeImmediate, A, A},
    _,
    {OpcodeEOR, ModeImmediate, A, A},
    _,
    {OpcodeCLC, ModeImplied, _NR, _NR},
    _,
    {OpcodeCLI, ModeImplied, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodePLP, ModeStack, S, P | S},
    {OpcodeBIT, ModeAbsolute, A, _NR},
    {OpcodePLA, ModeStack, S, A | S},
    {OpcodeJMP, ModeAbsoluteIndirect, _NR, _NR},
    {OpcodeAND, ModeImmediate, A, A},
    _,
    {OpcodeADC, ModeImmediate, A, A},
    _,
    {OpcodeSEC, ModeImplied, _NR, _NR},
    _,
    {OpcodeSEI, ModeImplied, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeCMP, ModeImmediate, A, _NR},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeINX, ModeImplied, X, X},
    _,
    {OpcodeLDA, ModeImmediate, _NR, A},
    {OpcodeLDA, ModeAbsolute, _NR, A},
    {OpcodeSBC, ModeImmediate, A, A},
    _,
    {OpcodeCLV, ModeImplied, _NR, _NR},
    _,
    _,
    _,
    _,
    {OpcodeLDA, ModeAbsoluteIndexedX, X, A},
    _,
    _,
    {OpcodeASL, ModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeROL, ModeZeroPage, _NR, _NR},
    _,
    {OpcodeROR, ModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeSTX, ModeZeroPage, X, _NR},
    _,
    {OpcodeDEC, ModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeDEC, ModeZeroPageIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeLDX, ModeImmediate, _NR, X},
    {OpcodeLDX, ModeZeroPage, _NR, X},
    _,
    {OpcodeINC, ModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeASL, ModeAccumulator, A, A},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeROL, ModeAccumulator, A, A},
    _,
    {OpcodeROR, ModeAccumulator, A, A},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeTXA, ModeImplied, A | X, A | X},
    {OpcodeSTX, ModeAbsolute, X, _NR},
    {OpcodeDEX, ModeImplied, X, X},
    _,
    _,
    _,
    _,
    _,
    {OpcodeTXS, ModeImplied, X | S, X | S},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeTAX, ModeImplied, A | X, A | X},
    _,
    {OpcodeNOP, ModeImplied, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeTSX, ModeImplied, X | S, X | S},
    _,
    _,
    _,
    _,
    _,
    _,
    _};

#undef A
#undef X
#undef Y
#undef S
#undef P

#undef _NO
#undef _NA
#undef _NR

#undef _

#pragma clang diagnostic pop
