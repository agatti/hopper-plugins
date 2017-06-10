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

#import "M740.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Opcode kOpcodeTable[256];

@implementation ItFrobHopper6502M740

+ (NSString *_Nonnull)family {
  return @"Mitsubishi";
}

+ (NSString *_Nonnull)model {
  return @"M740";
}

+ (BOOL)exported {
  return YES;
}

+ (int)addressSpaceWidth {
  return 16;
}

- (void)updateFlags:(DisasmStruct *)structure
     forInstruction:(const Instruction *_Nonnull)instruction {

  /*
   * This is a hack for the M740, which has an extra flag.  Currently Hopper
   * does not allow to add or remove custom CPU flags so we have to piggyback
   * on the ARM/Thumb register switcher which is still available on non-ARM CPU
   * backends (although it really shouldn't).
   */

  switch (instruction->opcode->type) {
  case OpcodeSET:
    structure->instruction.eflags.TF_flag = DISASM_EFLAGS_SET;
    break;

  case OpcodeCLT:
    structure->instruction.eflags.TF_flag = DISASM_EFLAGS_RESET;
    break;

  case OpcodeCLW:
    structure->instruction.eflags.OF_flag = DISASM_EFLAGS_RESET;
    break;

  default:
    break;
  }
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
    {OpcodeBRK, ModeImplied, _NR, S | P},
    {OpcodeORA, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeJSR, ModeZeroPageIndirect, _NR, _NR},
    {OpcodeBBS0, ModeAccumulator, A, A},
    _,
    {OpcodeORA, ModeZeroPage, A, A},
    {OpcodeASL, ModeZeroPage, _NR, _NR},
    {OpcodeBBS0, ModeZeroPage, _NR, _NR},
    {OpcodePHP, ModeStack, S | P, S},
    {OpcodeORA, ModeImmediate, A, A},
    {OpcodeASL, ModeAccumulator, A, A},
    {OpcodeSEB0, ModeAccumulator, A, A},
    _,
    {OpcodeORA, ModeAbsolute, A, A},
    {OpcodeASL, ModeAbsolute, _NR, _NR},
    {OpcodeSEB0, ModeZeroPage, _NR, _NR},
    {OpcodeBPL, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeORA, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeCLT, ModeImplied, _NR, _NR},
    {OpcodeBBC0, ModeAccumulator, A, A},
    _,
    {OpcodeORA, ModeZeroPageIndexedX, A | X, A},
    {OpcodeASL, ModeZeroPageIndexedX, A | X, A},
    {OpcodeBBC0, ModeZeroPage, _NR, _NR},
    {OpcodeCLC, ModeImplied, _NR, _NR},
    {OpcodeORA, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeDEC, ModeAccumulator, A, A},
    {OpcodeCLB0, ModeAccumulator, A, A},
    _,
    {OpcodeORA, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeASL, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeCLB0, ModeZeroPage, _NR, _NR},
    {OpcodeJSR, ModeAbsolute, _NR, _NR},
    {OpcodeAND, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeJSR, ModeSpecialPage, _NR, _NR},
    {OpcodeBBS1, ModeAccumulator, A, A},
    {OpcodeBIT, ModeZeroPage, A, _NR},
    {OpcodeAND, ModeZeroPage, A, A},
    {OpcodeROL, ModeZeroPage, _NR, _NR},
    {OpcodeBBS1, ModeZeroPage, _NR, _NR},
    {OpcodePLP, ModeStack, S, S | P},
    {OpcodeAND, ModeImmediate, A, A},
    {OpcodeROL, ModeAccumulator, A, A},
    {OpcodeSEB1, ModeAccumulator, A, A},
    {OpcodeBIT, ModeAbsolute, A, _NR},
    {OpcodeAND, ModeAbsolute, A, A},
    {OpcodeROL, ModeAbsolute, _NR, _NR},
    {OpcodeSEB1, ModeZeroPage, _NR, _NR},
    {OpcodeBMI, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeAND, ModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeSET, ModeImplied, _NR, _NR},
    {OpcodeBBC1, ModeAccumulator, A, A},
    _,
    {OpcodeAND, ModeZeroPageIndexedX, A | X, A},
    {OpcodeROL, ModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC1, ModeZeroPage, _NR, _NR},
    {OpcodeSEC, ModeImplied, _NR, _NR},
    {OpcodeAND, ModeAbsoluteIndexedY, A | Y, A},
    {OpcodeINC, ModeAccumulator, A, A},
    {OpcodeCLB1, ModeAccumulator, A, A},
    {OpcodeLDM, ModeImmediateZeroPage, _NR, _NR},
    {OpcodeAND, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeROL, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB1, ModeZeroPage, _NR, _NR},
    {OpcodeRTI, ModeStack, _NR, _NR},
    {OpcodeEOR, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeSTP, ModeImplied, _NR, _NR},
    {OpcodeBBS2, ModeAccumulator, A, A},
    {OpcodeCOM, ModeZeroPage, _NR, _NR},
    {OpcodeEOR, ModeZeroPage, A, A},
    {OpcodeLSR, ModeZeroPage, _NR, _NR},
    {OpcodeBBS2, ModeZeroPage, _NR, _NR},
    {OpcodePHA, ModeStack, A | S, S},
    {OpcodeEOR, ModeImmediate, A, A},
    {OpcodeLSR, ModeAccumulator, A, A},
    {OpcodeSEB2, ModeAccumulator, A, A},
    {OpcodeJMP, ModeAbsolute, _NR, _NR},
    {OpcodeEOR, ModeAbsolute, A, A},
    {OpcodeLSR, ModeAbsolute, _NR, _NR},
    {OpcodeSEB2, ModeZeroPage, _NR, _NR},
    {OpcodeBVC, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeEOR, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    {OpcodeBBC2, ModeAccumulator, A, A},
    _,
    {OpcodeEOR, ModeZeroPageIndexedX, A | X, A},
    {OpcodeLSR, ModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC2, ModeZeroPage, _NR, _NR},
    {OpcodeCLI, ModeImplied, _NR, _NR},
    {OpcodeEOR, ModeAbsoluteIndexedY, A | Y, A},
    _,
    {OpcodeCLB2, ModeAccumulator, A, A},
    _,
    {OpcodeEOR, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeLSR, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB2, ModeZeroPage, _NR, _NR},
    {OpcodeRTS, ModeStack, _NR, _NR},
    {OpcodeADC, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeMUL, ModeZeroPageIndexedX, A | X, A | S},
    {OpcodeBBS3, ModeAccumulator, A, A},
    {OpcodeTST, ModeZeroPage, _NR, _NR},
    {OpcodeADC, ModeZeroPage, A, A},
    {OpcodeROR, ModeZeroPage, _NR, _NR},
    {OpcodeBBS3, ModeZeroPage, _NR, _NR},
    {OpcodePLA, ModeStack, S, A | S},
    {OpcodeADC, ModeImmediate, A, A},
    {OpcodeROR, ModeAccumulator, A, A},
    {OpcodeSEB3, ModeAccumulator, A, A},
    {OpcodeJMP, ModeAbsoluteIndirect, _NR, _NR},
    {OpcodeADC, ModeAbsolute, A, A},
    {OpcodeROR, ModeAbsolute, _NR, _NR},
    {OpcodeSEB3, ModeZeroPage, _NR, _NR},
    {OpcodeBVS, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeADC, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    {OpcodeBBC3, ModeAccumulator, A, A},
    _,
    {OpcodeADC, ModeZeroPageIndexedX, A | X, A},
    {OpcodeROR, ModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC3, ModeZeroPage, _NR, _NR},
    {OpcodeSEI, ModeImplied, _NR, _NR},
    {OpcodeADC, ModeAbsoluteIndexedY, A | Y, A},
    _,
    {OpcodeCLB3, ModeAccumulator, A, A},
    _,
    {OpcodeADC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeROR, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB3, ModeZeroPage, _NR, _NR},
    {OpcodeBRA, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, ModeZeroPageIndexedIndirect, A | X, _NR},
    {OpcodeRRF, ModeZeroPage, _NR, _NR},
    {OpcodeBBS4, ModeAccumulator, A, A},
    {OpcodeSTY, ModeZeroPage, Y, _NR},
    {OpcodeSTA, ModeZeroPage, A, _NR},
    {OpcodeSTX, ModeZeroPage, X, _NR},
    {OpcodeBBS4, ModeZeroPage, _NR, _NR},
    {OpcodeDEY, ModeImplied, Y, Y},
    _,
    {OpcodeTXA, ModeImplied, A | X, A | X},
    {OpcodeSEB4, ModeAccumulator, A, A},
    {OpcodeSTY, ModeAbsolute, Y, _NR},
    {OpcodeSTA, ModeAbsolute, A, _NR},
    {OpcodeSTX, ModeAbsolute, X, _NR},
    {OpcodeSEB4, ModeZeroPage, _NR, _NR},
    {OpcodeBCC, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    {OpcodeBBC4, ModeAccumulator, A, A},
    {OpcodeSTY, ModeZeroPageIndexedX, X | Y, _NR},
    {OpcodeSTA, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeSTX, ModeZeroPageIndexedY, X | Y, _NR},
    {OpcodeBBC4, ModeZeroPage, _NR, _NR},
    {OpcodeTYA, ModeImplied, A | Y, A | Y},
    {OpcodeSTA, ModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeTXS, ModeImplied, X | S, X | S},
    {OpcodeCLB4, ModeAccumulator, A, A},
    _,
    {OpcodeSTA, ModeAbsoluteIndexedX, A | X, _NR},
    _,
    {OpcodeCLB4, ModeZeroPage, _NR, _NR},
    {OpcodeLDY, ModeImmediate, _NR, Y},
    {OpcodeLDA, ModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDX, ModeImmediate, _NR, X},
    {OpcodeBBS5, ModeAccumulator, A, A},
    {OpcodeLDY, ModeZeroPage, _NR, Y},
    {OpcodeLDA, ModeZeroPage, _NR, A},
    {OpcodeLDX, ModeZeroPage, _NR, X},
    {OpcodeBBS5, ModeZeroPage, _NR, _NR},
    {OpcodeTAY, ModeImplied, A | Y, A | Y},
    {OpcodeLDA, ModeImmediate, _NR, A},
    {OpcodeTAX, ModeImplied, A | X, A | X},
    {OpcodeSEB5, ModeAccumulator, A, A},
    {OpcodeLDY, ModeAbsolute, _NR, Y},
    {OpcodeLDA, ModeAbsolute, _NR, A},
    {OpcodeLDX, ModeAbsolute, _NR, X},
    {OpcodeSEB5, ModeZeroPage, _NR, _NR},
    {OpcodeBCS, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeLDA, ModeZeroPageIndirectIndexedY, Y, A},
    {OpcodeJMP, ModeZeroPageIndirect, _NR, _NR},
    {OpcodeBBC5, ModeAccumulator, A, A},
    {OpcodeLDY, ModeZeroPageIndexedX, X, Y},
    {OpcodeLDA, ModeZeroPageIndexedX, X, A},
    {OpcodeLDX, ModeZeroPageIndexedY, Y, A},
    {OpcodeBBC5, ModeZeroPage, _NR, _NR},
    {OpcodeCLV, ModeImplied, _NR, _NR},
    {OpcodeLDA, ModeAbsoluteIndexedY, Y, A},
    {OpcodeTSX, ModeImplied, X | S, X | S},
    {OpcodeCLB5, ModeAccumulator, A, A},
    {OpcodeLDY, ModeAbsoluteIndexedX, X, Y},
    {OpcodeLDA, ModeAbsoluteIndexedX, X, A},
    {OpcodeLDX, ModeAbsoluteIndexedY, X, Y},
    {OpcodeCLB5, ModeZeroPage, _NR, _NR},
    {OpcodeCPY, ModeImmediate, Y, _NR},
    {OpcodeCMP, ModeZeroPageIndexedIndirect, A, _NR},
    {OpcodeWIT, ModeImplied, _NR, _NR},
    {OpcodeBBS6, ModeAccumulator, A, A},
    {OpcodeCPY, ModeZeroPage, Y, _NR},
    {OpcodeCMP, ModeZeroPage, A, _NR},
    {OpcodeDEC, ModeZeroPage, _NR, _NR},
    {OpcodeBBS6, ModeZeroPage, _NR, _NR},
    {OpcodeINY, ModeImplied, Y, Y},
    {OpcodeCMP, ModeImmediate, A, _NR},
    {OpcodeDEX, ModeImplied, X, X},
    {OpcodeSEB6, ModeAccumulator, A, A},
    {OpcodeCPY, ModeAbsolute, Y, _NR},
    {OpcodeCMP, ModeAbsolute, A, _NR},
    {OpcodeDEC, ModeAbsolute, _NR, _NR},
    {OpcodeSEB6, ModeZeroPage, _NR, _NR},
    {OpcodeBNE, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeCMP, ModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    {OpcodeBBC6, ModeAccumulator, A, A},
    _,
    {OpcodeCMP, ModeZeroPageIndexedX, A | X, _NR},
    {OpcodeDEC, ModeZeroPageIndexedX, X, X},
    {OpcodeBBC6, ModeZeroPage, _NR, _NR},
    {OpcodeCLD, ModeImplied, _NR, _NR},
    {OpcodeCMP, ModeAbsoluteIndexedY, A | Y, _NR},
    _,
    {OpcodeCLB6, ModeAccumulator, A, A},
    _,
    {OpcodeCMP, ModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeDEC, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB6, ModeZeroPage, _NR, _NR},
    {OpcodeCPX, ModeImmediate, X, _NR},
    {OpcodeSBC, ModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeDIV, ModeZeroPageIndexedX, A | X, A | S},
    {OpcodeBBS7, ModeAccumulator, A, A},
    {OpcodeCPX, ModeZeroPage, X, _NR},
    {OpcodeSBC, ModeZeroPage, A, A},
    {OpcodeINC, ModeZeroPage, _NR, _NR},
    {OpcodeBBS7, ModeZeroPage, _NR, _NR},
    {OpcodeINX, ModeImplied, X, X},
    {OpcodeSBC, ModeImmediate, A, A},
    {OpcodeNOP, ModeImplied, _NR, _NR},
    {OpcodeSEB7, ModeAccumulator, _NR, _NR},
    {OpcodeCPX, ModeAbsolute, X, _NR},
    {OpcodeSBC, ModeAbsolute, A, A},
    {OpcodeINC, ModeAbsolute, _NR, _NR},
    {OpcodeSEB7, ModeZeroPage, _NR, _NR},
    {OpcodeBEQ, ModeProgramCounterRelative, _NR, _NR},
    {OpcodeSBC, ModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    {OpcodeBBC7, ModeAccumulator, A, A},
    _,
    {OpcodeSBC, ModeZeroPageIndexedX, A | X, A},
    {OpcodeINC, ModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC7, ModeZeroPage, _NR, _NR},
    {OpcodeSED, ModeImplied, _NR, _NR},
    {OpcodeSBC, ModeAbsoluteIndexedY, A | Y, A},
    _,
    {OpcodeCLB7, ModeAccumulator, A, A},
    _,
    {OpcodeSBC, ModeAbsoluteIndexedX, A | X, A},
    {OpcodeINC, ModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB7, ModeZeroPage, _NR, _NR}};

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
