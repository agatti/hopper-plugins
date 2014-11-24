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
#import "FRB65R02.h"
#import "FRBModelHandler.h"

static const struct FRBOpcode kOpcodeTable[256];

@implementation ItFrobHopperSunplus650265R02

static NSString * const kProviderName = @"it.frob.hopper.65R02";

@synthesize name;

- (instancetype)init {
    if (self = [super init]) {
        name = kProviderName;
    }

    return self;
}

+ (void)load {
    [[ItFrobHopper6502ModelHandler sharedModelHandler] registerProvider:[ItFrobHopperSunplus650265R02 class]
                                                                forName:kProviderName];
}

- (const FRBOpcode *)opcodeForByte:(uint8_t)byte {
    return &kOpcodeTable[byte];
}

@end

static const struct FRBOpcode kOpcodeTable[256] = {
    /* $00 */ { FRBOpcodeTypeBRK,          FRBAddressModeStack,                   0,     S | P },
    /* $01 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $02 */ { FRBOpcodeTypeRTI,          FRBAddressModeStack,                   0,     0     },
    /* $03 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $04 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $05 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPage,                A,     A     },
    /* $06 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $07 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPage,                A,     A     },
    /* $08 */ { FRBOpcodeTypeBPL,          FRBAddressModeProgramCounterRelative,  0,     0     },
    /* $09 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $0A */ { FRBOpcodeTypeBVC,          FRBAddressModeProgramCounterRelative,  0,     0     },
    /* $09 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $0C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $0D */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $0E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $0F */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndexedX,        A | X, A     },

    /* $10 */ { FRBOpcodeTypeJSR,          FRBAddressModeAbsolute,                0,     0     },
    /* $11 */ { FRBOpcodeTypeBIT,          FRBAddressModeZeroPage,                A,     0     },
    /* $12 */ { FRBOpcodeTypeRTS,          FRBAddressModeStack,                   0,     0     },
    /* $13 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $14 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $15 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPage,                A,     A     },
    /* $16 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $17 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPage,                A,     A     },
    /* $18 */ { FRBOpcodeTypeBMI,          FRBAddressModeProgramCounterRelative,  0,     0     },
    /* $19 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $1A */ { FRBOpcodeTypeBVS,          FRBAddressModeProgramCounterRelative,  0,     0     },
    /* $1B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $1C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $1D */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $1E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $1F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $20 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $21 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $22 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $23 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $24 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $25 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPage,                A,     0     },
    /* $26 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $27 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPage,                A,     0     },
    /* $28 */ { FRBOpcodeTypeBCC,          FRBAddressModeProgramCounterRelative,  0,     0     },
    /* $29 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $2A */ { FRBOpcodeTypeBNE,          FRBAddressModeProgramCounterRelative,  0,     0     },
    /* $2B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $2C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $2D */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndexedX,        A | X, 0     },
    /* $2E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $2F */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndexedX,        A | X, 0     },

    /* $30 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $31 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $32 */ { FRBOpcodeTypeCPX,          FRBAddressModeImmediate,               X,     0     },
    /* $33 */ { FRBOpcodeTypeCPX,          FRBAddressModeZeroPage,                X,     0     },
    /* $34 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndexedIndirect, X,     A     },
    /* $35 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPage,                0,     A     },
    /* $36 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $37 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPage,                A,     A     },
    /* $38 */ { FRBOpcodeTypeBCS,          FRBAddressModeProgramCounterRelative,  0,     0     },
    /* $39 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $3A */ { FRBOpcodeTypeBEQ,          FRBAddressModeProgramCounterRelative,  0,     0     },
    /* $3B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $3C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $3D */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndexedX,        X,     A     },
    /* $3E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $3F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $40 */ { FRBOpcodeTypePHP,          FRBAddressModeStack,                   P | S, S     },
    /* $41 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $42 */ { FRBOpcodeTypePHA,          FRBAddressModeStack,                   A | S, S     },
    /* $43 */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsolute,                0,     0     },
    /* $44 */ { FRBOpcodeTypeORA,          FRBAddressModeImmediate,               A,     A     },
    /* $45 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $46 */ { FRBOpcodeTypeEOR,          FRBAddressModeImmediate,               A,     A     },
    /* $47 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $48 */ { FRBOpcodeTypeCLC,          FRBAddressModeImplied,                 0,     0     },
    /* $49 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $4A */ { FRBOpcodeTypeCLI,          FRBAddressModeImplied,                 0,     0     },
    /* $4B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $4C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $4D */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $4E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $4F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $50 */ { FRBOpcodeTypePLP,          FRBAddressModeStack,                   S,     P | S },
    /* $51 */ { FRBOpcodeTypeBIT,          FRBAddressModeAbsolute,                A,     0     },
    /* $52 */ { FRBOpcodeTypePLA,          FRBAddressModeStack,                   S,     A | S },
    /* $53 */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsoluteIndirect,        0,     0     },
    /* $54 */ { FRBOpcodeTypeAND,          FRBAddressModeImmediate,               A,     A     },
    /* $55 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $56 */ { FRBOpcodeTypeADC,          FRBAddressModeImmediate,               A,     A     },
    /* $57 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $58 */ { FRBOpcodeTypeSEC,          FRBAddressModeImplied,                 0,     0     },
    /* $59 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $5A */ { FRBOpcodeTypeSEI,          FRBAddressModeImplied,                 0,     0     },
    /* $5B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $5C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $5D */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $5E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $5F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $60 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $61 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $62 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $63 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $64 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $65 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $66 */ { FRBOpcodeTypeCMP,          FRBAddressModeImmediate,               A,     0     },
    /* $67 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $68 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $69 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $6A */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $6B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $6C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $6D */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $6E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $6F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $70 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $71 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $72 */ { FRBOpcodeTypeINX,          FRBAddressModeImplied,                 X,     X     },
    /* $73 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $74 */ { FRBOpcodeTypeLDA,          FRBAddressModeImmediate,               0,     A     },
    /* $75 */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsolute,                0,     A     },
    /* $76 */ { FRBOpcodeTypeSBC,          FRBAddressModeImmediate,               A,     A     },
    /* $77 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $78 */ { FRBOpcodeTypeCLV,          FRBAddressModeImplied,                 0,     0     },
    /* $79 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $7A */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $7B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $7C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $7D */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsoluteIndexedX,        X,     A     },
    /* $7E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $7F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $81 */ { FRBOpcodeTypeASL,          FRBAddressModeZeroPage,                0,     0     },
    /* $82 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $83 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $84 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $85 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $86 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $87 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $88 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $89 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $8A */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $8B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $8C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $8D */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $8E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $8F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $90 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $91 */ { FRBOpcodeTypeROL,          FRBAddressModeZeroPage,                0,     0     },
    /* $92 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $93 */ { FRBOpcodeTypeROR,          FRBAddressModeZeroPage,                0,     0     },
    /* $94 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $95 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $96 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $97 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $98 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $99 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $9A */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $9B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $9C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $9D */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $9E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $9F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $A0 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $A1 */ { FRBOpcodeTypeSTX,          FRBAddressModeZeroPage,                X,     0     },
    /* $A2 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $A3 */ { FRBOpcodeTypeDEC,          FRBAddressModeZeroPage,                0,     0     },
    /* $A4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $A5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $A6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $A7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $A8 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $A9 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $AA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $AB */ { FRBOpcodeTypeDEC,          FRBAddressModeZeroPageIndexedX,        X,     0     },
    /* $AC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $AD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $AE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $AF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $B0 */ { FRBOpcodeTypeLDX,          FRBAddressModeImmediate,               0,     X     },
    /* $B1 */ { FRBOpcodeTypeLDX,          FRBAddressModeZeroPage,                0,     X     },
    /* $B2 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $B3 */ { FRBOpcodeTypeINC,          FRBAddressModeZeroPage,                0,     0     },
    /* $B4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $B5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $B6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $B7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $B8 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $B9 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $BA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $BB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $BC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $BD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $BE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $BF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $C0 */ { FRBOpcodeTypeASL,          FRBAddressModeAccumulator,             A,     A     },
    /* $C1 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $C2 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $C3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $C4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $C5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $C6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $C7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $C8 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $C9 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $CA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $CB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $CC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $CD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $CE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $CF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $D0 */ { FRBOpcodeTypeROL,          FRBAddressModeAccumulator,             A,     A     },
    /* $D1 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $D2 */ { FRBOpcodeTypeROR,          FRBAddressModeAccumulator,             A,     A     },
    /* $D3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $D4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $D5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $D6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $D7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $D8 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $D9 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $DA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $DB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $DC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $DD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $DE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $DF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $E0 */ { FRBOpcodeTypeTXA,          FRBAddressModeImplied,                 A | X, A | X },
    /* $E1 */ { FRBOpcodeTypeSTX,          FRBAddressModeAbsolute,                X,     0     },
    /* $E2 */ { FRBOpcodeTypeDEX,          FRBAddressModeImplied,                 X,     X     },
    /* $E3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $E4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $E5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $E6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $E7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $E8 */ { FRBOpcodeTypeTXS,          FRBAddressModeImplied,                 X | S, X | S },
    /* $E9 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $EA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $EB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $EC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $ED */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $EE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $EF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },

    /* $F0 */ { FRBOpcodeTypeTAX,          FRBAddressModeImplied,                 A | X, A | X },
    /* $F1 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $F2 */ { FRBOpcodeTypeNOP,          FRBAddressModeImplied,                 0,     0     },
    /* $F3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $F4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $F5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $F6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $F7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $F8 */ { FRBOpcodeTypeTSX,          FRBAddressModeImplied,                 X | S, X | S },
    /* $F9 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $FA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $FB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $FC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $FD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $FE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
    /* $FF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                 0,     0     },
};

