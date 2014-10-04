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
#import "FRB65N02.h"
#import "FRBModelHandler.h"

static const struct FRBOpcode kOpcodeTable[256];

@implementation ItFrobHopperSunplus650265N02

static NSString * const kProviderName = @"it.frob.hopper.65N02";

@synthesize name;

- (instancetype)init {
    if (self = [super init]) {
        name = kProviderName;
    }

    return self;
}

+ (void)load {
    [[ItFrobHopper6502ModelHandler sharedModelHandler] registerProvider:[ItFrobHopperSunplus650265N02 class]
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
    /* $01 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $02 */ { FRBOpcodeTypeRTI,          FRBAddressModeStack,                    0,     0     },
    /* $03 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $04 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $05 */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPage,                 A,     A     },
    /* $06 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $07 */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPage,                 A,     A     },
    /* $08 */ { FRBOpcodeTypeBPL,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $09 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $0A */ { FRBOpcodeTypeBVC,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $09 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $0C */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $0D */ { FRBOpcodeTypeORA,          FRBAddressModeZeroPageIndexedX,         A | X, A     },
    /* $0E */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $0F */ { FRBOpcodeTypeEOR,          FRBAddressModeZeroPageIndexedX,         A | X, A     },

    /* $10 */ { FRBOpcodeTypeJSR,          FRBAddressModeAbsolute,                 0,     0     },
    /* $11 */ { FRBOpcodeTypeBIT,          FRBAddressModeZeroPage,                 A,     0     },
    /* $12 */ { FRBOpcodeTypeRTS,          FRBAddressModeStack,                    0,     0     },
    /* $13 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $14 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $15 */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPage,                 A,     A     },
    /* $16 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $17 */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPage,                 A,     A     },
    /* $18 */ { FRBOpcodeTypeBMI,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $19 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $1A */ { FRBOpcodeTypeBVS,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $1B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $1C */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $1D */ { FRBOpcodeTypeAND,          FRBAddressModeZeroPageIndexedX,         A | X, A     },
    /* $1E */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $1F */ { FRBOpcodeTypeADC,          FRBAddressModeZeroPageIndexedX,         A | X, A     },

    /* $20 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $21 */ { FRBOpcodeTypeSTY,          FRBAddressModeZeroPage,                 Y,     0     },
    /* $22 */ { FRBOpcodeTypeCPY,          FRBAddressModeImmediate,                Y,     0     },
    /* $23 */ { FRBOpcodeTypeCPY,          FRBAddressModeZeroPage,                 Y,     0     },
    /* $24 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndexedIndirect,  A | X, 0     },
    /* $25 */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPage,                 A,     0     },
    /* $26 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndexedIndirect,  A,     0     },
    /* $27 */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPage,                 A,     0     },
    /* $28 */ { FRBOpcodeTypeBCC,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $29 */ { FRBOpcodeTypeSTY,          FRBAddressModeZeroPageIndexedX,         X | Y, 0     },
    /* $2A */ { FRBOpcodeTypeBNE,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $2B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $2C */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, 0     },
    /* $2D */ { FRBOpcodeTypeSTA,          FRBAddressModeZeroPageIndexedX,         A | X, 0     },
    /* $2E */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, 0     },
    /* $2F */ { FRBOpcodeTypeCMP,          FRBAddressModeZeroPageIndexedX,         A | X, 0     },

    /* $30 */ { FRBOpcodeTypeLDY,          FRBAddressModeImmediate,                0,     Y     },
    /* $31 */ { FRBOpcodeTypeLDY,          FRBAddressModeZeroPage,                 0,     Y     },
    /* $32 */ { FRBOpcodeTypeCPX,          FRBAddressModeImmediate,                X,     0     },
    /* $33 */ { FRBOpcodeTypeCPX,          FRBAddressModeZeroPage,                 X,     0     },
    /* $34 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndexedIndirect,  X,     A     },
    /* $35 */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPage,                 0,     A     },
    /* $36 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndexedIndirect,  A | X, A     },
    /* $37 */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPage,                 A,     A     },
    /* $38 */ { FRBOpcodeTypeBCS,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $39 */ { FRBOpcodeTypeLDY,          FRBAddressModeZeroPageIndexedX,         X,     Y     },
    /* $3A */ { FRBOpcodeTypeBEQ,          FRBAddressModeProgramCounterRelative,   0,     0     },
    /* $3B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $3C */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndirectIndexedY, Y,     A     },
    /* $3D */ { FRBOpcodeTypeLDA,          FRBAddressModeZeroPageIndexedX,         X,     A     },
    /* $3E */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndirectIndexedY, A | Y, A     },
    /* $3F */ { FRBOpcodeTypeSBC,          FRBAddressModeZeroPageIndexedX,         A | X, A     },

    /* $40 */ { FRBOpcodeTypePHP,          FRBAddressModeStack,                    P | S, S     },
    /* $41 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $42 */ { FRBOpcodeTypePHA,          FRBAddressModeStack,                    A | S, S     },
    /* $43 */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsolute,                 0,     0     },
    /* $44 */ { FRBOpcodeTypeORA,          FRBAddressModeImmediate,                A,     A     },
    /* $45 */ { FRBOpcodeTypeORA,          FRBAddressModeAbsolute,                 A,     A     },
    /* $46 */ { FRBOpcodeTypeEOR,          FRBAddressModeImmediate,                A,     A     },
    /* $47 */ { FRBOpcodeTypeEOR,          FRBAddressModeAbsolute,                 A,     A     },
    /* $48 */ { FRBOpcodeTypeCLC,          FRBAddressModeImplied,                  0,     0     },
    /* $49 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $4A */ { FRBOpcodeTypeCLI,          FRBAddressModeImplied,                  0,     0     },
    /* $4B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $4C */ { FRBOpcodeTypeORA,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $4D */ { FRBOpcodeTypeORA,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },
    /* $4E */ { FRBOpcodeTypeEOR,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $4F */ { FRBOpcodeTypeEOR,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },

    /* $50 */ { FRBOpcodeTypePLP,          FRBAddressModeStack,                    S,     P | S },
    /* $51 */ { FRBOpcodeTypeBIT,          FRBAddressModeAbsolute,                 A,     0     },
    /* $52 */ { FRBOpcodeTypePLA,          FRBAddressModeStack,                    S,     A | S },
    /* $53 */ { FRBOpcodeTypeJMP,          FRBAddressModeAbsoluteIndirect,         0,     0     },
    /* $54 */ { FRBOpcodeTypeAND,          FRBAddressModeImmediate,                A,     A     },
    /* $55 */ { FRBOpcodeTypeAND,          FRBAddressModeAbsolute,                 A,     A     },
    /* $56 */ { FRBOpcodeTypeADC,          FRBAddressModeImmediate,                A,     A     },
    /* $57 */ { FRBOpcodeTypeADC,          FRBAddressModeAbsolute,                 A,     A     },
    /* $58 */ { FRBOpcodeTypeSEC,          FRBAddressModeImplied,                  0,     0     },
    /* $59 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $5A */ { FRBOpcodeTypeSEI,          FRBAddressModeImplied,                  0,     0     },
    /* $5B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $5C */ { FRBOpcodeTypeAND,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $5D */ { FRBOpcodeTypeAND,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },
    /* $5E */ { FRBOpcodeTypeADC,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $5F */ { FRBOpcodeTypeADC,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },

    /* $60 */ { FRBOpcodeTypeDEY,          FRBAddressModeImplied,                  Y,     Y     },
    /* $61 */ { FRBOpcodeTypeSTY,          FRBAddressModeAbsolute,                 Y,     0     },
    /* $62 */ { FRBOpcodeTypeINY,          FRBAddressModeImplied,                  Y,     Y     },
    /* $63 */ { FRBOpcodeTypeCPY,          FRBAddressModeAbsolute,                 Y,     0     },
    /* $64 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $65 */ { FRBOpcodeTypeSTA,          FRBAddressModeAbsolute,                 A,     0     },
    /* $66 */ { FRBOpcodeTypeCMP,          FRBAddressModeImmediate,                A,     0     },
    /* $67 */ { FRBOpcodeTypeCMP,          FRBAddressModeAbsolute,                 A,     0     },
    /* $68 */ { FRBOpcodeTypeTYA,          FRBAddressModeImplied,                  A | Y, A | Y },
    /* $69 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $6A */ { FRBOpcodeTypeCLD,          FRBAddressModeImplied,                  0,     0     },
    /* $6B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $6C */ { FRBOpcodeTypeSTA,          FRBAddressModeAbsoluteIndexedY,         A | Y, 0     },
    /* $6D */ { FRBOpcodeTypeSTA,          FRBAddressModeAbsoluteIndexedX,         A | X, 0     },
    /* $6E */ { FRBOpcodeTypeCMP,          FRBAddressModeAbsoluteIndexedY,         A | Y, 0     },
    /* $6F */ { FRBOpcodeTypeCMP,          FRBAddressModeAbsoluteIndexedX,         A | X, 0     },

    /* $70 */ { FRBOpcodeTypeTAY,          FRBAddressModeImplied,                  A | Y, A | Y },
    /* $71 */ { FRBOpcodeTypeLDY,          FRBAddressModeAbsolute,                 0,     Y     },
    /* $72 */ { FRBOpcodeTypeINX,          FRBAddressModeImplied,                  X,     X     },
    /* $73 */ { FRBOpcodeTypeCPX,          FRBAddressModeAbsolute,                 X,     0     },
    /* $74 */ { FRBOpcodeTypeLDA,          FRBAddressModeImmediate,                0,     A     },
    /* $75 */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsolute,                 0,     A     },
    /* $76 */ { FRBOpcodeTypeSBC,          FRBAddressModeImmediate,                A,     A     },
    /* $77 */ { FRBOpcodeTypeSBC,          FRBAddressModeAbsolute,                 A,     A     },
    /* $78 */ { FRBOpcodeTypeCLV,          FRBAddressModeImplied,                  0,     0     },
    /* $79 */ { FRBOpcodeTypeLDY,          FRBAddressModeAbsoluteIndexedX,         X,     Y     },
    /* $7A */ { FRBOpcodeTypeSED,          FRBAddressModeImplied,                  0,     0     },
    /* $7B */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $7C */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsoluteIndexedY,         Y,     A     },
    /* $7D */ { FRBOpcodeTypeLDA,          FRBAddressModeAbsoluteIndexedX,         X,     A     },
    /* $7E */ { FRBOpcodeTypeSBC,          FRBAddressModeAbsoluteIndexedY,         A | Y, A     },
    /* $7F */ { FRBOpcodeTypeSBC,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },

    /* $81 */ { FRBOpcodeTypeASL,          FRBAddressModeZeroPage,                 0,     0     },
    /* $82 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $83 */ { FRBOpcodeTypeLSR,          FRBAddressModeZeroPage,                 0,     0     },
    /* $84 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $85 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $86 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $87 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $88 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $89 */ { FRBOpcodeTypeASL,          FRBAddressModeZeroPageIndexedX,         A | X, A     },
    /* $8A */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $8B */ { FRBOpcodeTypeLSR,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $8C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $8D */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $8E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $8F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $90 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $91 */ { FRBOpcodeTypeROL,          FRBAddressModeZeroPage,                 0,     0     },
    /* $92 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $93 */ { FRBOpcodeTypeROR,          FRBAddressModeZeroPage,                 0,     0     },
    /* $94 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $95 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $96 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $97 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $98 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $99 */ { FRBOpcodeTypeROL,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $9A */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $9B */ { FRBOpcodeTypeROR,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $9C */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $9D */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $9E */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $9F */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $A0 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $A1 */ { FRBOpcodeTypeSTX,          FRBAddressModeZeroPage,                 X,     0     },
    /* $A2 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $A3 */ { FRBOpcodeTypeDEC,          FRBAddressModeZeroPage,                 0,     0     },
    /* $A4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $A5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $A6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $A7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $A8 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $A9 */ { FRBOpcodeTypeSTX,          FRBAddressModeZeroPageIndexedY,         X | Y, 0     },
    /* $AA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $AB */ { FRBOpcodeTypeDEC,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $AC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $AD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $AE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $AF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $B0 */ { FRBOpcodeTypeLDX,          FRBAddressModeImmediate,                0,     X     },
    /* $B1 */ { FRBOpcodeTypeLDX,          FRBAddressModeZeroPage,                 0,     X     },
    /* $B2 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $B3 */ { FRBOpcodeTypeINC,          FRBAddressModeZeroPage,                 0,     0     },
    /* $B4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $B5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $B6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $B7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $B8 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $B9 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $BA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $BB */ { FRBOpcodeTypeINC,          FRBAddressModeZeroPageIndexedX,         X,     0     },
    /* $BC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $BD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $BE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $BF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $C0 */ { FRBOpcodeTypeASL,          FRBAddressModeAccumulator,              A,     A     },
    /* $C1 */ { FRBOpcodeTypeASL,          FRBAddressModeAbsolute,                 0,     0     },
    /* $C2 */ { FRBOpcodeTypeLSR,          FRBAddressModeAccumulator,              A,     A     },
    /* $C3 */ { FRBOpcodeTypeLSR,          FRBAddressModeAbsolute,                 0,     0     },
    /* $C4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $C5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $C6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $C7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $C8 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $C9 */ { FRBOpcodeTypeASL,          FRBAddressModeAbsoluteIndexedX,         A | X, A     },
    /* $CA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $CB */ { FRBOpcodeTypeLSR,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $CC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $CD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $CE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $CF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $D0 */ { FRBOpcodeTypeROL,          FRBAddressModeAccumulator,              A,     A     },
    /* $D1 */ { FRBOpcodeTypeROL,          FRBAddressModeAbsolute,                 0,     0     },
    /* $D2 */ { FRBOpcodeTypeROR,          FRBAddressModeAccumulator,              A,     A     },
    /* $D3 */ { FRBOpcodeTypeROR,          FRBAddressModeAbsolute,                 0,     0     },
    /* $D4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $D5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $D6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $D7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $D8 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $D9 */ { FRBOpcodeTypeROL,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $DA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $DB */ { FRBOpcodeTypeROR,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $DC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $DD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $DE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $DF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $E0 */ { FRBOpcodeTypeTXA,          FRBAddressModeImplied,                  A | X, A | X },
    /* $E1 */ { FRBOpcodeTypeSTX,          FRBAddressModeAbsolute,                 X,     0     },
    /* $E2 */ { FRBOpcodeTypeDEX,          FRBAddressModeImplied,                  X,     X     },
    /* $E3 */ { FRBOpcodeTypeDEC,          FRBAddressModeAbsolute,                 0,     0     },
    /* $E4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $E5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $E6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $E7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $E8 */ { FRBOpcodeTypeTXS,          FRBAddressModeImplied,                  X | S, X | S },
    /* $E9 */ { FRBOpcodeTypeLDX,          FRBAddressModeZeroPageIndexedY,         Y,     A     },
    /* $EA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $EB */ { FRBOpcodeTypeDEC,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $EC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $ED */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $EE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $EF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },

    /* $F0 */ { FRBOpcodeTypeTAX,          FRBAddressModeImplied,                  A | X, A | X },
    /* $F1 */ { FRBOpcodeTypeLDX,          FRBAddressModeAbsolute,                 0,     X     },
    /* $F2 */ { FRBOpcodeTypeNOP,          FRBAddressModeImplied,                  0,     0     },
    /* $F3 */ { FRBOpcodeTypeINC,          FRBAddressModeAbsolute,                 0,     0     },
    /* $F4 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $F5 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $F6 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $F7 */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $F8 */ { FRBOpcodeTypeTSX,          FRBAddressModeImplied,                  X | S, X | S },
    /* $F9 */ { FRBOpcodeTypeLDX,          FRBAddressModeAbsoluteIndexedY,         X,     Y     },
    /* $FA */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $FB */ { FRBOpcodeTypeINC,          FRBAddressModeAbsoluteIndexedX,         X,     0     },
    /* $FC */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $FD */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $FE */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
    /* $FF */ { FRBOpcodeTypeUndocumented, FRBAddressModeUnknown,                  0,     0     },
};
