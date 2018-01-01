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

#import "M37450.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Opcode kOpcodeTable[256];

@implementation ItFrobHopper6502M37450

+ (NSString *_Nonnull)family {
  return @"Mitsubishi";
}

+ (NSString *_Nonnull)model {
  return @"M37450";
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
    /* $0x */

    {OpcodeBRK, ModeImplied, _NR, S | P},
    {OpcodeORA, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeJSR, ModeZeroPageIndirect, _NR, _NR},
    {OpcodeBBS, ModeAccumulatorBitRelative, A, _NR},
    _,
    {OpcodeORA, ModeZeroPage, A, A},
    {OpcodeASL, ModeZeroPage, _NR, _NR},
    {OpcodeBBS, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodePHP, ModeStack, S | P, S},
    {OpcodeORA, ModeImmediate, A, A},
    {OpcodeASL, ModeAccumulator, A, A},
    {OpcodeSEB, ModeAccumulatorBit, A, _NR},
    _,
    {OpcodeORA, ModeAbsolute, A, A},
    {OpcodeASL, ModeAbsolute, _NR, _NR},
    {OpcodeSEB, ModeZeroPageBit, _NR, _NR},

    /* $1x */

    {OpcodeBPL, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeORA, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeCLT, ModeImplied, _NR, _NR},
    {OpcodeBBC, ModeAccumulatorBitRelative, A, _NR},
    _,
    {OpcodeORA, ModeZeroPageIndexedX, A | X, A},
    {OpcodeASL, ModeZeroPageIndexedX, A | X, A},
    {OpcodeBBC, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeCLC, ModeImplied, _NR, _NR},
    {OpcodeORA, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeDEC, ModeAccumulator, A, A},
    {OpcodeCLB, ModeAccumulatorBit, _NR, _NR},
    _,
    {OpcodeORA, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeASL, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeCLB, ModeZeroPageBit, _NR, _NR},

    /* $2x */

    {OpcodeJSR, ModeAbsolute, _NR, _NR},
    {OpcodeAND, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeJSR, ModeSpecialPage, _NR, _NR},
    {OpcodeBBS, ModeAccumulatorBitRelative, A, _NR},
    {OpcodeBIT, ModeZeroPage, A, _NR},
    {OpcodeAND, ModeZeroPage, A, A},
    {OpcodeROL, ModeZeroPage, _NR, _NR},
    {OpcodeBBS, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodePLP, ModeStack, S, S | P},
    {OpcodeAND, ModeImmediate, A, A},
    {OpcodeROL, ModeAccumulator, A, A},
    {OpcodeSEB, ModeAccumulatorBit, A, _NR},
    {OpcodeBIT, ModeAbsolute, A, _NR},
    {OpcodeAND, ModeAbsolute, A, A},
    {OpcodeROL, ModeAbsolute, _NR, _NR},
    {OpcodeSEB, ModeZeroPageBit, _NR, _NR},

    /* $3x */

    {OpcodeBMI, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeAND, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeSET, ModeImplied, _NR, _NR},
    {OpcodeBBC, ModeAccumulatorBitRelative, A, _NR},
    _,
    {OpcodeAND, ModeZeroPageIndexedX, A | X, A},
    {OpcodeROL, ModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeSEC, ModeImplied, _NR, _NR},
    {OpcodeAND, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeINC, ModeAccumulator, A, A},
    {OpcodeCLB, ModeAccumulatorBit, A, _NR},
    {OpcodeLDM, ModeDirectMemoryAccess, _NR, _NR},
    {OpcodeAND, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeROL, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB, ModeZeroPage, _NR, _NR},

    /* $4x */

    {OpcodeRTI, ModeStack, _NR, _NR},
    {OpcodeEOR, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeSTP, ModeImplied, _NR, _NR},
    {OpcodeBBS, ModeAccumulatorBitRelative, A, A},
    {OpcodeCOM, ModeZeroPage, _NR, _NR},
    {OpcodeEOR, ModeZeroPage, A, A},
    {OpcodeLSR, ModeZeroPage, _NR, _NR},
    {OpcodeBBS, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodePHA, ModeStack, A | S, S},
    {OpcodeEOR, ModeImmediate, A, A},
    {OpcodeLSR, ModeAccumulator, A, A},
    {OpcodeSEB, ModeAccumulatorBit, A, _NR},
    {OpcodeJMP, ModeAbsolute, _NR, _NR},
    {OpcodeEOR, ModeAbsolute, A, A},
    {OpcodeLSR, ModeAbsolute, _NR, _NR},
    {OpcodeSEB, ModeZeroPageBit, _NR, _NR},

    /* $5x */

    {OpcodeBVC, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeEOR, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    {OpcodeBBC, ModeAccumulatorBitRelative, A, _NR},
    _,
    {OpcodeEOR, ModeZeroPageIndexedX, A | X, A},
    {OpcodeLSR, ModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeCLI, ModeImplied, _NR, _NR},
    {OpcodeEOR, ModeAbsoluteIndexedY, A | Y, A},
    _,
    {OpcodeCLB, ModeAccumulatorBit, A, _NR},
    _,
    {OpcodeEOR, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeLSR, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB, ModeZeroPageBit, _NR, _NR},

    /* $6x */

    {OpcodeRTS, ModeStack, _NR, _NR},
    {OpcodeADC, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeMUL, ModeZeroPageIndexedX, A | X, A | S},
    {OpcodeBBS, ModeAccumulatorBitRelative, A, _NR},
    {OpcodeTST, ModeZeroPage, _NR, _NR},
    {OpcodeADC, ModeZeroPage, A, A},
    {OpcodeROR, ModeZeroPage, _NR, _NR},
    {OpcodeBBS, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodePLA, ModeStack, S, A | S},
    {OpcodeADC, ModeImmediate, A, A},
    {OpcodeROR, ModeAccumulator, A, A},
    {OpcodeSEB, ModeAccumulatorBit, A, _NR},
    {OpcodeJMP, ModeAbsoluteIndirect, _NR, _NR},
    {OpcodeADC, ModeAbsolute, A, A},
    {OpcodeROR, ModeAbsolute, _NR, _NR},
    {OpcodeSEB, ModeZeroPageBit, _NR, _NR},

    /* $7x */

    {OpcodeBVS, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeADC, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    {OpcodeBBC, ModeAccumulatorBitRelative, A, _NR},
    _,
    {OpcodeADC, ModeZeroPageIndexedX, A | X, A},
    {OpcodeROR, ModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeSEI, ModeImplied, _NR, _NR},
    {OpcodeADC, ModeAbsoluteIndexedY, A | Y, A},
    _,
    {OpcodeCLB, ModeAccumulatorBit, A, _NR},
    _,
    {OpcodeADC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeROR, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB, ModeZeroPageBit, _NR, _NR},

    /* $8x */

    {OpcodeBRA, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, ModeZeroPageIndexedIndirect, A | X, _NR},
    {OpcodeRRF, ModeZeroPage, _NR, _NR},
    {OpcodeBBS, ModeAccumulatorBitRelative, A, _NR},
    {OpcodeSTY, ModeZeroPage, Y, _NR},
    {OpcodeSTA, ModeZeroPage, A, _NR},
    {OpcodeSTX, ModeZeroPage, X, _NR},
    {OpcodeBBS, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeDEY, ModeImplied, Y, Y},
    _,
    {OpcodeTXA, ModeImplied, A | X, A | X},
    {OpcodeSEB, ModeAccumulatorBit, A, _NR},
    {OpcodeSTY, ModeAbsolute, Y, _NR},
    {OpcodeSTA, ModeAbsolute, A, _NR},
    {OpcodeSTX, ModeAbsolute, X, _NR},
    {OpcodeSEB, ModeZeroPageBit, _NR, _NR},

    /* $9x */

    {OpcodeBCC, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    {OpcodeBBC, ModeAccumulatorBitRelative, A, _NR},
    {OpcodeSTY, ModeZeroPageIndexedX, X | Y, _NR},
    {OpcodeSTA, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeSTX, ModeZeroPageIndexedY, X | Y, _NR},
    {OpcodeBBC, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeTYA, ModeImplied, A | Y, A | Y},
    {OpcodeSTA, ModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeTXS, ModeImplied, X | S, X | S},
    {OpcodeCLB, ModeAccumulatorBit, A, _NR},
    _,
    {OpcodeSTA, ModeAbsoluteIndexedX, A | X, _NR},
    _,
    {OpcodeCLB, ModeZeroPageBit, _NR, _NR},

    /* $Ax */

    {OpcodeLDY, ModeImmediate, _NR, Y},
    {OpcodeLDA, ModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDX, ModeImmediate, _NR, X},
    {OpcodeBBS, ModeAccumulatorBitRelative, A, _NR},
    {OpcodeLDY, ModeZeroPage, _NR, Y},
    {OpcodeLDA, ModeZeroPage, _NR, A},
    {OpcodeLDX, ModeZeroPage, _NR, X},
    {OpcodeBBS, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeTAY, ModeImplied, A | Y, A | Y},
    {OpcodeLDA, ModeImmediate, _NR, A},
    {OpcodeTAX, ModeImplied, A | X, A | X},
    {OpcodeSEB, ModeAccumulatorBit, _NR, _NR},
    {OpcodeLDY, ModeAbsolute, _NR, Y},
    {OpcodeLDA, ModeAbsolute, _NR, A},
    {OpcodeLDX, ModeAbsolute, _NR, X},
    {OpcodeSEB, ModeZeroPageBit, _NR, _NR},

    /* $Bx */

    {OpcodeBCS, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeLDA, ModeZeroPageIndirectIndexedY, Y, A},
    {OpcodeJMP, ModeZeroPageIndirect, _NR, _NR},
    {OpcodeBBC, ModeAccumulatorBitRelative, A, _NR},
    {OpcodeLDY, ModeZeroPageIndexedX, X, Y},
    {OpcodeLDA, ModeZeroPageIndexedX, X, A},
    {OpcodeLDX, ModeZeroPageIndexedY, Y, A},
    {OpcodeBBC, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeCLV, ModeImplied, _NR, _NR},
    {OpcodeLDA, ModeAbsoluteIndexedY, Y, A},
    {OpcodeTSX, ModeImplied, X | S, X | S},
    {OpcodeCLB, ModeAccumulatorBit, A, _NR},
    {OpcodeLDY, ModeAbsoluteIndexedX, X, Y},
    {OpcodeLDA, ModeAbsoluteIndexedX, X, A},
    {OpcodeLDX, ModeAbsoluteIndexedY, X, Y},
    {OpcodeCLB, ModeZeroPageBit, _NR, _NR},

    /* $Cx */

    {OpcodeCPY, ModeImmediate, Y, _NR},
    {OpcodeCMP, ModeZeroPageIndexedIndirect, A, _NR},
    {OpcodeWIT, ModeImplied, _NR, _NR},
    {OpcodeBBS, ModeAccumulatorBitRelative, A, _NR},
    {OpcodeCPY, ModeZeroPage, Y, _NR},
    {OpcodeCMP, ModeZeroPage, A, _NR},
    {OpcodeDEC, ModeZeroPage, _NR, _NR},
    {OpcodeBBS, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeINY, ModeImplied, Y, Y},
    {OpcodeCMP, ModeImmediate, A, _NR},
    {OpcodeDEX, ModeImplied, X, X},
    {OpcodeSEB, ModeAccumulatorBit, _NR, _NR},
    {OpcodeCPY, ModeAbsolute, Y, _NR},
    {OpcodeCMP, ModeAbsolute, A, _NR},
    {OpcodeDEC, ModeAbsolute, _NR, _NR},
    {OpcodeSEB, ModeZeroPageBit, _NR, _NR},

    /* $Dx */

    {OpcodeBNE, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeCMP, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    {OpcodeBBC, ModeAccumulatorBitRelative, A, _NR},
    _,
    {OpcodeCMP, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeDEC, ModeZeroPageIndexedX, X, X},
    {OpcodeBBC, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeCLD, ModeImplied, _NR, _NR},
    {OpcodeCMP, ModeAbsoluteIndexedY, A | Y, _NR},
    _,
    {OpcodeCLB, ModeAccumulatorBit, A, _NR},
    _,
    {OpcodeCMP, ModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeDEC, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB, ModeZeroPageBit, _NR, _NR},

    /* $Ex */

    {OpcodeCPX, ModeImmediate, X, _NR},
    {OpcodeSBC, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeDIV, ModeZeroPageIndexedX, A | X, A | S},
    {OpcodeBBS, ModeAccumulatorBitRelative, A, _NR},
    {OpcodeCPX, ModeZeroPage, X, _NR},
    {OpcodeSBC, ModeZeroPage, A, A},
    {OpcodeINC, ModeZeroPage, _NR, _NR},
    {OpcodeBBS, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeINX, ModeImplied, X, X},
    {OpcodeSBC, ModeImmediate, A, A},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    {OpcodeSEB, ModeAccumulatorBit, _NR, _NR},
    {OpcodeCPX, ModeAbsolute, X, _NR},
    {OpcodeSBC, ModeAbsolute, A, A},
    {OpcodeINC, ModeAbsolute, _NR, _NR},
    {OpcodeSEB, ModeZeroPageBit, _NR, _NR},

    /* $Fx */

    {OpcodeBEQ, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSBC, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    {OpcodeBBC, ModeAccumulatorBitRelative, A, _NR},
    _,
    {OpcodeSBC, ModeZeroPageIndexedX, A | X, A},
    {OpcodeINC, ModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC, ModeZeroPageBitRelative, _NR, _NR},
    {OpcodeSED, ModeImplied, _NR, _NR},
    {OpcodeSBC, ModeAbsoluteIndexedY, A | Y, A},
    _,
    {OpcodeCLB, ModeAccumulatorBit, A, _NR},
    _,
    {OpcodeSBC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeINC, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB, ModeZeroPageBit, _NR, _NR}};

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
