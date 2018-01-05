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

#import "MOS6510.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Opcode kOpcodeTable[256];

@implementation ItFrobHopper6502MOS6510

+ (NSString *_Nonnull)family {
  return @"MOS";
}

+ (NSString *_Nonnull)model {
  return @"6510";
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

#define _NR RegisterFlagsNone

static const Opcode kOpcodeTable[256] = {
    {OpcodeBRK, ModeStack, _NR, S | P},
    {OpcodeORA, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeSLO, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeNOP, ModeZeroPage, _NR, _NR},
    {OpcodeORA, ModeZeroPage, A, A},
    {OpcodeASL, ModeZeroPage, _NR, _NR},
    {OpcodeSLO, ModeZeroPage, A, A},
    {OpcodePHP, ModeStack, P | S, S},
    {OpcodeORA, ModeImmediate, A, A},
    {OpcodeASL, ModeAccumulator, A, A},
    {OpcodeANC, ModeImmediate, A, A},
    {OpcodeNOP, ModeAbsolute, _NR, _NR},
    {OpcodeORA, ModeAbsolute, A, A},
    {OpcodeASL, ModeAbsolute, _NR, _NR},
    {OpcodeSLO, ModeAbsolute, A, A},

    {OpcodeBPL, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeORA, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeSLO, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeNOP, ModeZeroPageIndexedX, X, _NR},
    {OpcodeORA, ModeZeroPageIndexedX, A | X, A},
    {OpcodeASL, ModeZeroPageIndexedX, A | X, A},
    {OpcodeSLO, ModeZeroPageIndexedX, A | X, A},
    {OpcodeCLC, ModeImplied, _NR, _NR},
    {OpcodeORA, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeNOP, ModeImmediate, _NR, _NR},
    {OpcodeSLO, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeNOP, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeORA, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeASL, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeSLO, ModeAbsoluteIndexedX, A | X, A},

    {OpcodeJSR, ModeAbsolute, _NR, _NR},
    {OpcodeAND, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeRLA, ModeZeroPageIndexedIndirect, _NR, _NR},
    {OpcodeBIT, ModeZeroPage, A, _NR},
    {OpcodeAND, ModeZeroPage, A, A},
    {OpcodeROL, ModeZeroPage, _NR, _NR},
    {OpcodeRLA, ModeZeroPage, _NR, _NR},
    {OpcodePLP, ModeStack, S, P | S},
    {OpcodeAND, ModeImmediate, A, A},
    {OpcodeROL, ModeAccumulator, A, A},
    {OpcodeANC, ModeImmediate, A, A},
    {OpcodeBIT, ModeAbsolute, A, _NR},
    {OpcodeAND, ModeAbsolute, A, A},
    {OpcodeROL, ModeAbsolute, _NR, _NR},
    {OpcodeRLA, ModeAbsolute, _NR, _NR},

    {OpcodeBMI, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeAND, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeRLA, ModeZeroPageIndirectIndexedY, Y, _NR},
    {OpcodeNOP, ModeZeroPageIndexedX, X, _NR},
    {OpcodeAND, ModeZeroPageIndexedX, A | X, A},
    {OpcodeROL, ModeZeroPageIndexedX, X, _NR},
    {OpcodeRLA, ModeZeroPageIndexedX, X, _NR},
    {OpcodeSEC, ModeImplied, _NR, _NR},
    {OpcodeAND, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    {OpcodeRLA, ModeAbsoluteIndexedY, Y, _NR},
    {OpcodeNOP, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeAND, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeROL, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeRLA, ModeAbsolute, _NR, _NR},

    {OpcodeRTI, ModeStack, _NR, _NR},
    {OpcodeEOR, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeSRE, ModeZeroPageIndexedIndirect, _NR, _NR},
    {OpcodeNOP, ModeZeroPage, _NR, _NR},
    {OpcodeEOR, ModeZeroPage, A, A},
    {OpcodeLSR, ModeZeroPage, _NR, _NR},
    {OpcodeSRE, ModeZeroPage, _NR, _NR},
    {OpcodePHA, ModeStack, A | S, S},
    {OpcodeEOR, ModeImmediate, A, A},
    {OpcodeLSR, ModeAccumulator, A, A},
    {OpcodeALR, ModeImmediate, A, A},
    {OpcodeJMP, ModeAbsolute, _NR, _NR},
    {OpcodeEOR, ModeAbsolute, A, A},
    {OpcodeLSR, ModeAbsolute, _NR, _NR},
    {OpcodeSRE, ModeAbsolute, _NR, _NR},

    {OpcodeBVC, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeEOR, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeSRE, ModeZeroPageIndirectIndexedY, Y, _NR},
    {OpcodeNOP, ModeZeroPageIndexedX, X, _NR},
    {OpcodeEOR, ModeZeroPageIndexedX, A | X, A},
    {OpcodeLSR, ModeZeroPageIndexedX, X, _NR},
    {OpcodeSRE, ModeZeroPageIndexedX, X, _NR},
    {OpcodeCLI, ModeImplied, _NR, _NR},
    {OpcodeEOR, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    {OpcodeSRE, ModeAbsoluteIndexedY, Y, _NR},
    {OpcodeNOP, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeEOR, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeLSR, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeSRE, ModeAbsoluteIndexedX, X, _NR},

    {OpcodeRTS, ModeStack, _NR, _NR},
    {OpcodeADC, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeRRA, ModeZeroPageIndexedIndirect, X, _NR},
    {OpcodeNOP, ModeZeroPage, _NR, _NR},
    {OpcodeADC, ModeZeroPage, A, A},
    {OpcodeROR, ModeZeroPage, _NR, _NR},
    {OpcodeRRA, ModeZeroPage, _NR, _NR},
    {OpcodePLA, ModeStack, S, A | S},
    {OpcodeADC, ModeImmediate, A, A},
    {OpcodeROR, ModeAccumulator, A, A},
    {OpcodeARR, ModeImmediate, A, A},
    {OpcodeJMP, ModeAbsoluteIndirect, _NR, _NR},
    {OpcodeADC, ModeAbsolute, A, A},
    {OpcodeROR, ModeAbsolute, _NR, _NR},
    {OpcodeRRA, ModeAbsolute, A, A},

    {OpcodeBVS, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeADC, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeRRA, ModeZeroPageIndirectIndexedY, Y, _NR},
    {OpcodeNOP, ModeZeroPageIndexedX, X, _NR},
    {OpcodeADC, ModeZeroPageIndexedX, A | X, A},
    {OpcodeROR, ModeZeroPageIndexedX, X, _NR},
    {OpcodeRRA, ModeZeroPageIndexedX, X, _NR},
    {OpcodeSEI, ModeImplied, _NR, _NR},
    {OpcodeADC, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    {OpcodeRRA, ModeAbsoluteIndexedY, Y, _NR},
    {OpcodeNOP, ModeAbsoluteIndexedX, _NR, _NR},
    {OpcodeADC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeROR, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeRRA, ModeAbsoluteIndexedX, X, _NR},

    {OpcodeNOP, ModeImmediate, _NR, _NR},
    {OpcodeSTA, ModeZeroPageIndexedIndirect, A | X, _NR},
    {OpcodeNOP, ModeImmediate, _NR, _NR},
    {OpcodeSAX, ModeZeroPageIndexedIndirect, A | X, _NR},
    {OpcodeSTY, ModeZeroPage, Y, _NR},
    {OpcodeSTA, ModeZeroPage, A, _NR},
    {OpcodeSTX, ModeZeroPage, X, _NR},
    {OpcodeSAX, ModeZeroPage, A | X, _NR},
    {OpcodeDEY, ModeImplied, Y, Y},
    {OpcodeNOP, ModeImmediate, _NR, _NR},
    {OpcodeTXA, ModeImplied, A | X, A | X},
    {OpcodeXAA, ModeImmediate, X, A},
    {OpcodeSTY, ModeAbsolute, Y, _NR},
    {OpcodeSTA, ModeAbsolute, A, _NR},
    {OpcodeSTX, ModeAbsolute, X, _NR},
    {OpcodeSAX, ModeAbsolute, A | X, _NR},

    {OpcodeBCC, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeAHX, ModeZeroPageIndirectIndexedY, A | X, _NR},
    {OpcodeSTY, ModeZeroPageIndexedX, X | Y, _NR},
    {OpcodeSTA, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeSTX, ModeZeroPageIndexedY, X | Y, _NR},
    {OpcodeSAX, ModeZeroPageIndexedY, A | X | Y, _NR},
    {OpcodeTYA, ModeImplied, A | Y, A | Y},
    {OpcodeSTA, ModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeTXS, ModeImplied, X | S, X | S},
    {OpcodeTAS, ModeAbsoluteIndexedY, A | X | Y, S},
    {OpcodeSHY, ModeAbsoluteIndexedX, X | Y, _NR},
    {OpcodeSTA, ModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeSHX, ModeAbsoluteIndexedY, X | Y, _NR},
    {OpcodeAHX, ModeAbsoluteIndexedY, A | X | Y, _NR},

    {OpcodeLDY, ModeImmediate, _NR, Y},
    {OpcodeLDA, ModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDX, ModeImmediate, _NR, X},
    {OpcodeLAX, ModeZeroPageIndexedIndirect, X, A | X},
    {OpcodeLDY, ModeZeroPage, _NR, Y},
    {OpcodeLDA, ModeZeroPage, _NR, A},
    {OpcodeLDX, ModeZeroPage, _NR, X},
    {OpcodeLAX, ModeZeroPage, _NR, A | X},
    {OpcodeTAY, ModeImplied, A | Y, A | Y},
    {OpcodeLDA, ModeImmediate, _NR, A},
    {OpcodeTAX, ModeImplied, A | X, A | X},
    {OpcodeLAX, ModeImmediate, _NR, A | X},
    {OpcodeLDY, ModeAbsolute, _NR, Y},
    {OpcodeLDA, ModeAbsolute, _NR, A},
    {OpcodeLDX, ModeAbsolute, _NR, X},
    {OpcodeLAX, ModeAbsolute, _NR, A | X},

    {OpcodeBCS, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeLDA, ModeZeroPageIndirectIndexedY, Y, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeLAX, ModeZeroPageIndirectIndexedY, Y, A | X},
    {OpcodeLDY, ModeZeroPageIndexedX, X, Y},
    {OpcodeLDA, ModeZeroPageIndexedX, X, A},
    {OpcodeLDX, ModeZeroPageIndexedY, Y, A},
    {OpcodeLAX, ModeZeroPageIndexedY, Y, A | X},
    {OpcodeCLV, ModeImplied, _NR, _NR},
    {OpcodeLDA, ModeAbsoluteIndexedY, Y, A},
    {OpcodeTSX, ModeImplied, X | S, X | S},
    {OpcodeLAS, ModeAbsoluteIndexedY, S, A | S | X},
    {OpcodeLDY, ModeAbsoluteIndexedX, X, Y},
    {OpcodeLDA, ModeAbsoluteIndexedX, X, A},
    {OpcodeLDX, ModeAbsoluteIndexedY, X, Y},
    {OpcodeLAX, ModeAbsoluteIndexedY, Y, A | X},

    {OpcodeCPY, ModeImmediate, Y, _NR},
    {OpcodeCMP, ModeZeroPageIndexedIndirect, A, _NR},
    {OpcodeNOP, ModeImmediate, _NR, _NR},
    {OpcodeDCP, ModeZeroPageIndexedIndirect, X, A},
    {OpcodeCPY, ModeZeroPage, Y, _NR},
    {OpcodeCMP, ModeZeroPage, A, _NR},
    {OpcodeDEC, ModeZeroPage, _NR, _NR},
    {OpcodeDCP, ModeZeroPage, _NR, A},
    {OpcodeINY, ModeImplied, Y, Y},
    {OpcodeCMP, ModeImmediate, A, _NR},
    {OpcodeDEX, ModeImplied, X, X},
    {OpcodeAXS, ModeImmediate, A | X, X},
    {OpcodeCPY, ModeAbsolute, Y, _NR},
    {OpcodeCMP, ModeAbsolute, A, _NR},
    {OpcodeDEC, ModeAbsolute, _NR, _NR},
    {OpcodeDCP, ModeAbsolute, X, A},

    {OpcodeBNE, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeCMP, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeDCP, ModeZeroPageIndirectIndexedY, X | Y, A},
    {OpcodeNOP, ModeZeroPageIndexedX, X, _NR},
    {OpcodeCMP, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeDEC, ModeZeroPageIndexedX, X, _NR},
    {OpcodeDCP, ModeZeroPageIndexedX, X, A},
    {OpcodeCLD, ModeImplied, _NR, _NR},
    {OpcodeCMP, ModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    {OpcodeDCP, ModeAbsoluteIndexedY, Y, A},
    {OpcodeNOP, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCMP, ModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeDEC, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeDCP, ModeAbsoluteIndexedX, X, A},

    {OpcodeCPX, ModeImmediate, X, _NR},
    {OpcodeSBC, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeISC, ModeZeroPageIndexedIndirect, X, A},
    {OpcodeCPX, ModeZeroPage, X, _NR},
    {OpcodeSBC, ModeZeroPage, A, A},
    {OpcodeINC, ModeZeroPage, _NR, _NR},
    {OpcodeISC, ModeZeroPage, _NR, A},
    {OpcodeINX, ModeImplied, X, X},
    {OpcodeSBC, ModeImmediate, A, A},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    {OpcodeSBC, ModeImmediate, A, A},
    {OpcodeCPX, ModeAbsolute, X, _NR},
    {OpcodeSBC, ModeAbsolute, A, A},
    {OpcodeINC, ModeAbsolute, _NR, _NR},
    {OpcodeISC, ModeAbsolute, _NR, A},

    {OpcodeBEQ, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSBC, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeKIL, ModeImmediate, _NR, _NR},
    {OpcodeISC, ModeZeroPageIndirectIndexedY, Y, A},
    {OpcodeNOP, ModeZeroPageIndexedX, X, _NR},
    {OpcodeSBC, ModeZeroPageIndexedX, A | X, A},
    {OpcodeINC, ModeZeroPageIndexedX, X, _NR},
    {OpcodeISC, ModeZeroPageIndexedX, X, A},
    {OpcodeSED, ModeImplied, _NR, _NR},
    {OpcodeSBC, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    {OpcodeISC, ModeAbsoluteIndexedY, Y, A},
    {OpcodeNOP, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeSBC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeINC, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeISC, ModeAbsoluteIndexedX, X, A}};

#undef A
#undef X
#undef Y
#undef S
#undef P

#undef _NR

#pragma clang diagnostic pop
