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

#import "FRBTMS1100.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const FRBInstruction kOpcodes[256];

@implementation FRBTMS1100

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

- (FRBInstruction)instructionForByte:(uint8_t)byte {
  return kOpcodes[byte];
}

@end

static const FRBInstruction kOpcodes[256] = {
    {FRBOpcodeTypeMNEA, FRBInstructionEncodingIV},
    {FRBOpcodeTypeALEM, FRBInstructionEncodingIV},
    {FRBOpcodeTypeYNEA, FRBInstructionEncodingIV},
    {FRBOpcodeTypeXMA, FRBInstructionEncodingIV},
    {FRBOpcodeTypeDYN, FRBInstructionEncodingIV},
    {FRBOpcodeTypeIYC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeAMAAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeDMAN, FRBInstructionEncodingIV},
    {FRBOpcodeTypeTKA, FRBInstructionEncodingIV},
    {FRBOpcodeTypeCOMX, FRBInstructionEncodingIV},
    {FRBOpcodeTypeTDO, FRBInstructionEncodingIV},
    {FRBOpcodeTypeCOMC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeRSTR, FRBInstructionEncodingIV},
    {FRBOpcodeTypeSETR, FRBInstructionEncodingIV},
    {FRBOpcodeTypeKNEZ, FRBInstructionEncodingIV},
    {FRBOpcodeTypeRETN, FRBInstructionEncodingIV},

    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},
    {FRBOpcodeTypeLDP, FRBInstructionEncodingII},

    {FRBOpcodeTypeTAY, FRBInstructionEncodingIV},
    {FRBOpcodeTypeTMA, FRBInstructionEncodingIV},
    {FRBOpcodeTypeTMY, FRBInstructionEncodingIV},
    {FRBOpcodeTypeTYA, FRBInstructionEncodingIV},
    {FRBOpcodeTypeTAMDYN, FRBInstructionEncodingIV},
    {FRBOpcodeTypeTAMIYC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeTAMZA, FRBInstructionEncodingIV},
    {FRBOpcodeTypeTAM, FRBInstructionEncodingIV},
    {FRBOpcodeTypeLDX, FRBInstructionEncodingV},
    {FRBOpcodeTypeLDX, FRBInstructionEncodingV},
    {FRBOpcodeTypeLDX, FRBInstructionEncodingV},
    {FRBOpcodeTypeLDX, FRBInstructionEncodingV},
    {FRBOpcodeTypeLDX, FRBInstructionEncodingV},
    {FRBOpcodeTypeLDX, FRBInstructionEncodingV},
    {FRBOpcodeTypeLDX, FRBInstructionEncodingV},
    {FRBOpcodeTypeLDX, FRBInstructionEncodingV},

    {FRBOpcodeTypeSBIT, FRBInstructionEncodingIII},
    {FRBOpcodeTypeSBIT, FRBInstructionEncodingIII},
    {FRBOpcodeTypeSBIT, FRBInstructionEncodingIII},
    {FRBOpcodeTypeSBIT, FRBInstructionEncodingIII},
    {FRBOpcodeTypeRBIT, FRBInstructionEncodingIII},
    {FRBOpcodeTypeRBIT, FRBInstructionEncodingIII},
    {FRBOpcodeTypeRBIT, FRBInstructionEncodingIII},
    {FRBOpcodeTypeRBIT, FRBInstructionEncodingIII},
    {FRBOpcodeTypeTBIT1, FRBInstructionEncodingIII},
    {FRBOpcodeTypeTBIT1, FRBInstructionEncodingIII},
    {FRBOpcodeTypeTBIT1, FRBInstructionEncodingIII},
    {FRBOpcodeTypeTBIT1, FRBInstructionEncodingIII},
    {FRBOpcodeTypeSAMAN, FRBInstructionEncodingIV},
    {FRBOpcodeTypeCPAIZ, FRBInstructionEncodingIV},
    {FRBOpcodeTypeIMAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeMNEZ, FRBInstructionEncodingIV},

    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCY, FRBInstructionEncodingII},

    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},
    {FRBOpcodeTypeYNEC, FRBInstructionEncodingII},

    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},
    {FRBOpcodeTypeTCMIY, FRBInstructionEncodingII},

    {FRBOpcodeTypeIAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA9AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA5AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA13AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA3AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA11AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA7AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeDAN, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA2AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA10AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA6AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA14AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA4AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA12AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeA8AAC, FRBInstructionEncodingIV},
    {FRBOpcodeTypeCLA, FRBInstructionEncodingIV},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeBR, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI},
    {FRBOpcodeTypeCALL, FRBInstructionEncodingI}};

#pragma clang diagnostic pop