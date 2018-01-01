/*
 Copyright (c) 2014-2018, Alessandro Gatti - frob.it
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

/**
 * Address modes.
 */
typedef NS_ENUM(NSUInteger, Mode) {
  ModeAbsolute = 0,
  ModeAbsoluteIndexedX,
  ModeAbsoluteIndexedY,
  ModeAbsoluteLong,
  ModeAbsoluteLongIndexed,
  ModeAbsoluteBitAddressing,
  ModeAbsoluteMemoryAddress,
  ModeAbsoluteMemoryAddressIndexed,
  ModeImmediate,
  ModeAccumulator,
  ModeImplied,
  ModeStack,
  ModeAbsoluteIndirect,
  ModeProgramCounterRelative,
  ModeProgramCounterRelativeLong,
  ModeDirect,
  ModeDirectBitAddressing,
  ModeDirectBitAddressingProgramCounterRelative,
  ModeDirectBitAddressingAbsolute,
  ModeDirectMemoryAccess,
  ModeDirectMemoryAccessIndexed,
  ModeDirectIndexedX,
  ModeDirectIndexedY,
  ModeDirectIndexedIndirect,
  ModeDirectIndirectIndexedY,
  ModeDirectIndirect,
  ModeDirectIndirectLong,
  ModeDirectIndirectLongIndexed,
  ModeAbsoluteIndexedIndirect,
  ModeStackRelative,
  ModeStackRelativeIndirectIndexed,
  ModeBlockMove,

  ModeUnknown
};

static const size_t kAddressModesCount = ModeUnknown;

static const size_t kOpcodeLength[kAddressModesCount] = {
    3, 3, 3, 4, 4, 4, 4, 4, 2, 1, 1, 1, 3, 2, 3, 2,
    3, 4, 5, 3, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 3};

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

typedef NS_ENUM(NSUInteger, OpcodeType) {
  OpcodeADC = 0,
  OpcodeAND,
  OpcodeASL,
  OpcodeBBC, // M7700
  OpcodeBBS, // M7700
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
  OpcodeCLB, // M7700
  OpcodeCLC,
  OpcodeCLD,
  OpcodeCLI,
  OpcodeCLM, // M7700
  OpcodeCLP, // M7700
  OpcodeCLV,
  OpcodeCMP,
  OpcodeCOP,
  OpcodeCPX,
  OpcodeCPY,
  OpcodeDEC,
  OpcodeDEX,
  OpcodeDEY,
  OpcodeDIV, // M7700
  OpcodeEOR,
  OpcodeINC,
  OpcodeINX,
  OpcodeINY,
  OpcodeJML,
  OpcodeJMP,
  OpcodeJSL,
  OpcodeJSR,
  OpcodeLDA,
  OpcodeLDM, // M7700
  OpcodeLDT, // M7700
  OpcodeLDX,
  OpcodeLDY,
  OpcodeLSR,
  OpcodeMPY, // M7700
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
  OpcodePHG, // M7700
  OpcodePHK,
  OpcodePHP,
  OpcodePHT, // M7700
  OpcodePHX,
  OpcodePHY,
  OpcodePLA,
  OpcodePLB,
  OpcodePLD,
  OpcodePLP,
  OpcodePLT, // M7700
  OpcodePLX,
  OpcodePLY,
  OpcodePSH, // M7700
  OpcodePUL, // M7700
  OpcodeREP,
  OpcodeRLA, // M7700
  OpcodeROL,
  OpcodeROR,
  OpcodeRTI,
  OpcodeRTL,
  OpcodeRTS,
  OpcodeSBC,
  OpcodeSEB, // M7700
  OpcodeSEC,
  OpcodeSED,
  OpcodeSEI,
  OpcodeSEM, // M7700
  OpcodeSEP,
  OpcodeSTA,
  OpcodeSTP,
  OpcodeSTX,
  OpcodeSTY,
  OpcodeSTZ,
  OpcodeTAD, // M7700
  OpcodeTAS, // M7700
  OpcodeTAX,
  OpcodeTAY,
  OpcodeTBD, // M7700
  OpcodeTBS, // M7700
  OpcodeTBX, // M7700
  OpcodeTBY, // M7700
  OpcodeTCD,
  OpcodeTCS,
  OpcodeTDA, // M7700
  OpcodeTDB, // M7700
  OpcodeTDC,
  OpcodeTRB,
  OpcodeTSA, // M7700
  OpcodeTSB,
  OpcodeTSC,
  OpcodeTSX,
  OpcodeTXA,
  OpcodeTXB, // M7700
  OpcodeTXS,
  OpcodeTXY,
  OpcodeTYA,
  OpcodeTYB,
  OpcodeTYX,
  OpcodeWAI, // 65816
  OpcodeWDM, // 65816
  OpcodeWIT, // M7700
  OpcodeXAB, // M7700
  OpcodeXBA, // 65816
  OpcodeXCE,

  OpcodeUndocumented
};

static const size_t kOpcodesCount = OpcodeUndocumented;

typedef NS_ENUM(NSUInteger, Registers) {
  RegisterA = 0,
  RegisterX,
  RegisterY,
  RegisterS,
};

typedef NS_OPTIONS(NSUInteger, RegisterMask) {
  RegisterNone = 0,
  RegisterAccumulator = 1 << RegisterA,
  RegisterIndexX = 1 << RegisterX,
  RegisterIndexY = 1 << RegisterY,
  RegisterDataBank = 1 << 3,
  RegisterDirect = 1 << 4,
  RegisterStack = 1 << RegisterS,
  RegisterProcessorState = 1 << 6,
  RegisterProgramBank = 1 << 7,
  RegisterB = 1 << 8,
  RegisterC = 1 << 9,
};

#define N RegisterNone
#define A RegisterAccumulator
#define X RegisterIndexX
#define Y RegisterIndexY
#define S RegisterStack
#define D RegisterDirect
#define P RegisterProcessorState
#define DBR RegisterDataBank
#define PBR RegisterProgramBank
#define B RegisterB
#define C RegisterC

typedef struct {
  const char *const name;
  DisasmBranchType branchType;
  Category category;
} Instruction;

typedef NS_ENUM(NSUInteger, AccumulatorType) {
  AccumulatorDefault = 0,
  AccumulatorA,
  AccumulatorB
};

typedef struct {
  OpcodeType type;
  Mode addressMode;
  RegisterMask readRegisters;
  RegisterMask writtenRegisters;
  AccumulatorType accumulatorType;
} Opcode;

static const Instruction kMnemonics[kOpcodesCount] = {
    {"ADC", DISASM_BRANCH_NONE, CategoryArithmetic},
    {"AND", DISASM_BRANCH_NONE, CategoryLogical},
    {"ASL", DISASM_BRANCH_NONE, CategoryShifts},
    {"BBC", DISASM_BRANCH_JE, CategoryBranches},
    {"BBS", DISASM_BRANCH_JNE, CategoryBranches},
    {"BCC", DISASM_BRANCH_JNC, CategoryBranches},
    {"BCS", DISASM_BRANCH_JC, CategoryBranches},
    {"BEQ", DISASM_BRANCH_JE, CategoryBranches},
    {"BIT", DISASM_BRANCH_NONE, CategoryLogical},
    {"BMI", DISASM_BRANCH_JS, CategoryBranches},
    {"BNE", DISASM_BRANCH_JNE, CategoryBranches},
    {"BPL", DISASM_BRANCH_JNS, CategoryBranches},
    {"BRA", DISASM_BRANCH_JMP, CategoryBranches},
    {"BRK", DISASM_BRANCH_NONE, CategorySystem},
    {"BRL", DISASM_BRANCH_JMP, CategoryJumps},
    {"BVC", DISASM_BRANCH_JNO, CategoryBranches},
    {"BVS", DISASM_BRANCH_JO, CategoryBranches},
    {"CLB", DISASM_BRANCH_NONE, CategoryLogical},
    {"CLC", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"CLD", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"CLI", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"CLM", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"CLP", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"CLV", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"CMP", DISASM_BRANCH_NONE, CategoryComparison},
    {"COP", DISASM_BRANCH_NONE, CategorySystem},
    {"CPX", DISASM_BRANCH_NONE, CategoryComparison},
    {"CPY", DISASM_BRANCH_NONE, CategoryComparison},
    {"DEC", DISASM_BRANCH_NONE, CategoryIncrementDecrement},
    {"DEX", DISASM_BRANCH_NONE, CategoryIncrementDecrement},
    {"DEY", DISASM_BRANCH_NONE, CategoryIncrementDecrement},
    {"DIV", DISASM_BRANCH_NONE, CategoryArithmetic},
    {"EOR", DISASM_BRANCH_NONE, CategoryLogical},
    {"INC", DISASM_BRANCH_NONE, CategoryIncrementDecrement},
    {"INX", DISASM_BRANCH_NONE, CategoryIncrementDecrement},
    {"INY", DISASM_BRANCH_NONE, CategoryIncrementDecrement},
    {"JML", DISASM_BRANCH_JMP, CategoryJumps},
    {"JMP", DISASM_BRANCH_JMP, CategoryJumps},
    {"JSL", DISASM_BRANCH_CALL, CategoryJumps},
    {"JSR", DISASM_BRANCH_CALL, CategoryJumps},
    {"LDA", DISASM_BRANCH_NONE, CategoryLoad},
    {"LDM", DISASM_BRANCH_NONE, CategoryLoad},
    {"LDT", DISASM_BRANCH_NONE, CategoryLoad},
    {"LDX", DISASM_BRANCH_NONE, CategoryLoad},
    {"LDY", DISASM_BRANCH_NONE, CategoryLoad},
    {"LSR", DISASM_BRANCH_NONE, CategoryShifts},
    {"MPY", DISASM_BRANCH_NONE, CategoryArithmetic},
    {"MVN", DISASM_BRANCH_NONE, CategoryBlockTransfer},
    {"MVP", DISASM_BRANCH_NONE, CategoryBlockTransfer},
    {"NOP", DISASM_BRANCH_NONE, CategorySystem},
    {"ORA", DISASM_BRANCH_NONE, CategoryLogical},
    {"PEA", DISASM_BRANCH_NONE, CategoryStack},
    {"PEI", DISASM_BRANCH_NONE, CategoryStack},
    {"PER", DISASM_BRANCH_NONE, CategoryStack},
    {"PHA", DISASM_BRANCH_NONE, CategoryStack},
    {"PHB", DISASM_BRANCH_NONE, CategoryStack},
    {"PHD", DISASM_BRANCH_NONE, CategoryStack},
    {"PHG", DISASM_BRANCH_NONE, CategoryStack},
    {"PHK", DISASM_BRANCH_NONE, CategoryStack},
    {"PHP", DISASM_BRANCH_NONE, CategoryStack},
    {"PHT", DISASM_BRANCH_NONE, CategoryStack},
    {"PHX", DISASM_BRANCH_NONE, CategoryStack},
    {"PHY", DISASM_BRANCH_NONE, CategoryStack},
    {"PLA", DISASM_BRANCH_NONE, CategoryStack},
    {"PLB", DISASM_BRANCH_NONE, CategoryStack},
    {"PLD", DISASM_BRANCH_NONE, CategoryStack},
    {"PLP", DISASM_BRANCH_NONE, CategoryStack},
    {"PLT", DISASM_BRANCH_NONE, CategoryStack},
    {"PLX", DISASM_BRANCH_NONE, CategoryStack},
    {"PLY", DISASM_BRANCH_NONE, CategoryStack},
    {"PSH", DISASM_BRANCH_NONE, CategoryStack},
    {"PUL", DISASM_BRANCH_NONE, CategoryStack},
    {"REP", DISASM_BRANCH_NONE, CategorySystem},
    {"RLA", DISASM_BRANCH_NONE, CategoryShifts},
    {"ROL", DISASM_BRANCH_NONE, CategoryShifts},
    {"ROR", DISASM_BRANCH_NONE, CategoryShifts},
    {"RTI", DISASM_BRANCH_RET, CategorySystem},
    {"RTL", DISASM_BRANCH_RET, CategorySystem},
    {"RTS", DISASM_BRANCH_RET, CategorySystem},
    {"SBC", DISASM_BRANCH_NONE, CategoryArithmetic},
    {"SEB", DISASM_BRANCH_NONE, CategoryLogical},
    {"SEC", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"SED", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"SEI", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"SEM", DISASM_BRANCH_NONE, CategoryStatusFlagChanges},
    {"SEP", DISASM_BRANCH_NONE, CategorySystem},
    {"STA", DISASM_BRANCH_NONE, CategoryStore},
    {"STP", DISASM_BRANCH_NONE, CategorySystem},
    {"STX", DISASM_BRANCH_NONE, CategoryStore},
    {"STY", DISASM_BRANCH_NONE, CategoryStore},
    {"STZ", DISASM_BRANCH_NONE, CategoryStore},
    {"TAD", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TAS", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TAX", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TAY", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TBD", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TBS", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TBX", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TBY", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TCD", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TCS", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TDA", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TDB", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TDC", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TRB", DISASM_BRANCH_NONE, CategoryLogical},
    {"TSA", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TSB", DISASM_BRANCH_NONE, CategoryLogical},
    {"TSC", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TSX", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TXA", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TXB", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TXS", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TXY", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TYA", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TYB", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"TYX", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"WAI", DISASM_BRANCH_NONE, CategorySystem},
    {"WDM", DISASM_BRANCH_NONE, CategorySystem},
    {"WIT", DISASM_BRANCH_NONE, CategorySystem},
    {"XAB", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"XBA", DISASM_BRANCH_NONE, CategoryRegisterTransfers},
    {"XCE", DISASM_BRANCH_NONE, CategorySystem}};
