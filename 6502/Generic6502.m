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

#import "Generic6502.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Opcode kOpcodeTable[256];

@implementation ItFrobHopper6502Generic6502

+ (NSString *_Nonnull)family {
  return @"Generic";
}

+ (NSString *_Nonnull)model {
  return @"6502";
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
    {OpcodeORA, ModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    _,
    {OpcodeORA, ModeZeroPage, A, A},
    {OpcodeASL, ModeZeroPage, _NR, _NR},
    _,
    {OpcodePHP, ModeStack, P | S, S},
    {OpcodeORA, ModeImmediate, A, A},
    {OpcodeASL, ModeAccumulator, A, A},
    _,
    _,
    {OpcodeORA, ModeAbsolute, A, A},
    {OpcodeASL, ModeAbsolute, _NR, _NR},
    _,
    {OpcodeBPL, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeORA, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeORA, ModeZeroPageIndexedX, A | X, A},
    {OpcodeASL, ModeZeroPageIndexedX, A | X, A},
    _,
    {OpcodeCLC, ModeImplied, _NR, _NR},
    {OpcodeORA, ModeAbsoluteIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeORA, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeASL, ModeAbsoluteIndexedX, A | X, A},
    _,
    {OpcodeJSR, ModeAbsolute, _NR, _NR},
    {OpcodeAND, ModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    {OpcodeBIT, ModeZeroPage, A, _NR},
    {OpcodeAND, ModeZeroPage, A, A},
    {OpcodeROL, ModeZeroPage, _NR, _NR},
    _,
    {OpcodePLP, ModeStack, S, P | S},
    {OpcodeAND, ModeImmediate, A, A},
    {OpcodeROL, ModeAccumulator, A, A},
    _,
    {OpcodeBIT, ModeAbsolute, A, _NR},
    {OpcodeAND, ModeAbsolute, A, A},
    {OpcodeROL, ModeAbsolute, _NR, _NR},
    _,
    {OpcodeBMI, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeAND, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeAND, ModeZeroPageIndexedX, A | X, A},
    {OpcodeROL, ModeZeroPageIndexedX, X, _NR},
    _,
    {OpcodeSEC, ModeImplied, _NR, _NR},
    {OpcodeAND, ModeAbsoluteIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeAND, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeROL, ModeAbsoluteIndexedX, X, _NR},
    _,
    {OpcodeRTI, ModeStack, _NR, _NR},
    {OpcodeEOR, ModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    _,
    {OpcodeEOR, ModeZeroPage, A, A},
    {OpcodeLSR, ModeZeroPage, _NR, _NR},
    _,
    {OpcodePHA, ModeStack, A | S, S},
    {OpcodeEOR, ModeImmediate, A, A},
    {OpcodeLSR, ModeAccumulator, A, A},
    _,
    {OpcodeJMP, ModeAbsolute, _NR, _NR},
    {OpcodeEOR, ModeAbsolute, A, A},
    {OpcodeLSR, ModeAbsolute, _NR, _NR},
    _,
    {OpcodeBVC, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeEOR, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeEOR, ModeZeroPageIndexedX, A | X, A},
    {OpcodeLSR, ModeZeroPageIndexedX, X, _NR},
    _,
    {OpcodeCLI, ModeImplied, _NR, _NR},
    {OpcodeEOR, ModeAbsoluteIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeEOR, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeLSR, ModeAbsoluteIndexedX, X, _NR},
    _,
    {OpcodeRTS, ModeStack, _NR, _NR},
    {OpcodeADC, ModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    _,
    {OpcodeADC, ModeZeroPage, A, A},
    {OpcodeROR, ModeZeroPage, _NR, _NR},
    _,
    {OpcodePLA, ModeStack, S, A | S},
    {OpcodeADC, ModeImmediate, A, A},
    {OpcodeROR, ModeAccumulator, A, A},
    _,
    {OpcodeJMP, ModeAbsoluteIndirect, _NR, _NR},
    {OpcodeADC, ModeAbsolute, A, A},
    {OpcodeROR, ModeAbsolute, _NR, _NR},
    _,
    {OpcodeBVS, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeADC, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeADC, ModeZeroPageIndexedX, A | X, A},
    {OpcodeROR, ModeZeroPageIndexedX, X, _NR},
    _,
    {OpcodeSEI, ModeImplied, _NR, _NR},
    {OpcodeADC, ModeAbsoluteIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeADC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeROR, ModeAbsoluteIndexedX, X, _NR},
    _,
    _,
    {OpcodeSTA, ModeZeroPageIndexedIndirect, A | X, _NR},
    _,
    _,
    {OpcodeSTY, ModeZeroPage, Y, _NR},
    {OpcodeSTA, ModeZeroPage, A, _NR},
    {OpcodeSTX, ModeZeroPage, X, _NR},
    _,
    {OpcodeDEY, ModeImplied, Y, Y},
    _,
    {OpcodeTXA, ModeImplied, A | X, A | X},
    _,
    {OpcodeSTY, ModeAbsolute, Y, _NR},
    {OpcodeSTA, ModeAbsolute, A, _NR},
    {OpcodeSTX, ModeAbsolute, X, _NR},
    _,
    {OpcodeBCC, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    _,
    {OpcodeSTY, ModeZeroPageIndexedX, X | Y, _NR},
    {OpcodeSTA, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeSTX, ModeZeroPageIndexedY, X | Y, _NR},
    _,
    {OpcodeTYA, ModeImplied, A | Y, A | Y},
    {OpcodeSTA, ModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeTXS, ModeImplied, X | S, X | S},
    _,
    _,
    {OpcodeSTA, ModeAbsoluteIndexedX, A | X, _NR},
    _,
    _,
    {OpcodeLDY, ModeImmediate, _NR, Y},
    {OpcodeLDA, ModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDX, ModeImmediate, _NR, X},
    _,
    {OpcodeLDY, ModeZeroPage, _NR, Y},
    {OpcodeLDA, ModeZeroPage, _NR, A},
    {OpcodeLDX, ModeZeroPage, _NR, X},
    _,
    {OpcodeTAY, ModeImplied, A | Y, A | Y},
    {OpcodeLDA, ModeImmediate, _NR, A},
    {OpcodeTAX, ModeImplied, A | X, A | X},
    _,
    {OpcodeLDY, ModeAbsolute, _NR, Y},
    {OpcodeLDA, ModeAbsolute, _NR, A},
    {OpcodeLDX, ModeAbsolute, _NR, X},
    _,
    {OpcodeBCS, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeLDA, ModeZeroPageIndirectIndexedY, Y, A},
    _,
    _,
    {OpcodeLDY, ModeZeroPageIndexedX, X, Y},
    {OpcodeLDA, ModeZeroPageIndexedX, X, A},
    {OpcodeLDX, ModeZeroPageIndexedY, Y, A},
    _,
    {OpcodeCLV, ModeImplied, _NR, _NR},
    {OpcodeLDA, ModeAbsoluteIndexedY, Y, A},
    {OpcodeTSX, ModeImplied, X | S, X | S},
    _,
    {OpcodeLDY, ModeAbsoluteIndexedX, X, Y},
    {OpcodeLDA, ModeAbsoluteIndexedX, X, A},
    {OpcodeLDX, ModeAbsoluteIndexedY, X, Y},
    _,
    {OpcodeCPY, ModeImmediate, Y, _NR},
    {OpcodeCMP, ModeZeroPageIndexedIndirect, A, _NR},
    _,
    _,
    {OpcodeCPY, ModeZeroPage, Y, _NR},
    {OpcodeCMP, ModeZeroPage, A, _NR},
    {OpcodeDEC, ModeZeroPage, _NR, _NR},
    _,
    {OpcodeINY, ModeImplied, Y, Y},
    {OpcodeCMP, ModeImmediate, A, _NR},
    {OpcodeDEX, ModeImplied, X, X},
    _,
    {OpcodeCPY, ModeAbsolute, Y, _NR},
    {OpcodeCMP, ModeAbsolute, A, _NR},
    {OpcodeDEC, ModeAbsolute, _NR, _NR},
    _,
    {OpcodeBNE, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeCMP, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    _,
    _,
    {OpcodeCMP, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeDEC, ModeZeroPageIndexedX, X, _NR},
    _,
    {OpcodeCLD, ModeImplied, _NR, _NR},
    {OpcodeCMP, ModeAbsoluteIndexedY, A | Y, _NR},
    _,
    _,
    _,
    {OpcodeCMP, ModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeDEC, ModeAbsoluteIndexedX, X, _NR},
    _,
    {OpcodeCPX, ModeImmediate, X, _NR},
    {OpcodeSBC, ModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    {OpcodeCPX, ModeZeroPage, X, _NR},
    {OpcodeSBC, ModeZeroPage, A, A},
    {OpcodeINC, ModeZeroPage, _NR, _NR},
    _,
    {OpcodeINX, ModeImplied, X, X},
    {OpcodeSBC, ModeImmediate, A, A},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    _,
    {OpcodeCPX, ModeAbsolute, X, _NR},
    {OpcodeSBC, ModeAbsolute, A, A},
    {OpcodeINC, ModeAbsolute, _NR, _NR},
    _,
    {OpcodeBEQ, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSBC, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeSBC, ModeZeroPageIndexedX, A | X, A},
    {OpcodeINC, ModeZeroPageIndexedX, X, _NR},
    _,
    {OpcodeSED, ModeImplied, _NR, _NR},
    {OpcodeSBC, ModeAbsoluteIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeSBC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeINC, ModeAbsoluteIndexedX, X, _NR},
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
