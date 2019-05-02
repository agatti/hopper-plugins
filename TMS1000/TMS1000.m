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

#import "TMS1000.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Instruction kOpcodes[256];

@implementation TMS1000

+ (NSString *_Nonnull)family {
  return @"Texas Instruments";
}

+ (NSString *_Nonnull)model {
  return @"TMS1000";
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

static const Instruction kOpcodes[256] = {{OpcodeCOMX, InstructionEncodingIV},
                                          {OpcodeA8AAC, InstructionEncodingIV},
                                          {OpcodeYNEA, InstructionEncodingIV},
                                          {OpcodeTAM, InstructionEncodingIV},
                                          {OpcodeTAMZA, InstructionEncodingIV},
                                          {OpcodeA10AAC, InstructionEncodingIV},
                                          {OpcodeA6AAC, InstructionEncodingIV},
                                          {OpcodeDAN, InstructionEncodingIV},
                                          {OpcodeTKA, InstructionEncodingIV},
                                          {OpcodeKNEZ, InstructionEncodingIV},
                                          {OpcodeTDO, InstructionEncodingIV},
                                          {OpcodeCLO, InstructionEncodingIV},
                                          {OpcodeRSTR, InstructionEncodingIV},
                                          {OpcodeSETR, InstructionEncodingIV},
                                          {OpcodeIA, InstructionEncodingIV},
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

                                          {OpcodeTAMIY, InstructionEncodingIV},
                                          {OpcodeTMA, InstructionEncodingIV},
                                          {OpcodeTMY, InstructionEncodingIV},
                                          {OpcodeTYA, InstructionEncodingIV},
                                          {OpcodeTAY, InstructionEncodingIV},
                                          {OpcodeAMAAC, InstructionEncodingIV},
                                          {OpcodeMNEZ, InstructionEncodingIV},
                                          {OpcodeSAMAN, InstructionEncodingIV},
                                          {OpcodeIMAC, InstructionEncodingIV},
                                          {OpcodeALEM, InstructionEncodingIV},
                                          {OpcodeDMAN, InstructionEncodingIV},
                                          {OpcodeIYC, InstructionEncodingIV},
                                          {OpcodeDYN, InstructionEncodingIV},
                                          {OpcodeCPAIZ, InstructionEncodingIV},
                                          {OpcodeXMA, InstructionEncodingIV},
                                          {OpcodeCLA, InstructionEncodingIV},

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
                                          {OpcodeLDX, InstructionEncodingIII},
                                          {OpcodeLDX, InstructionEncodingIII},
                                          {OpcodeLDX, InstructionEncodingIII},
                                          {OpcodeLDX, InstructionEncodingIII},

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

                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},
                                          {OpcodeALEC, InstructionEncodingII},

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
