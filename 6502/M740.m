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
#define _NA AddressModeUnknown
#define _NR RegisterFlagsNone

#define _                                                                      \
  { _NO, _NA, _NR, _NR }

static const Opcode kOpcodeTable[256] = {
    {OpcodeBRK, AddressModeImplied, _NR, S | P},
    {OpcodeORA, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeJSR, AddressModeZeroPageIndirect, _NR, _NR},
    {OpcodeBBS0, AddressModeAccumulator, A, A},
    _,
    {OpcodeORA, AddressModeZeroPage, A, A},
    {OpcodeASL, AddressModeZeroPage, _NR, _NR},
    {OpcodeBBS0, AddressModeZeroPage, _NR, _NR},
    {OpcodePHP, AddressModeStack, S | P, S},
    {OpcodeORA, AddressModeImmediate, A, A},
    {OpcodeASL, AddressModeAccumulator, A, A},
    {OpcodeSEB0, AddressModeAccumulator, A, A},
    _,
    {OpcodeORA, AddressModeAbsolute, A, A},
    {OpcodeASL, AddressModeAbsolute, _NR, _NR},
    {OpcodeSEB0, AddressModeZeroPage, _NR, _NR},
    {OpcodeBPL, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeORA, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeCLT, AddressModeImplied, _NR, _NR},
    {OpcodeBBC0, AddressModeAccumulator, A, A},
    _,
    {OpcodeORA, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeASL, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeBBC0, AddressModeZeroPage, _NR, _NR},
    {OpcodeCLC, AddressModeImplied, _NR, _NR},
    {OpcodeORA, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodeDEC, AddressModeAccumulator, A, A},
    {OpcodeCLB0, AddressModeAccumulator, A, A},
    _,
    {OpcodeORA, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeASL, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeCLB0, AddressModeZeroPage, _NR, _NR},
    {OpcodeJSR, AddressModeAbsolute, _NR, _NR},
    {OpcodeAND, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeJSR, AddressModeSpecialPage, _NR, _NR},
    {OpcodeBBS1, AddressModeAccumulator, A, A},
    {OpcodeBIT, AddressModeZeroPage, A, _NR},
    {OpcodeAND, AddressModeZeroPage, A, A},
    {OpcodeROL, AddressModeZeroPage, _NR, _NR},
    {OpcodeBBS1, AddressModeZeroPage, _NR, _NR},
    {OpcodePLP, AddressModeStack, S, S | P},
    {OpcodeAND, AddressModeImmediate, A, A},
    {OpcodeROL, AddressModeAccumulator, A, A},
    {OpcodeSEB1, AddressModeAccumulator, A, A},
    {OpcodeBIT, AddressModeAbsolute, A, _NR},
    {OpcodeAND, AddressModeAbsolute, A, A},
    {OpcodeROL, AddressModeAbsolute, _NR, _NR},
    {OpcodeSEB1, AddressModeZeroPage, _NR, _NR},
    {OpcodeBMI, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeAND, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    {OpcodeSET, AddressModeImplied, _NR, _NR},
    {OpcodeBBC1, AddressModeAccumulator, A, A},
    _,
    {OpcodeAND, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeROL, AddressModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC1, AddressModeZeroPage, _NR, _NR},
    {OpcodeSEC, AddressModeImplied, _NR, _NR},
    {OpcodeAND, AddressModeAbsoluteIndexedY, A | Y, A},
    {OpcodeINC, AddressModeAccumulator, A, A},
    {OpcodeCLB1, AddressModeAccumulator, A, A},
    {OpcodeLDM, AddressModeImmediateZeroPage, _NR, _NR},
    {OpcodeAND, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeROL, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB1, AddressModeZeroPage, _NR, _NR},
    {OpcodeRTI, AddressModeStack, _NR, _NR},
    {OpcodeEOR, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeSTP, AddressModeImplied, _NR, _NR},
    {OpcodeBBS2, AddressModeAccumulator, A, A},
    {OpcodeCOM, AddressModeZeroPage, _NR, _NR},
    {OpcodeEOR, AddressModeZeroPage, A, A},
    {OpcodeLSR, AddressModeZeroPage, _NR, _NR},
    {OpcodeBBS2, AddressModeZeroPage, _NR, _NR},
    {OpcodePHA, AddressModeStack, A | S, S},
    {OpcodeEOR, AddressModeImmediate, A, A},
    {OpcodeLSR, AddressModeAccumulator, A, A},
    {OpcodeSEB2, AddressModeAccumulator, A, A},
    {OpcodeJMP, AddressModeAbsolute, _NR, _NR},
    {OpcodeEOR, AddressModeAbsolute, A, A},
    {OpcodeLSR, AddressModeAbsolute, _NR, _NR},
    {OpcodeSEB2, AddressModeZeroPage, _NR, _NR},
    {OpcodeBVC, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeEOR, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    {OpcodeBBC2, AddressModeAccumulator, A, A},
    _,
    {OpcodeEOR, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeLSR, AddressModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC2, AddressModeZeroPage, _NR, _NR},
    {OpcodeCLI, AddressModeImplied, _NR, _NR},
    {OpcodeEOR, AddressModeAbsoluteIndexedY, A | Y, A},
    _,
    {OpcodeCLB2, AddressModeAccumulator, A, A},
    _,
    {OpcodeEOR, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeLSR, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB2, AddressModeZeroPage, _NR, _NR},
    {OpcodeRTS, AddressModeStack, _NR, _NR},
    {OpcodeADC, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeMUL, AddressModeZeroPageIndexedX, A | X, A | S},
    {OpcodeBBS3, AddressModeAccumulator, A, A},
    {OpcodeTST, AddressModeZeroPage, _NR, _NR},
    {OpcodeADC, AddressModeZeroPage, A, A},
    {OpcodeROR, AddressModeZeroPage, _NR, _NR},
    {OpcodeBBS3, AddressModeZeroPage, _NR, _NR},
    {OpcodePLA, AddressModeStack, S, A | S},
    {OpcodeADC, AddressModeImmediate, A, A},
    {OpcodeROR, AddressModeAccumulator, A, A},
    {OpcodeSEB3, AddressModeAccumulator, A, A},
    {OpcodeJMP, AddressModeAbsoluteIndirect, _NR, _NR},
    {OpcodeADC, AddressModeAbsolute, A, A},
    {OpcodeROR, AddressModeAbsolute, _NR, _NR},
    {OpcodeSEB3, AddressModeZeroPage, _NR, _NR},
    {OpcodeBVS, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeADC, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    {OpcodeBBC3, AddressModeAccumulator, A, A},
    _,
    {OpcodeADC, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeROR, AddressModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC3, AddressModeZeroPage, _NR, _NR},
    {OpcodeSEI, AddressModeImplied, _NR, _NR},
    {OpcodeADC, AddressModeAbsoluteIndexedY, A | Y, A},
    _,
    {OpcodeCLB3, AddressModeAccumulator, A, A},
    _,
    {OpcodeADC, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeROR, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB3, AddressModeZeroPage, _NR, _NR},
    {OpcodeBRA, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, AddressModeZeroPageIndexedIndirect, A | X, _NR},
    {OpcodeRRF, AddressModeZeroPage, _NR, _NR},
    {OpcodeBBS4, AddressModeAccumulator, A, A},
    {OpcodeSTY, AddressModeZeroPage, Y, _NR},
    {OpcodeSTA, AddressModeZeroPage, A, _NR},
    {OpcodeSTX, AddressModeZeroPage, X, _NR},
    {OpcodeBBS4, AddressModeZeroPage, _NR, _NR},
    {OpcodeDEY, AddressModeImplied, Y, Y},
    _,
    {OpcodeTXA, AddressModeImplied, A | X, A | X},
    {OpcodeSEB4, AddressModeAccumulator, A, A},
    {OpcodeSTY, AddressModeAbsolute, Y, _NR},
    {OpcodeSTA, AddressModeAbsolute, A, _NR},
    {OpcodeSTX, AddressModeAbsolute, X, _NR},
    {OpcodeSEB4, AddressModeZeroPage, _NR, _NR},
    {OpcodeBCC, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeSTA, AddressModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    {OpcodeBBC4, AddressModeAccumulator, A, A},
    {OpcodeSTY, AddressModeZeroPageIndexedX, X | Y, _NR},
    {OpcodeSTA, AddressModeZeroPageIndexedX, A | X, _NR},
    {OpcodeSTX, AddressModeZeroPageIndexedY, X | Y, _NR},
    {OpcodeBBC4, AddressModeZeroPage, _NR, _NR},
    {OpcodeTYA, AddressModeImplied, A | Y, A | Y},
    {OpcodeSTA, AddressModeAbsoluteIndexedY, A | Y, _NR},
    {OpcodeTXS, AddressModeImplied, X | S, X | S},
    {OpcodeCLB4, AddressModeAccumulator, A, A},
    _,
    {OpcodeSTA, AddressModeAbsoluteIndexedX, A | X, _NR},
    _,
    {OpcodeCLB4, AddressModeZeroPage, _NR, _NR},
    {OpcodeLDY, AddressModeImmediate, _NR, Y},
    {OpcodeLDA, AddressModeZeroPageIndexedIndirect, X, A},
    {OpcodeLDX, AddressModeImmediate, _NR, X},
    {OpcodeBBS5, AddressModeAccumulator, A, A},
    {OpcodeLDY, AddressModeZeroPage, _NR, Y},
    {OpcodeLDA, AddressModeZeroPage, _NR, A},
    {OpcodeLDX, AddressModeZeroPage, _NR, X},
    {OpcodeBBS5, AddressModeZeroPage, _NR, _NR},
    {OpcodeTAY, AddressModeImplied, A | Y, A | Y},
    {OpcodeLDA, AddressModeImmediate, _NR, A},
    {OpcodeTAX, AddressModeImplied, A | X, A | X},
    {OpcodeSEB5, AddressModeAccumulator, A, A},
    {OpcodeLDY, AddressModeAbsolute, _NR, Y},
    {OpcodeLDA, AddressModeAbsolute, _NR, A},
    {OpcodeLDX, AddressModeAbsolute, _NR, X},
    {OpcodeSEB5, AddressModeZeroPage, _NR, _NR},
    {OpcodeBCS, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeLDA, AddressModeZeroPageIndirectIndexedY, Y, A},
    {OpcodeJMP, AddressModeZeroPageIndirect, _NR, _NR},
    {OpcodeBBC5, AddressModeAccumulator, A, A},
    {OpcodeLDY, AddressModeZeroPageIndexedX, X, Y},
    {OpcodeLDA, AddressModeZeroPageIndexedX, X, A},
    {OpcodeLDX, AddressModeZeroPageIndexedY, Y, A},
    {OpcodeBBC5, AddressModeZeroPage, _NR, _NR},
    {OpcodeCLV, AddressModeImplied, _NR, _NR},
    {OpcodeLDA, AddressModeAbsoluteIndexedY, Y, A},
    {OpcodeTSX, AddressModeImplied, X | S, X | S},
    {OpcodeCLB5, AddressModeAccumulator, A, A},
    {OpcodeLDY, AddressModeAbsoluteIndexedX, X, Y},
    {OpcodeLDA, AddressModeAbsoluteIndexedX, X, A},
    {OpcodeLDX, AddressModeAbsoluteIndexedY, X, Y},
    {OpcodeCLB5, AddressModeZeroPage, _NR, _NR},
    {OpcodeCPY, AddressModeImmediate, Y, _NR},
    {OpcodeCMP, AddressModeZeroPageIndexedIndirect, A, _NR},
    {OpcodeWIT, AddressModeImplied, _NR, _NR},
    {OpcodeBBS6, AddressModeAccumulator, A, A},
    {OpcodeCPY, AddressModeZeroPage, Y, _NR},
    {OpcodeCMP, AddressModeZeroPage, A, _NR},
    {OpcodeDEC, AddressModeZeroPage, _NR, _NR},
    {OpcodeBBS6, AddressModeZeroPage, _NR, _NR},
    {OpcodeINY, AddressModeImplied, Y, Y},
    {OpcodeCMP, AddressModeImmediate, A, _NR},
    {OpcodeDEX, AddressModeImplied, X, X},
    {OpcodeSEB6, AddressModeAccumulator, A, A},
    {OpcodeCPY, AddressModeAbsolute, Y, _NR},
    {OpcodeCMP, AddressModeAbsolute, A, _NR},
    {OpcodeDEC, AddressModeAbsolute, _NR, _NR},
    {OpcodeSEB6, AddressModeZeroPage, _NR, _NR},
    {OpcodeBNE, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeCMP, AddressModeZeroPageIndirectIndexedY, A | Y, _NR},
    _,
    {OpcodeBBC6, AddressModeAccumulator, A, A},
    _,
    {OpcodeCMP, AddressModeZeroPageIndexedX, A | X, _NR},
    {OpcodeDEC, AddressModeZeroPageIndexedX, X, X},
    {OpcodeBBC6, AddressModeZeroPage, _NR, _NR},
    {OpcodeCLD, AddressModeImplied, _NR, _NR},
    {OpcodeCMP, AddressModeAbsoluteIndexedY, A | Y, _NR},
    _,
    {OpcodeCLB6, AddressModeAccumulator, A, A},
    _,
    {OpcodeCMP, AddressModeAbsoluteIndexedX, A | X, _NR},
    {OpcodeDEC, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB6, AddressModeZeroPage, _NR, _NR},
    {OpcodeCPX, AddressModeImmediate, X, _NR},
    {OpcodeSBC, AddressModeZeroPageIndexedIndirect, A | X, A},
    {OpcodeDIV, AddressModeZeroPageIndexedX, A | X, A | S},
    {OpcodeBBS7, AddressModeAccumulator, A, A},
    {OpcodeCPX, AddressModeZeroPage, X, _NR},
    {OpcodeSBC, AddressModeZeroPage, A, A},
    {OpcodeINC, AddressModeZeroPage, _NR, _NR},
    {OpcodeBBS7, AddressModeZeroPage, _NR, _NR},
    {OpcodeINX, AddressModeImplied, X, X},
    {OpcodeSBC, AddressModeImmediate, A, A},
    {OpcodeNOP, AddressModeImplied, _NR, _NR},
    {OpcodeSEB7, AddressModeAccumulator, _NR, _NR},
    {OpcodeCPX, AddressModeAbsolute, X, _NR},
    {OpcodeSBC, AddressModeAbsolute, A, A},
    {OpcodeINC, AddressModeAbsolute, _NR, _NR},
    {OpcodeSEB7, AddressModeZeroPage, _NR, _NR},
    {OpcodeBEQ, AddressModeProgramCounterRelative, _NR, _NR},
    {OpcodeSBC, AddressModeZeroPageIndirectIndexedY, A | Y, A},
    _,
    {OpcodeBBC7, AddressModeAccumulator, A, A},
    _,
    {OpcodeSBC, AddressModeZeroPageIndexedX, A | X, A},
    {OpcodeINC, AddressModeZeroPageIndexedX, X, _NR},
    {OpcodeBBC7, AddressModeZeroPage, _NR, _NR},
    {OpcodeSED, AddressModeImplied, _NR, _NR},
    {OpcodeSBC, AddressModeAbsoluteIndexedY, A | Y, A},
    _,
    {OpcodeCLB7, AddressModeAccumulator, A, A},
    _,
    {OpcodeSBC, AddressModeAbsoluteIndexedX, A | X, A},
    {OpcodeINC, AddressModeAbsoluteIndexedX, X, _NR},
    {OpcodeCLB7, AddressModeZeroPage, _NR, _NR}};

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
