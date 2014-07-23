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

/*! 6502 Address modes, as per the W65C02S datasheet. */
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
    FRBAddressModeZeroPageProgramCounterRelative, // Generic W65C02S, and R6500

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
    FRBOpcodeCategoryStatusFlagChanges
};

typedef NS_ENUM(NSUInteger, FRBOpcodeType) {
    FRBOpcodeTypeADC = 0,
    FRBOpcodeTypeAND,
    FRBOpcodeTypeASL,
    FRBOpcodeTypeBBR0, // W65C02S and R6500
    FRBOpcodeTypeBBR1, // W65C02S and R6500
    FRBOpcodeTypeBBR2, // W65C02S and R6500
    FRBOpcodeTypeBBR3, // W65C02S and R6500
    FRBOpcodeTypeBBR4, // W65C02S and R6500
    FRBOpcodeTypeBBR5, // W65C02S and R6500
    FRBOpcodeTypeBBR6, // W65C02S and R6500
    FRBOpcodeTypeBBR7, // W65C02S and R6500
    FRBOpcodeTypeBBS0, // W65C02S and R6500
    FRBOpcodeTypeBBS1, // W65C02S and R6500
    FRBOpcodeTypeBBS2, // W65C02S and R6500
    FRBOpcodeTypeBBS3, // W65C02S and R6500
    FRBOpcodeTypeBBS4, // W65C02S and R6500
    FRBOpcodeTypeBBS5, // W65C02S and R6500
    FRBOpcodeTypeBBS6, // W65C02S and R6500
    FRBOpcodeTypeBBS7, // W65C02S and R6500
    FRBOpcodeTypeBCC,
    FRBOpcodeTypeBCS,
    FRBOpcodeTypeBEQ,
    FRBOpcodeTypeBIT,
    FRBOpcodeTypeBMI,
    FRBOpcodeTypeBNE,
    FRBOpcodeTypeBPL,
    FRBOpcodeTypeBRA,  // Generic 65C02, W65C02S, and R6500
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
    FRBOpcodeTypePHX,  // Generic 65C02, W65C02S, and R6500
    FRBOpcodeTypePHY,  // Generic 65C02, W65C02S, and R6500
    FRBOpcodeTypePLA,
    FRBOpcodeTypePLP,
    FRBOpcodeTypePLX,  // Generic 65C02, W65C02S, and R6500
    FRBOpcodeTypePLY,  // Generic 65C02, W65C02S, and R6500
    FRBOpcodeTypeRMB0, // W65C02S and R6500
    FRBOpcodeTypeRMB1, // W65C02S and R6500
    FRBOpcodeTypeRMB2, // W65C02S and R6500
    FRBOpcodeTypeRMB3, // W65C02S and R6500
    FRBOpcodeTypeRMB4, // W65C02S and R6500
    FRBOpcodeTypeRMB5, // W65C02S and R6500
    FRBOpcodeTypeRMB6, // W65C02S and R6500
    FRBOpcodeTypeRMB7, // W65C02S and R6500
    FRBOpcodeTypeROL,
    FRBOpcodeTypeROR,
    FRBOpcodeTypeRTI,
    FRBOpcodeTypeRTS,
    FRBOpcodeTypeSBC,
    FRBOpcodeTypeSEC,
    FRBOpcodeTypeSED,
    FRBOpcodeTypeSEI,
    FRBOpcodeTypeSMB0, // W65C02S and R6500
    FRBOpcodeTypeSMB1, // W65C02S and R6500
    FRBOpcodeTypeSMB2, // W65C02S and R6500
    FRBOpcodeTypeSMB3, // W65C02S and R6500
    FRBOpcodeTypeSMB4, // W65C02S and R6500
    FRBOpcodeTypeSMB5, // W65C02S and R6500
    FRBOpcodeTypeSMB6, // W65C02S and R6500
    FRBOpcodeTypeSMB7, // W65C02S and R6500
    FRBOpcodeTypeSTA,
    FRBOpcodeTypeSTP,  // W65C02S
    FRBOpcodeTypeSTX,
    FRBOpcodeTypeSTY,
    FRBOpcodeTypeSTZ,  // Generic 65C02, W65C02S, and R6500
    FRBOpcodeTypeTAX,
    FRBOpcodeTypeTAY,
    FRBOpcodeTypeTRB,  // Generic 65C02, W65C02S, and R6500
    FRBOpcodeTypeTSB,  // Generic 65C02, W65C02S, and R6500
    FRBOpcodeTypeTSX,
    FRBOpcodeTypeTXA,
    FRBOpcodeTypeTXS,
    FRBOpcodeTypeTYA,
    FRBOpcodeTypeWAI,  // W65C02S and R6500

    FRBOpcodeTypeUndocumented
};

static const size_t FRBUniqueOpcodesCount = 98;

struct FRBInstruction {
    FRBOpcodeType type;
    const char * const name;
    DisasmBranchType branchType;
    FRBOpcodeCategory category;
};

struct FRBOpcode {
    FRBOpcodeType type;
    FRBAddressMode addressMode;
};

static const struct FRBInstruction FRBInstructions[FRBUniqueOpcodesCount] = {
    { FRBOpcodeTypeADC, "ADC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic },
    { FRBOpcodeTypeAND, "AND", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { FRBOpcodeTypeASL, "ASL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { FRBOpcodeTypeBBR0, "BBR0", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBR1, "BBR1", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBR2, "BBR2", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBR3, "BBR3", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBR4, "BBR4", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBR5, "BBR5", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBR6, "BBR6", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBR7, "BBR7", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBS0, "BBS0", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBS1, "BBS1", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBS2, "BBS2", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBS3, "BBS3", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBS4, "BBS4", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBS5, "BBS5", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBS6, "BBS6", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBBS7, "BBS7", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches }, // :(
    { FRBOpcodeTypeBCC, "BCC", DISASM_BRANCH_JNC, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeBCS, "BCS", DISASM_BRANCH_JC, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeBEQ, "BEQ", DISASM_BRANCH_JE, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeBIT, "BIT", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { FRBOpcodeTypeBMI, "BMI", DISASM_BRANCH_JS, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeBNE, "BNE", DISASM_BRANCH_JNE, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeBPL, "BPL", DISASM_BRANCH_JNS, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeBRA, "BRA", DISASM_BRANCH_JMP, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeBRK, "BRK", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
    { FRBOpcodeTypeBVC, "BVC", DISASM_BRANCH_JNO, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeBVS, "BVS", DISASM_BRANCH_JO, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeCLC, "CLC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeCLD, "CLD", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeCLI, "CLI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeCLV, "CLV", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeCMP, "CMP", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison },
    { FRBOpcodeTypeCPX, "CPX", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison },
    { FRBOpcodeTypeCPY, "CPY", DISASM_BRANCH_NONE, FRBOpcodeCategoryComparison },
    { FRBOpcodeTypeDEC, "DEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { FRBOpcodeTypeDEX, "DEX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { FRBOpcodeTypeDEY, "DEY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { FRBOpcodeTypeEOR, "EOR", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { FRBOpcodeTypeINC, "INC", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { FRBOpcodeTypeINX, "INX", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { FRBOpcodeTypeINY, "INY", DISASM_BRANCH_NONE, FRBOpcodeCategoryIncrementDecrement },
    { FRBOpcodeTypeJMP, "JMP", DISASM_BRANCH_JMP, FRBOpcodeCategoryJumps },
    { FRBOpcodeTypeJSR, "JSR", DISASM_BRANCH_CALL, FRBOpcodeCategoryJumps },
    { FRBOpcodeTypeLDA, "LDA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad },
    { FRBOpcodeTypeLDX, "LDX", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad },
    { FRBOpcodeTypeLDY, "LDY", DISASM_BRANCH_NONE, FRBOpcodeCategoryLoad },
    { FRBOpcodeTypeLSR, "LSR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { FRBOpcodeTypeNOP, "NOP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
    { FRBOpcodeTypeORA, "ORA", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { FRBOpcodeTypePHA, "PHA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { FRBOpcodeTypePHP, "PHP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { FRBOpcodeTypePHX, "PHX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { FRBOpcodeTypePHY, "PHY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { FRBOpcodeTypePLA, "PLA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { FRBOpcodeTypePLP, "PLP", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { FRBOpcodeTypePLX, "PLX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { FRBOpcodeTypePLY, "PLY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStack },
    { FRBOpcodeTypeRMB0, "RMB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeRMB0, "RMB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeRMB0, "RMB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeRMB0, "RMB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeRMB0, "RMB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeRMB0, "RMB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeRMB0, "RMB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeRMB0, "RMB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeROL, "ROL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { FRBOpcodeTypeROR, "ROR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { FRBOpcodeTypeRTI, "RTI", DISASM_BRANCH_RET, FRBOpcodeCategorySystem },
    { FRBOpcodeTypeRTS, "RTS", DISASM_BRANCH_RET, FRBOpcodeCategorySystem },
    { FRBOpcodeTypeSBC, "SBC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic },
    { FRBOpcodeTypeSEC, "SEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeSED, "SED", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeSEI, "SEI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeSMB0, "SMB0", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSMB0, "SMB1", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSMB0, "SMB2", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSMB0, "SMB3", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSMB0, "SMB4", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSMB0, "SMB5", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSMB0, "SMB6", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSMB0, "SMB7", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSTA, "STA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSTP, "STP", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
    { FRBOpcodeTypeSTX, "STX", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSTY, "STY", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeSTZ, "STZ", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
    { FRBOpcodeTypeTAX, "TAX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { FRBOpcodeTypeTAY, "TAY", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { FRBOpcodeTypeTRB, "TRB", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { FRBOpcodeTypeTSB, "TSB", DISASM_BRANCH_NONE, FRBOpcodeCategoryLogical },
    { FRBOpcodeTypeTSX, "TSX", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { FRBOpcodeTypeTXA, "TXA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { FRBOpcodeTypeTXS, "TXS", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { FRBOpcodeTypeTYA, "TYA", DISASM_BRANCH_NONE, FRBOpcodeCategoryRegisterTransfers },
    { FRBOpcodeTypeWAI, "WAI", DISASM_BRANCH_NONE, FRBOpcodeCategorySystem },
};

#endif
