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
    FRBAddressModeZeroPageIndirectIndexedX,       /*! Zero Page Indirect Indexed with X: (zp),x */
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
    2, // FRBAddressModeZeroPageIndirectIndexedX
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
    FRBOpcodeTypeAND,
    FRBOpcodeTypeASL,
    FRBOpcodeTypeBCC,
    FRBOpcodeTypeBCS,
    FRBOpcodeTypeBEQ,
    FRBOpcodeTypeBIT,
    FRBOpcodeTypeBMI,
    FRBOpcodeTypeBNE,
    FRBOpcodeTypeBPL,
    FRBOpcodeTypeBRK,
    FRBOpcodeTypeBVC,
    FRBOpcodeTypeBVS,
    FRBOpcodeTypeCLC,
    FRBOpcodeTypeCLD,
    FRBOpcodeTypeCLI,
    FRBOpcodeTypeCLV,
    FRBOpcodeTypeCMP,
    FRBOpcodeTypeCPX,
    FRBOpcodeTypeCPY,
    FRBOpcodeTypeDEC,
    FRBOpcodeTypeDEX,
    FRBOpcodeTypeDEY,
    FRBOpcodeTypeEOR,
    FRBOpcodeTypeINC,
    FRBOpcodeTypeINX,
    FRBOpcodeTypeINY,
    FRBOpcodeTypeJMP,
    FRBOpcodeTypeJSR,
    FRBOpcodeTypeLDA,
    FRBOpcodeTypeLDX,
    FRBOpcodeTypeLDY,
    FRBOpcodeTypeLSR,
    FRBOpcodeTypeNOP,
    FRBOpcodeTypeORA,
    FRBOpcodeTypePHA,
    FRBOpcodeTypePHP,
    FRBOpcodeTypePLA,
    FRBOpcodeTypePLP,
    FRBOpcodeTypeROL,
    FRBOpcodeTypeROR,
    FRBOpcodeTypeRTI,
    FRBOpcodeTypeRTS,
    FRBOpcodeTypeSBC,
    FRBOpcodeTypeSEC,
    FRBOpcodeTypeSED,
    FRBOpcodeTypeSEI,
    FRBOpcodeTypeSTA,
    FRBOpcodeTypeSTX,
    FRBOpcodeTypeSTY,
    FRBOpcodeTypeTAX,
    FRBOpcodeTypeTAY,
    FRBOpcodeTypeTSX,
    FRBOpcodeTypeTXA,
    FRBOpcodeTypeTXS,
    FRBOpcodeTypeTYA,

    FRBOpcodeTypeUndocumented
};

static const size_t FRBUniqueOpcodesCount = FRBOpcodeTypeUndocumented;

typedef NS_ENUM(NSUInteger, FRBRegisters) {
    FRBRegisterA = 0,
    FRBRegisterX,
    FRBRegisterY,
    FRBRegisterS,
    FRBRegisterP,

    FRBRegisterUnknown
};

static const size_t FRBUniqueRegistersCount = FRBRegisterUnknown;

typedef NS_OPTIONS(NSUInteger, FRBRegisterFlags) {
    FRBRegisterFlagsA = 1 << FRBRegisterA,
    FRBRegisterFlagsX = 1 << FRBRegisterX,
    FRBRegisterFlagsY = 1 << FRBRegisterY,
    FRBRegisterFlagsS = 1 << FRBRegisterS,
    FRBRegisterFlagsP = 1 << FRBRegisterP,
};

#define A FRBRegisterFlagsA
#define X FRBRegisterFlagsX
#define Y FRBRegisterFlagsY
#define S FRBRegisterFlagsS
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
    { "ADC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "AND", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "ASL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "BCC", DISASM_BRANCH_JNC,  FRBOpcodeCategoryBranches           },
    { "BCS", DISASM_BRANCH_JC,   FRBOpcodeCategoryBranches           },
    { "BEQ", DISASM_BRANCH_JE,   FRBOpcodeCategoryBranches           },
    { "BIT", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "BMI", DISASM_BRANCH_JS,   FRBOpcodeCategoryBranches           },
    { "BNE", DISASM_BRANCH_JNE,  FRBOpcodeCategoryBranches           },
    { "BPL", DISASM_BRANCH_JNS,  FRBOpcodeCategoryBranches           },
    { "BRK", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "BVC", DISASM_BRANCH_JNO,  FRBOpcodeCategoryBranches           },
    { "BVS", DISASM_BRANCH_JO,   FRBOpcodeCategoryBranches           },
    { "CLC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLD", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLV", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CMP", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "CPX", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "CPY", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "DEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "DEX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "DEY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "EOR", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "INC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "INX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "INY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "JMP", DISASM_BRANCH_JMP,  FRBOpcodeCategoryJumps              },
    { "JSR", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "LDA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LDX", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LDY", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LSR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "NOP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "ORA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "PHA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "ROL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "ROR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "RTI", DISASM_BRANCH_RET,  FRBOpcodeCategorySystem             },
    { "RTS", DISASM_BRANCH_RET,  FRBOpcodeCategorySystem             },
    { "SBC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "SEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "SED", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "SEI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "STA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "TAX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TAY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TSX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TXA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TXS", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TYA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
};

#endif
