/*
 Copyright (c) 2014-2017, Alessandro Gatti - frob.it
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

static NSString *const kSyntaxVariant = @"Generic";
static NSString *const kCPUMode = @"generic";

typedef NS_ENUM(NSUInteger, FRBRegisterType) {
  FRBRegisterA = 0,
  FRBRegisterO,
  FRBRegisterPB,
  FRBRegisterX,
  FRBRegisterY,
};

typedef NS_OPTIONS(NSUInteger, FRBRegisterTypeMask) {
  FRBRegisterMaskA = 1 << FRBRegisterA,
  FRBRegisterMaskO = 1 << FRBRegisterO,
  FRBRegisterMaskPB = 1 << FRBRegisterPB,
  FRBRegisterMaskX = 1 << FRBRegisterX,
  FRBRegisterMaskY = 1 << FRBRegisterY,
};

#define A FRBRegisterMaskA
#define O FRBRegisterMaskO
#define PB FRBRegisterMaskPB
#define X FRBRegisterMaskX
#define Y FRBRegisterMaskY
#define N 0

typedef NS_ENUM(NSUInteger, FRBInstructionEncoding) {
  FRBInstructionEncodingI,
  FRBInstructionEncodingII,
  FRBInstructionEncodingIII,
  FRBInstructionEncodingIV,
  FRBInstructionEncodingV
};

typedef NS_ENUM(NSUInteger, FRBOpcodeType) {
  FRBOpcodeTypeA10AAC = 0,
  FRBOpcodeTypeA11AAC,
  FRBOpcodeTypeA12AAC,
  FRBOpcodeTypeA13AAC,
  FRBOpcodeTypeA14AAC,
  FRBOpcodeTypeA2AAC,
  FRBOpcodeTypeA3AAC,
  FRBOpcodeTypeA4AAC,
  FRBOpcodeTypeA5AAC,
  FRBOpcodeTypeA6AAC,
  FRBOpcodeTypeA7AAC,
  FRBOpcodeTypeA8AAC,
  FRBOpcodeTypeA9AAC,
  FRBOpcodeTypeALEC,
  FRBOpcodeTypeALEM,
  FRBOpcodeTypeAMAAC,
  FRBOpcodeTypeBR,
  FRBOpcodeTypeCALL,
  FRBOpcodeTypeCLA,
  FRBOpcodeTypeCLO,
  FRBOpcodeTypeCOMC,
  FRBOpcodeTypeCOMX,
  FRBOpcodeTypeCPAIZ,
  FRBOpcodeTypeDAN,
  FRBOpcodeTypeDMAN,
  FRBOpcodeTypeDYN,
  FRBOpcodeTypeIA,
  FRBOpcodeTypeIAC,
  FRBOpcodeTypeIMAC,
  FRBOpcodeTypeIYC,
  FRBOpcodeTypeKNEZ,
  FRBOpcodeTypeLDP,
  FRBOpcodeTypeLDX,
  FRBOpcodeTypeMNEA,
  FRBOpcodeTypeMNEZ,
  FRBOpcodeTypeRBIT,
  FRBOpcodeTypeRETN,
  FRBOpcodeTypeRSTR,
  FRBOpcodeTypeSAMAN,
  FRBOpcodeTypeSBIT,
  FRBOpcodeTypeSETR,
  FRBOpcodeTypeTAM,
  FRBOpcodeTypeTAMDYN,
  FRBOpcodeTypeTAMIY,
  FRBOpcodeTypeTAMIYC,
  FRBOpcodeTypeTAMZA,
  FRBOpcodeTypeTAY,
  FRBOpcodeTypeTBIT1,
  FRBOpcodeTypeTCMIY,
  FRBOpcodeTypeTCY,
  FRBOpcodeTypeTDO,
  FRBOpcodeTypeTKA,
  FRBOpcodeTypeTMA,
  FRBOpcodeTypeTMY,
  FRBOpcodeTypeTYA,
  FRBOpcodeTypeXMA,
  FRBOpcodeTypeYNEA,
  FRBOpcodeTypeYNEC
};

typedef struct {
  FRBOpcodeType opcode;
  const char *name;
  NSUInteger readRegisters;
  NSUInteger writtenRegisters;
  DisasmBranchType branchType;
} FRBOpcode;

typedef struct {
  FRBOpcodeType opcode;
  FRBInstructionEncoding encoding;
} FRBInstruction;

static const FRBOpcode FRBOpcodes[] = {
    {FRBOpcodeTypeA10AAC, "A10AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA11AAC, "A11AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA12AAC, "A12AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA13AAC, "A13AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA14AAC, "A14AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA2AAC, "A2AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA3AAC, "A3AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA4AAC, "A4AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA5AAC, "A5AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA6AAC, "A6AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA7AAC, "A7AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA8AAC, "A8AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeA9AAC, "A9AAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeALEC, "ALEC", A, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeALEM, "ALEM", A | X | Y, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeAMAAC, "AMAAC", A | X | Y, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeBR, "BR", PB, PB, DISASM_BRANCH_JMP},
    {FRBOpcodeTypeCALL, "CALL", PB, PB, DISASM_BRANCH_CALL},
    {FRBOpcodeTypeCLA, "CLA", N, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeCLO, "CLO", N, O, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeCOMC, "COMC", N, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeCOMX, "COMX", X, X, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeCPAIZ, "CPAIZ", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeDAN, "DAN", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeDMAN, "DMAN", X | Y, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeDYN, "DYN", Y, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeIA, "IA", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeIAC, "IAC", A, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeIMAC, "IMAC", A | X | Y, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeIYC, "IYC", Y, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeKNEZ, "KNEZ", N, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeLDP, "LDP", N, PB, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeLDX, "LDX", N, X, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeMNEA, "MNEA", A | X | Y, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeMNEZ, "MNEZ", X | Y, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeRBIT, "RBIT", X | Y, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeRETN, "RETN", PB, N, DISASM_BRANCH_RET},
    {FRBOpcodeTypeRSTR, "RSTR", N, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeSAMAN, "SAMAN", A | X | Y, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeSBIT, "SBIT", X | Y, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeSETR, "SETR", N, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTAM, "TAM", A | X | Y, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTAMDYN, "TAMDYN", A | X | Y, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTAMIY, "TAMIY", A | X | Y, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTAMIYC, "TAMIYC", A | X | Y, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTAMZA, "TAMZA", A | X | Y, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTAY, "TAY", A, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTBIT1, "TBIT1", X | Y, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTCMIY, "TCMIY", N, X | Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTCY, "TCY", N, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTDO, "TDO", A, O, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTKA, "TKA", N, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTMA, "TMA", X | Y, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTMY, "TMY", X | Y, Y, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeTYA, "TYA", Y, A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeXMA, "XMA", A | X, Y | A, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeYNEA, "YNEA", A | Y, N, DISASM_BRANCH_NONE},
    {FRBOpcodeTypeYNEC, "YNEC", Y, N, DISASM_BRANCH_NONE}};
