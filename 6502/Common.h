/*
 Copyright (c) 2014-2019, Alessandro Gatti - frob.it
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

#import <Hopper/Hopper.h>

/**
 * Address modes.
 */
typedef NS_ENUM(NSUInteger, Mode) {
  ModeAbsolute = 0,
  ModeAbsoluteIndexedX,
  ModeAbsoluteIndexedY,
  ModeImmediate,
  ModeAccumulator,
  ModeImplied,
  ModeStack,
  ModeAbsoluteIndirect,
  ModeProgramCounterRelative,
  ModeZeroPage,
  ModeZeroPageIndexedX,
  ModeZeroPageIndexedY,
  ModeZeroPageIndexedIndirect,
  ModeZeroPageIndirectIndexedY,
  ModeZeroPageIndirect,
  ModeAbsoluteIndexedIndirect,
  ModeZeroPageProgramCounterRelative,
  ModeBlockTransfer,
  ModeImmediateZeroPage,
  ModeImmediateZeroPageX,
  ModeImmediateAbsolute,
  ModeImmediateAbsoluteX,
  ModeZeroPageIndirectIndexedX,
  ModeBitsProgramCounterAbsolute,
  ModeSpecialPage,
  ModeAccumulatorBitRelative,
  ModeZeroPageBitRelative,
  ModeZeroPageBit,
  ModeAccumulatorBit,
  ModeDirectMemoryAccess,
  ModeUnknown
};

/**
 * Available address modes count.
 */
static const size_t kAddressModesCount = ModeUnknown;

/**
 * Opcode length, in bytes, for each address mode.
 */
static const size_t kOpcodeLengths[kAddressModesCount] = {
    3, 3, 3, 2, 1, 1, 1, 3, 2, 2, 2, 2, 2, 2, 2,
    3, 3, 7, 3, 3, 4, 4, 2, 5, 2, 2, 3, 2, 1, 3};

/**
 * Opcode categories
 */
typedef NS_ENUM(NSUInteger, OpcodeCategory) {
  OpcodeCategorySystem,
  OpcodeCategoryLoad,
  OpcodeCategoryStore,
  OpcodeCategoryRegisterTransfers,
  OpcodeCategoryStack,
  OpcodeCategoryLogical,
  OpcodeCategoryComparison,
  OpcodeCategoryArithmetic,
  OpcodeCategoryIncrementDecrement,
  OpcodeCategoryShifts,
  OpcodeCategoryJumps,
  OpcodeCategoryBranches,
  OpcodeCategoryStatusFlagChanges,
  OpcodeCategoryBlockTransfer
};

/**
 * Opcodes.
 */
typedef NS_ENUM(NSUInteger, OpcodeType) {
  OpcodeADC = 0,
  OpcodeADD, // R65C19
  OpcodeAHX, // MOS6510
  OpcodeALR, // MOS6510
  OpcodeANC, // MOS6510
  OpcodeAND,
  OpcodeARR, // MOS6510
  OpcodeASL,
  OpcodeASR,  // R65C19
  OpcodeAXS,  // MOS6510
  OpcodeBAR,  // R65C19
  OpcodeBAS,  // R65C19
  OpcodeBBC,  // M740 and M37450
  OpcodeBBR0, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBR1, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBR2, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBR3, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBR4, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBR5, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBR6, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBR7, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBS,  // M740 and M37450
  OpcodeBBS0, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBS1, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBS2, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBS3, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBS4, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBS5, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBS6, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBBS7, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeBCC,
  OpcodeBCS,
  OpcodeBEQ,
  OpcodeBIT,
  OpcodeBMI,
  OpcodeBNE,
  OpcodeBPL,
  OpcodeBRA, // 65C02, W65C02S, R6500, R65C19, and Hu6280
  OpcodeBRK,
  OpcodeBVC,
  OpcodeBVS,
  OpcodeCLA, // Hu6280
  OpcodeCLB, // M740 and M37450
  OpcodeCLC,
  OpcodeCLD,
  OpcodeCLI,
  OpcodeCLT, // M740 and M37450
  OpcodeCLV,
  OpcodeCLW, // R65C19
  OpcodeCLX, // Hu6280
  OpcodeCLY, // Hu6280
  OpcodeCMP,
  OpcodeCOM, // M740 and M37450
  OpcodeCPX,
  OpcodeCPY,
  OpcodeCSH, // Hu6280
  OpcodeCSL, // Hu6280
  OpcodeDCP, // MOS6510
  OpcodeDEC,
  OpcodeDEX,
  OpcodeDEY,
  OpcodeDIV, // M37450
  OpcodeEOR,
  OpcodeEXC, // R65C19
  OpcodeINC,
  OpcodeINI, // R65C19
  OpcodeINX,
  OpcodeINY,
  OpcodeISC, // MOS6510
  OpcodeJMP,
  OpcodeJPI,  // R65C19
  OpcodeJSB0, // R65C19
  OpcodeJSB1, // R65C19
  OpcodeJSB2, // R65C19
  OpcodeJSB3, // R65C19
  OpcodeJSB4, // R65C19
  OpcodeJSB5, // R65C19
  OpcodeJSB6, // R65C19
  OpcodeJSB7, // R65C19
  OpcodeJSR,
  OpcodeKIL, // MOS6510
  OpcodeLAB, // R65C19
  OpcodeLAI, // R65C19
  OpcodeLAN, // R65C19
  OpcodeLAS, // MOS6510
  OpcodeLAX, // MOS6510
  OpcodeLDA,
  OpcodeLDM, // M740 and M37450
  OpcodeLDX,
  OpcodeLDY,
  OpcodeLII, // R65C19
  OpcodeLSR,
  OpcodeMPA, // R65C19
  OpcodeMPY, // R65C19
  OpcodeMUL, // R65C29 and M37450
  OpcodeNEG, // R65C19
  OpcodeNOP,
  OpcodeNXT, // R65C19
  OpcodeORA,
  OpcodePHA,
  OpcodePHI, // R65C19
  OpcodePHP,
  OpcodePHW, // R65C19
  OpcodePHX, // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodePHY, // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodePIA, // R65C19
  OpcodePLA,
  OpcodePLI, // R65C19
  OpcodePLP,
  OpcodePLW,  // R65C19
  OpcodePLX,  // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodePLY,  // 65C02, W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodePSH,  // R65C19
  OpcodePUL,  // R65C19
  OpcodeRBA,  // R65C19
  OpcodeRLA,  // MOS6510
  OpcodeRMB0, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeRMB1, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeRMB2, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeRMB3, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeRMB4, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeRMB5, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeRMB6, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeRMB7, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeRND,  // R65C19
  OpcodeROL,
  OpcodeROR,
  OpcodeRRA, // MOS6510
  OpcodeRRF, // M740 and M37450
  OpcodeRTI,
  OpcodeRTS,
  OpcodeSAX, // Hu6280 and MOS6510
  OpcodeSAY, // Hu6280
  OpcodeSBA, // R65C19
  OpcodeSBC,
  OpcodeSEB, // M740 and M37450
  OpcodeSEC,
  OpcodeSED,
  OpcodeSEI,
  OpcodeSET,  // Hu6280
  OpcodeSHX,  // MOS6510
  OpcodeSHY,  // MOS6510
  OpcodeSLO,  // MOS6510
  OpcodeSMB0, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeSMB1, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeSMB2, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeSMB3, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeSMB4, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeSMB5, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeSMB6, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeSMB7, // W65C02S, R6500, R65C19, R65C29, and Hu6280
  OpcodeSRE,  // MOS6510
  OpcodeST0,  // Hu6280
  OpcodeST1,  // Hu6280
  OpcodeST2,  // Hu6280
  OpcodeSTA,
  OpcodeSTI, // R65C19
  OpcodeSTP, // W65C02S, M740, and M37450
  OpcodeSTX,
  OpcodeSTY,
  OpcodeSTZ, // 65C02, W65C02S, R6500, and Hu6280
  OpcodeSXY, // Hu6280
  OpcodeTAI, // Hu6280
  OpcodeTAM, // Hu6280
  OpcodeTAS, // MOS6510
  OpcodeTAW, // R65C19
  OpcodeTAX,
  OpcodeTAY,
  OpcodeTIP, // R65C19
  OpcodeTDD, // Hu6280
  OpcodeTIA, // Hu6280
  OpcodeTII, // Hu6280
  OpcodeTIN, // Hu6280
  OpcodeTMA, // Hu6280
  OpcodeTRB, // 65C02, W65C02S, R6500, and Hu6280
  OpcodeTSB, // 65C02, W65C02S, R6500, and Hu6280
  OpcodeTST, // Hu6280, M740, and M37450
  OpcodeTSX,
  OpcodeTWA, // R65C19
  OpcodeTXA,
  OpcodeTXS,
  OpcodeTYA,
  OpcodeWAI, // W65C02S
  OpcodeWIT, // M740 and M37450
  OpcodeXAA, // MOS6510

  OpcodeUndocumented
};

static const size_t kOpcodesCount = OpcodeUndocumented;

typedef NS_ENUM(NSUInteger, Registers) {
  RegisterA = 0,
  RegisterX,
  RegisterY,
  RegisterS,
  RegisterW,
  RegisterI,
  RegisterP
};

typedef NS_OPTIONS(NSUInteger, RegisterFlags) {
  RegisterFlagsNone = 0,
  RegisterFlagsA = 1 << RegisterA,
  RegisterFlagsX = 1 << RegisterX,
  RegisterFlagsY = 1 << RegisterY,
  RegisterFlagsS = 1 << RegisterS,
  RegisterFlagsW = 1 << RegisterW, // R65C19
  RegisterFlagsI = 1 << RegisterI, // R65C19
  RegisterFlagsP = 1 << RegisterP,
};

/**
 * CPU Instructions structure.
 */
typedef struct {
  const char *const name;
  DisasmBranchType branchType;
  OpcodeCategory category;
  BOOL haltsFlow;
} Mnemonic;

/**
 * CPU Opcodes table item structure.
 */
typedef struct {
  OpcodeType type;
  Mode addressMode;
  RegisterFlags readRegisters;
  RegisterFlags writtenRegisters;
} Opcode;

typedef struct {
  const Mnemonic *mnemonic;
  const Opcode *opcode;
} Instruction;

/**
 * Core-independent instruction lookup table
 */
static const Mnemonic kMnemonics[kOpcodesCount] = {
    {"ADC", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"ADD", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"AHX", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"ANC", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"AND", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"ALR", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"ARR", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"ASL", DISASM_BRANCH_NONE, OpcodeCategoryShifts, NO},
    {"ASR", DISASM_BRANCH_NONE, OpcodeCategoryShifts, NO},
    {"AXS", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"BAR", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BAS", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BBC", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BBR0", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BBR1", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BBR2", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BBR3", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BBR4", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BBR5", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BBR6", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BBR7", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BBS", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BBS0", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BBS1", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BBS2", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BBS3", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BBS4", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BBS5", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BBS6", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BBS7", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BCC", DISASM_BRANCH_JNC, OpcodeCategoryBranches, NO},
    {"BCS", DISASM_BRANCH_JC, OpcodeCategoryBranches, NO},
    {"BEQ", DISASM_BRANCH_JE, OpcodeCategoryBranches, NO},
    {"BIT", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"BMI", DISASM_BRANCH_JS, OpcodeCategoryBranches, NO},
    {"BNE", DISASM_BRANCH_JNE, OpcodeCategoryBranches, NO},
    {"BPL", DISASM_BRANCH_JNS, OpcodeCategoryBranches, NO},
    {"BRA", DISASM_BRANCH_JMP, OpcodeCategoryBranches, NO},
    {"BRK", DISASM_BRANCH_NONE, OpcodeCategorySystem, YES},
    {"BVC", DISASM_BRANCH_JNO, OpcodeCategoryBranches, NO},
    {"BVS", DISASM_BRANCH_JO, OpcodeCategoryBranches, NO},
    {"CLA", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"CLB", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"CLC", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"CLD", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"CLI", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"CLT", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"CLV", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"CLW", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"CLX", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"CLY", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"CMP", DISASM_BRANCH_NONE, OpcodeCategoryComparison, NO},
    {"COM", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"CPX", DISASM_BRANCH_NONE, OpcodeCategoryComparison, NO},
    {"CPY", DISASM_BRANCH_NONE, OpcodeCategoryComparison, NO},
    {"CSH", DISASM_BRANCH_NONE, OpcodeCategorySystem, NO},
    {"CSL", DISASM_BRANCH_NONE, OpcodeCategorySystem, NO},
    {"DCP", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"DEC", DISASM_BRANCH_NONE, OpcodeCategoryIncrementDecrement, NO},
    {"DEX", DISASM_BRANCH_NONE, OpcodeCategoryIncrementDecrement, NO},
    {"DEY", DISASM_BRANCH_NONE, OpcodeCategoryIncrementDecrement, NO},
    {"DIV", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"EOR", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"EXC", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"INC", DISASM_BRANCH_NONE, OpcodeCategoryIncrementDecrement, NO},
    {"INI", DISASM_BRANCH_NONE, OpcodeCategoryIncrementDecrement, NO},
    {"INX", DISASM_BRANCH_NONE, OpcodeCategoryIncrementDecrement, NO},
    {"INY", DISASM_BRANCH_NONE, OpcodeCategoryIncrementDecrement, NO},
    {"ISC", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"JMP", DISASM_BRANCH_JMP, OpcodeCategoryJumps, NO},
    {"JPI", DISASM_BRANCH_JMP, OpcodeCategoryJumps, NO},
    {"JSB0", DISASM_BRANCH_CALL, OpcodeCategoryJumps, NO},
    {"JSB1", DISASM_BRANCH_CALL, OpcodeCategoryJumps, NO},
    {"JSB2", DISASM_BRANCH_CALL, OpcodeCategoryJumps, NO},
    {"JSB3", DISASM_BRANCH_CALL, OpcodeCategoryJumps, NO},
    {"JSB4", DISASM_BRANCH_CALL, OpcodeCategoryJumps, NO},
    {"JSB5", DISASM_BRANCH_CALL, OpcodeCategoryJumps, NO},
    {"JSB6", DISASM_BRANCH_CALL, OpcodeCategoryJumps, NO},
    {"JSB7", DISASM_BRANCH_CALL, OpcodeCategoryJumps, NO},
    {"JSR", DISASM_BRANCH_CALL, OpcodeCategoryJumps, NO},
    {"KIL", DISASM_BRANCH_NONE, OpcodeCategorySystem, YES},
    {"LAB", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LAI", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LAN", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LAS", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LAX", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LDA", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LDM", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LDX", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LDY", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LII", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"LSR", DISASM_BRANCH_NONE, OpcodeCategoryShifts, NO},
    {"MPA", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"MPY", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"MUL", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"NEG", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"NOP", DISASM_BRANCH_NONE, OpcodeCategorySystem, NO},
    {"NXT", DISASM_BRANCH_NONE, OpcodeCategorySystem, NO},
    {"ORA", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"PHA", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PHI", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PHP", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PHW", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PHX", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PHY", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PIA", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PLA", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PLI", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PLP", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PLW", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PLX", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PLY", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PSH", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"PUL", DISASM_BRANCH_NONE, OpcodeCategoryStack, NO},
    {"RBA", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"RLA", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"RMB0", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"RMB1", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"RMB2", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"RMB3", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"RMB4", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"RMB5", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"RMB6", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"RMB7", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"RND", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"ROL", DISASM_BRANCH_NONE, OpcodeCategoryShifts, NO},
    {"ROR", DISASM_BRANCH_NONE, OpcodeCategoryShifts, NO},
    {"RRA", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"RRF", DISASM_BRANCH_NONE, OpcodeCategoryShifts, NO},
    {"RTI", DISASM_BRANCH_RET, OpcodeCategorySystem, NO},
    {"RTS", DISASM_BRANCH_RET, OpcodeCategorySystem, NO},
    {"SAX", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"SAY", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"SBA", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SBC", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"SEB", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"SEC", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"SED", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"SEI", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"SET", DISASM_BRANCH_NONE, OpcodeCategoryStatusFlagChanges, NO},
    {"SHX", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SHY", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SLO", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"SMB0", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SMB1", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SMB2", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SMB3", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SMB4", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SMB5", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SMB6", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SMB7", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SRE", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"ST0", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"ST1", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"ST2", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"STA", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"STI", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"STP", DISASM_BRANCH_NONE, OpcodeCategorySystem, YES},
    {"STX", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"STY", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"STZ", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"SXY", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"TAI", DISASM_BRANCH_NONE, OpcodeCategoryBlockTransfer, NO},
    {"TAM", DISASM_BRANCH_NONE, OpcodeCategoryStore, NO},
    {"TAS", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO},
    {"TAW", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"TAX", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"TAY", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"TIP", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"TDD", DISASM_BRANCH_NONE, OpcodeCategoryBlockTransfer, NO},
    {"TIA", DISASM_BRANCH_NONE, OpcodeCategoryBlockTransfer, NO},
    {"TII", DISASM_BRANCH_NONE, OpcodeCategoryBlockTransfer, NO},
    {"TIN", DISASM_BRANCH_NONE, OpcodeCategoryBlockTransfer, NO},
    {"TMA", DISASM_BRANCH_NONE, OpcodeCategoryLoad, NO},
    {"TRB", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"TSB", DISASM_BRANCH_NONE, OpcodeCategoryLogical, NO},
    {"TST", DISASM_BRANCH_NONE, OpcodeCategoryComparison, NO},
    {"TSX", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"TWA", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"TXA", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"TXS", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"TYA", DISASM_BRANCH_NONE, OpcodeCategoryRegisterTransfers, NO},
    {"WAI", DISASM_BRANCH_NONE, OpcodeCategorySystem, NO},
    {"WIT", DISASM_BRANCH_NONE, OpcodeCategorySystem, YES},
    {"XAA", DISASM_BRANCH_NONE, OpcodeCategoryArithmetic, NO}};
