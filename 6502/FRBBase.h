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

    /*! Absolute: a */
    FRBAddressModeAbsolute = 0,

    /*! Absolute Indexed with X: a,x */
    FRBAddressModeAbsoluteIndexedX,

    /*! Absolute Indexed with Y: a,y */
    FRBAddressModeAbsoluteIndexedY,

    /*! Immediate: # */
    FRBAddressModeImmediate,

    /*! Accumulator: A */
    FRBAddressModeAccumulator,

    /*! Implied: i */
    FRBAddressModeImplied,

    /*! Stack: s */
    FRBAddressModeStack,

    /*! Absolute Indirect: (a) */
    FRBAddressModeAbsoluteIndirect,

    /*! Program Counter Relative: r */
    FRBAddressModeProgramCounterRelative,

    /*! Zero Page: zp */
    FRBAddressModeZeroPage,

    /*! Zero Page Indexed with X: zp,X */
    FRBAddressModeZeroPageIndexedX,

    /*! Zero Page Indexed with Y: zp,Y */
    FRBAddressModeZeroPageIndexedY,

    /*! Zero Page Indexed Indirect: (zp,x) */
    FRBAddressModeZeroPageIndexedIndirect,

    /*! Zero Page Indirect Indexed with Y: (zp),y */
    FRBAddressModeZeroPageIndirectIndexedY,

    /*! Zero Page Indirect: (zp) */
    FRBAddressModeZeroPageIndirect, // Generic 65C02

    /*! Absolute Indexed Indirect: (a,x) */
    FRBAddressModeAbsoluteIndexedIndirect, // Generic 65C02, W65C02S, and R6500

    /*! Zero Page Program Counter Relative: zp, r */
    FRBAddressModeZeroPageProgramCounterRelative, // W65C02S and R6500

    /*! Block transfer: (a, a, a) */
    FRBAddressModeBlockTransfer, // Hu6280

    /*! Immediate, Zero Page: ? */
    FRBAddressModeImmediateZeroPage, // Hu6280

    /*! Immediate, Zero Page, X: ? */
    FRBAddressModeImmediateZeroPageX, // Hu6280

    /*! Immediate, Absolute: ? */
    FRBAddressModeImmediateAbsolute, // Hu6280

    /*! Immediate, Absolute, X: ? */
    FRBAddressModeImmediateAbsoluteX, // Hu6280

    /*! Unknown address mode, used for undocumented opcodes */
    FRBAddressModeUnknown,
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
    FRBOpcodeCategoryBlockTransfer // Hu6280
};

typedef NS_ENUM(NSUInteger, FRBOpcodeType) {
    FRBOpcodeTypeADC = 0,
    FRBOpcodeTypeAND,
    FRBOpcodeTypeASL,
    FRBOpcodeTypeBBR0, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBR1, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBR2, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBR3, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBR4, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBR5, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBR6, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBR7, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBS0, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBS1, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBS2, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBS3, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBS4, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBS5, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBS6, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBBS7, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBCC,
    FRBOpcodeTypeBCS,
    FRBOpcodeTypeBEQ,
    FRBOpcodeTypeBIT,
    FRBOpcodeTypeBMI,
    FRBOpcodeTypeBNE,
    FRBOpcodeTypeBPL,
    FRBOpcodeTypeBRA,  // Generic 65C02, W65C02S, R6500, and Hu6280
    FRBOpcodeTypeBRK,
    FRBOpcodeTypeBVC,
    FRBOpcodeTypeBVS,
    FRBOpcodeTypeCLA,  // Hu6280
    FRBOpcodeTypeCLC,
    FRBOpcodeTypeCLD,
    FRBOpcodeTypeCLI,
    FRBOpcodeTypeCLV,
    FRBOpcodeTypeCLX,  // Hu6280
    FRBOpcodeTypeCLY,  // Hu6280
    FRBOpcodeTypeCMP,
    FRBOpcodeTypeCPX,
    FRBOpcodeTypeCPY,
    FRBOpcodeTypeCSH,  // Hu6280
    FRBOpcodeTypeCSL,  // Hu6280
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
    FRBOpcodeTypePHX,  // Generic 65C02, W65C02S, R6500, and Hu6280
    FRBOpcodeTypePHY,  // Generic 65C02, W65C02S, R6500, and Hu6280
    FRBOpcodeTypePLA,
    FRBOpcodeTypePLP,
    FRBOpcodeTypePLX,  // Generic 65C02, W65C02S, R6500, and Hu6280
    FRBOpcodeTypePLY,  // Generic 65C02, W65C02S, R6500, and Hu6280
    FRBOpcodeTypeRMB0, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeRMB1, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeRMB2, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeRMB3, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeRMB4, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeRMB5, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeRMB6, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeRMB7, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeROL,
    FRBOpcodeTypeROR,
    FRBOpcodeTypeRTI,
    FRBOpcodeTypeRTS,
    FRBOpcodeTypeSAX,  // Hu6280
    FRBOpcodeTypeSAY,  // Hu6280
    FRBOpcodeTypeSBC,
    FRBOpcodeTypeSEC,
    FRBOpcodeTypeSED,
    FRBOpcodeTypeSEI,
    FRBOpcodeTypeSET,  // Hu6280
    FRBOpcodeTypeSMB0, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeSMB1, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeSMB2, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeSMB3, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeSMB4, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeSMB5, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeSMB6, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeSMB7, // W65C02S, R6500, and Hu6280
    FRBOpcodeTypeST0,  // Hu6280
    FRBOpcodeTypeST1,  // Hu6280
    FRBOpcodeTypeST2,  // Hu6280
    FRBOpcodeTypeSTA,
    FRBOpcodeTypeSTP,  // W65C02S
    FRBOpcodeTypeSTX,
    FRBOpcodeTypeSTY,
    FRBOpcodeTypeSTZ,  // Generic 65C02, W65C02S, R6500, and Hu6280
    FRBOpcodeTypeSXY,  // Hu6280
    FRBOpcodeTypeTAI,  // Hu6280
    FRBOpcodeTypeTAM,  // Hu6280
    FRBOpcodeTypeTAX,
    FRBOpcodeTypeTAY,
    FRBOpcodeTypeTDD,  // Hu6280
    FRBOpcodeTypeTIA,  // Hu6280
    FRBOpcodeTypeTII,  // Hu6280
    FRBOpcodeTypeTIN,  // Hu6280
    FRBOpcodeTypeTMA,  // Hu6280
    FRBOpcodeTypeTRB,  // Generic 65C02, W65C02S, and Hu6280
    FRBOpcodeTypeTSB,  // Generic 65C02, W65C02S, and Hu6280
    FRBOpcodeTypeTST,  // Hu6280
    FRBOpcodeTypeTSX,
    FRBOpcodeTypeTXA,
    FRBOpcodeTypeTXS,
    FRBOpcodeTypeTYA,
    FRBOpcodeTypeWAI,  // W65C02S

    FRBOpcodeTypeUndocumented
};

static const size_t FRBUniqueOpcodesCount = 118;

typedef NS_OPTIONS(NSUInteger, FRBRegisterMask) {
    FRBRegisterAccumulator = 1 << 0,
    FRBRegisterIndexX = 1 << 1,
    FRBRegisterIndexY = 1 << 2,
    FRBRegisterCustom = 1 << 16
};

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
    { "ADC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic },
    { "AND", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { "ASL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { "BBR0", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { "BBR1", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { "BBR2", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { "BBR3", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { "BBR4", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { "BBR5", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { "BBR6", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { "BBR7", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { "BBS0", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { "BBS1", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { "BBS2", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { "BBS3", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { "BBS4", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { "BBS5", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { "BBS6", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { "BBS7", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { "BCC", DISASM_BRANCH_JNC, FRBOpcodeCategoryBranches },
    { "BCS", DISASM_BRANCH_JC, FRBOpcodeCategoryBranches },
    { "BEQ", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches },
    { "BIT", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { "BMI", DISASM_BRANCH_JS, FRBOpcodeCategoryBranches },
    { "BNE", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches },
    { "BPL", DISASM_BRANCH_JNS, FRBOpcodeCategoryBranches },
    { "BRA", DISASM_BRANCH_JMP, FRBOpcodeCategoryBranches },
    { "BRK", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
    { "BVC", DISASM_BRANCH_JNO, FRBOpcodeCategoryBranches },
    { "BVS", DISASM_BRANCH_JO, FRBOpcodeCategoryBranches },
    { "CLA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { "CLC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { "CLD", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { "CLI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { "CLV", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { "CLX", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { "CLY", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { "CMP", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison },
    { "CPX", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison },
    { "CPY", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison },
    { "CSH", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
    { "CSL", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
    { "DEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "DEX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "DEY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "EOR", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { "INC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "INX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "INY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { "JMP", DISASM_BRANCH_JMP, FRBOpcodeCategoryJumps },
    { "JSR", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps },
    { "LDA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad },
    { "LDX", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad },
    { "LDY", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad },
    { "LSR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { "NOP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
    { "ORA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { "PHA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { "PHP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { "PHX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { "PHY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { "PLA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { "PLP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { "PLX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { "PLY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { "RMB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "RMB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "RMB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "RMB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "RMB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "RMB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "RMB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "RMB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "ROL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { "ROR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { "RTI", DISASM_BRANCH_RET, FRBOpcodeCategorySystem },
    { "RTS", DISASM_BRANCH_RET, FRBOpcodeCategorySystem },
    { "SAX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { "SAY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { "SBC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic },
    { "SEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { "SED", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { "SEI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { "SET", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { "SMB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "SMB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "SMB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "SMB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "SMB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "SMB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "SMB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "SMB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "ST0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "ST1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "ST2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "STA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "STP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
    { "STX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "STY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "STZ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "SXY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { "TAI", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer },
    { "TAM", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { "TAX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { "TAY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { "TDD", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer },
    { "TIA", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer },
    { "TII", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer },
    { "TIN", DISASM_BRANCH_NONE, FRBOpcodeCategoryBlockTransfer },
    { "TMA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad },
    { "TRB", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { "TSB", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { "TST", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison },
    { "TSX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { "TXA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { "TXS", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { "TYA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { "WAI", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
};

#endif
