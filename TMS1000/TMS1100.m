/*
 Copyright (c) 2014-2020, Alessandro Gatti - frob.it
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

#import "TMS1100.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Instruction kOpcodes[256];

@implementation TMS1100

+ (NSString *_Nonnull)family {
  return @"Texas Instruments";
}

+ (NSString *_Nonnull)model {
  return @"TMS1100";
}

+ (BOOL)exported {
  return YES;
}

+ (int)addressSpaceWidth {
  return 16;
}

- (Instruction)instructionForByte:(uint8_t)byte {
  return kOpcodes[byte];
}

@end

static const Instruction kOpcodes[256] = {{OpcodeMNEA, InstructionEncodingIV},
                                          {OpcodeALEM, InstructionEncodingIV},
                                          {OpcodeYNEA, InstructionEncodingIV},
                                          {OpcodeXMA, InstructionEncodingIV},
                                          {OpcodeDYN, InstructionEncodingIV},
                                          {OpcodeIYC, InstructionEncodingIV},
                                          {OpcodeAMAAC, InstructionEncodingIV},
                                          {OpcodeDMAN, InstructionEncodingIV},
                                          {OpcodeTKA, InstructionEncodingIV},
                                          {OpcodeCOMX, InstructionEncodingIV},
                                          {OpcodeTDO, InstructionEncodingIV},
                                          {OpcodeCOMC, InstructionEncodingIV},
                                          {OpcodeRSTR, InstructionEncodingIV},
                                          {OpcodeSETR, InstructionEncodingIV},
                                          {OpcodeKNEZ, InstructionEncodingIV},
                                          {OpcodeRETN, InstructionEncodingIV},

                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},
                                          {OpcodeLDP, InstructionEncodingII},

                                          {OpcodeTAY, InstructionEncodingIV},
                                          {OpcodeTMA, InstructionEncodingIV},
                                          {OpcodeTMY, InstructionEncodingIV},
                                          {OpcodeTYA, InstructionEncodingIV},
                                          {OpcodeTAMDYN, InstructionEncodingIV},
                                          {OpcodeTAMIYC, InstructionEncodingIV},
                                          {OpcodeTAMZA, InstructionEncodingIV},
                                          {OpcodeTAM, InstructionEncodingIV},
                                          {OpcodeLDX, InstructionEncodingV},
                                          {OpcodeLDX, InstructionEncodingV},
                                          {OpcodeLDX, InstructionEncodingV},
                                          {OpcodeLDX, InstructionEncodingV},
                                          {OpcodeLDX, InstructionEncodingV},
                                          {OpcodeLDX, InstructionEncodingV},
                                          {OpcodeLDX, InstructionEncodingV},
                                          {OpcodeLDX, InstructionEncodingV},

                                          {OpcodeSBIT, InstructionEncodingIII},
                                          {OpcodeSBIT, InstructionEncodingIII},
                                          {OpcodeSBIT, InstructionEncodingIII},
                                          {OpcodeSBIT, InstructionEncodingIII},
                                          {OpcodeRBIT, InstructionEncodingIII},
                                          {OpcodeRBIT, InstructionEncodingIII},
                                          {OpcodeRBIT, InstructionEncodingIII},
                                          {OpcodeRBIT, InstructionEncodingIII},
                                          {OpcodeTBIT1, InstructionEncodingIII},
                                          {OpcodeTBIT1, InstructionEncodingIII},
                                          {OpcodeTBIT1, InstructionEncodingIII},
                                          {OpcodeTBIT1, InstructionEncodingIII},
                                          {OpcodeSAMAN, InstructionEncodingIV},
                                          {OpcodeCPAIZ, InstructionEncodingIV},
                                          {OpcodeIMAC, InstructionEncodingIV},
                                          {OpcodeMNEZ, InstructionEncodingIV},

                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},
                                          {OpcodeTCY, InstructionEncodingII},

                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},
                                          {OpcodeYNEC, InstructionEncodingII},

                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},
                                          {OpcodeTCMIY, InstructionEncodingII},

                                          {OpcodeIAC, InstructionEncodingIV},
                                          {OpcodeA9AAC, InstructionEncodingIV},
                                          {OpcodeA5AAC, InstructionEncodingIV},
                                          {OpcodeA13AAC, InstructionEncodingIV},
                                          {OpcodeA3AAC, InstructionEncodingIV},
                                          {OpcodeA11AAC, InstructionEncodingIV},
                                          {OpcodeA7AAC, InstructionEncodingIV},
                                          {OpcodeDAN, InstructionEncodingIV},
                                          {OpcodeA2AAC, InstructionEncodingIV},
                                          {OpcodeA10AAC, InstructionEncodingIV},
                                          {OpcodeA6AAC, InstructionEncodingIV},
                                          {OpcodeA14AAC, InstructionEncodingIV},
                                          {OpcodeA4AAC, InstructionEncodingIV},
                                          {OpcodeA12AAC, InstructionEncodingIV},
                                          {OpcodeA8AAC, InstructionEncodingIV},
                                          {OpcodeCLA, InstructionEncodingIV},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeBR, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI},
                                          {OpcodeCALL, InstructionEncodingI}};

#pragma clang diagnostic pop
