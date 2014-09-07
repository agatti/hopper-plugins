/*
 Copyright (c) 2014, Alessandro Gatti - frob.it
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

#ifndef FRBBase_h
#define FRBBase_h

static NSString * const kSyntaxVariant = @"Generic";
static NSString * const kCPUMode = @"generic";

/*! Address modes. */
typedef NS_ENUM(NSUInteger, FRBAddressMode) {
    FRBAddressModeAbsolute = 0,                   /*! Absolute: a */
    FRBAddressModeAbsoluteIndexedX,               /*! Absolute Indexed with X: a,x */
    FRBAddressModeAbsoluteIndexedY,               /*! Absolute Indexed with Y: a,y */
    FRBAddressModeImmediate,                      /*! Immediate: # */
    FRBAddressModeAccumulator,                    /*! Accumulator: A */
    FRBAddressModeImplied,                        /*! Implied: i */
    FRBAddressModeStack,                          /*! Stack: s */
    FRBAddressModeAbsoluteIndirect,               /*! Absolute Indirect: (a) */
    FRBAddressModeProgramCounterRelative,         /*! Program Counter Relative: r */
    FRBAddressModeZeroPage,                       /*! Zero Page: zp */
    FRBAddressModeZeroPageIndexedX,               /*! Zero Page Indexed with X: zp,X */
    FRBAddressModeZeroPageIndexedY,               /*! Zero Page Indexed with Y: zp,Y */
    FRBAddressModeZeroPageIndexedIndirect,        /*! Zero Page Indexed Indirect: (zp,x) */
    FRBAddressModeZeroPageIndirectIndexedY,       /*! Zero Page Indirect Indexed with Y: (zp),y */
    FRBAddressModeZeroPageIndirect,               /*! Zero Page Indirect: (zp) */
    FRBAddressModeAbsoluteIndexedIndirect,        /*! Absolute Indexed Indirect: (a,x) */
    FRBAddressModeZeroPageProgramCounterRelative, /*! Zero Page Program Counter Relative: zp, r */
    FRBAddressModeBlockTransfer,                  /*! Block transfer: (a, a, a) */
    FRBAddressModeImmediateZeroPage,              /*! Immediate, Zero Page: ? */
    FRBAddressModeImmediateZeroPageX,             /*! Immediate, Zero Page, X: ? */
    FRBAddressModeImmediateAbsolute,              /*! Immediate, Absolute: ? */
    FRBAddressModeImmediateAbsoluteX,             /*! Immediate, Absolute, X: ? */
    FRBAddressModeZeroPageIndirectIndexedX,       /*! Zero Page Indirect Indexed with X: (zp),x */
    FRBAddressModeBitsProgramCounterAbsolute,     /*! Bits Program Counter Absolute: #, abs, r */
    FRBAddressModeSpecialPage,                    /*! Special Page: sp */
    FRBAddressModeUnknown,                        /*! Unknown address mode, used for undocumented opcodes */
};

static const size_t FRBAddressModesCount = FRBAddressModeUnknown;

static const size_t FRBOpcodeLength[FRBAddressModesCount] = {
    3, // FRBAddressModeAbsolute
    3, // FRBAddressModeAbsoluteIndexedX
    3, // FRBAddressModeAbsoluteIndexedY
    2, // FRBAddressModeImmediate
    1, // FRBAddressModeAccumulator
    1, // FRBAddressModeImplied
    1, // FRBAddressModeStack
    3, // FRBAddressModeAbsoluteIndirect
    2, // FRBAddressModeProgramCounterRelative
    2, // FRBAddressModeZeroPage
    2, // FRBAddressModeZeroPageIndexedX
    2, // FRBAddressModeZeroPageIndexedY
    2, // FRBAddressModeZeroPageIndexedIndirect
    2, // FRBAddressModeZeroPageIndirectIndexedY
    2, // FRBAddressModeZeroPageIndirect
    3, // FRBAddressModeAbsoluteIndexedIndirect
    3, // FRBAddressModeZeroPageProgramCounterRelative
    7, // FRBAddressModeBlockTransfer
    3, // FRBAddressModeImmediateZeroPage
    3, // FRBAddressModeImmediateZeroPageX
    4, // FRBAddressModeImmediateAbsolute
    4, // FRBAddressModeImmediateAbsoluteX
    2, // FRBAddressModeZeroPageIndirectIndexedX
    5, // FRBAddressModeBitsProgramCounterAbsolute
    3  // FRBAddressModeSpecialPage
};

/*! Opcode categories */
typedef NS_ENUM(NSUInteger, FRBOpcodeCategory) {
    FRBOpcodeCategoryUnknown = 0, /*! Unknown opcode category, used for undocumented opcodes */
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
    FRBOpcodeTypeADD,  // R65C19
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
    FRBOpcodeTypeBRA,  // 65C02, W65C02S, R6500, R65C19, and Hu6280
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
    FRBOpcodeTypeCLT,  // M50734
    FRBOpcodeTypeCLV,
    FRBOpcodeTypeCLW,  // R65C19
    FRBOpcodeTypeCLX,  // Hu6280
    FRBOpcodeTypeCLY,  // Hu6280
    FRBOpcodeTypeCMP,
    FRBOpcodeTypeCOM,  // M50734
    FRBOpcodeTypeCPX,
    FRBOpcodeTypeCPY,
    FRBOpcodeTypeCSH,  // Hu6280
    FRBOpcodeTypeCSL,  // Hu6280
    FRBOpcodeTypeDEC,
    FRBOpcodeTypeDEX,
    FRBOpcodeTypeDEY,
    FRBOpcodeTypeDIV,  // M50734
    FRBOpcodeTypeEOR,
    FRBOpcodeTypeEXC,  // R65C19
    FRBOpcodeTypeINC,
    FRBOpcodeTypeINI,  // R65C19
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
    FRBOpcodeTypeLAB,  // R65C19
    FRBOpcodeTypeLAI,  // R65C19
    FRBOpcodeTypeLAN,  // R65C19
    FRBOpcodeTypeLDA,
    FRBOpcodeTypeLDM,  // M50734
    FRBOpcodeTypeLDX,
    FRBOpcodeTypeLDY,
    FRBOpcodeTypeLII,  // R65C19
    FRBOpcodeTypeLSR,
    FRBOpcodeTypeMPA,  // R65C19
    FRBOpcodeTypeMPY,  // R65C19
    FRBOpcodeTypeMUL,  // R65C29, M50734
    FRBOpcodeTypeNEG,  // R65C19
    FRBOpcodeTypeNOP,
    FRBOpcodeTypeNXT,  // R65C19
    FRBOpcodeTypeORA,
    FRBOpcodeTypePHA,
    FRBOpcodeTypePHI,  // R65C19
    FRBOpcodeTypePHP,
    FRBOpcodeTypePHW,  // R65C19
    FRBOpcodeTypePHX,  // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
    FRBOpcodeTypePHY,  // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
    FRBOpcodeTypePIA,  // R65C19
    FRBOpcodeTypePLA,
    FRBOpcodeTypePLI,  // R65C19
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
    FRBOpcodeTypeRRF,  // M50734
    FRBOpcodeTypeRTI,
    FRBOpcodeTypeRTS,
    FRBOpcodeTypeSAX,  // Hu6280
    FRBOpcodeTypeSAY,  // Hu6280
    FRBOpcodeTypeSBA,  // R65C19
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
    FRBOpcodeTypeSTI,  // R65C19
    FRBOpcodeTypeSTP,  // W65C02S and M50734
    FRBOpcodeTypeSTX,
    FRBOpcodeTypeSTY,
    FRBOpcodeTypeSTZ,  // 65C02, W65C02S, R6500, and Hu6280
    FRBOpcodeTypeSXY,  // Hu6280
    FRBOpcodeTypeTAI,  // Hu6280
    FRBOpcodeTypeTAM,  // Hu6280
    FRBOpcodeTypeTAW,  // R65C19
    FRBOpcodeTypeTAX,
    FRBOpcodeTypeTAY,
    FRBOpcodeTypeTIP,  // R65C19
    FRBOpcodeTypeTDD,  // Hu6280
    FRBOpcodeTypeTIA,  // Hu6280
    FRBOpcodeTypeTII,  // Hu6280
    FRBOpcodeTypeTIN,  // Hu6280
    FRBOpcodeTypeTMA,  // Hu6280
    FRBOpcodeTypeTRB,  // 65C02, W65C02S, R6500, and Hu6280
    FRBOpcodeTypeTSB,  // 65C02, W65C02S, R6500, and Hu6280
    FRBOpcodeTypeTST,  // Hu6280 and M50734
    FRBOpcodeTypeTSX,
    FRBOpcodeTypeTWA,  // R65C19
    FRBOpcodeTypeTXA,
    FRBOpcodeTypeTXS,
    FRBOpcodeTypeTYA,
    FRBOpcodeTypeWAI,  // W65C02S
    FRBOpcodeTypeWIT,  // M50734

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
    FRBRegisterFlagsA = 1 << FRBRegisterA,
    FRBRegisterFlagsX = 1 << FRBRegisterX,
    FRBRegisterFlagsY = 1 << FRBRegisterY,
    FRBRegisterFlagsS = 1 << FRBRegisterS,
    FRBRegisterFlagsW = 1 << FRBRegisterW, // R65C19
    FRBRegisterFlagsI = 1 << FRBRegisterI, // R65C19
    FRBRegisterFlagsP = 1 << FRBRegisterP,
};

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
struct FRBInstruction {
    const char * const name;
    DisasmBranchType branchType;
    FRBOpcodeCategory category;
};

/*!
 *	CPU Opcodes table item structure.
 */
struct FRBOpcode {
    FRBOpcodeType type;
    FRBAddressMode addressMode;
    FRBRegisterFlags readRegisters;
    FRBRegisterFlags writtenRegisters;
};

// TODO: Ask on the forum how to best model BAR, BAS, BBR and BBS opcodes.

/*! Core-independent instruction lookup table */
static const struct FRBInstruction FRBInstructions[FRBUniqueOpcodesCount] = {
    { "ADC ", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "ADD ", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "AND ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "ASL ", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "ASR ", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "BAR ", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BAS ", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BBC0", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBC1", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBC2", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBC3", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBC4", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBC5", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBC6", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBC7", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBR0", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBR1", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBR2", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBR3", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBR4", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBR5", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBR6", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBR7", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BBS0", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BBS1", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BBS2", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BBS3", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BBS4", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BBS5", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BBS6", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BBS7", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BCC ", DISASM_BRANCH_JNC,  FRBOpcodeCategoryBranches           },
    { "BCS ", DISASM_BRANCH_JC,   FRBOpcodeCategoryBranches           },
    { "BEQ ", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BIT ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "BMI ", DISASM_BRANCH_JS,   FRBOpcodeCategoryBranches           },
    { "BNE ", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BPL ", DISASM_BRANCH_JNS,  FRBOpcodeCategoryBranches           },
    { "BRA ", DISASM_BRANCH_JMP,  FRBOpcodeCategoryBranches           },
    { "BRK ", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "BVC ", DISASM_BRANCH_JNO,  FRBOpcodeCategoryBranches           },
    { "BVS ", DISASM_BRANCH_JO,   FRBOpcodeCategoryBranches           },
    { "CLA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CLB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CLB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CLB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CLB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CLB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CLB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CLB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CLB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CLC ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLD ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLI ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLT ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLV ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLW ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "CLY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "CMP ", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "COM ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "CPX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "CPY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "CSH ", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "CSL ", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "DEC ", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "DEX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "DEY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "DIV ", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "EOR ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "EXC ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "INC ", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "INI ", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "INX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "INY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "JMP ", DISASM_BRANCH_JMP,  FRBOpcodeCategoryJumps              },
    { "JPI ", DISASM_BRANCH_JMP,  FRBOpcodeCategoryJumps              },
    { "JSB0", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "JSB1", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "JSB2", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "JSB3", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "JSB4", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "JSB5", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "JSB6", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "JSB7", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "JSR ", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "LAB ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LAI ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LAN ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LDA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LDM ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LDX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LDY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LII ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LSR ", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "MPA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "MPY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "MUL ", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "NEG ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "NOP ", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "NXT ", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "ORA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "PHA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHI ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHP ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHW ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PIA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLI ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLP ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLW ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PSH ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PUL ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "RBA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "RMB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "RMB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "RMB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "RMB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "RMB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "RMB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "RMB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "RMB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "RND ", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "ROL ", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "ROR ", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "RRF ", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "RTI ", DISASM_BRANCH_RET,  FRBOpcodeCategorySystem             },
    { "RTS ", DISASM_BRANCH_RET,  FRBOpcodeCategorySystem             },
    { "SAX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "SAY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "SBA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "SBC ", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "SEB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "SEB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "SEB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "SEB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "SEB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "SEB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "SEB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "SEB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "SEC ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "SED ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "SEI ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "SET ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "SMB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "SMB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "SMB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "SMB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "SMB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "SMB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "SMB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "SMB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "ST0 ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "ST1 ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "ST2 ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STI ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STP ", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "STX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STZ ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "SXY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TAI ", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer      },
    { "TAM ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "TAW ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TAX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TAY ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TIP ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TDD ", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer      },
    { "TIA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer      },
    { "TII ", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer      },
    { "TIN ", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer      },
    { "TMA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "TRB ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "TSB ", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "TST ", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "TSX ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TWA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TXA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TXS ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TYA ", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "WAI ", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "WIT ", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
};

#endif
