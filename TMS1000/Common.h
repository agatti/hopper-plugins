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

#import "Hopper/Hopper.h"

typedef NS_ENUM(NSUInteger, RegisterType) {
  RegisterA = 0,
  RegisterO,
  RegisterPB,
  RegisterX,
  RegisterY,
};

typedef NS_OPTIONS(NSUInteger, RegisterTypeMask) {
  RegisterMaskNone = 0,
  RegisterMaskA = 1 << RegisterA,
  RegisterMaskO = 1 << RegisterO,
  RegisterMaskPB = 1 << RegisterPB,
  RegisterMaskX = 1 << RegisterX,
  RegisterMaskY = 1 << RegisterY,
};

#define A RegisterMaskA
#define O RegisterMaskO
#define PB RegisterMaskPB
#define X RegisterMaskX
#define Y RegisterMaskY
#define N RegisterMaskNone

typedef NS_ENUM(NSUInteger, InstructionEncoding) {
  InstructionEncodingI,
  InstructionEncodingII,
  InstructionEncodingIII,
  InstructionEncodingIV,
  InstructionEncodingV
};

typedef NS_ENUM(NSUInteger, OpcodeType) {
  OpcodeA10AAC = 0,
  OpcodeA11AAC,
  OpcodeA12AAC,
  OpcodeA13AAC,
  OpcodeA14AAC,
  OpcodeA2AAC,
  OpcodeA3AAC,
  OpcodeA4AAC,
  OpcodeA5AAC,
  OpcodeA6AAC,
  OpcodeA7AAC,
  OpcodeA8AAC,
  OpcodeA9AAC,
  OpcodeALEC,
  OpcodeALEM,
  OpcodeAMAAC,
  OpcodeBR,
  OpcodeCALL,
  OpcodeCLA,
  OpcodeCLO,
  OpcodeCOMC,
  OpcodeCOMX,
  OpcodeCPAIZ,
  OpcodeDAN,
  OpcodeDMAN,
  OpcodeDYN,
  OpcodeIA,
  OpcodeIAC,
  OpcodeIMAC,
  OpcodeIYC,
  OpcodeKNEZ,
  OpcodeLDP,
  OpcodeLDX,
  OpcodeMNEA,
  OpcodeMNEZ,
  OpcodeRBIT,
  OpcodeRETN,
  OpcodeRSTR,
  OpcodeSAMAN,
  OpcodeSBIT,
  OpcodeSETR,
  OpcodeTAM,
  OpcodeTAMDYN,
  OpcodeTAMIY,
  OpcodeTAMIYC,
  OpcodeTAMZA,
  OpcodeTAY,
  OpcodeTBIT1,
  OpcodeTCMIY,
  OpcodeTCY,
  OpcodeTDO,
  OpcodeTKA,
  OpcodeTMA,
  OpcodeTMY,
  OpcodeTYA,
  OpcodeXMA,
  OpcodeYNEA,
  OpcodeYNEC
};

typedef struct {
  OpcodeType opcode;
  const char *name;
  NSUInteger readRegisters;
  NSUInteger writtenRegisters;
  DisasmBranchType branchType;
} Opcode;

typedef struct {
  OpcodeType opcode;
  InstructionEncoding encoding;
} Instruction;

static const Opcode kMnemonics[] = {
    {OpcodeA10AAC, "A10AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA11AAC, "A11AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA12AAC, "A12AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA13AAC, "A13AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA14AAC, "A14AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA2AAC, "A2AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA3AAC, "A3AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA4AAC, "A4AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA5AAC, "A5AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA6AAC, "A6AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA7AAC, "A7AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA8AAC, "A8AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeA9AAC, "A9AAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeALEC, "ALEC", A, N, DISASM_BRANCH_NONE},
    {OpcodeALEM, "ALEM", A | X | Y, N, DISASM_BRANCH_NONE},
    {OpcodeAMAAC, "AMAAC", A | X | Y, A, DISASM_BRANCH_NONE},
    {OpcodeBR, "BR", PB, PB, DISASM_BRANCH_JMP},
    {OpcodeCALL, "CALL", PB, PB, DISASM_BRANCH_CALL},
    {OpcodeCLA, "CLA", N, A, DISASM_BRANCH_NONE},
    {OpcodeCLO, "CLO", N, O, DISASM_BRANCH_NONE},
    {OpcodeCOMC, "COMC", N, N, DISASM_BRANCH_NONE},
    {OpcodeCOMX, "COMX", X, X, DISASM_BRANCH_NONE},
    {OpcodeCPAIZ, "CPAIZ", A, A, DISASM_BRANCH_NONE},
    {OpcodeDAN, "DAN", A, A, DISASM_BRANCH_NONE},
    {OpcodeDMAN, "DMAN", X | Y, A, DISASM_BRANCH_NONE},
    {OpcodeDYN, "DYN", Y, Y, DISASM_BRANCH_NONE},
    {OpcodeIA, "IA", A, A, DISASM_BRANCH_NONE},
    {OpcodeIAC, "IAC", A, A, DISASM_BRANCH_NONE},
    {OpcodeIMAC, "IMAC", A | X | Y, A, DISASM_BRANCH_NONE},
    {OpcodeIYC, "IYC", Y, Y, DISASM_BRANCH_NONE},
    {OpcodeKNEZ, "KNEZ", N, N, DISASM_BRANCH_NONE},
    {OpcodeLDP, "LDP", N, PB, DISASM_BRANCH_NONE},
    {OpcodeLDX, "LDX", N, X, DISASM_BRANCH_NONE},
    {OpcodeMNEA, "MNEA", A | X | Y, N, DISASM_BRANCH_NONE},
    {OpcodeMNEZ, "MNEZ", X | Y, N, DISASM_BRANCH_NONE},
    {OpcodeRBIT, "RBIT", X | Y, N, DISASM_BRANCH_NONE},
    {OpcodeRETN, "RETN", PB, N, DISASM_BRANCH_RET},
    {OpcodeRSTR, "RSTR", N, Y, DISASM_BRANCH_NONE},
    {OpcodeSAMAN, "SAMAN", A | X | Y, A, DISASM_BRANCH_NONE},
    {OpcodeSBIT, "SBIT", X | Y, N, DISASM_BRANCH_NONE},
    {OpcodeSETR, "SETR", N, Y, DISASM_BRANCH_NONE},
    {OpcodeTAM, "TAM", A | X | Y, N, DISASM_BRANCH_NONE},
    {OpcodeTAMDYN, "TAMDYN", A | X | Y, Y, DISASM_BRANCH_NONE},
    {OpcodeTAMIY, "TAMIY", A | X | Y, Y, DISASM_BRANCH_NONE},
    {OpcodeTAMIYC, "TAMIYC", A | X | Y, Y, DISASM_BRANCH_NONE},
    {OpcodeTAMZA, "TAMZA", A | X | Y, A, DISASM_BRANCH_NONE},
    {OpcodeTAY, "TAY", A, Y, DISASM_BRANCH_NONE},
    {OpcodeTBIT1, "TBIT1", X | Y, N, DISASM_BRANCH_NONE},
    {OpcodeTCMIY, "TCMIY", N, X | Y, DISASM_BRANCH_NONE},
    {OpcodeTCY, "TCY", N, Y, DISASM_BRANCH_NONE},
    {OpcodeTDO, "TDO", A, O, DISASM_BRANCH_NONE},
    {OpcodeTKA, "TKA", N, A, DISASM_BRANCH_NONE},
    {OpcodeTMA, "TMA", X | Y, A, DISASM_BRANCH_NONE},
    {OpcodeTMY, "TMY", X | Y, Y, DISASM_BRANCH_NONE},
    {OpcodeTYA, "TYA", Y, A, DISASM_BRANCH_NONE},
    {OpcodeXMA, "XMA", A | X, Y | A, DISASM_BRANCH_NONE},
    {OpcodeYNEA, "YNEA", A | Y, N, DISASM_BRANCH_NONE},
    {OpcodeYNEC, "YNEC", Y, N, DISASM_BRANCH_NONE}};
