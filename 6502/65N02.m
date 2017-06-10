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

#import "65N02.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Opcode kOpcodeTable[256];

@implementation ItFrobHopperSunplus650265N02

+ (NSString *_Nonnull)family {
  return @"Sunplus";
}

+ (NSString *_Nonnull)model {
  return @"65N02";
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
#define Y RegisterFlagsY
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
    {OpcodeORA, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeORA, ModeZeroPage, A, A},
    {OpcodeEOR, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeEOR, ModeZeroPage, A, A},
    {OpcodeBPL, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBVC, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeORA, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeORA, ModeZeroPageIndexedX, A | X, A},
    {OpcodeEOR, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeEOR, ModeZeroPageIndexedX, A | X, A},
    {OpcodeJSR, ModeAbsolute, _NR, _NR},
    {OpcodeBIT, ModeZeroPage, A, _NR},
    {OpcodeRTS, ModeStack, _NR, _NR},
    _,
    {OpcodeAND, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeAND, ModeZeroPage, A, A},
    {OpcodeADC, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeADC, ModeZeroPage, A, A},
    {OpcodeBMI, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBVS, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeAND, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeAND, ModeZeroPageIndexedX, A | X, A},
    {OpcodeADC, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeADC, ModeZeroPageIndexedX, A | X, A},
    _,
    {OpcodeSTY, ModeZeroPage, Y, _NR},
    {OpcodeCPY, ModeImmediate, Y, _NR},
    {OpcodeCPY, ModeZeroPage, Y, _NR},
    {OpcodeSTA, ModeZeroPageIndexedIndirect, A | X, _NR},
    {OpcodeSTA, ModeZeroPage, A, _NR},
    {OpcodeCMP, ModeZeroPageIndexedIndirect, A, _NR},
    {OpcodeCMP, ModeZeroPage, A, _NR},
    {OpcodeBCC, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTY, ModeZeroPageIndexedX, X | Y, _NR},
    {OpcodeBNE, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeSTA, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    {OpcodeSTA, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeCMP, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    {OpcodeCMP, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeLDY, ModeImmediate, _NR, Y},
    {OpcodeLDY, ModeZeroPage, _NR, Y},
    {OpcodeCPX, ModeImmediate, X, _NR},
    {OpcodeCPX, ModeZeroPage, X, _NR},
    {OpcodeLDA, ModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDA, ModeZeroPage, _NR, A},
    {OpcodeSBC, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeSBC, ModeZeroPage, A, A},
    {OpcodeBCS, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeLDY, ModeZeroPageIndexedX, X, Y},
    {OpcodeBEQ, ModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeLDA, ModeZeroPageIndirectIndexedY, Y, A},
    {OpcodeLDA, ModeZeroPageIndexedX, X, A},
    {OpcodeSBC, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeSBC, ModeZeroPageIndexedX, A | X, A},
    {OpcodePHP, ModeStack, P | S, S},
    _,
    {OpcodePHA, ModeStack, A | S, S},
    {OpcodeJMP, ModeAbsolute, _NR, _NR},
    {OpcodeORA, ModeImmediate, A, A},
    {OpcodeORA, ModeAbsolute, A, A},
    {OpcodeEOR, ModeImmediate, A, A},
    {OpcodeEOR, ModeAbsolute, A, A},
    {OpcodeCLC, ModeImplied, _NR, _NR},
    _,
    {OpcodeCLI, ModeImplied, _NR, _NR},
    _,
    {OpcodeORA, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeORA, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeEOR, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeEOR, ModeAbsoluteIndexedX, A | X, A},
    {OpcodePLP, ModeStack, S, P | S},
    {OpcodeBIT, ModeAbsolute, A, _NR},
    {OpcodePLA, ModeStack, S, A | S},
    {OpcodeJMP, ModeAbsoluteIndirect, _NR, _NR},
    {OpcodeAND, ModeImmediate, A, A},
    {OpcodeAND, ModeAbsolute, A, A},
    {OpcodeADC, ModeImmediate, A, A},
    {OpcodeADC, ModeAbsolute, A, A},
    {OpcodeSEC, ModeImplied, _NR, _NR},
    _,
    {OpcodeSEI, ModeImplied, _NR, _NR},
    _,
    {OpcodeAND, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeAND, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeADC, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeADC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeDEY, ModeImplied, Y, Y},
    {OpcodeSTY, ModeAbsolute, Y, _NR},
    {OpcodeINY, ModeImplied, Y, Y},
    {OpcodeCPY, ModeAbsolute, Y, _NR},
    _,
    {OpcodeSTA, ModeAbsolute, A, _NR},
    {OpcodeCMP, ModeImmediate, A, _NR},
    {OpcodeCMP, ModeAbsolute, A, _NR},
    {OpcodeTYA, ModeImplied, A | Y, A | Y},
    _,
    {OpcodeCLD, ModeImplied, _NR, _NR},
    _,
    {OpcodeSTA, ModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeSTA, ModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeCMP, ModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeCMP, ModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeTAY, ModeImplied, A | Y, A | Y},
    {OpcodeLDY, ModeAbsolute, _NR, Y},
    {OpcodeINX, ModeImplied, X, X},
    {OpcodeCPX, ModeAbsolute, X, _NR},
    {OpcodeLDA, ModeImmediate, _NR, A},
    {OpcodeLDA, ModeAbsolute, _NR, A},
    {OpcodeSBC, ModeImmediate, A, A},
    {OpcodeSBC, ModeAbsolute, A, A},
    {OpcodeCLV, ModeImplied, _NR, _NR},
    {OpcodeLDY, ModeAbsoluteIndexedX, X, Y},
    {OpcodeSED, ModeImplied, _NR, _NR},
    _,
    {OpcodeLDA, ModeAbsoluteIndexedY, Y, A},
    {OpcodeLDA, ModeAbsoluteIndexedX, X, A},
    {OpcodeSBC, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeSBC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeASL, ModeZeroPage, _NR, _NR},
    _,
    {OpcodeLSR, ModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeASL, ModeZeroPageIndexedX, A | X, A},
    _,
    {OpcodeLSR, ModeZeroPageIndexedX, X, _NR},
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
    {OpcodeROL, ModeZeroPageIndexedX, X, _NR},
    _,
    {OpcodeROR, ModeZeroPageIndexedX, X, _NR},
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
    {OpcodeSTX, ModeZeroPageIndexedY, X | Y, _NR},
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
    {OpcodeINC, ModeZeroPageIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeASL, ModeAccumulator, A, A},
    {OpcodeASL, ModeAbsolute, _NR, _NR},
    {OpcodeLSR, ModeAccumulator, A, A},
    {OpcodeLSR, ModeAbsolute, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeASL, ModeAbsoluteIndexedX, A | X, A},
    _,
    {OpcodeLSR, ModeAbsoluteIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeROL, ModeAccumulator, A, A},
    {OpcodeROL, ModeAbsolute, _NR, _NR},
    {OpcodeROR, ModeAccumulator, A, A},
    {OpcodeROR, ModeAbsolute, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeROL, ModeAbsoluteIndexedX, X, _NR},
    _,
    {OpcodeROR, ModeAbsoluteIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeTXA, ModeImplied, A | X, A | X},
    {OpcodeSTX, ModeAbsolute, X, _NR},
    {OpcodeDEX, ModeImplied, X, X},
    {OpcodeDEC, ModeAbsolute, _NR, _NR},
    _,
    _,
    _,
    _,
    {OpcodeTXS, ModeImplied, X | S, X | S},
    {OpcodeLDX, ModeZeroPageIndexedY, Y, A},
    _,
    {OpcodeDEC, ModeAbsoluteIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeTAX, ModeImplied, A | X, A | X},
    {OpcodeLDX, ModeAbsolute, _NR, X},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    {OpcodeINC, ModeAbsolute, _NR, _NR},
    _,
    _,
    _,
    _,
    {OpcodeTSX, ModeImplied, X | S, X | S},
    {OpcodeLDX, ModeAbsoluteIndexedY, X, Y},
    _,
    {OpcodeINC, ModeAbsoluteIndexedX, X, _NR},
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
