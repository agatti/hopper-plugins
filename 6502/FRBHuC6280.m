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

#import "FRBHuC6280.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const struct FRBOpcode kOpcodeTable[256];

@implementation ItFrobHopper6502HuC6280

+ (NSString *_Nonnull)family {
  return @"HudsonSoft";
}

+ (NSString *_Nonnull)model {
  return @"HuC6280";
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
   * This is a hack for the HuC6280, which has an extra flag.  Currently Hopper
   * does not allow to add or remove custom CPU flags so we have to piggyback
   * on the ARM/Thumb register switcher which is still available on non-ARM CPU
   * backends (although it really shouldn't).
   */

  structure->instruction.eflags.TF_flag =
      instruction->opcode->type == FRBOpcodeTypeSET ? DISASM_EFLAGS_SET
                                                    : DISASM_EFLAGS_RESET;
}

- (const FRBOpcode *)opcodeForByte:(uint8_t)byte {
  return &kOpcodeTable[byte];
}

@end

static const struct FRBOpcode kOpcodeTable[256] = {
    {FRBOpcodeTypeBRK, FRBAddressModeStack, N, S | P},
    {FRBOpcodeTypeORA, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeSXY, FRBAddressModeImplied, X | Y, X | Y},
    {FRBOpcodeTypeST0, FRBAddressModeImmediate, N, N},
    {FRBOpcodeTypeTSB, FRBAddressModeZeroPage, A, N},
    {FRBOpcodeTypeORA, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeASL, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeRMB0, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypePHP, FRBAddressModeStack, P | S, S},
    {FRBOpcodeTypeORA, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeASL, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeTSB, FRBAddressModeAbsolute, A, N},
    {FRBOpcodeTypeORA, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeASL, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeBBR0, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeBPL, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeORA, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeORA, FRBAddressModeZeroPageIndirect, A, A},
    {FRBOpcodeTypeST1, FRBAddressModeImmediate, N, N},
    {FRBOpcodeTypeTRB, FRBAddressModeZeroPage, A, N},
    {FRBOpcodeTypeORA, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeASL, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeRMB1, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCLC, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeORA, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypeINC, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeTRB, FRBAddressModeAbsolute, A, N},
    {FRBOpcodeTypeORA, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeASL, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeBBR1, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeJSR, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeAND, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeSAX, FRBAddressModeImplied, A | X, A | X},
    {FRBOpcodeTypeST2, FRBAddressModeImmediate, N, N},
    {FRBOpcodeTypeBIT, FRBAddressModeZeroPage, A, N},
    {FRBOpcodeTypeAND, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeROL, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeRMB2, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypePLP, FRBAddressModeStack, S, P | S},
    {FRBOpcodeTypeAND, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeROL, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeBIT, FRBAddressModeAbsolute, A, N},
    {FRBOpcodeTypeAND, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeROL, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeBBR2, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeBMI, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeAND, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeAND, FRBAddressModeZeroPageIndirect, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeBIT, FRBAddressModeZeroPageIndexedX, A | X, N},
    {FRBOpcodeTypeAND, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeROL, FRBAddressModeZeroPageIndexedX, X, N},
    {FRBOpcodeTypeRMB3, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeSEC, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeAND, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypeDEC, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeBIT, FRBAddressModeAbsoluteIndexedX, A | X, N},
    {FRBOpcodeTypeAND, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeROL, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeBBR3, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeRTI, FRBAddressModeStack, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeSAY, FRBAddressModeImplied, A | Y, A | Y},
    {FRBOpcodeTypeTMA, FRBAddressModeImmediate, N, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeLSR, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeRMB4, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypePHA, FRBAddressModeStack, A | S, S},
    {FRBOpcodeTypeEOR, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeLSR, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeJMP, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeLSR, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeBBR4, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeBVC, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeEOR, FRBAddressModeZeroPageIndirect, A, A},
    {FRBOpcodeTypeTAM, FRBAddressModeImmediate, A, N},
    {FRBOpcodeTypeCSL, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeLSR, FRBAddressModeZeroPageIndexedX, X, N},
    {FRBOpcodeTypeRMB5, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCLI, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypePHY, FRBAddressModeStack, Y | S, S},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeEOR, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeLSR, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeBBR5, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeRTS, FRBAddressModeStack, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeCLA, FRBAddressModeImplied, N, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeSTZ, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeROR, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeRMB6, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypePLA, FRBAddressModeStack, S, A | S},
    {FRBOpcodeTypeADC, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeROR, FRBAddressModeAccumulator, A, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeJMP, FRBAddressModeAbsoluteIndirect, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeROR, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeBBR6, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeBVS, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeADC, FRBAddressModeZeroPageIndirect, A, A},
    {FRBOpcodeTypeTII, FRBAddressModeBlockTransfer, N, N},
    {FRBOpcodeTypeSTZ, FRBAddressModeZeroPageIndexedX, X, N},
    {FRBOpcodeTypeADC, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeROR, FRBAddressModeZeroPageIndexedX, X, N},
    {FRBOpcodeTypeRMB7, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeSEI, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeADC, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypePLY, FRBAddressModeStack, S, Y | S},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeJMP, FRBAddressModeAbsoluteIndexedIndirect, X, N},
    {FRBOpcodeTypeADC, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeROR, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeBBR7, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeBRA, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeSTA, FRBAddressModeZeroPageIndexedIndirect, A | X, N},
    {FRBOpcodeTypeCLX, FRBAddressModeImplied, N, X},
    {FRBOpcodeTypeTST, FRBAddressModeImmediateZeroPage, N, N},
    {FRBOpcodeTypeSTY, FRBAddressModeZeroPage, Y, N},
    {FRBOpcodeTypeSTA, FRBAddressModeZeroPage, A, N},
    {FRBOpcodeTypeSTX, FRBAddressModeZeroPage, X, N},
    {FRBOpcodeTypeSMB0, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeDEY, FRBAddressModeImplied, Y, Y},
    {FRBOpcodeTypeBIT, FRBAddressModeImmediate, A, N},
    {FRBOpcodeTypeTXA, FRBAddressModeImplied, A | X, A | X},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeSTY, FRBAddressModeAbsolute, Y, N},
    {FRBOpcodeTypeSTA, FRBAddressModeAbsolute, A, N},
    {FRBOpcodeTypeSTX, FRBAddressModeAbsolute, X, N},
    {FRBOpcodeTypeBBS0, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeBCC, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeSTA, FRBAddressModeZeroPageIndirectIndexedY, A | Y, N},
    {FRBOpcodeTypeSTA, FRBAddressModeZeroPageIndirect, A, N},
    {FRBOpcodeTypeTST, FRBAddressModeImmediateAbsolute, N, N},
    {FRBOpcodeTypeSTY, FRBAddressModeZeroPageIndexedX, X | Y, N},
    {FRBOpcodeTypeSTA, FRBAddressModeZeroPageIndexedX, A | X, N},
    {FRBOpcodeTypeSTX, FRBAddressModeZeroPageIndexedY, X | Y, N},
    {FRBOpcodeTypeSMB1, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeTYA, FRBAddressModeImplied, A | Y, A | Y},
    {FRBOpcodeTypeSTA, FRBAddressModeAbsoluteIndexedY, A | Y, N},
    {FRBOpcodeTypeTXS, FRBAddressModeImplied, X | S, X | S},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeSTZ, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeSTA, FRBAddressModeAbsoluteIndexedX, A | X, N},
    {FRBOpcodeTypeSTZ, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeBBS1, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeLDY, FRBAddressModeImmediate, N, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeZeroPageIndexedIndirect, X, A},
    {FRBOpcodeTypeLDX, FRBAddressModeImmediate, N, X},
    {FRBOpcodeTypeTST, FRBAddressModeImmediateZeroPageX, X, N},
    {FRBOpcodeTypeLDY, FRBAddressModeZeroPage, N, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeZeroPage, N, A},
    {FRBOpcodeTypeLDX, FRBAddressModeZeroPage, N, X},
    {FRBOpcodeTypeSMB2, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeTAY, FRBAddressModeImplied, A | Y, A | Y},
    {FRBOpcodeTypeLDA, FRBAddressModeImmediate, N, A},
    {FRBOpcodeTypeTAX, FRBAddressModeImplied, A | X, A | X},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeLDY, FRBAddressModeAbsolute, N, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeAbsolute, N, A},
    {FRBOpcodeTypeLDX, FRBAddressModeAbsolute, N, X},
    {FRBOpcodeTypeBBS2, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeBCS, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeLDA, FRBAddressModeZeroPageIndirectIndexedY, Y, A},
    {FRBOpcodeTypeLDA, FRBAddressModeZeroPageIndirect, N, A},
    {FRBOpcodeTypeTST, FRBAddressModeImmediateAbsoluteX, X, N},
    {FRBOpcodeTypeLDY, FRBAddressModeZeroPageIndexedX, X, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeZeroPageIndexedX, X, A},
    {FRBOpcodeTypeLDX, FRBAddressModeZeroPageIndexedY, Y, A},
    {FRBOpcodeTypeSMB3, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCLV, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeLDA, FRBAddressModeAbsoluteIndexedY, Y, A},
    {FRBOpcodeTypeTSX, FRBAddressModeImplied, X | S, X | S},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeLDY, FRBAddressModeAbsoluteIndexedX, X, Y},
    {FRBOpcodeTypeLDA, FRBAddressModeAbsoluteIndexedX, X, A},
    {FRBOpcodeTypeLDX, FRBAddressModeAbsoluteIndexedY, X, Y},
    {FRBOpcodeTypeBBS3, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeCPY, FRBAddressModeImmediate, Y, N},
    {FRBOpcodeTypeCMP, FRBAddressModeZeroPageIndexedIndirect, A, N},
    {FRBOpcodeTypeCLY, FRBAddressModeImplied, N, Y},
    {FRBOpcodeTypeTDD, FRBAddressModeBlockTransfer, N, N},
    {FRBOpcodeTypeCPY, FRBAddressModeZeroPage, Y, N},
    {FRBOpcodeTypeCMP, FRBAddressModeZeroPage, A, N},
    {FRBOpcodeTypeDEC, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeSMB4, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeINY, FRBAddressModeImplied, Y, Y},
    {FRBOpcodeTypeCMP, FRBAddressModeImmediate, A, N},
    {FRBOpcodeTypeDEX, FRBAddressModeImplied, X, X},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCPY, FRBAddressModeAbsolute, Y, N},
    {FRBOpcodeTypeCMP, FRBAddressModeAbsolute, A, N},
    {FRBOpcodeTypeDEC, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeBBS4, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeBNE, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeCMP, FRBAddressModeZeroPageIndirectIndexedY, A | Y, N},
    {FRBOpcodeTypeCMP, FRBAddressModeZeroPageIndirect, A, N},
    {FRBOpcodeTypeTIN, FRBAddressModeBlockTransfer, N, N},
    {FRBOpcodeTypeCSH, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeCMP, FRBAddressModeZeroPageIndexedX, A | X, N},
    {FRBOpcodeTypeDEC, FRBAddressModeZeroPageIndexedX, X, X},
    {FRBOpcodeTypeSMB5, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeCLD, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeCMP, FRBAddressModeAbsoluteIndexedY, A | Y, N},
    {FRBOpcodeTypePHX, FRBAddressModeStack, X | S, S},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCMP, FRBAddressModeAbsoluteIndexedX, A | X, N},
    {FRBOpcodeTypeDEC, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeBBS5, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeCPX, FRBAddressModeImmediate, X, N},
    {FRBOpcodeTypeSBC, FRBAddressModeZeroPageIndexedIndirect, A | X, A},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeTIA, FRBAddressModeBlockTransfer, N, N},
    {FRBOpcodeTypeCPX, FRBAddressModeZeroPage, X, N},
    {FRBOpcodeTypeSBC, FRBAddressModeZeroPage, A, A},
    {FRBOpcodeTypeINC, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeSMB6, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeINX, FRBAddressModeImplied, X, X},
    {FRBOpcodeTypeSBC, FRBAddressModeImmediate, A, A},
    {FRBOpcodeTypeNOP, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeCPX, FRBAddressModeAbsolute, X, N},
    {FRBOpcodeTypeSBC, FRBAddressModeAbsolute, A, A},
    {FRBOpcodeTypeINC, FRBAddressModeAbsolute, N, N},
    {FRBOpcodeTypeBBS6, FRBAddressModeZeroPageProgramCounterRelative, N, N},
    {FRBOpcodeTypeBEQ, FRBAddressModeProgramCounterRelative, N, N},
    {FRBOpcodeTypeSBC, FRBAddressModeZeroPageIndirectIndexedY, A | Y, A},
    {FRBOpcodeTypeSBC, FRBAddressModeZeroPageIndirect, A, A},
    {FRBOpcodeTypeTAI, FRBAddressModeBlockTransfer, N, N},
    {FRBOpcodeTypeSET, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeSBC, FRBAddressModeZeroPageIndexedX, A | X, A},
    {FRBOpcodeTypeINC, FRBAddressModeZeroPageIndexedX, X, N},
    {FRBOpcodeTypeSMB7, FRBAddressModeZeroPage, N, N},
    {FRBOpcodeTypeSED, FRBAddressModeImplied, N, N},
    {FRBOpcodeTypeSBC, FRBAddressModeAbsoluteIndexedY, A | Y, A},
    {FRBOpcodeTypePLX, FRBAddressModeStack, S, X | S},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeUndocumented, FRBAddressModeUnknown, N, N},
    {FRBOpcodeTypeSBC, FRBAddressModeAbsoluteIndexedX, A | X, A},
    {FRBOpcodeTypeINC, FRBAddressModeAbsoluteIndexedX, X, N},
    {FRBOpcodeTypeBBS7, FRBAddressModeZeroPageProgramCounterRelative, N, N}};

#pragma clang diagnostic pop
