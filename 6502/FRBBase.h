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

@import Foundation;

#import "Hopper/Hopper.h"

static NSString *const kSyntaxVariant = @"Generic";
static NSString *const kCPUMode = @"generic";

/**
 * Address modes.
 */
typedef NS_ENUM(NSUInteger, FRBAddressMode) {
  FRBAddressModeAbsolute = 0,
  FRBAddressModeAbsoluteIndexedX,
  FRBAddressModeAbsoluteIndexedY,
  FRBAddressModeImmediate,
  FRBAddressModeAccumulator,
  FRBAddressModeImplied,
  FRBAddressModeStack,
  FRBAddressModeAbsoluteIndirect,
  FRBAddressModeProgramCounterRelative,
  FRBAddressModeZeroPage,
  FRBAddressModeZeroPageIndexedX,
  FRBAddressModeZeroPageIndexedY,
  FRBAddressModeZeroPageIndexedIndirect,
  FRBAddressModeZeroPageIndirectIndexedY,
  FRBAddressModeZeroPageIndirect,
  FRBAddressModeAbsoluteIndexedIndirect,
  FRBAddressModeZeroPageProgramCounterRelative,
  FRBAddressModeBlockTransfer,
  FRBAddressModeImmediateZeroPage,
  FRBAddressModeImmediateZeroPageX,
  FRBAddressModeImmediateAbsolute,
  FRBAddressModeImmediateAbsoluteX,
  FRBAddressModeZeroPageIndirectIndexedX,
  FRBAddressModeBitsProgramCounterAbsolute,
  FRBAddressModeSpecialPage,
  FRBAddressModeUnknown
};

static const size_t FRBAddressModesCount = FRBAddressModeUnknown;

static const size_t FRBOpcodeLength[FRBAddressModesCount] = {
    3, 3, 3, 2, 1, 1, 1, 3, 2, 2, 2, 2, 2, 2, 2, 3, 3, 7, 3, 3, 4, 4, 2, 5, 3};

/**
 * Opcode categories
 */
typedef NS_ENUM(NSUInteger, FRBOpcodeCategory) {
  FRBOpcodeCategoryUnknown = 0,
  FRBOpcodeCategorySystem,
  FRBOpcodeCategoryLoad,
  FRBOpcodeCategoryStore,
  FRBOpcodeCategoryRegisterTransfers,
  FRBOpcodeCategoryStack,
  FRBOpcodeCategoryLogical,
  FRBOpcodeCategoryComparison,
  FRBOpcodeCategoryArithmetic,
  FRBOpcodeCategoryIncrementDecrement,
  FRBOpcodeCategoryShifts,
  FRBOpcodeCategoryJumps,
  FRBOpcodeCategoryBranches,
  FRBOpcodeCategoryStatusFlagChanges,
  FRBOpcodeCategoryBlockTransfer
};

typedef NS_ENUM(NSUInteger, FRBOpcodeType) {
  FRBOpcodeTypeADC = 0,
  FRBOpcodeTypeADD, // R65C19
  FRBOpcodeTypeAND,
  FRBOpcodeTypeASL,
  FRBOpcodeTypeASR,  // R65C19
  FRBOpcodeTypeBAR,  // R65C19
  FRBOpcodeTypeBAS,  // R65C19
  FRBOpcodeTypeBBC0, // M50734
  FRBOpcodeTypeBBC1, // M50734
  FRBOpcodeTypeBBC2, // M50734
  FRBOpcodeTypeBBC3, // M50734
  FRBOpcodeTypeBBC4, // M50734
  FRBOpcodeTypeBBC5, // M50734
  FRBOpcodeTypeBBC6, // M50734
  FRBOpcodeTypeBBC7, // M50734
  FRBOpcodeTypeBBR0, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBR1, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBR2, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBR3, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBR4, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBR5, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBR6, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBR7, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBS0, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBS1, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBS2, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBS3, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBS4, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBS5, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBS6, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBBS7, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeBCC,
  FRBOpcodeTypeBCS,
  FRBOpcodeTypeBEQ,
  FRBOpcodeTypeBIT,
  FRBOpcodeTypeBMI,
  FRBOpcodeTypeBNE,
  FRBOpcodeTypeBPL,
  FRBOpcodeTypeBRA, // 65C02, W65C02S, R6500, R65C19, and Hu6280
  FRBOpcodeTypeBRK,
  FRBOpcodeTypeBVC,
  FRBOpcodeTypeBVS,
  FRBOpcodeTypeCLA,  // Hu6280
  FRBOpcodeTypeCLB0, // M50734
  FRBOpcodeTypeCLB1, // M50734
  FRBOpcodeTypeCLB2, // M50734
  FRBOpcodeTypeCLB3, // M50734
  FRBOpcodeTypeCLB4, // M50734
  FRBOpcodeTypeCLB5, // M50734
  FRBOpcodeTypeCLB6, // M50734
  FRBOpcodeTypeCLB7, // M50734
  FRBOpcodeTypeCLC,
  FRBOpcodeTypeCLD,
  FRBOpcodeTypeCLI,
  FRBOpcodeTypeCLT, // M50734
  FRBOpcodeTypeCLV,
  FRBOpcodeTypeCLW, // R65C19
  FRBOpcodeTypeCLX, // Hu6280
  FRBOpcodeTypeCLY, // Hu6280
  FRBOpcodeTypeCMP,
  FRBOpcodeTypeCOM, // M50734
  FRBOpcodeTypeCPX,
  FRBOpcodeTypeCPY,
  FRBOpcodeTypeCSH, // Hu6280
  FRBOpcodeTypeCSL, // Hu6280
  FRBOpcodeTypeDEC,
  FRBOpcodeTypeDEX,
  FRBOpcodeTypeDEY,
  FRBOpcodeTypeDIV, // M50734
  FRBOpcodeTypeEOR,
  FRBOpcodeTypeEXC, // R65C19
  FRBOpcodeTypeINC,
  FRBOpcodeTypeINI, // R65C19
  FRBOpcodeTypeINX,
  FRBOpcodeTypeINY,
  FRBOpcodeTypeJMP,
  FRBOpcodeTypeJPI,  // R65C19
  FRBOpcodeTypeJSB0, // R65C19
  FRBOpcodeTypeJSB1, // R65C19
  FRBOpcodeTypeJSB2, // R65C19
  FRBOpcodeTypeJSB3, // R65C19
  FRBOpcodeTypeJSB4, // R65C19
  FRBOpcodeTypeJSB5, // R65C19
  FRBOpcodeTypeJSB6, // R65C19
  FRBOpcodeTypeJSB7, // R65C19
  FRBOpcodeTypeJSR,
  FRBOpcodeTypeLAB, // R65C19
  FRBOpcodeTypeLAI, // R65C19
  FRBOpcodeTypeLAN, // R65C19
  FRBOpcodeTypeLDA,
  FRBOpcodeTypeLDM, // M50734
  FRBOpcodeTypeLDX,
  FRBOpcodeTypeLDY,
  FRBOpcodeTypeLII, // R65C19
  FRBOpcodeTypeLSR,
  FRBOpcodeTypeMPA, // R65C19
  FRBOpcodeTypeMPY, // R65C19
  FRBOpcodeTypeMUL, // R65C29, M50734
  FRBOpcodeTypeNEG, // R65C19
  FRBOpcodeTypeNOP,
  FRBOpcodeTypeNXT, // R65C19
  FRBOpcodeTypeORA,
  FRBOpcodeTypePHA,
  FRBOpcodeTypePHI, // R65C19
  FRBOpcodeTypePHP,
  FRBOpcodeTypePHW, // R65C19
  FRBOpcodeTypePHX, // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypePHY, // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypePIA, // R65C19
  FRBOpcodeTypePLA,
  FRBOpcodeTypePLI, // R65C19
  FRBOpcodeTypePLP,
  FRBOpcodeTypePLW,  // R65C19
  FRBOpcodeTypePLX,  // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypePLY,  // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypePSH,  // R65C19
  FRBOpcodeTypePUL,  // R65C19
  FRBOpcodeTypeRBA,  // R65C19
  FRBOpcodeTypeRMB0, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeRMB1, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeRMB2, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeRMB3, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeRMB4, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeRMB5, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeRMB6, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeRMB7, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeRND,  // R65C19
  FRBOpcodeTypeROL,
  FRBOpcodeTypeROR,
  FRBOpcodeTypeRRF, // M50734
  FRBOpcodeTypeRTI,
  FRBOpcodeTypeRTS,
  FRBOpcodeTypeSAX, // Hu6280
  FRBOpcodeTypeSAY, // Hu6280
  FRBOpcodeTypeSBA, // R65C19
  FRBOpcodeTypeSBC,
  FRBOpcodeTypeSEB0, // M50734
  FRBOpcodeTypeSEB1, // M50734
  FRBOpcodeTypeSEB2, // M50734
  FRBOpcodeTypeSEB3, // M50734
  FRBOpcodeTypeSEB4, // M50734
  FRBOpcodeTypeSEB5, // M50734
  FRBOpcodeTypeSEB6, // M50734
  FRBOpcodeTypeSEB7, // M50734
  FRBOpcodeTypeSEC,
  FRBOpcodeTypeSED,
  FRBOpcodeTypeSEI,
  FRBOpcodeTypeSET,  // Hu6280
  FRBOpcodeTypeSMB0, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeSMB1, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeSMB2, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeSMB3, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeSMB4, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeSMB5, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeSMB6, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeSMB7, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  FRBOpcodeTypeST0,  // Hu6280
  FRBOpcodeTypeST1,  // Hu6280
  FRBOpcodeTypeST2,  // Hu6280
  FRBOpcodeTypeSTA,
  FRBOpcodeTypeSTI, // R65C19
  FRBOpcodeTypeSTP, // W65C02S and M50734
  FRBOpcodeTypeSTX,
  FRBOpcodeTypeSTY,
  FRBOpcodeTypeSTZ, // 65C02, W65C02S, R6500, and Hu6280
  FRBOpcodeTypeSXY, // Hu6280
  FRBOpcodeTypeTAI, // Hu6280
  FRBOpcodeTypeTAM, // Hu6280
  FRBOpcodeTypeTAW, // R65C19
  FRBOpcodeTypeTAX,
  FRBOpcodeTypeTAY,
  FRBOpcodeTypeTIP, // R65C19
  FRBOpcodeTypeTDD, // Hu6280
  FRBOpcodeTypeTIA, // Hu6280
  FRBOpcodeTypeTII, // Hu6280
  FRBOpcodeTypeTIN, // Hu6280
  FRBOpcodeTypeTMA, // Hu6280
  FRBOpcodeTypeTRB, // 65C02, W65C02S, R6500, and Hu6280
  FRBOpcodeTypeTSB, // 65C02, W65C02S, R6500, and Hu6280
  FRBOpcodeTypeTST, // Hu6280 and M50734
  FRBOpcodeTypeTSX,
  FRBOpcodeTypeTWA, // R65C19
  FRBOpcodeTypeTXA,
  FRBOpcodeTypeTXS,
  FRBOpcodeTypeTYA,
  FRBOpcodeTypeWAI, // W65C02S
  FRBOpcodeTypeWIT, // M50734

  FRBOpcodeTypeUndocumented
};

static const size_t FRBUniqueOpcodesCount = FRBOpcodeTypeUndocumented;

typedef NS_ENUM(NSUInteger, FRBRegisters) {
  FRBRegisterA = 0,
  FRBRegisterX,
  FRBRegisterY,
  FRBRegisterS,
  FRBRegisterW,
  FRBRegisterI,
  FRBRegisterP,

  FRBRegisterUnknown
};

static const size_t FRBUniqueRegistersCount = FRBRegisterUnknown;

typedef NS_OPTIONS(NSUInteger, FRBRegisterFlags) {
  FRBRegisterFlagsNone = 0,
  FRBRegisterFlagsA = 1 << FRBRegisterA,
  FRBRegisterFlagsX = 1 << FRBRegisterX,
  FRBRegisterFlagsY = 1 << FRBRegisterY,
  FRBRegisterFlagsS = 1 << FRBRegisterS,
  FRBRegisterFlagsW = 1 << FRBRegisterW, // R65C19
  FRBRegisterFlagsI = 1 << FRBRegisterI, // R65C19
  FRBRegisterFlagsP = 1 << FRBRegisterP,
};

#define N FRBRegisterFlagsNone
#define A FRBRegisterFlagsA
#define X FRBRegisterFlagsX
#define Y FRBRegisterFlagsY
#define S FRBRegisterFlagsS
#define W FRBRegisterFlagsW // R65C19
#define I FRBRegisterFlagsI // R65C19
#define P FRBRegisterFlagsP

/*!
 *	CPU Instructions structure.
 */
typedef struct FRBMnemonic {
  const char *const name;
  DisasmBranchType branchType;
  FRBOpcodeCategory category;
  BOOL haltsFlow;
} FRBMnemonic;

/*!
 *	CPU Opcodes table item structure.
 */
typedef struct FRBOpcode {
  FRBOpcodeType type;
  FRBAddressMode addressMode;
  FRBRegisterFlags readRegisters;
  FRBRegisterFlags writtenRegisters;
} FRBOpcode;

typedef struct FRBInstruction {
  const FRBMnemonic *mnemonic;
  const FRBOpcode *opcode;
} FRBInstruction;

/*! Core-independent instruction lookup table */
static const FRBMnemonic FRBMnemonics[FRBUniqueOpcodesCount] = {
    {"ADC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic, NO},
    {"ADD", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic, NO},
    {"AND", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"ASL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts, NO},
    {"ASR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts, NO},
    {"BAR", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BAS", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BBC0", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBC1", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBC2", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBC3", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBC4", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBC5", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBC6", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBC7", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBR0", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBR1", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBR2", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBR3", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBR4", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBR5", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBR6", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBR7", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BBS0", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BBS1", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BBS2", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BBS3", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BBS4", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BBS5", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BBS6", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BBS7", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BCC", DISASM_BRANCH_JNC, FRBOpcodeCategoryBranches, NO},
    {"BCS", DISASM_BRANCH_JC, FRBOpcodeCategoryBranches, NO},
    {"BEQ", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches, NO},
    {"BIT", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"BMI", DISASM_BRANCH_JS, FRBOpcodeCategoryBranches, NO},
    {"BNE", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches, NO},
    {"BPL", DISASM_BRANCH_JNS, FRBOpcodeCategoryBranches, NO},
    {"BRA", DISASM_BRANCH_JMP, FRBOpcodeCategoryBranches, NO},
    {"BRK", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem, YES},
    {"BVC", DISASM_BRANCH_JNO, FRBOpcodeCategoryBranches, NO},
    {"BVS", DISASM_BRANCH_JO, FRBOpcodeCategoryBranches, NO},
    {"CLA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CLB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CLB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CLB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CLB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CLB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CLB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CLB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CLB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CLC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"CLD", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"CLI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"CLT", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"CLV", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"CLW", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"CLX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"CLY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"CMP", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison, NO},
    {"COM", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"CPX", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison, NO},
    {"CPY", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison, NO},
    {"CSH", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem, NO},
    {"CSL", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem, NO},
    {"DEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement, NO},
    {"DEX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement, NO},
    {"DEY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement, NO},
    {"DIV", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic, NO},
    {"EOR", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"EXC", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"INC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement, NO},
    {"INI", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement, NO},
    {"INX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement, NO},
    {"INY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement, NO},
    {"JMP", DISASM_BRANCH_JMP, FRBOpcodeCategoryJumps, NO},
    {"JPI", DISASM_BRANCH_JMP, FRBOpcodeCategoryJumps, NO},
    {"JSB0", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps, NO},
    {"JSB1", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps, NO},
    {"JSB2", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps, NO},
    {"JSB3", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps, NO},
    {"JSB4", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps, NO},
    {"JSB5", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps, NO},
    {"JSB6", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps, NO},
    {"JSB7", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps, NO},
    {"JSR", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps, NO},
    {"LAB", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad, NO},
    {"LAI", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad, NO},
    {"LAN", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad, NO},
    {"LDA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad, NO},
    {"LDM", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad, NO},
    {"LDX", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad, NO},
    {"LDY", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad, NO},
    {"LII", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad, NO},
    {"LSR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts, NO},
    {"MPA", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic, NO},
    {"MPY", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic, NO},
    {"MUL", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic, NO},
    {"NEG", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"NOP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem, NO},
    {"NXT", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem, NO},
    {"ORA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"PHA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PHI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PHP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PHW", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PHX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PHY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PIA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PLA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PLI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PLP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PLW", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PLX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PLY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PSH", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"PUL", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack, NO},
    {"RBA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"RMB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"RMB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"RMB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"RMB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"RMB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"RMB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"RMB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"RMB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"RND", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic, NO},
    {"ROL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts, NO},
    {"ROR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts, NO},
    {"RRF", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts, NO},
    {"RTI", DISASM_BRANCH_RET, FRBOpcodeCategorySystem, NO},
    {"RTS", DISASM_BRANCH_RET, FRBOpcodeCategorySystem, NO},
    {"SAX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"SAY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"SBA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"SBC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic, NO},
    {"SEB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"SEB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"SEB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"SEB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"SEB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"SEB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"SEB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"SEB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"SEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"SED", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"SEI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"SET", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges, NO},
    {"SMB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"SMB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"SMB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"SMB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"SMB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"SMB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"SMB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"SMB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"ST0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"ST1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"ST2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"STA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"STI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"STP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem, YES},
    {"STX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"STY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"STZ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"SXY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"TAI", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer, NO},
    {"TAM", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore, NO},
    {"TAW", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"TAX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"TAY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"TIP", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"TDD", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer, NO},
    {"TIA", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer, NO},
    {"TII", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer, NO},
    {"TIN", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer, NO},
    {"TMA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad, NO},
    {"TRB", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"TSB", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical, NO},
    {"TST", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison, NO},
    {"TSX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"TWA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"TXA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"TXS", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"TYA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers, NO},
    {"WAI", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem, NO},
    {"WIT", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem, YES},
};
