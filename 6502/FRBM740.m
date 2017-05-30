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

#import "FRBM740.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const struct FRBOpcode kOpcodeTable[256];

@implementation ItFrobHopper6502M740

+ (NSString *_Nonnull)family {
  return @"Mitsubishi";
}

+ (NSString *_Nonnull)model {
  return @"M50734";
}

+ (BOOL)exported {
  return YES;
}

+ (int)addressSpaceWidth {
  return 16;
}

- (void)updateFlags:(DisasmStruct *)structure
     forInstruction:(const FRBInstruction *)instruction {

  /*
   * This is a hack for the M740, which has an extra flag.  Currently Hopper
   * does not allow to add or remove custom CPU flags so we have to piggyback
   * on the ARM/Thumb register switcher which is still available on non-ARM CPU
   * backends (although it really shouldn't).
   */

  switch (instruction->opcode->type) {
  case FRBOpcodeTypeSET:
    structure->instruction.eflags.TF_flag = DISASM_EFLAGS_SET;
    break;

  case FRBOpcodeTypeCLT:
    structure->instruction.eflags.TF_flag = DISASM_EFLAGS_RESET;
    break;

  case FRBOpcodeTypeCLW:
    structure->instruction.eflags.OF_flag = DISASM_EFLAGS_RESET;
    break;

  default:
    break;
  }
}

- (const FRBOpcode *)opcodeForByte:(uint8_t)byte {
  return &kOpcodeTable[byte];
}

@end

static const struct FRBOpcode kOpcodeTable[256] = {
    {FRBOpcodeTypeBRK, FRBAddressModeImplied, N, S | P},
    {FRBOpcodeTypeORA, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeJSR, FRBAddressModeZeroPageIndirect, N, N},
    {FRBOpcodeTypeBBS0, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeORA, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeASL, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBBS0, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypePHP, FRBAddressModeStack, S | P, S},
    {FRBOpcodeTypeORA, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeASL, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeSEB0, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeORA, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeASL, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeSEB0, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBPL, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeORA, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeCLT, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeBBC0, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeORA, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeASL, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeBBC0, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCLC, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeORA, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypeDEC, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeCLB0, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeORA, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeASL, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeCLB0, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeJSR, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeAND, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeJSR, FRBAddressModeSpecialPage, N, N},
    {FRBOpcodeTypeBBS1, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeBIT, FRBAddressModeZeroPage, A, N},
    {FRBOpcodeTypeAND, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeROL, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBBS1, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypePLP, FRBAddressModeStack, S, S | P},
    {FRBOpcodeTypeAND, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeROL, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeSEB1, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeBIT, FRBAddressModeAbsolute, A, N},
    {FRBOpcodeTypeAND, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeROL, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeSEB1, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBMI, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeAND, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeSET, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeBBC1, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeAND, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeROL, FRBAddressModeZeroPageIndexedX, X, N},
    {FRBOpcodeTypeBBC1, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeSEC, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeAND, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypeINC, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeCLB1, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeLDM, FRBAddressModeImmediateZeroPage, N, N},
    {FRBOpcodeTypeAND, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeROL, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeCLB1, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeRTI, FRBAddressModeStack, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeSTP, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeBBS2, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeCOM, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeLSR, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBBS2, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypePHA, FRBAddressModeStack, A | S, S},
    {FRBOpcodeTypeEOR, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeLSR, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeSEB2, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeJMP, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeLSR, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeSEB2, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBVC, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeBBC2, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeLSR, FRBAddressModeZeroPageIndexedX, X, N},
    {FRBOpcodeTypeBBC2, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCLI, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCLB2, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeLSR, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeCLB2, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeRTS, FRBAddressModeStack, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeMUL, FRBAddressModeZeroPageIndexedX, A | X, A | S},
    {FRBOpcodeTypeBBS3, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeTST, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeROR, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBBS3, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypePLA, FRBAddressModeStack, S, A | S},
    {FRBOpcodeTypeADC, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeROR, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeSEB3, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeJMP, FRBAddressModeAbsoluteIndirect, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeROR, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeSEB3, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBVS, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeBBC3, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeROR, FRBAddressModeZeroPageIndexedX, X, N},
    {FRBOpcodeTypeBBC3, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeSEI, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCLB3, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeROR, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeCLB3, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBRA, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeSTA, FRBAddressModeZeroPageIndexedIndirect, A | X, N},
    {FRBOpcodeTypeRRF, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBBS4, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeSTY, FRBAddressModeZeroPage, Y, N},
    {FRBOpcodeTypeSTA, FRBAddressModeZeroPage, A, N},
    {FRBOpcodeTypeSTX, FRBAddressModeZeroPage, X, N},
    {FRBOpcodeTypeBBS4, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeDEY, FRBAddressModeImplied, Y, Y},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeTXA, FRBAddressModeImplied, A | X, A | X},
    {FRBOpcodeTypeSEB4, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeSTY, FRBAddressModeAbsolute, Y, N},
    {FRBOpcodeTypeSTA, FRBAddressModeAbsolute, A, N},
    {FRBOpcodeTypeSTX, FRBAddressModeAbsolute, X, N},
    {FRBOpcodeTypeSEB4, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBCC, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeSTA, FRBAddressModeZeroPageIndirectIndexedY, A | Y, N},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeBBC4, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeSTY, FRBAddressModeZeroPageIndexedX, X | Y, N},
    {FRBOpcodeTypeSTA, FRBAddressModeZeroPageIndexedX, A | X, N},
    {FRBOpcodeTypeSTX, FRBAddressModeZeroPageIndexedY, X | Y, N},
    {FRBOpcodeTypeBBC4, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeTYA, FRBAddressModeImplied, A | Y, A | Y},
    {FRBOpcodeTypeSTA, FRBAddressModeAbsoluteIndexedY, A | Y, N},
    {FRBOpcodeTypeTXS, FRBAddressModeImplied, X | S, X | S},
    {FRBOpcodeTypeCLB4, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeSTA, FRBAddressModeAbsoluteIndexedX, A | X, N},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCLB4, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeLDY, FRBAddressModeImmediate, N, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeZeroPageIndexedIndirect, X, A},
    {FRBOpcodeTypeLDX, FRBAddressModeImmediate, N, X},
    {FRBOpcodeTypeBBS5, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeLDY, FRBAddressModeZeroPage, N, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeZeroPage, N, A},
    {FRBOpcodeTypeLDX, FRBAddressModeZeroPage, N, X},
    {FRBOpcodeTypeBBS5, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeTAY, FRBAddressModeImplied, A | Y, A | Y},
    {FRBOpcodeTypeLDA, FRBAddressModeImmediate, N, A},
    {FRBOpcodeTypeTAX, FRBAddressModeImplied, A | X, A | X},
    {FRBOpcodeTypeSEB5, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeLDY, FRBAddressModeAbsolute, N, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeAbsolute, N, A},
    {FRBOpcodeTypeLDX, FRBAddressModeAbsolute, N, X},
    {FRBOpcodeTypeSEB5, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBCS, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeLDA, FRBAddressModeZeroPageIndirectIndexedY, Y, A},
    {FRBOpcodeTypeJMP, FRBAddressModeZeroPageIndirect, N, N},
    {FRBOpcodeTypeBBC5, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeLDY, FRBAddressModeZeroPageIndexedX, X, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeZeroPageIndexedX, X, A},
    {FRBOpcodeTypeLDX, FRBAddressModeZeroPageIndexedY, Y, A},
    {FRBOpcodeTypeBBC5, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCLV, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeLDA, FRBAddressModeAbsoluteIndexedY, Y, A},
    {FRBOpcodeTypeTSX, FRBAddressModeImplied, X | S, X | S},
    {FRBOpcodeTypeCLB5, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeLDY, FRBAddressModeAbsoluteIndexedX, X, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeAbsoluteIndexedX, X, A},
    {FRBOpcodeTypeLDX, FRBAddressModeAbsoluteIndexedY, X, Y},
    {FRBOpcodeTypeCLB5, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCPY, FRBAddressModeImmediate, Y, N},
    {FRBOpcodeTypeCMP, FRBAddressModeZeroPageIndexedIndirect, A, N},
    {FRBOpcodeTypeWIT, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeBBS6, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeCPY, FRBAddressModeZeroPage, Y, N},
    {FRBOpcodeTypeCMP, FRBAddressModeZeroPage, A, N},
    {FRBOpcodeTypeDEC, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBBS6, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeINY, FRBAddressModeImplied, Y, Y},
    {FRBOpcodeTypeCMP, FRBAddressModeImmediate, A, N},
    {FRBOpcodeTypeDEX, FRBAddressModeImplied, X, X},
    {FRBOpcodeTypeSEB6, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeCPY, FRBAddressModeAbsolute, Y, N},
    {FRBOpcodeTypeCMP, FRBAddressModeAbsolute, A, N},
    {FRBOpcodeTypeDEC, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeSEB6, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBNE, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeCMP, FRBAddressModeZeroPageIndirectIndexedY, A | Y, N},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeBBC6, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCMP, FRBAddressModeZeroPageIndexedX, A | X, N},
    {FRBOpcodeTypeDEC, FRBAddressModeZeroPageIndexedX, X, X},
    {FRBOpcodeTypeBBC6, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCLD, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeCMP, FRBAddressModeAbsoluteIndexedY, A | Y, N},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCLB6, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCMP, FRBAddressModeAbsoluteIndexedX, A | X, N},
    {FRBOpcodeTypeDEC, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeCLB6, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCPX, FRBAddressModeImmediate, X, N},
    {FRBOpcodeTypeSBC, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeDIV, FRBAddressModeZeroPageIndexedX, A | X, A | S},
    {FRBOpcodeTypeBBS7, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeCPX, FRBAddressModeZeroPage, X, N},
    {FRBOpcodeTypeSBC, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeINC, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBBS7, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeINX, FRBAddressModeImplied, X, X},
    {FRBOpcodeTypeSBC, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeNOP, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeSEB7, FRBAddressModeAccumulator, N, N},
    {FRBOpcodeTypeCPX, FRBAddressModeAbsolute, X, N},
    {FRBOpcodeTypeSBC, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeINC, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeSEB7, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeBEQ, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeSBC, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeBBC7, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeSBC, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeINC, FRBAddressModeZeroPageIndexedX, X, N},
    {FRBOpcodeTypeBBC7, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeSED, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeSBC, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCLB7, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeSBC, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeINC, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeCLB7, FRBAddressModeZeroPage, N, N}};

#pragma clang diagnostic pop
