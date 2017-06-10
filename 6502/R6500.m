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

#import "R6500.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Opcode kOpcodeTable[256];

@implementation ItFrobHopper6502R6500

+ (NSString *_Nonnull)family {
  return @"Rockwell";
}

+ (NSString *_Nonnull)model {
  return @"R6500";
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
    {OpcodeORA, AddressModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    _,
    {OpcodeORA, AddressModeZeroPage, A, A},
    {OpcodeASL, AddressModeZeroPage, _NR, _NR},
    {OpcodeRMB0, AddressModeZeroPage, _NR, _NR},
    {OpcodePHP, AddressModeStack, S | P, S},
    {OpcodeORA, AddressModeImmediate, A, A},
    {OpcodeASL, AddressModeAccumulator, A, A},
    _,
    _,
    {OpcodeORA, AddressModeAbsolute, A, A},
    {OpcodeASL, AddressModeAbsolute, _NR, _NR},
    {OpcodeBBR0, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeBPL, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeORA, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeORA, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeASL, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeRMB1, AddressModeZeroPage, _NR, _NR},
    {OpcodeCLC, AddressModeImplied, _NR, _NR},
    {OpcodeORA, AddressModeAbsoluteIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeORA, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeASL, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeBBR1, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeJSR, AddressModeAbsolute, _NR, _NR},
    {OpcodeAND, AddressModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    {OpcodeBIT, AddressModeZeroPage, A, _NR},
    {OpcodeAND, AddressModeZeroPage, A, A},
    {OpcodeROL, AddressModeZeroPage, _NR, _NR},
    {OpcodeRMB2, AddressModeZeroPage, _NR, _NR},
    {OpcodePLP, AddressModeStack, S, S | P},
    {OpcodeAND, AddressModeImmediate, A, A},
    {OpcodeROL, AddressModeAccumulator, A, A},
    _,
    {OpcodeBIT, AddressModeAbsolute, A, _NR},
    {OpcodeAND, AddressModeAbsolute, A, A},
    {OpcodeROL, AddressModeAbsolute, _NR, _NR},
    {OpcodeBBR2, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeBMI, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeAND, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    {OpcodeBIT, AddressModeZeroPageIndexedX, A | X, _NR},
    {OpcodeAND, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeROL, AddressModeZeroPageIndexedX, X, _NR},
    {OpcodeRMB3, AddressModeZeroPage, _NR, _NR},
    {OpcodeSEC, AddressModeImplied, _NR, _NR},
    {OpcodeAND, AddressModeAbsoluteIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeAND, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeROL, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeBBR3, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeRTI, AddressModeStack, _NR, _NR},
    {OpcodeEOR, AddressModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    _,
    {OpcodeEOR, AddressModeZeroPage, A, A},
    {OpcodeLSR, AddressModeZeroPage, _NR, _NR},
    {OpcodeRMB4, AddressModeZeroPage, _NR, _NR},
    {OpcodePHA, AddressModeStack, A | S, S},
    {OpcodeEOR, AddressModeImmediate, A, A},
    {OpcodeLSR, AddressModeAccumulator, A, A},
    _,
    {OpcodeJMP, AddressModeAbsolute, _NR, _NR},
    {OpcodeEOR, AddressModeAbsolute, A, A},
    {OpcodeLSR, AddressModeAbsolute, _NR, _NR},
    {OpcodeBBR4, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeBVC, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeEOR, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeEOR, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeLSR, AddressModeZeroPageIndexedX, X, _NR},
    {OpcodeRMB5, AddressModeZeroPage, _NR, _NR},
    {OpcodeCLI, AddressModeImplied, _NR, _NR},
    {OpcodeEOR, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodePHY, AddressModeStack, Y | S, S},
    _,
    _,
    {OpcodeEOR, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeLSR, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeBBR5, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeRTS, AddressModeStack, _NR, _NR},
    {OpcodeADC, AddressModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    {OpcodeSTZ, AddressModeZeroPage, _NR, _NR},
    {OpcodeADC, AddressModeZeroPage, A, A},
    {OpcodeROR, AddressModeZeroPage, _NR, _NR},
    {OpcodeRMB6, AddressModeZeroPage, _NR, _NR},
    {OpcodePLA, AddressModeStack, S, A | S},
    {OpcodeADC, AddressModeImmediate, A, A},
    {OpcodeROR, AddressModeAccumulator, A, A},
    _,
    {OpcodeJMP, AddressModeAbsoluteIndirect, _NR, _NR},
    {OpcodeADC, AddressModeAbsolute, A, A},
    {OpcodeROR, AddressModeAbsolute, _NR, _NR},
    {OpcodeBBR6, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeBVS, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeADC, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    {OpcodeSTZ, AddressModeZeroPageIndexedX, X, _NR},
    {OpcodeADC, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeROR, AddressModeZeroPageIndexedX, X, _NR},
    {OpcodeRMB7, AddressModeZeroPage, _NR, _NR},
    {OpcodeSEI, AddressModeImplied, _NR, _NR},
    {OpcodeADC, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodePLY, AddressModeStack, S, Y | S},
    _,
    _,
    {OpcodeADC, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeROR, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeBBR7, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeBRA, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, AddressModeZeroPageIndexedIndirect, A | X, _NR},
    _,
    _,
    {OpcodeSTY, AddressModeZeroPage, Y, _NR},
    {OpcodeSTA, AddressModeZeroPage, A, _NR},
    {OpcodeSTX, AddressModeZeroPage, X, _NR},
    {OpcodeSMB0, AddressModeZeroPage, _NR, _NR},
    {OpcodeDEY, AddressModeImplied, Y, Y},
    {OpcodeBIT, AddressModeImmediate, A, _NR},
    {OpcodeTXA, AddressModeImplied, A | X, A | X},
    _,
    {OpcodeSTY, AddressModeAbsolute, Y, _NR},
    {OpcodeSTA, AddressModeAbsolute, A, _NR},
    {OpcodeSTX, AddressModeAbsolute, X, _NR},
    {OpcodeBBS0, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeBCC, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, AddressModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    _,
    {OpcodeSTY, AddressModeZeroPageIndexedX, X | Y, _NR},
    {OpcodeSTA, AddressModeZeroPageIndexedX, A | X, _NR},
    {OpcodeSTX, AddressModeZeroPageIndexedY, X | Y, _NR},
    {OpcodeSMB1, AddressModeZeroPage, _NR, _NR},
    {OpcodeTYA, AddressModeImplied, A | Y, A | Y},
    {OpcodeSTA, AddressModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeTXS, AddressModeImplied, X | S, X | S},
    _,
    {OpcodeSTZ, AddressModeAbsolute, _NR, _NR},
    {OpcodeSTA, AddressModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeSTZ, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeBBS1, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeLDY, AddressModeImmediate, _NR, Y},
    {OpcodeLDA, AddressModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDX, AddressModeImmediate, _NR, X},
    _,
    {OpcodeLDY, AddressModeZeroPage, _NR, Y},
    {OpcodeLDA, AddressModeZeroPage, _NR, A},
    {OpcodeLDX, AddressModeZeroPage, _NR, X},
    {OpcodeSMB2, AddressModeZeroPage, _NR, _NR},
    {OpcodeTAY, AddressModeImplied, A | Y, A | Y},
    {OpcodeLDA, AddressModeImmediate, _NR, A},
    {OpcodeTAX, AddressModeImplied, A | X, A | X},
    _,
    {OpcodeLDY, AddressModeAbsolute, _NR, Y},
    {OpcodeLDA, AddressModeAbsolute, _NR, A},
    {OpcodeLDX, AddressModeAbsolute, _NR, X},
    {OpcodeBBS2, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeBCS, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeLDA, AddressModeZeroPageIndirectIndexedY, Y, A},
    _,
    _,
    {OpcodeLDY, AddressModeZeroPageIndexedX, X, Y},
    {OpcodeLDA, AddressModeZeroPageIndexedX, X, A},
    {OpcodeLDX, AddressModeZeroPageIndexedY, Y, A},
    {OpcodeSMB3, AddressModeZeroPage, _NR, _NR},
    {OpcodeCLV, AddressModeImplied, _NR, _NR},
    {OpcodeLDA, AddressModeAbsoluteIndexedY, Y, A},
    {OpcodeTSX, AddressModeImplied, X | S, X | S},
    _,
    {OpcodeLDY, AddressModeAbsoluteIndexedX, X, Y},
    {OpcodeLDA, AddressModeAbsoluteIndexedX, X, A},
    {OpcodeLDX, AddressModeAbsoluteIndexedY, X, Y},
    {OpcodeBBS3, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeCPY, AddressModeImmediate, Y, _NR},
    {OpcodeCMP, AddressModeZeroPageIndexedIndirect, A, _NR},
    _,
    _,
    {OpcodeCPY, AddressModeZeroPage, Y, _NR},
    {OpcodeCMP, AddressModeZeroPage, A, _NR},
    {OpcodeDEC, AddressModeZeroPage, _NR, _NR},
    {OpcodeSMB4, AddressModeZeroPage, _NR, _NR},
    {OpcodeINY, AddressModeImplied, Y, Y},
    {OpcodeCMP, AddressModeImmediate, A, _NR},
    {OpcodeDEX, AddressModeImplied, X, X},
    _,
    {OpcodeCPY, AddressModeAbsolute, Y, _NR},
    {OpcodeCMP, AddressModeAbsolute, A, _NR},
    {OpcodeDEC, AddressModeAbsolute, _NR, _NR},
    {OpcodeBBS4, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeBNE, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeCMP, AddressModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    _,
    _,
    {OpcodeCMP, AddressModeZeroPageIndexedX, A | X, _NR},
    {OpcodeDEC, AddressModeZeroPageIndexedX, X, X},
    {OpcodeSMB5, AddressModeZeroPage, _NR, _NR},
    {OpcodeCLD, AddressModeImplied, _NR, _NR},
    {OpcodeCMP, AddressModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodePHX, AddressModeStack, X | S, S},
    _,
    _,
    {OpcodeCMP, AddressModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeDEC, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeBBS5, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeCPX, AddressModeImmediate, X, _NR},
    {OpcodeSBC, AddressModeZeroPageIndexedIndirect, A | X, A},
    _,
    _,
    {OpcodeCPX, AddressModeZeroPage, X, _NR},
    {OpcodeSBC, AddressModeZeroPage, A, A},
    {OpcodeINC, AddressModeZeroPage, _NR, _NR},
    {OpcodeSMB6, AddressModeZeroPage, _NR, _NR},
    {OpcodeINX, AddressModeImplied, X, X},
    {OpcodeSBC, AddressModeImmediate, A, A},
    {OpcodeNOP, AddressModeImplied, _NR, _NR},
    _,
    {OpcodeCPX, AddressModeAbsolute, X, _NR},
    {OpcodeSBC, AddressModeAbsolute, A, A},
    {OpcodeINC, AddressModeAbsolute, _NR, _NR},
    {OpcodeBBS6, AddressModeZeroPageProgramCounterRelative, _NR, _NR},
    {OpcodeBEQ, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeSBC, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    _,
    _,
    {OpcodeSBC, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeINC, AddressModeZeroPageIndexedX, X, _NR},
    {OpcodeSMB7, AddressModeZeroPage, _NR, _NR},
    {OpcodeSED, AddressModeImplied, _NR, _NR},
    {OpcodeSBC, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodePLX, AddressModeStack, S, X | S},
    _,
    _,
    {OpcodeSBC, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeINC, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeBBS7, AddressModeZeroPageProgramCounterRelative, _NR, _NR}};

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
