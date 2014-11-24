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

#import "FRBBase.h"
#import "FRBR65C19.h"
#import "FRBModelHandler.h"

static const struct FRBOpcode kOpcodeTable[256];

@implementation ItFrobHopper6502R65C19

static NSString * const kProviderName = @"it.frob.hopper.r65c19";

@synthesize name;

- (instancetype)init {
    if (self = [super init]) {
        name = kProviderName;
    }

    return self;
}

+ (void)load {
    [[ItFrobHopper6502ModelHandler sharedModelHandler] registerProvider:[ItFrobHopper6502R65C19 class]
                                                                forName:kProviderName];
}

- (const FRBOpcode *)opcodeForByte:(uint8_t)byte {
    return &kOpcodeTable[byte];
}

@end

static const struct FRBOpcode kOpcodeTable[256] = {
    /* $00 */ { FRBOpcodeTypeBRK,          FRBAddressModeStack,                          0,         S | P     },
    /* $01 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndirect,               A,         A         },
    /* $02 */ { FRBOpcodeTypeMPY,          FRBAddressModeImplied,                        A | Y,     A | Y     },
    /* $03 */ { FRBOpcodeTypeTIP,          FRBAddressModeImplied,                        I,         0         },
    /* $04 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $05 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPage,                       A,         A         },
    /* $06 */ { FRBOpcodeTypeASL,          FRBAddressModeZeroPage,                       0,         0         },
    /* $07 */ { FRBOpcodeTypeRMB0,         FRBAddressModeZeroPage,                       0,         0         },
    /* $08 */ { FRBOpcodeTypePHP,          FRBAddressModeStack,                          P | S,     S         },
    /* $09 */ { FRBOpcodeTypeORA,          FRBAddressModeImmediate,                      A,         A         },
    /* $0A */ { FRBOpcodeTypeASL,          FRBAddressModeAccumulator,                    A,         A         },
    /* $0B */ { FRBOpcodeTypeJSB0,         FRBAddressModeImplied,                        0,         0         },
    /* $0C */ { FRBOpcodeTypeJPI,          FRBAddressModeAbsolute,                       I,         I         },
    /* $0D */ { FRBOpcodeTypeORA,          FRBAddressModeAbsolute,                       A,         A         },
    /* $0E */ { FRBOpcodeTypeASL,          FRBAddressModeAbsolute,                       0,         0         },
    /* $0F */ { FRBOpcodeTypeBBR0,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $10 */ { FRBOpcodeTypeBPL,          FRBAddressModeProgramCounterRelative,         0,         0         },
    /* $11 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndirectIndexedX,       A | X,     A         },
    /* $12 */ { FRBOpcodeTypeMPA,          FRBAddressModeImplied,                        A | W | Y, W         },
    /* $13 */ { FRBOpcodeTypeLAB,          FRBAddressModeAccumulator,                    A,         A         },
    /* $14 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $15 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndexedX,               A | X,     A         },
    /* $16 */ { FRBOpcodeTypeASL,          FRBAddressModeZeroPageIndexedX,               A | X,     A         },
    /* $17 */ { FRBOpcodeTypeRMB1,         FRBAddressModeZeroPage,                       0,         0         },
    /* $18 */ { FRBOpcodeTypeCLC,          FRBAddressModeImplied,                        0,         0         },
    /* $19 */ { FRBOpcodeTypeORA,          FRBAddressModeAbsoluteIndexedY,               A | Y,     A         },
    /* $1A */ { FRBOpcodeTypeNEG,          FRBAddressModeAccumulator,                    A,         A         },
    /* $1B */ { FRBOpcodeTypeJSB1,         FRBAddressModeImplied,                        0,         0         },
    /* $1C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $1D */ { FRBOpcodeTypeORA,          FRBAddressModeAbsoluteIndexedX,               A | X,     A         },
    /* $1E */ { FRBOpcodeTypeASL,          FRBAddressModeAbsoluteIndexedX,               A | X,     A         },
    /* $1F */ { FRBOpcodeTypeBBR1,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $20 */ { FRBOpcodeTypeJSR,          FRBAddressModeAbsolute,                       0,         0         },
    /* $21 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndirect,               A,         A         },
    /* $22 */ { FRBOpcodeTypePSH,          FRBAddressModeImplied,                        A | X | Y, S         },
    /* $23 */ { FRBOpcodeTypePHW,          FRBAddressModeImplied,                        W,         S         },
    /* $24 */ { FRBOpcodeTypeBIT,          FRBAddressModeZeroPage,                       A,         0         },
    /* $25 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPage,                       A,         A         },
    /* $26 */ { FRBOpcodeTypeROL,          FRBAddressModeZeroPage,                       0,         0         },
    /* $27 */ { FRBOpcodeTypeRMB2,         FRBAddressModeZeroPage,                       0,         0         },
    /* $28 */ { FRBOpcodeTypePLP,          FRBAddressModeStack,                          S,         P | S     },
    /* $29 */ { FRBOpcodeTypeAND,          FRBAddressModeImmediate,                      A,         A         },
    /* $2A */ { FRBOpcodeTypeROL,          FRBAddressModeAccumulator,                    A,         A         },
    /* $2B */ { FRBOpcodeTypeJSB2,         FRBAddressModeImplied,                        0,         0         },
    /* $2C */ { FRBOpcodeTypeBIT,          FRBAddressModeAbsolute,                       A,         0         },
    /* $2D */ { FRBOpcodeTypeAND,          FRBAddressModeAbsolute,                       A,         A         },
    /* $2E */ { FRBOpcodeTypeROL,          FRBAddressModeAbsolute,                       0,         0         },
    /* $2F */ { FRBOpcodeTypeBBR2,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $30 */ { FRBOpcodeTypeBMI,          FRBAddressModeProgramCounterRelative,         0,         0         },
    /* $31 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndirectIndexedX,       A | X,     A         },
    /* $32 */ { FRBOpcodeTypePUL,          FRBAddressModeImplied,                        S,         A | X | Y },
    /* $33 */ { FRBOpcodeTypePLW,          FRBAddressModeImplied,                        S,         S | W     },
    /* $34 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $35 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndexedX,               A | X,     A         },
    /* $36 */ { FRBOpcodeTypeROL,          FRBAddressModeZeroPageIndexedX,               X,         0         },
    /* $37 */ { FRBOpcodeTypeRMB3,         FRBAddressModeZeroPage,                       0,         0         },
    /* $38 */ { FRBOpcodeTypeSEC,          FRBAddressModeImplied,                        0,         0         },
    /* $39 */ { FRBOpcodeTypeAND,          FRBAddressModeAbsoluteIndexedY,               A | Y,     A         },
    /* $3A */ { FRBOpcodeTypeASR,          FRBAddressModeAccumulator,                    A,         A         },
    /* $3B */ { FRBOpcodeTypeJSB3,         FRBAddressModeImplied,                        0,         0         },
    /* $3C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $3D */ { FRBOpcodeTypeAND,          FRBAddressModeAbsoluteIndexedX,               A | X,     A         },
    /* $3E */ { FRBOpcodeTypeROL,          FRBAddressModeAbsoluteIndexedX,               X,         0         },
    /* $3F */ { FRBOpcodeTypeBBR3,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $40 */ { FRBOpcodeTypeRTI,          FRBAddressModeStack,                          0,         0         },
    /* $41 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndirect,               A,         A         },
    /* $42 */ { FRBOpcodeTypeRND,          FRBAddressModeImplied,                        W,         A | W     },
    /* $43 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $44 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $45 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPage,                       A,         A         },
    /* $46 */ { FRBOpcodeTypeLSR,          FRBAddressModeZeroPage,                       0,         0         },
    /* $47 */ { FRBOpcodeTypeRMB4,         FRBAddressModeZeroPage,                       0,         0         },
    /* $48 */ { FRBOpcodeTypePHA,          FRBAddressModeStack,                          A | S,     S         },
    /* $49 */ { FRBOpcodeTypeEOR,          FRBAddressModeImmediate,                      A,         A         },
    /* $4A */ { FRBOpcodeTypeLSR,          FRBAddressModeAccumulator,                    A,         A         },
    /* $4B */ { FRBOpcodeTypeJSB4,         FRBAddressModeImplied,                        0,         0         },
    /* $4C */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsolute,                       0,         0         },
    /* $4D */ { FRBOpcodeTypeEOR,          FRBAddressModeAbsolute,                       A,         A         },
    /* $4E */ { FRBOpcodeTypeLSR,          FRBAddressModeAbsolute,                       0,         0         },
    /* $4F */ { FRBOpcodeTypeBBR4,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $50 */ { FRBOpcodeTypeBVC,          FRBAddressModeProgramCounterRelative,         0,         0         },
    /* $51 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndirectIndexedX,       A | X,     A         },
    /* $52 */ { FRBOpcodeTypeCLW,          FRBAddressModeImplied,                        0,         W         },
    /* $53 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $54 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $55 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndexedX,               A | X,     A         },
    /* $56 */ { FRBOpcodeTypeLSR,          FRBAddressModeZeroPageIndexedX,               X,         0         },
    /* $57 */ { FRBOpcodeTypeRMB5,         FRBAddressModeZeroPage,                       0,         0         },
    /* $58 */ { FRBOpcodeTypeCLI,          FRBAddressModeImplied,                        0,         0         },
    /* $59 */ { FRBOpcodeTypeEOR,          FRBAddressModeAbsoluteIndexedY,               A | Y,     A         },
    /* $5A */ { FRBOpcodeTypePHY,          FRBAddressModeStack,                          Y | S,     S         },
    /* $5B */ { FRBOpcodeTypeJSB5,         FRBAddressModeImplied,                        0,         0         },
    /* $5C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $5D */ { FRBOpcodeTypeEOR,          FRBAddressModeAbsoluteIndexedX,               A | X,     A         },
    /* $5E */ { FRBOpcodeTypeLSR,          FRBAddressModeAbsoluteIndexedX,               X,         0         },
    /* $5F */ { FRBOpcodeTypeBBR5,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $60 */ { FRBOpcodeTypeRTS,          FRBAddressModeStack,                          0,         0         },
    /* $61 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndirect,               A,         A         },
    /* $62 */ { FRBOpcodeTypeTAW,          FRBAddressModeImplied,                        A | W,     A | W     },
    /* $63 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $64 */ { FRBOpcodeTypeADD,          FRBAddressModeZeroPage,                       A,         A         },
    /* $65 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPage,                       A,         A         },
    /* $66 */ { FRBOpcodeTypeROR,          FRBAddressModeZeroPage,                       0,         0         },
    /* $67 */ { FRBOpcodeTypeRMB6,         FRBAddressModeZeroPage,                       0,         0         },
    /* $68 */ { FRBOpcodeTypePLA,          FRBAddressModeStack,                          S,         A | S     },
    /* $69 */ { FRBOpcodeTypeADC,          FRBAddressModeImmediate,                      A,         A         },
    /* $6A */ { FRBOpcodeTypeROR,          FRBAddressModeAccumulator,                    A,         A         },
    /* $6B */ { FRBOpcodeTypeJSB6,         FRBAddressModeImplied,                        0,         0         },
    /* $6C */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsoluteIndirect,               0,         0         },
    /* $6D */ { FRBOpcodeTypeADC,          FRBAddressModeAbsolute,                       A,         A         },
    /* $6E */ { FRBOpcodeTypeROR,          FRBAddressModeAbsolute,                       0,         0         },
    /* $6F */ { FRBOpcodeTypeBBR6,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $70 */ { FRBOpcodeTypeBVS,          FRBAddressModeProgramCounterRelative,         0,         0         },
    /* $71 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndirectIndexedX,       A | X,     A         },
    /* $72 */ { FRBOpcodeTypeTWA,          FRBAddressModeImplied,                        A | W,     A | W     },
    /* $73 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $74 */ { FRBOpcodeTypeADD,          FRBAddressModeZeroPageIndexedX,               A | X,     A         },
    /* $75 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndexedX,               A | X,     A         },
    /* $76 */ { FRBOpcodeTypeROR,          FRBAddressModeZeroPageIndexedX,               X,         0         },
    /* $77 */ { FRBOpcodeTypeRMB7,         FRBAddressModeZeroPage,                       0,         0         },
    /* $78 */ { FRBOpcodeTypeSEI,          FRBAddressModeImplied,                        0,         0         },
    /* $79 */ { FRBOpcodeTypeADC,          FRBAddressModeAbsoluteIndexedY,               A | Y,     A         },
    /* $7A */ { FRBOpcodeTypePLY,          FRBAddressModeStack,                          S,         Y | S     },
    /* $7B */ { FRBOpcodeTypeJSB7,         FRBAddressModeImplied,                        0,         0         },
    /* $7C */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsoluteIndexedIndirect,        X,         0         },
    /* $7D */ { FRBOpcodeTypeADC,          FRBAddressModeAbsoluteIndexedX,               A | X,     A         },
    /* $7E */ { FRBOpcodeTypeROR,          FRBAddressModeAbsoluteIndexedX,               X,         0         },
    /* $7F */ { FRBOpcodeTypeBBR7,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $80 */ { FRBOpcodeTypeBRA,          FRBAddressModeProgramCounterRelative,         0,         0         },
    /* $81 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndirect,               A,         0         },
    /* $82 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $83 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $84 */ { FRBOpcodeTypeSTY,          FRBAddressModeZeroPage,                       Y,         0         },
    /* $85 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPage,                       A,         0         },
    /* $86 */ { FRBOpcodeTypeSTX,          FRBAddressModeZeroPage,                       X,         0         },
    /* $87 */ { FRBOpcodeTypeSMB0,         FRBAddressModeZeroPage,                       0,         0         },
    /* $88 */ { FRBOpcodeTypeDEY,          FRBAddressModeImplied,                        Y,         Y         },
    /* $89 */ { FRBOpcodeTypeADD,          FRBAddressModeImmediate,                      A,         A         },
    /* $8A */ { FRBOpcodeTypeTXA,          FRBAddressModeImplied,                        A | X,     A | X     },
    /* $8B */ { FRBOpcodeTypeNXT,          FRBAddressModeImplied,                        I,         I         },
    /* $8C */ { FRBOpcodeTypeSTY,          FRBAddressModeAbsolute,                       Y,         0         },
    /* $8D */ { FRBOpcodeTypeSTA,          FRBAddressModeAbsolute,                       A,         0         },
    /* $8E */ { FRBOpcodeTypeSTX,          FRBAddressModeAbsolute,                       X,         0         },
    /* $8F */ { FRBOpcodeTypeBBS0,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $90 */ { FRBOpcodeTypeBCC,          FRBAddressModeProgramCounterRelative,         0,         0         },
    /* $91 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndirectIndexedX,       A | X,     0         },
    /* $92 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $93 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $94 */ { FRBOpcodeTypeSTY,          FRBAddressModeZeroPageIndexedX,               X | Y,     0         },
    /* $95 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndexedX,               A | X,     0         },
    /* $96 */ { FRBOpcodeTypeSTX,          FRBAddressModeZeroPageIndexedY,               X | Y,     0         },
    /* $97 */ { FRBOpcodeTypeSMB1,         FRBAddressModeZeroPage,                       0,         0         },
    /* $98 */ { FRBOpcodeTypeTYA,          FRBAddressModeImplied,                        A | Y,     A | Y     },
    /* $99 */ { FRBOpcodeTypeSTA,          FRBAddressModeAbsoluteIndexedY,               A | Y,     0         },
    /* $9A */ { FRBOpcodeTypeTXS,          FRBAddressModeImplied,                        X | S,     X | S     },
    /* $9B */ { FRBOpcodeTypeLII,          FRBAddressModeImplied,                        I,         I         },
    /* $9C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $9D */ { FRBOpcodeTypeSTA,          FRBAddressModeAbsoluteIndexedX,               A | X,     0         },
    /* $9E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $9F */ { FRBOpcodeTypeBBS1,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $A0 */ { FRBOpcodeTypeLDY,          FRBAddressModeImmediate,                      0,         Y         },
    /* $A1 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndexedIndirect,        X,         A         },
    /* $A2 */ { FRBOpcodeTypeLDX,          FRBAddressModeImmediate,                      0,         X         },
    /* $A3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $A4 */ { FRBOpcodeTypeLDY,          FRBAddressModeZeroPage,                       0,         Y         },
    /* $A5 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPage,                       0,         A         },
    /* $A6 */ { FRBOpcodeTypeLDX,          FRBAddressModeZeroPage,                       0,         X         },
    /* $A7 */ { FRBOpcodeTypeSMB2,         FRBAddressModeZeroPage,                       0,         0         },
    /* $A8 */ { FRBOpcodeTypeTAY,          FRBAddressModeImplied,                        A | Y,     A | Y     },
    /* $A9 */ { FRBOpcodeTypeLDA,          FRBAddressModeImmediate,                      0,         A         },
    /* $AA */ { FRBOpcodeTypeTAX,          FRBAddressModeImplied,                        A | X,     A | X     },
    /* $AB */ { FRBOpcodeTypeLAN,          FRBAddressModeImplied,                        I,         A | I     },
    /* $AC */ { FRBOpcodeTypeLDY,          FRBAddressModeAbsolute,                       0,         Y         },
    /* $AD */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsolute,                       0,         A         },
    /* $AE */ { FRBOpcodeTypeLDX,          FRBAddressModeAbsolute,                       0,         X         },
    /* $AF */ { FRBOpcodeTypeBBS2,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $B0 */ { FRBOpcodeTypeBCS,          FRBAddressModeProgramCounterRelative,         0,         0         },
    /* $B1 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndirectIndexedX,       X,         A         },
    /* $B2 */ { FRBOpcodeTypeSTI,          FRBAddressModeZeroPage,                       I,         0         },
    /* $B3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $B4 */ { FRBOpcodeTypeLDY,          FRBAddressModeZeroPageIndexedX,               X,         Y         },
    /* $B5 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndexedX,               X,         A         },
    /* $B6 */ { FRBOpcodeTypeLDX,          FRBAddressModeZeroPageIndexedY,               Y,         A         },
    /* $B7 */ { FRBOpcodeTypeSMB3,         FRBAddressModeZeroPage,                       0,         0         },
    /* $B8 */ { FRBOpcodeTypeCLV,          FRBAddressModeImplied,                        0,         0         },
    /* $B9 */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsoluteIndexedY,               Y,         A         },
    /* $BA */ { FRBOpcodeTypeTSX,          FRBAddressModeImplied,                        X | S,     X | S     },
    /* $BB */ { FRBOpcodeTypeINI,          FRBAddressModeImplied,                        I,         I         },
    /* $BC */ { FRBOpcodeTypeLDY,          FRBAddressModeAbsoluteIndexedX,               X,         Y         },
    /* $BD */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsoluteIndexedX,               X,         A         },
    /* $BE */ { FRBOpcodeTypeLDX,          FRBAddressModeAbsoluteIndexedY,               X,         Y         },
    /* $BF */ { FRBOpcodeTypeBBS3,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },
    
    /* $C0 */ { FRBOpcodeTypeCPY,          FRBAddressModeImmediate,                      Y,         0         },
    /* $C1 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndirect,               A,         0         },
    /* $C2 */ { FRBOpcodeTypeRBA,          FRBAddressModeImmediateAbsolute,              0,         0         },
    /* $C3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $C4 */ { FRBOpcodeTypeCPY,          FRBAddressModeZeroPage,                       Y,         0         },
    /* $C5 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPage,                       A,         0         },
    /* $C6 */ { FRBOpcodeTypeDEC,          FRBAddressModeZeroPage,                       0,         0         },
    /* $C7 */ { FRBOpcodeTypeSMB4,         FRBAddressModeZeroPage,                       0,         0         },
    /* $C8 */ { FRBOpcodeTypeINY,          FRBAddressModeImplied,                        Y,         Y         },
    /* $C9 */ { FRBOpcodeTypeCMP,          FRBAddressModeImmediate,                      A,         0         },
    /* $CA */ { FRBOpcodeTypeDEX,          FRBAddressModeImplied,                        X,         X         },
    /* $CB */ { FRBOpcodeTypePHI,          FRBAddressModeStack,                          I,         I | S     },
    /* $CC */ { FRBOpcodeTypeCPY,          FRBAddressModeAbsolute,                       Y,         0         },
    /* $CD */ { FRBOpcodeTypeCMP,          FRBAddressModeAbsolute,                       A,         0         },
    /* $CE */ { FRBOpcodeTypeDEC,          FRBAddressModeAbsolute,                       0,         0         },
    /* $CF */ { FRBOpcodeTypeBBS4,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $D0 */ { FRBOpcodeTypeBNE,          FRBAddressModeProgramCounterRelative,         0,         0         },
    /* $D1 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndirectIndexedX,       A | X,     0         },
    /* $D2 */ { FRBOpcodeTypeSBA,          FRBAddressModeImmediateAbsolute,              0,         0         },
    /* $D3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $D4 */ { FRBOpcodeTypeEXC,          FRBAddressModeZeroPageIndexedX,               A | X,     A         },
    /* $D5 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndexedX,               A | X,     0         },
    /* $D6 */ { FRBOpcodeTypeDEC,          FRBAddressModeZeroPageIndexedX,               X,         0         },
    /* $D7 */ { FRBOpcodeTypeSMB5,         FRBAddressModeZeroPage,                       0,         0         },
    /* $D8 */ { FRBOpcodeTypeCLD,          FRBAddressModeImplied,                        0,         0         },
    /* $D9 */ { FRBOpcodeTypeCMP,          FRBAddressModeAbsoluteIndexedY,               A | Y,     0         },
    /* $DA */ { FRBOpcodeTypePHX,          FRBAddressModeStack,                          X | S,     S         },
    /* $DB */ { FRBOpcodeTypePLI,          FRBAddressModeImplied,                        S,         I | S     },
    /* $DC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $DD */ { FRBOpcodeTypeCMP,          FRBAddressModeAbsoluteIndexedX,               A | X,     0         },
    /* $DE */ { FRBOpcodeTypeDEC,          FRBAddressModeAbsoluteIndexedX,               X,         0         },
    /* $DF */ { FRBOpcodeTypeBBS5,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $E0 */ { FRBOpcodeTypeCPX,          FRBAddressModeImmediate,                      X,         0         },
    /* $E1 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndirect,               A,         A         },
    /* $E2 */ { FRBOpcodeTypeBAR,          FRBAddressModeBitsProgramCounterAbsolute,     0,         0         },
    /* $E3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $E4 */ { FRBOpcodeTypeCPX,          FRBAddressModeZeroPage,                       X,         0         },
    /* $E5 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPage,                       A,         A         },
    /* $E6 */ { FRBOpcodeTypeINC,          FRBAddressModeZeroPage,                       0,         0         },
    /* $E7 */ { FRBOpcodeTypeSMB6,         FRBAddressModeZeroPage,                       0,         0         },
    /* $E8 */ { FRBOpcodeTypeINX,          FRBAddressModeImplied,                        X,         X         },
    /* $E9 */ { FRBOpcodeTypeSBC,          FRBAddressModeImmediate,                      A,         A         },
    /* $EA */ { FRBOpcodeTypeNOP,          FRBAddressModeImplied,                        0,         0         },
    /* $EB */ { FRBOpcodeTypeLAI,          FRBAddressModeImplied,                        I,         A         },
    /* $EC */ { FRBOpcodeTypeCPX,          FRBAddressModeAbsolute,                       X,         0         },
    /* $ED */ { FRBOpcodeTypeSBC,          FRBAddressModeAbsolute,                       A,         A         },
    /* $EE */ { FRBOpcodeTypeINC,          FRBAddressModeAbsolute,                       0,         0         },
    /* $EF */ { FRBOpcodeTypeBBS6,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },

    /* $F0 */ { FRBOpcodeTypeBEQ,          FRBAddressModeProgramCounterRelative,         0,         0         },
    /* $F1 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndirectIndexedX,       A | X,     A         },
    /* $F2 */ { FRBOpcodeTypeBAS,          FRBAddressModeBitsProgramCounterAbsolute,     0,         0         },
    /* $F3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $F4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $F5 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndexedX,               A | X,     A         },
    /* $F6 */ { FRBOpcodeTypeINC,          FRBAddressModeZeroPageIndexedX,               X,         0         },
    /* $F7 */ { FRBOpcodeTypeSMB7,         FRBAddressModeZeroPage,                       0,         0         },
    /* $F8 */ { FRBOpcodeTypeSED,          FRBAddressModeImplied,                        0,         0         },
    /* $F9 */ { FRBOpcodeTypeSBC,          FRBAddressModeAbsoluteIndexedY,               A | Y,     A         },
    /* $FA */ { FRBOpcodeTypePLX,          FRBAddressModeStack,                          S,         X | S     },
    /* $FB */ { FRBOpcodeTypePIA,          FRBAddressModeImplied,                        I | S,     A | I | S },
    /* $FC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                        0,         0         },
    /* $FD */ { FRBOpcodeTypeSBC,          FRBAddressModeAbsoluteIndexedX,               A | X,     A         },
    /* $FE */ { FRBOpcodeTypeINC,          FRBAddressModeAbsoluteIndexedX,               X,         0         },
    /* $FF */ { FRBOpcodeTypeBBS7,         FRBAddressModeZeroPageProgramCounterRelative, 0,         0         },
};
