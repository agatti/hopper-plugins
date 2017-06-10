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
#define _NA AddressModeUnknown
#define _NR RegisterFlagsNone

#define _                                                                      \
  { _NO, _NA, _NR, _NR }

static const Opcode kOpcodeTable[256] = {
    {OpcodeBRK, AddressModeStack, _NR, S | P},
    _,
    {OpcodeRTI, AddressModeStack, _NR, _NR},
    _,
    {OpcodeORA, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeORA, AddressModeZeroPage, A, A},
    {OpcodeEOR, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeEOR, AddressModeZeroPage, A, A},
    {OpcodeBPL, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBVC, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeORA, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeORA, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeEOR, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeEOR, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeJSR, AddressModeAbsolute, _NR, _NR},
    {OpcodeBIT, AddressModeZeroPage, A, _NR},
    {OpcodeRTS, AddressModeStack, _NR, _NR},
    _,
    {OpcodeAND, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeAND, AddressModeZeroPage, A, A},
    {OpcodeADC, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeADC, AddressModeZeroPage, A, A},
    {OpcodeBMI, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBVS, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeAND, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeAND, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeADC, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeADC, AddressModeZeroPageIndexedX, A | X, A},
    _,
    {OpcodeSTY, AddressModeZeroPage, Y, _NR},
    {OpcodeCPY, AddressModeImmediate, Y, _NR},
    {OpcodeCPY, AddressModeZeroPage, Y, _NR},
    {OpcodeSTA, AddressModeZeroPageIndexedIndirect, A | X, _NR},
    {OpcodeSTA, AddressModeZeroPage, A, _NR},
    {OpcodeCMP, AddressModeZeroPageIndexedIndirect, A, _NR},
    {OpcodeCMP, AddressModeZeroPage, A, _NR},
    {OpcodeBCC, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTY, AddressModeZeroPageIndexedX, X | Y, _NR},
    {OpcodeBNE, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeSTA, AddressModeZeroPageIndirectIndexedY, A | Y, _NR},
    {OpcodeSTA, AddressModeZeroPageIndexedX, A | X, _NR},
    {OpcodeCMP, AddressModeZeroPageIndirectIndexedY, A | Y, _NR},
    {OpcodeCMP, AddressModeZeroPageIndexedX, A | X, _NR},
    {OpcodeLDY, AddressModeImmediate, _NR, Y},
    {OpcodeLDY, AddressModeZeroPage, _NR, Y},
    {OpcodeCPX, AddressModeImmediate, X, _NR},
    {OpcodeCPX, AddressModeZeroPage, X, _NR},
    {OpcodeLDA, AddressModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDA, AddressModeZeroPage, _NR, A},
    {OpcodeSBC, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeSBC, AddressModeZeroPage, A, A},
    {OpcodeBCS, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeLDY, AddressModeZeroPageIndexedX, X, Y},
    {OpcodeBEQ, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeLDA, AddressModeZeroPageIndirectIndexedY, Y, A},
    {OpcodeLDA, AddressModeZeroPageIndexedX, X, A},
    {OpcodeSBC, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeSBC, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodePHP, AddressModeStack, P | S, S},
    _,
    {OpcodePHA, AddressModeStack, A | S, S},
    {OpcodeJMP, AddressModeAbsolute, _NR, _NR},
    {OpcodeORA, AddressModeImmediate, A, A},
    {OpcodeORA, AddressModeAbsolute, A, A},
    {OpcodeEOR, AddressModeImmediate, A, A},
    {OpcodeEOR, AddressModeAbsolute, A, A},
    {OpcodeCLC, AddressModeImplied, _NR, _NR},
    _,
    {OpcodeCLI, AddressModeImplied, _NR, _NR},
    _,
    {OpcodeORA, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodeORA, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeEOR, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodeEOR, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodePLP, AddressModeStack, S, P | S},
    {OpcodeBIT, AddressModeAbsolute, A, _NR},
    {OpcodePLA, AddressModeStack, S, A | S},
    {OpcodeJMP, AddressModeAbsoluteIndirect, _NR, _NR},
    {OpcodeAND, AddressModeImmediate, A, A},
    {OpcodeAND, AddressModeAbsolute, A, A},
    {OpcodeADC, AddressModeImmediate, A, A},
    {OpcodeADC, AddressModeAbsolute, A, A},
    {OpcodeSEC, AddressModeImplied, _NR, _NR},
    _,
    {OpcodeSEI, AddressModeImplied, _NR, _NR},
    _,
    {OpcodeAND, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodeAND, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeADC, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodeADC, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeDEY, AddressModeImplied, Y, Y},
    {OpcodeSTY, AddressModeAbsolute, Y, _NR},
    {OpcodeINY, AddressModeImplied, Y, Y},
    {OpcodeCPY, AddressModeAbsolute, Y, _NR},
    _,
    {OpcodeSTA, AddressModeAbsolute, A, _NR},
    {OpcodeCMP, AddressModeImmediate, A, _NR},
    {OpcodeCMP, AddressModeAbsolute, A, _NR},
    {OpcodeTYA, AddressModeImplied, A | Y, A | Y},
    _,
    {OpcodeCLD, AddressModeImplied, _NR, _NR},
    _,
    {OpcodeSTA, AddressModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeSTA, AddressModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeCMP, AddressModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeCMP, AddressModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeTAY, AddressModeImplied, A | Y, A | Y},
    {OpcodeLDY, AddressModeAbsolute, _NR, Y},
    {OpcodeINX, AddressModeImplied, X, X},
    {OpcodeCPX, AddressModeAbsolute, X, _NR},
    {OpcodeLDA, AddressModeImmediate, _NR, A},
    {OpcodeLDA, AddressModeAbsolute, _NR, A},
    {OpcodeSBC, AddressModeImmediate, A, A},
    {OpcodeSBC, AddressModeAbsolute, A, A},
    {OpcodeCLV, AddressModeImplied, _NR, _NR},
    {OpcodeLDY, AddressModeAbsoluteIndexedX, X, Y},
    {OpcodeSED, AddressModeImplied, _NR, _NR},
    _,
    {OpcodeLDA, AddressModeAbsoluteIndexedY, Y, A},
    {OpcodeLDA, AddressModeAbsoluteIndexedX, X, A},
    {OpcodeSBC, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodeSBC, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeASL, AddressModeZeroPage, _NR, _NR},
    _,
    {OpcodeLSR, AddressModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeASL, AddressModeZeroPageIndexedX, A | X, A},
    _,
    {OpcodeLSR, AddressModeZeroPageIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeROL, AddressModeZeroPage, _NR, _NR},
    _,
    {OpcodeROR, AddressModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeROL, AddressModeZeroPageIndexedX, X, _NR},
    _,
    {OpcodeROR, AddressModeZeroPageIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeSTX, AddressModeZeroPage, X, _NR},
    _,
    {OpcodeDEC, AddressModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeSTX, AddressModeZeroPageIndexedY, X | Y, _NR},
    _,
    {OpcodeDEC, AddressModeZeroPageIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeLDX, AddressModeImmediate, _NR, X},
    {OpcodeLDX, AddressModeZeroPage, _NR, X},
    _,
    {OpcodeINC, AddressModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeINC, AddressModeZeroPageIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeASL, AddressModeAccumulator, A, A},
    {OpcodeASL, AddressModeAbsolute, _NR, _NR},
    {OpcodeLSR, AddressModeAccumulator, A, A},
    {OpcodeLSR, AddressModeAbsolute, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeASL, AddressModeAbsoluteIndexedX, A | X, A},
    _,
    {OpcodeLSR, AddressModeAbsoluteIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeROL, AddressModeAccumulator, A, A},
    {OpcodeROL, AddressModeAbsolute, _NR, _NR},
    {OpcodeROR, AddressModeAccumulator, A, A},
    {OpcodeROR, AddressModeAbsolute, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeROL, AddressModeAbsoluteIndexedX, X, _NR},
    _,
    {OpcodeROR, AddressModeAbsoluteIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeTXA, AddressModeImplied, A | X, A | X},
    {OpcodeSTX, AddressModeAbsolute, X, _NR},
    {OpcodeDEX, AddressModeImplied, X, X},
    {OpcodeDEC, AddressModeAbsolute, _NR, _NR},
    _,
    _,
    _,
    _,
    {OpcodeTXS, AddressModeImplied, X | S, X | S},
    {OpcodeLDX, AddressModeZeroPageIndexedY, Y, A},
    _,
    {OpcodeDEC, AddressModeAbsoluteIndexedX, X, _NR},
    _,
    _,
    _,
    _,
    {OpcodeTAX, AddressModeImplied, A | X, A | X},
    {OpcodeLDX, AddressModeAbsolute, _NR, X},
    {OpcodeNOP, AddressModeImplied, _NR, _NR},
    {OpcodeINC, AddressModeAbsolute, _NR, _NR},
    _,
    _,
    _,
    _,
    {OpcodeTSX, AddressModeImplied, X | S, X | S},
    {OpcodeLDX, AddressModeAbsoluteIndexedY, X, Y},
    _,
    {OpcodeINC, AddressModeAbsoluteIndexedX, X, _NR},
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
