/*
 Copyright (c) 2014-2015, Alessandro Gatti - frob.it
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

#import <Foundation/Foundation.h>
#import <Hopper/Hopper.h>

static NSString * const FRBSyntaxVariant = @"Generic";
static NSString * const FRBCPUMode = @"generic";

/*! Address modes. */
typedef NS_ENUM(NSUInteger, Mode) {
    ModeAbsolute = 0,                 /*! Absolute: a */
    ModeAbsoluteIndexedX,             /*! Absolute Indexed with X: a,x */
    ModeAbsoluteIndexedY,             /*! Absolute Indexed with Y: a,y */
    ModeAbsoluteLong,                 /*! Absolute Long: al */
    ModeAbsoluteLongIndexed,          /*! Absolute Long Indexed: al,x */
    ModeImmediate,                    /*! Immediate: # */
    ModeAccumulator,                  /*! Accumulator: A */
    ModeImplied,                      /*! Implied: i */
    ModeStack,                        /*! Stack: s */
    ModeAbsoluteIndirect,             /*! Absolute Indirect: (a) */
    ModeProgramCounterRelative,       /*! Program Counter Relative: r */
    ModeProgramCounterRelativeLong,   /*! Program Counter Relative Long: rl */
    ModeDirect,                       /*! Direct: d */
    ModeDirectIndexedX,               /*! Direct Indexed with X: d,x */
    ModeDirectIndexedY,               /*! Direct Indexed with Y: d,y */
    ModeDirectIndexedIndirect,        /*! Direct Indexed Indirect: (d,x) */
    ModeDirectIndirectIndexedY,       /*! Direct Indirect Indexed with Y: (d),y */
    ModeDirectIndirect,               /*! Direct Indirect: (d) */
    ModeDirectIndirectLong,           /*! Direct Indirect Long: [d] */
    ModeDirectIndirectLongIndexed,    /*! Direct Indirect Long Indexed: [d],y */
    ModeAbsoluteIndexedIndirect,      /*! Absolute Indexed Indirect: (a,x) */
    ModeStackRelative,                /*! Stack Relative: d,s */
    ModeStackRelativeIndirectIndexed, /*! Stack Relative Indirect Indexed: (d,s),y */
    ModeBlockMove,                    /*! Block Move: xyc */
    ModeUnknown,                      /*! Unknown address mode, used for undocumented opcodes */
};

static const size_t FRBAddressModesCount = ModeUnknown;

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

typedef NS_ENUM(NSUInteger, Category) {
    CategoryUnknown = 0,
    CategorySystem,
    CategoryLoad,
    CategoryStore,
    CategoryRegisterTransfers,
    CategoryStack,
    CategoryLogical,
    CategoryComparison,
    CategoryArithmetic,
    CategoryIncrementDecrement,
    CategoryShifts,
    CategoryJumps,
    CategoryBranches,
    CategoryStatusFlagChanges,
    CategoryBlockTransfer
};

typedef NS_ENUM(NSUInteger, Opcode) {
    OpcodeADC = 0,
    OpcodeAND,
    OpcodeASL,
    OpcodeBCC,
    OpcodeBCS,
    OpcodeBEQ,
    OpcodeBIT,
    OpcodeBMI,
    OpcodeBNE,
    OpcodeBPL,
    OpcodeBRA,
    OpcodeBRK,
    OpcodeBRL,
    OpcodeBVC,
    OpcodeBVS,
    OpcodeCLC,
    OpcodeCLD,
    OpcodeCLI,
    OpcodeCLV,
    OpcodeCMP,
    OpcodeCOP,
    OpcodeCPX,
    OpcodeCPY,
    OpcodeDEC,
    OpcodeDEX,
    OpcodeDEY,
    OpcodeEOR,
    OpcodeINC,
    OpcodeINX,
    OpcodeINY,
    OpcodeJML,
    OpcodeJMP,
    OpcodeJSL,
    OpcodeJSR,
    OpcodeLDA,
    OpcodeLDX,
    OpcodeLDY,
    OpcodeLSR,
    OpcodeMVN,
    OpcodeMVP,
    OpcodeNOP,
    OpcodeORA,
    OpcodePEA,
    OpcodePEI,
    OpcodePER,
    OpcodePHA,
    OpcodePHB,
    OpcodePHD,
    OpcodePHK,
    OpcodePHP,
    OpcodePHX,
    OpcodePHY,
    OpcodePLA,
    OpcodePLB,
    OpcodePLD,
    OpcodePLP,
    OpcodePLX,
    OpcodePLY,
    OpcodeREP,
    OpcodeROL,
    OpcodeROR,
    OpcodeRTI,
    OpcodeRTL,
    OpcodeRTS,
    OpcodeSBC,
    OpcodeSEC,
    OpcodeSED,
    OpcodeSEI,
    OpcodeSEP,
    OpcodeSTA,
    OpcodeSTP,
    OpcodeSTX,
    OpcodeSTY,
    OpcodeSTZ,
    OpcodeTAX,
    OpcodeTAY,
    OpcodeTCD,
    OpcodeTCS,
    OpcodeTDC,
    OpcodeTRB,
    OpcodeTSB,
    OpcodeTSC,
    OpcodeTSX,
    OpcodeTXA,
    OpcodeTXS,
    OpcodeTXY,
    OpcodeTYA,
    OpcodeTYX,
    OpcodeWAI,
    OpcodeWDM,
    OpcodeXBA,
    OpcodeXCE,

    OpcodeUndocumented
};

static const size_t FRBUniqueOpcodesCount = OpcodeUndocumented;

typedef NS_ENUM(NSUInteger, Registers) {
    RegisterA = 0,
    RegisterX,
    RegisterY,
    RegisterS,
};

typedef NS_OPTIONS(NSUInteger, RegisterMask) {
    RegisterAccumulator    = 1 << RegisterA,
    RegisterIndexX         = 1 << RegisterX,
    RegisterIndexY         = 1 << RegisterY,
    RegisterDataBank       = 1 << 3,
    RegisterDirect         = 1 << 4,
    RegisterStack          = 1 << RegisterS,
    RegisterProcessorState = 1 << 6,
    RegisterProgramBank    = 1 << 7,
    RegisterB              = 1 << 8,
    RegisterC              = 1 << 9,
};

#define A   RegisterAccumulator
#define X   RegisterIndexX
#define Y   RegisterIndexY
#define S   RegisterStack
#define D   RegisterDirect
#define P   RegisterProcessorState
#define DBR RegisterDataBank
#define PBR RegisterProgramBank
#define B   RegisterB
#define C   RegisterC

struct FRBInstruction {
    const char * const name;
    DisasmBranchType branchType;
    Category category;
};

struct FRBOpcode {
    Opcode type;
    Mode addressMode;
    RegisterMask readRegisters;
    RegisterMask writtenRegisters;
};

static const struct FRBInstruction FRBInstructions[FRBUniqueOpcodesCount] = {
    { "ADC", DISASM_BRANCH_NONE, CategoryArithmetic         },
    { "AND", DISASM_BRANCH_NONE, CategoryLogical            },
    { "ASL", DISASM_BRANCH_NONE, CategoryShifts             },
    { "BCC", DISASM_BRANCH_JNC,  CategoryBranches           },
    { "BCS", DISASM_BRANCH_JC,   CategoryBranches           },
    { "BEQ", DISASM_BRANCH_JE,   CategoryBranches           },
    { "BIT", DISASM_BRANCH_NONE, CategoryLogical            },
    { "BMI", DISASM_BRANCH_JS,   CategoryBranches           },
    { "BNE", DISASM_BRANCH_JNE,  CategoryBranches           },
    { "BPL", DISASM_BRANCH_JNS,  CategoryBranches           },
    { "BRA", DISASM_BRANCH_JMP,  CategoryBranches           },
    { "BRK", DISASM_BRANCH_NONE, CategorySystem             },
    { "BRL", DISASM_BRANCH_JMP,  CategoryJumps              },
    { "BVC", DISASM_BRANCH_JNO,  CategoryBranches           },
    { "BVS", DISASM_BRANCH_JO,   CategoryBranches           },
    { "CLC", DISASM_BRANCH_NONE, CategoryStatusFlagChanges  },
    { "CLD", DISASM_BRANCH_NONE, CategoryStatusFlagChanges  },
    { "CLI", DISASM_BRANCH_NONE, CategoryStatusFlagChanges  },
    { "CLV", DISASM_BRANCH_NONE, CategoryStatusFlagChanges  },
    { "CMP", DISASM_BRANCH_NONE, CategoryComparison         },
    { "COP", DISASM_BRANCH_NONE, CategorySystem             },
    { "CPX", DISASM_BRANCH_NONE, CategoryComparison         },
    { "CPY", DISASM_BRANCH_NONE, CategoryComparison         },
    { "DEC", DISASM_BRANCH_NONE, CategoryIncrementDecrement },
    { "DEX", DISASM_BRANCH_NONE, CategoryIncrementDecrement },
    { "DEY", DISASM_BRANCH_NONE, CategoryIncrementDecrement },
    { "EOR", DISASM_BRANCH_NONE, CategoryLogical            },
    { "INC", DISASM_BRANCH_NONE, CategoryIncrementDecrement },
    { "INX", DISASM_BRANCH_NONE, CategoryIncrementDecrement },
    { "INY", DISASM_BRANCH_NONE, CategoryIncrementDecrement },
    { "JML", DISASM_BRANCH_JMP,  CategoryJumps              },
    { "JMP", DISASM_BRANCH_JMP,  CategoryJumps              },
    { "JSL", DISASM_BRANCH_CALL, CategoryJumps              },
    { "JSR", DISASM_BRANCH_CALL, CategoryJumps              },
    { "LDA", DISASM_BRANCH_NONE, CategoryLoad               },
    { "LDX", DISASM_BRANCH_NONE, CategoryLoad               },
    { "LDY", DISASM_BRANCH_NONE, CategoryLoad               },
    { "LSR", DISASM_BRANCH_NONE, CategoryShifts             },
    { "MVN", DISASM_BRANCH_NONE, CategoryBlockTransfer      },
    { "MVP", DISASM_BRANCH_NONE, CategoryBlockTransfer      },
    { "NOP", DISASM_BRANCH_NONE, CategorySystem             },
    { "ORA", DISASM_BRANCH_NONE, CategoryLogical            },
    { "PEA", DISASM_BRANCH_NONE, CategoryStack              },
    { "PEI", DISASM_BRANCH_NONE, CategoryStack              },
    { "PER", DISASM_BRANCH_NONE, CategoryStack              },
    { "PHA", DISASM_BRANCH_NONE, CategoryStack              },
    { "PHB", DISASM_BRANCH_NONE, CategoryStack              },
    { "PHD", DISASM_BRANCH_NONE, CategoryStack              },
    { "PHK", DISASM_BRANCH_NONE, CategoryStack              },
    { "PHP", DISASM_BRANCH_NONE, CategoryStack              },
    { "PHX", DISASM_BRANCH_NONE, CategoryStack              },
    { "PHY", DISASM_BRANCH_NONE, CategoryStack              },
    { "PLA", DISASM_BRANCH_NONE, CategoryStack              },
    { "PLB", DISASM_BRANCH_NONE, CategoryStack              },
    { "PLD", DISASM_BRANCH_NONE, CategoryStack              },
    { "PLP", DISASM_BRANCH_NONE, CategoryStack              },
    { "PLX", DISASM_BRANCH_NONE, CategoryStack              },
    { "PLY", DISASM_BRANCH_NONE, CategoryStack              },
    { "REP", DISASM_BRANCH_NONE, CategorySystem             },
    { "ROL", DISASM_BRANCH_NONE, CategoryShifts             },
    { "ROR", DISASM_BRANCH_NONE, CategoryShifts             },
    { "RTI", DISASM_BRANCH_RET,  CategorySystem             },
    { "RTL", DISASM_BRANCH_RET,  CategorySystem             },
    { "RTS", DISASM_BRANCH_RET,  CategorySystem             },
    { "SBC", DISASM_BRANCH_NONE, CategoryArithmetic         },
    { "SEC", DISASM_BRANCH_NONE, CategoryStatusFlagChanges  },
    { "SED", DISASM_BRANCH_NONE, CategoryStatusFlagChanges  },
    { "SEI", DISASM_BRANCH_NONE, CategoryStatusFlagChanges  },
    { "SEP", DISASM_BRANCH_NONE, CategorySystem             },
    { "STA", DISASM_BRANCH_NONE, CategoryStore              },
    { "STP", DISASM_BRANCH_NONE, CategorySystem             },
    { "STX", DISASM_BRANCH_NONE, CategoryStore              },
    { "STY", DISASM_BRANCH_NONE, CategoryStore              },
    { "STZ", DISASM_BRANCH_NONE, CategoryStore              },
    { "TAX", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TAY", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TCD", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TCS", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TDC", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TRB", DISASM_BRANCH_NONE, CategoryLogical            },
    { "TSB", DISASM_BRANCH_NONE, CategoryLogical            },
    { "TSC", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TSX", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TXA", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TXS", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TXY", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TYA", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "TYX", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "WAI", DISASM_BRANCH_NONE, CategorySystem             },
    { "WDM", DISASM_BRANCH_NONE, CategorySystem             },
    { "XBA", DISASM_BRANCH_NONE, CategoryRegisterTransfers  },
    { "XCE", DISASM_BRANCH_NONE, CategorySystem             },
};
