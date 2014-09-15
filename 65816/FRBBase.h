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

static NSString * const FRBSyntaxVariant = @"Generic";
static NSString * const FRBCPUMode = @"generic";

/*! Address modes. */
typedef NS_ENUM(NSUInteger, FRBAddressMode) {
    FRBAddressModeAbsolute = 0,                 /*! Absolute: a */
    FRBAddressModeAbsoluteIndexedX,             /*! Absolute Indexed with X: a,x */
    FRBAddressModeAbsoluteIndexedY,             /*! Absolute Indexed with Y: a,y */
    FRBAddressModeAbsoluteLong,                 /*! Absolute Long: al */
    FRBAddressModeAbsoluteLongIndexed,          /*! Absolute Long Indexed: al,x */
    FRBAddressModeImmediate,                    /*! Immediate: # */
    FRBAddressModeAccumulator,                  /*! Accumulator: A */
    FRBAddressModeImplied,                      /*! Implied: i */
    FRBAddressModeStack,                        /*! Stack: s */
    FRBAddressModeAbsoluteIndirect,             /*! Absolute Indirect: (a) */
    FRBAddressModeProgramCounterRelative,       /*! Program Counter Relative: r */
    FRBAddressModeProgramCounterRelativeLong,   /*! Program Counter Relative Long: rl */
    FRBAddressModeDirect,                       /*! Direct: d */
    FRBAddressModeDirectIndexedX,               /*! Direct Indexed with X: d,x */
    FRBAddressModeDirectIndexedY,               /*! Direct Indexed with Y: d,y */
    FRBAddressModeDirectIndexedIndirect,        /*! Direct Indexed Indirect: (d,x) */
    FRBAddressModeDirectIndirectIndexedY,       /*! Direct Indirect Indexed with Y: (d),y */
    FRBAddressModeDirectIndirect,               /*! Direct Indirect: (d) */
    FRBAddressModeDirectIndirectLong,           /*! Direct Indirect Long: [d] */
    FRBAddressModeDirectIndirectLongIndexed,    /*! Direct Indirect Long Indexed: [d],y */
    FRBAddressModeAbsoluteIndexedIndirect,      /*! Absolute Indexed Indirect: (a,x) */
    FRBAddressModeStackRelative,                /*! Stack Relative: d,s */
    FRBAddressModeStackRelativeIndirectIndexed, /*! Stack Relative Indirect Indexed: (d,s),y */
    FRBAddressModeBlockMove,                    /*! Block Move: xyc */
    FRBAddressModeUnknown,                      /*! Unknown address mode, used for undocumented opcodes */
};

static const size_t FRBAddressModesCount = FRBAddressModeUnknown;

static const size_t FRBOpcodeLength[FRBAddressModesCount] = {
    3,
    3,
    3,
    4,
    4,
    2,
    1,
    1,
    1,
    3,
    2,
    3,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    3,
    2,
    2,
    3
};

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
    FRBOpcodeTypeAND,
    FRBOpcodeTypeASL,
    FRBOpcodeTypeBCC,
    FRBOpcodeTypeBCS,
    FRBOpcodeTypeBEQ,
    FRBOpcodeTypeBIT,
    FRBOpcodeTypeBMI,
    FRBOpcodeTypeBNE,
    FRBOpcodeTypeBPL,
    FRBOpcodeTypeBRA,
    FRBOpcodeTypeBRK,
    FRBOpcodeTypeBRL,
    FRBOpcodeTypeBVC,
    FRBOpcodeTypeBVS,
    FRBOpcodeTypeCLC,
    FRBOpcodeTypeCLD,
    FRBOpcodeTypeCLI,
    FRBOpcodeTypeCLV,
    FRBOpcodeTypeCMP,
    FRBOpcodeTypeCOP,
    FRBOpcodeTypeCPX,
    FRBOpcodeTypeCPY,
    FRBOpcodeTypeDEC,
    FRBOpcodeTypeDEX,
    FRBOpcodeTypeDEY,
    FRBOpcodeTypeEOR,
    FRBOpcodeTypeINC,
    FRBOpcodeTypeINX,
    FRBOpcodeTypeINY,
    FRBOpcodeTypeJML,
    FRBOpcodeTypeJMP,
    FRBOpcodeTypeJSL,
    FRBOpcodeTypeJSR,
    FRBOpcodeTypeLDA,
    FRBOpcodeTypeLDX,
    FRBOpcodeTypeLDY,
    FRBOpcodeTypeLSR,
    FRBOpcodeTypeMVN,
    FRBOpcodeTypeMVP,
    FRBOpcodeTypeNOP,
    FRBOpcodeTypeORA,
    FRBOpcodeTypePEA,
    FRBOpcodeTypePEI,
    FRBOpcodeTypePER,
    FRBOpcodeTypePHA,
    FRBOpcodeTypePHB,
    FRBOpcodeTypePHD,
    FRBOpcodeTypePHK,
    FRBOpcodeTypePHP,
    FRBOpcodeTypePHX,
    FRBOpcodeTypePHY,
    FRBOpcodeTypePLA,
    FRBOpcodeTypePLB,
    FRBOpcodeTypePLD,
    FRBOpcodeTypePLP,
    FRBOpcodeTypePLX,
    FRBOpcodeTypePLY,
    FRBOpcodeTypeREP,
    FRBOpcodeTypeROL,
    FRBOpcodeTypeROR,
    FRBOpcodeTypeRTI,
    FRBOpcodeTypeRTL,
    FRBOpcodeTypeRTS,
    FRBOpcodeTypeSBC,
    FRBOpcodeTypeSEC,
    FRBOpcodeTypeSED,
    FRBOpcodeTypeSEI,
    FRBOpcodeTypeSEP,
    FRBOpcodeTypeSTA,
    FRBOpcodeTypeSTP,
    FRBOpcodeTypeSTX,
    FRBOpcodeTypeSTY,
    FRBOpcodeTypeSTZ,
    FRBOpcodeTypeTAX,
    FRBOpcodeTypeTAY,
    FRBOpcodeTypeTCD,
    FRBOpcodeTypeTCS,
    FRBOpcodeTypeTDC,
    FRBOpcodeTypeTRB,
    FRBOpcodeTypeTSB,
    FRBOpcodeTypeTSC,
    FRBOpcodeTypeTSX,
    FRBOpcodeTypeTXA,
    FRBOpcodeTypeTXS,
    FRBOpcodeTypeTXY,
    FRBOpcodeTypeTYA,
    FRBOpcodeTypeTYX,
    FRBOpcodeTypeWAI,
    FRBOpcodeTypeWDM,
    FRBOpcodeTypeXBA,
    FRBOpcodeTypeXCE,

    FRBOpcodeTypeUndocumented
};

static const size_t FRBUniqueOpcodesCount = FRBOpcodeTypeUndocumented;

typedef NS_ENUM(NSUInteger, FRBRegisters) {
    FRBRegisterA = 0,
    FRBRegisterX,
    FRBRegisterY,
    FRBRegisterS,
};

typedef NS_OPTIONS(NSUInteger, FRBRegisterMask) {
    FRBRegisterAccumulator    = 1 << FRBRegisterA,
    FRBRegisterIndexX         = 1 << FRBRegisterX,
    FRBRegisterIndexY         = 1 << FRBRegisterY,
    FRBRegisterDataBank       = 1 << 3,
    FRBRegisterDirect         = 1 << 4,
    FRBRegisterStack          = 1 << FRBRegisterS,
    FRBRegisterProcessorState = 1 << 6,
    FRBRegisterProgramBank    = 1 << 7,
    FRBRegisterB              = 1 << 8,
    FRBRegisterC              = 1 << 9,
};

#define A   FRBRegisterAccumulator
#define X   FRBRegisterIndexX
#define Y   FRBRegisterIndexY
#define S   FRBRegisterStack
#define D   FRBRegisterDirect
#define P   FRBRegisterProcessorState
#define DBR FRBRegisterDataBank
#define PBR FRBRegisterProgramBank
#define B   FRBRegisterB
#define C   FRBRegisterC

struct FRBInstruction {
    const char * const name;
    DisasmBranchType branchType;
    FRBOpcodeCategory category;
};

struct FRBOpcode {
    FRBOpcodeType type;
    FRBAddressMode addressMode;
    FRBRegisterMask readRegisters;
    FRBRegisterMask writtenRegisters;
};

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
    { "BRA", DISASM_BRANCH_JMP,  FRBOpcodeCategoryBranches           },
    { "BRK", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "BRL", DISASM_BRANCH_JMP,  FRBOpcodeCategoryJumps              },
    { "BVC", DISASM_BRANCH_JNO,  FRBOpcodeCategoryBranches           },
    { "BVS", DISASM_BRANCH_JO,   FRBOpcodeCategoryBranches           },
    { "CLC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLD", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CLV", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "CMP", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "COP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "CPX", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "CPY", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison         },
    { "DEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "DEX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "DEY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "EOR", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "INC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "INX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "INY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "JML", DISASM_BRANCH_JMP,  FRBOpcodeCategoryJumps              },
    { "JMP", DISASM_BRANCH_JMP,  FRBOpcodeCategoryJumps              },
    { "JSL", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "JSR", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps              },
    { "LDA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LDX", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LDY", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad               },
    { "LSR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "MVN", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer      },
    { "MVP", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer      },
    { "NOP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "ORA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "PEA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PEI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PER", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHB", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHD", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHK", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PHY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLB", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLD", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "PLY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack              },
    { "REP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "ROL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "ROR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts             },
    { "RTI", DISASM_BRANCH_RET,  FRBOpcodeCategorySystem             },
    { "RTL", DISASM_BRANCH_RET,  FRBOpcodeCategorySystem             },
    { "RTS", DISASM_BRANCH_RET,  FRBOpcodeCategorySystem             },
    { "SBC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic         },
    { "SEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "SED", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "SEI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges  },
    { "SEP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "STA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "STX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "STZ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore              },
    { "TAX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TAY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TCD", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TCS", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TDC", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TRB", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "TSB", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical            },
    { "TSC", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TSX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TXA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TXS", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TXY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TYA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "TYX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "WAI", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "WDM", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
    { "XBA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers  },
    { "XCE", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem             },
};

#endif
