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
#import "FRBGeneric65c02.h"
#import "FRBModelHandler.h"

static const struct FRBOpcode kOpcodeTable[256];

@implementation ItFrobHopper6502Generic65C02

static NSString * const kProviderName = @"it.frob.hopper.generic65c02";

@synthesize name;

- (instancetype)init {
    if (self = [super init]) {
        name = kProviderName;
    }

    return self;
}

+ (void)load {
    [[ItFrobHopper6502ModelHandler sharedModelHandler] registerProvider:[ItFrobHopper6502Generic65C02 class]
                                                                forName:kProviderName];
}

- (const struct FRBOpcode *)opcodeForByte:(uint8_t)byte {
    return &kOpcodeTable[byte];
}

- (BOOL)processOpcode:(const struct FRBOpcode *)opcode
            forDisasm:(DisasmStruct *)disasm {
    return NO;
}

- (BOOL)haltsExecutionFlow:(const struct FRBOpcode *)opcode {
    return opcode->type == FRBOpcodeTypeBRK;
}

@end

static const struct FRBOpcode kOpcodeTable[256] = {
    /* $00 */ { FRBOpcodeTypeBRK,          FRBAddressModeStack,                    0,     S | P },
    /* $01 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $02 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $03 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $04 */ { FRBOpcodeTypeTSB,          FRBAddressModeZeroPage,                 A,     0     },
    /* $05 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPage,                 A,     A     },
    /* $06 */ { FRBOpcodeTypeASL,          FRBAddressModeZeroPage,                 0,     0     },
    /* $07 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $08 */ { FRBOpcodeTypePHP,          FRBAddressModeStack,                    P | S, S     },
    /* $09 */ { FRBOpcodeTypeORA,          FRBAddressModeImmediate,                A,     A     },
    /* $0A */ { FRBOpcodeTypeASL,          FRBAddressModeAccumulator,              A,     A     },
    /* $0B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $0C */ { FRBOpcodeTypeTSB,          FRBAddressModeAbsolute,                 A,     0     },
    /* $0D */ { FRBOpcodeTypeORA,          FRBAddressModeAbsolute,                 A,     A     },
    /* $0E */ { FRBOpcodeTypeASL,          FRBAddressModeAbsolute,                 0,     0     },
    /* $0F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $10 */ { FRBOpcodeTypeBPL,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $11 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $12 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndirect,         A,     A     },
    /* $13 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $14 */ { FRBOpcodeTypeTRB,          FRBAddressModeZeroPage,                 A,     0     },
    /* $15 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndexedX,         A | X, A     },
    /* $16 */ { FRBOpcodeTypeASL,          FRBAddressModeZeroPageIndexedX,         A | X, A     },
    /* $17 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $18 */ { FRBOpcodeTypeCLC,          FRBAddressModeImplied,                  0,     0     },
    /* $19 */ { FRBOpcodeTypeORA,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $1A */ { FRBOpcodeTypeINC,          FRBAddressModeAccumulator,              A,     A     },
    /* $1B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $1C */ { FRBOpcodeTypeTRB,          FRBAddressModeAbsolute,                 A,     0     },
    /* $1D */ { FRBOpcodeTypeORA,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },
    /* $1E */ { FRBOpcodeTypeASL,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },
    /* $1F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $20 */ { FRBOpcodeTypeJSR,          FRBAddressModeAbsolute,                 0,     0     },
    /* $21 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $22 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $23 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $24 */ { FRBOpcodeTypeBIT,          FRBAddressModeZeroPage,                 A,     0     },
    /* $25 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPage,                 A,     A     },
    /* $26 */ { FRBOpcodeTypeROL,          FRBAddressModeZeroPage,                 0,     0     },
    /* $27 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $28 */ { FRBOpcodeTypePLP,          FRBAddressModeStack,                    S,     P | S },
    /* $29 */ { FRBOpcodeTypeAND,          FRBAddressModeImmediate,                A,     A     },
    /* $2A */ { FRBOpcodeTypeROL,          FRBAddressModeAccumulator,              A,     A     },
    /* $2B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $2C */ { FRBOpcodeTypeBIT,          FRBAddressModeAbsolute,                 A,     0     },
    /* $2D */ { FRBOpcodeTypeAND,          FRBAddressModeAbsolute,                 A,     A     },
    /* $2E */ { FRBOpcodeTypeROL,          FRBAddressModeAbsolute,                 0,     0     },
    /* $2F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $30 */ { FRBOpcodeTypeBMI,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $31 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $32 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndirect,         A,     A     },
    /* $33 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $34 */ { FRBOpcodeTypeBIT,          FRBAddressModeZeroPageIndexedX,         A | X, 0     },
    /* $35 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndexedX,         A | X, A     },
    /* $36 */ { FRBOpcodeTypeROL,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $37 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $38 */ { FRBOpcodeTypeSEC,          FRBAddressModeImplied,                  0,     0     },
    /* $39 */ { FRBOpcodeTypeAND,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $3A */ { FRBOpcodeTypeDEC,          FRBAddressModeAccumulator,              A,     A     },
    /* $3B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $3C */ { FRBOpcodeTypeBIT,          FRBAddressModeAbsoluteIndexedX,         A | X, 0     },
    /* $3D */ { FRBOpcodeTypeAND,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },
    /* $3E */ { FRBOpcodeTypeROL,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $3F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $40 */ { FRBOpcodeTypeRTI,          FRBAddressModeStack,                    0,     0     },
    /* $41 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $42 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $43 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $44 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $45 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPage,                 A,     A     },
    /* $46 */ { FRBOpcodeTypeLSR,          FRBAddressModeZeroPage,                 0,     0     },
    /* $47 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $48 */ { FRBOpcodeTypePHA,          FRBAddressModeStack,                    A | S, S     },
    /* $49 */ { FRBOpcodeTypeEOR,          FRBAddressModeImmediate,                A,     A     },
    /* $4A */ { FRBOpcodeTypeLSR,          FRBAddressModeAccumulator,              A,     A     },
    /* $4B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $4C */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsolute,                 0,     0     },
    /* $4D */ { FRBOpcodeTypeEOR,          FRBAddressModeAbsolute,                 A,     A     },
    /* $4E */ { FRBOpcodeTypeLSR,          FRBAddressModeAbsolute,                 0,     0     },
    /* $4F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $50 */ { FRBOpcodeTypeBVC,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $51 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $52 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndirect,         A,     A     },
    /* $53 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $54 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $55 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndexedX,         A | X, A     },
    /* $56 */ { FRBOpcodeTypeLSR,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $57 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $58 */ { FRBOpcodeTypeCLI,          FRBAddressModeImplied,                  0,     0     },
    /* $59 */ { FRBOpcodeTypeEOR,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $5A */ { FRBOpcodeTypePHY,          FRBAddressModeStack,                    Y | S, S     },
    /* $5B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $5C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $5D */ { FRBOpcodeTypeEOR,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },
    /* $5E */ { FRBOpcodeTypeLSR,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $5F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $60 */ { FRBOpcodeTypeRTS,          FRBAddressModeStack,                    0,     0     },
    /* $61 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $62 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $63 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $64 */ { FRBOpcodeTypeSTZ,          FRBAddressModeZeroPage,                 0,     0     },
    /* $65 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPage,                 A,     A     },
    /* $66 */ { FRBOpcodeTypeROR,          FRBAddressModeZeroPage,                 0,     0     },
    /* $67 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $68 */ { FRBOpcodeTypePLA,          FRBAddressModeStack,                    S,     A | S },
    /* $69 */ { FRBOpcodeTypeADC,          FRBAddressModeImmediate,                A,     A     },
    /* $6A */ { FRBOpcodeTypeROR,          FRBAddressModeAccumulator,              A,     A     },
    /* $6B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $6C */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsoluteIndirect,         0,     0     },
    /* $6D */ { FRBOpcodeTypeADC,          FRBAddressModeAbsolute,                 A,     A     },
    /* $6E */ { FRBOpcodeTypeROR,          FRBAddressModeAbsolute,                 0,     0     },
    /* $6F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $70 */ { FRBOpcodeTypeBVS,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $71 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $72 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndirect,         A,     A     },
    /* $73 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $74 */ { FRBOpcodeTypeSTZ,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $75 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndexedX,         A | X, A     },
    /* $76 */ { FRBOpcodeTypeROR,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $77 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $78 */ { FRBOpcodeTypeSEI,          FRBAddressModeImplied,                  0,     0     },
    /* $79 */ { FRBOpcodeTypeADC,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $7A */ { FRBOpcodeTypePLY,          FRBAddressModeStack,                    Y,     Y | S },
    /* $7B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $7C */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsoluteIndexedIndirect,  X,     0     },
    /* $7D */ { FRBOpcodeTypeADC,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },
    /* $7E */ { FRBOpcodeTypeROR,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $7F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $80 */ { FRBOpcodeTypeBRA,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $81 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndexedIndirect,  A | X, 0     },
    /* $82 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $83 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $84 */ { FRBOpcodeTypeSTY,          FRBAddressModeZeroPage,                 Y,     0     },
    /* $85 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPage,                 A,     0     },
    /* $86 */ { FRBOpcodeTypeSTX,          FRBAddressModeZeroPage,                 X,     0     },
    /* $87 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $88 */ { FRBOpcodeTypeDEY,          FRBAddressModeImplied,                  Y,     Y     },
    /* $89 */ { FRBOpcodeTypeBIT,          FRBAddressModeImmediate,                A,     0     },
    /* $8A */ { FRBOpcodeTypeTXA,          FRBAddressModeImplied,                  A | X, A | X },
    /* $8B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $8C */ { FRBOpcodeTypeSTY,          FRBAddressModeAbsolute,                 Y,     0     },
    /* $8D */ { FRBOpcodeTypeSTA,          FRBAddressModeAbsolute,                 A,     0     },
    /* $8E */ { FRBOpcodeTypeSTX,          FRBAddressModeAbsolute,                 X,     0     },
    /* $8F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $90 */ { FRBOpcodeTypeBCC,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $91 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, 0     },
    /* $92 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndirect,         A,     0,    },
    /* $93 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $94 */ { FRBOpcodeTypeSTY,          FRBAddressModeZeroPageIndexedX,         X | Y, 0     },
    /* $95 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndexedX,         A | X, 0     },
    /* $96 */ { FRBOpcodeTypeSTX,          FRBAddressModeZeroPageIndexedY,         X | Y, 0     },
    /* $97 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $98 */ { FRBOpcodeTypeTYA,          FRBAddressModeImplied,                  A | Y, A | Y },
    /* $99 */ { FRBOpcodeTypeSTA,          FRBAddressModeAbsoluteIndexedY,         A | Y, 0     },
    /* $9A */ { FRBOpcodeTypeTXS,          FRBAddressModeImplied,                  X | S, X | S },
    /* $9B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $9C */ { FRBOpcodeTypeSTZ,          FRBAddressModeAbsolute,                 0,     0     },
    /* $9D */ { FRBOpcodeTypeSTA,          FRBAddressModeAbsoluteIndexedX,         A | X, 0     },
    /* $9E */ { FRBOpcodeTypeSTZ,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $9F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $A0 */ { FRBOpcodeTypeLDY,          FRBAddressModeImmediate,                0,     Y     },
    /* $A1 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndexedIndirect,  X,     A     },
    /* $A2 */ { FRBOpcodeTypeLDX,          FRBAddressModeImmediate,                0,     X     },
    /* $A3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $A4 */ { FRBOpcodeTypeLDY,          FRBAddressModeZeroPage,                 0,     Y     },
    /* $A5 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPage,                 0,     A     },
    /* $A6 */ { FRBOpcodeTypeLDX,          FRBAddressModeZeroPage,                 0,     X     },
    /* $A7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $A8 */ { FRBOpcodeTypeTAY,          FRBAddressModeImplied,                  A | Y, A | Y },
    /* $A9 */ { FRBOpcodeTypeLDA,          FRBAddressModeImmediate,                0,     A     },
    /* $AA */ { FRBOpcodeTypeTAX,          FRBAddressModeImplied,                  A | X, A | X },
    /* $AB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $AC */ { FRBOpcodeTypeLDY,          FRBAddressModeAbsolute,                 0,     Y     },
    /* $AD */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsolute,                 0,     A     },
    /* $AE */ { FRBOpcodeTypeLDX,          FRBAddressModeAbsolute,                 0,     X     },
    /* $AF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $B0 */ { FRBOpcodeTypeBCS,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $B1 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndirectIndexedY, Y,     A     },
    /* $B2 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndirect,         0,     A     },
    /* $B3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $B4 */ { FRBOpcodeTypeLDY,          FRBAddressModeZeroPageIndexedX,         X,     Y     },
    /* $B5 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndexedX,         X,     A     },
    /* $B6 */ { FRBOpcodeTypeLDX,          FRBAddressModeZeroPageIndexedY,         Y,     A     },
    /* $B7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $B8 */ { FRBOpcodeTypeCLV,          FRBAddressModeImplied,                  0,     0     },
    /* $B9 */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsoluteIndexedY,         Y,     A     },
    /* $BA */ { FRBOpcodeTypeTSX,          FRBAddressModeImplied,                  X | S, X | S },
    /* $BB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $BC */ { FRBOpcodeTypeLDY,          FRBAddressModeAbsoluteIndexedX,         X,     Y     },
    /* $BD */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsoluteIndexedX,         X,     A     },
    /* $BE */ { FRBOpcodeTypeLDX,          FRBAddressModeAbsoluteIndexedY,         X,     Y     },
    /* $BF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $C0 */ { FRBOpcodeTypeCPY,          FRBAddressModeImmediate,                Y,     0     },
    /* $C1 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndexedIndirect,  A,     0     },
    /* $C2 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $C3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $C4 */ { FRBOpcodeTypeCPY,          FRBAddressModeZeroPage,                 Y,     0     },
    /* $C5 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPage,                 A,     0     },
    /* $C6 */ { FRBOpcodeTypeDEC,          FRBAddressModeZeroPage,                 0,     0     },
    /* $C7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $C8 */ { FRBOpcodeTypeINY,          FRBAddressModeImplied,                  Y,     Y     },
    /* $C9 */ { FRBOpcodeTypeCMP,          FRBAddressModeImmediate,                A,     0     },
    /* $CA */ { FRBOpcodeTypeDEX,          FRBAddressModeImplied,                  X,     X     },
    /* $CB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $CC */ { FRBOpcodeTypeCPY,          FRBAddressModeAbsolute,                 Y,     0     },
    /* $CD */ { FRBOpcodeTypeCMP,          FRBAddressModeAbsolute,                 A,     0     },
    /* $CE */ { FRBOpcodeTypeDEC,          FRBAddressModeAbsolute,                 0,     0     },
    /* $CF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $D0 */ { FRBOpcodeTypeBNE,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $D1 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, 0     },
    /* $D2 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndirect,         A,     0     },
    /* $D3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $D4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $D5 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndexedX,         A | X, 0     },
    /* $D6 */ { FRBOpcodeTypeDEC,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $D7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $D8 */ { FRBOpcodeTypeCLD,          FRBAddressModeImplied,                  0,     0     },
    /* $D9 */ { FRBOpcodeTypeCMP,          FRBAddressModeAbsoluteIndexedY,         A | Y, 0     },
    /* $DA */ { FRBOpcodeTypePHX,          FRBAddressModeStack,                    X | S, S     },
    /* $DB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $DC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $DD */ { FRBOpcodeTypeCMP,          FRBAddressModeAbsoluteIndexedX,         A | X, 0     },
    /* $DE */ { FRBOpcodeTypeDEC,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $DF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $E0 */ { FRBOpcodeTypeCPX,          FRBAddressModeImmediate,                X,     0     },
    /* $E1 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $E2 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $E3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $E4 */ { FRBOpcodeTypeCPX,          FRBAddressModeZeroPage,                 X,     0     },
    /* $E5 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPage,                 A,     A     },
    /* $E6 */ { FRBOpcodeTypeINC,          FRBAddressModeZeroPage,                 0,     0     },
    /* $E7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $E8 */ { FRBOpcodeTypeINX,          FRBAddressModeImplied,                  X,     X     },
    /* $E9 */ { FRBOpcodeTypeSBC,          FRBAddressModeImmediate,                A,     A     },
    /* $EA */ { FRBOpcodeTypeNOP,          FRBAddressModeImplied,                  0,     0     },
    /* $EB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $EC */ { FRBOpcodeTypeCPX,          FRBAddressModeAbsolute,                 X,     0     },
    /* $ED */ { FRBOpcodeTypeSBC,          FRBAddressModeAbsolute,                 A,     A     },
    /* $EE */ { FRBOpcodeTypeINC,          FRBAddressModeAbsolute,                 0,     0     },
    /* $EF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $F0 */ { FRBOpcodeTypeBEQ,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $F1 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $F2 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndirect,         A,     A     },
    /* $F3 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $F4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $F5 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndexedX,         A | X, A     },
    /* $F6 */ { FRBOpcodeTypeINC,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $F7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $F8 */ { FRBOpcodeTypeSED,          FRBAddressModeImplied,                  0,     0     },
    /* $F9 */ { FRBOpcodeTypeSBC,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $FA */ { FRBOpcodeTypePLX,          FRBAddressModeStack,                    X,     X | S },
    /* $FB */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $FC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $FD */ { FRBOpcodeTypeSBC,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },
    /* $FE */ { FRBOpcodeTypeINC,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $FF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
};
