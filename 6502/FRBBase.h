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

/*! 6502 Address modes */
typedef NS_ENUM(NSUInteger, FRBAddressMode) {
    /*! Unknown address mode, used for undocumented opcodes */
    FRBAddressModeUnknown = 0,

    /*! Absolute addressing: $HHLL */
    FRBAddressModeAbsolute,

    /*! Absolute X-Indexed addressing: $HHLL,X */
    FRBAddressModeAbsoluteXIndexed,

    /*! Absolute Y-Indexed addressing: $HHLL,Y */
    FRBAddressModeAbsoluteYIndexed,

    /*! Immediate addressing: #$LL */
    FRBAddressModeImmediate,

    /*! Implied addressing: no operands */
    FRBAddressModeImplied,

    /*! Indirect addressing: ($HHLL) */
    FRBAddressModeIndirect,

    /*! Indirect X-Indexed addressing: ($LL,X) */
    FRBAddressModeIndirectXIndexed,

    /*! Indirect Y-Indexed addressing: ($LL),Y */
    FRBAddressModeIndirectYIndexed,

    /*! Relative addressing: $LL */
    FRBAddressModeRelative,

    /*! Zeropage addressing: $LL */
    FRBAddressModeZeropage,

    /*! Zeropage X-Indexed addressing: $LL,X */
    FRBAddressModeZeropageXIndexed,

    /*! Zeropage Y-Indexed addressing: $LL,Y */
    FRBAddressModeZeropageYIndexed,

    /*! Zeropage Indirect addressing: ($LL) */
    FRBAddressModeZeropageIndirect, // Generic 65C02

    /*! Absolute Indirect X-Indexed addressing: ($HHLL,X) */
    FRBAddressModeAbsoluteIndirectXIndexed, // Generic 65C02
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
    FRBOpcodeTypeBCC,
    FRBOpcodeTypeBCS,
    FRBOpcodeTypeBEQ,
    FRBOpcodeTypeBIT,
    FRBOpcodeTypeBMI,
    FRBOpcodeTypeBNE,
    FRBOpcodeTypeBPL,
    FRBOpcodeTypeBRA, // Generic 65C02
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
    FRBOpcodeTypePHX, // Generic 65C02
    FRBOpcodeTypePHY, // Generic 65C02
    FRBOpcodeTypePLA,
    FRBOpcodeTypePLP,
    FRBOpcodeTypePLX, // Generic 65C02
    FRBOpcodeTypePLY, // Generic 65C02
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
    FRBOpcodeTypeSTZ, // Generic 65C02
    FRBOpcodeTypeTAX,
    FRBOpcodeTypeTAY,
    FRBOpcodeTypeTRB, // Generic 65C02
    FRBOpcodeTypeTSB, // Generic 65C02
    FRBOpcodeTypeTSX,
    FRBOpcodeTypeTXA,
    FRBOpcodeTypeTXS,
    FRBOpcodeTypeTYA,

    FRBOpcodeTypeUndocumented
};

static const size_t FRBUniqueOpcodesCount = 64;

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
    { FRBOpcodeTypeJMP, "JMP", DISASM_BRANCH_JMP, FRBOpcodeCategoryBranches },
    { FRBOpcodeTypeJSR, "JSR", DISASM_BRANCH_CALL, FRBOpcodeCategoryBranches },
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
    { FRBOpcodeTypeROL, "ROL", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { FRBOpcodeTypeROR, "ROR", DISASM_BRANCH_NONE, FRBOpcodeCategoryShifts },
    { FRBOpcodeTypeRTI, "RTI", DISASM_BRANCH_RET, FRBOpcodeCategorySystem },
    { FRBOpcodeTypeRTS, "RTS", DISASM_BRANCH_RET, FRBOpcodeCategorySystem },
    { FRBOpcodeTypeSBC, "SBC", DISASM_BRANCH_NONE, FRBOpcodeCategoryArithmetic },
    { FRBOpcodeTypeSEC, "SEC", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeSED, "SED", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeSEI, "SEI", DISASM_BRANCH_NONE, FRBOpcodeCategoryStatusFlagChanges },
    { FRBOpcodeTypeSTA, "STA", DISASM_BRANCH_NONE, FRBOpcodeCategoryStore },
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
};

#endif
