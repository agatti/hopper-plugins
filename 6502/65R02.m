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
#define _NA AddressModeUnknown
#define _NR RegisterFlagsNone

#define _                                                                      \
  { _NO, _NA, _NR, _NR }

static const Opcode kOpcodeTable[256] = {
    {OpcodeBRK, AddressModeStack, _NR, S | P},
    _,
    {OpcodeRTI, AddressModeStack, _NR, _NR},
    _,
    _,
    {OpcodeORA, AddressModeZeroPage, A, A},
    _,
    {OpcodeEOR, AddressModeZeroPage, A, A},
    {OpcodeBPL, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBVC, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    _,
    _,
    _,
    {OpcodeEOR, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeJSR, AddressModeAbsolute, _NR, _NR},
    {OpcodeBIT, AddressModeZeroPage, A, _NR},
    {OpcodeRTS, AddressModeStack, _NR, _NR},
    _,
    _,
    {OpcodeAND, AddressModeZeroPage, A, A},
    _,
    {OpcodeADC, AddressModeZeroPage, A, A},
    {OpcodeBMI, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBVS, AddressModeProgramCounterRelative, _NR, _NR},
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
    {OpcodeSTA, AddressModeZeroPage, A, _NR},
    _,
    {OpcodeCMP, AddressModeZeroPage, A, _NR},
    {OpcodeBCC, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBNE, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    _,
    {OpcodeSTA, AddressModeZeroPageIndexedX, A | X, _NR},
    _,
    {OpcodeCMP, AddressModeZeroPageIndexedX, A | X, _NR},
    _,
    _,
    {OpcodeCPX, AddressModeImmediate, X, _NR},
    {OpcodeCPX, AddressModeZeroPage, X, _NR},
    {OpcodeLDA, AddressModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDA, AddressModeZeroPage, _NR, A},
    _,
    {OpcodeSBC, AddressModeZeroPage, A, A},
    {OpcodeBCS, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    {OpcodeBEQ, AddressModeProgramCounterRelative, _NR, _NR},
    _,
    _,
    {OpcodeLDA, AddressModeZeroPageIndexedX, X, A},
    _,
    _,
    {OpcodePHP, AddressModeStack, P | S, S},
    _,
    {OpcodePHA, AddressModeStack, A | S, S},
    {OpcodeJMP, AddressModeAbsolute, _NR, _NR},
    {OpcodeORA, AddressModeImmediate, A, A},
    _,
    {OpcodeEOR, AddressModeImmediate, A, A},
    _,
    {OpcodeCLC, AddressModeImplied, _NR, _NR},
    _,
    {OpcodeCLI, AddressModeImplied, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodePLP, AddressModeStack, S, P | S},
    {OpcodeBIT, AddressModeAbsolute, A, _NR},
    {OpcodePLA, AddressModeStack, S, A | S},
    {OpcodeJMP, AddressModeAbsoluteIndirect, _NR, _NR},
    {OpcodeAND, AddressModeImmediate, A, A},
    _,
    {OpcodeADC, AddressModeImmediate, A, A},
    _,
    {OpcodeSEC, AddressModeImplied, _NR, _NR},
    _,
    {OpcodeSEI, AddressModeImplied, _NR, _NR},
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
    {OpcodeCMP, AddressModeImmediate, A, _NR},
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
    {OpcodeINX, AddressModeImplied, X, X},
    _,
    {OpcodeLDA, AddressModeImmediate, _NR, A},
    {OpcodeLDA, AddressModeAbsolute, _NR, A},
    {OpcodeSBC, AddressModeImmediate, A, A},
    _,
    {OpcodeCLV, AddressModeImplied, _NR, _NR},
    _,
    _,
    _,
    _,
    {OpcodeLDA, AddressModeAbsoluteIndexedX, X, A},
    _,
    _,
    {OpcodeASL, AddressModeZeroPage, _NR, _NR},
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
    {OpcodeROL, AddressModeZeroPage, _NR, _NR},
    _,
    {OpcodeROR, AddressModeZeroPage, _NR, _NR},
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
    {OpcodeSTX, AddressModeZeroPage, X, _NR},
    _,
    {OpcodeDEC, AddressModeZeroPage, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    _,
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
    _,
    _,
    _,
    _,
    _,
    {OpcodeASL, AddressModeAccumulator, A, A},
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
    {OpcodeROL, AddressModeAccumulator, A, A},
    _,
    {OpcodeROR, AddressModeAccumulator, A, A},
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
    {OpcodeTXA, AddressModeImplied, A | X, A | X},
    {OpcodeSTX, AddressModeAbsolute, X, _NR},
    {OpcodeDEX, AddressModeImplied, X, X},
    _,
    _,
    _,
    _,
    _,
    {OpcodeTXS, AddressModeImplied, X | S, X | S},
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    {OpcodeTAX, AddressModeImplied, A | X, A | X},
    _,
    {OpcodeNOP, AddressModeImplied, _NR, _NR},
    _,
    _,
    _,
    _,
    _,
    {OpcodeTSX, AddressModeImplied, X | S, X | S},
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
