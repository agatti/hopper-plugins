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
#import "FRBGeneric65816.h"
#import "FRBModelHandler.h"

static const struct FRBOpcode kOpcodeTable[256];

@implementation ItFrobHopper65816Generic65816

static NSString * const kProviderName = @"it.frob.hopper.generic65816";

@synthesize name;

- (instancetype)init {
    if (self = [super init]) {
        name = kProviderName;
    }

    return self;
}

+ (void)load {
    [[ItFrobHopper65816ModelHandler sharedModelHandler] registerProvider:[ItFrobHopper65816Generic65816 class]
                                                                 forName:kProviderName];
}

- (BOOL)processOpcode:(const struct FRBOpcode *)opcode
            forDisasm:(DisasmStruct *)disasm {
    return NO;
}

- (const struct FRBOpcode *)opcodeForByte:(uint8_t)byte {
    return &kOpcodeTable[byte];
}

- (BOOL)haltsExecutionFlow:(const struct FRBOpcode *)opcode {
    return opcode->type == FRBOpcodeTypeBRK || opcode->type == FRBOpcodeTypeSTP;
}

@end

static const struct FRBOpcode kOpcodeTable[256] = {
    /* $00 */ { FRBOpcodeTypeBRK, FRBAddressModeStack,                        0,             S | P     },
    /* $01 */ { FRBOpcodeTypeORA, FRBAddressModeDirectIndexedIndirect,        A | D | X,     A         },
    /* $02 */ { FRBOpcodeTypeCOP, FRBAddressModeImmediate,                    S,             S         },
    /* $03 */ { FRBOpcodeTypeORA, FRBAddressModeStackRelative,                A | D | S,     A         },
    /* $04 */ { FRBOpcodeTypeTSB, FRBAddressModeDirect,                       A | D,         0         },
    /* $05 */ { FRBOpcodeTypeORA, FRBAddressModeDirect,                       A | D,         A         },
    /* $06 */ { FRBOpcodeTypeASL, FRBAddressModeDirect,                       D,             0         },
    /* $07 */ { FRBOpcodeTypeORA, FRBAddressModeDirectIndirectLong,           A | D,         A         },
    /* $08 */ { FRBOpcodeTypePHP, FRBAddressModeStack,                        P | S,         S         },
    /* $09 */ { FRBOpcodeTypeORA, FRBAddressModeImmediate,                    A,             A         },
    /* $0A */ { FRBOpcodeTypeASL, FRBAddressModeAccumulator,                  A,             A         },
    /* $0B */ { FRBOpcodeTypePHD, FRBAddressModeStack,                        D | S,         S         },
    /* $0C */ { FRBOpcodeTypeTSB, FRBAddressModeAbsolute,                     A,             0         },
    /* $0D */ { FRBOpcodeTypeORA, FRBAddressModeAbsolute,                     A,             A         },
    /* $0E */ { FRBOpcodeTypeASL, FRBAddressModeAbsolute,                     0,             0         },
    /* $0F */ { FRBOpcodeTypeORA, FRBAddressModeAbsoluteLong,                 A,             A         },

    /* $10 */ { FRBOpcodeTypeBPL, FRBAddressModeProgramCounterRelative,       0,             0         },
    /* $11 */ { FRBOpcodeTypeORA, FRBAddressModeDirectIndirectIndexedY,       A | D,         A         },
    /* $12 */ { FRBOpcodeTypeORA, FRBAddressModeDirectIndirect,               A | D,         A         },
    /* $13 */ { FRBOpcodeTypeORA, FRBAddressModeStackRelativeIndirectIndexed, A | D | Y | S, A         },
    /* $14 */ { FRBOpcodeTypeTRB, FRBAddressModeDirect,                       A | D,         0         },
    /* $15 */ { FRBOpcodeTypeORA, FRBAddressModeDirectIndexedX,               A | D | X,     A         },
    /* $16 */ { FRBOpcodeTypeASL, FRBAddressModeDirectIndexedX,               D | X,         0         },
    /* $17 */ { FRBOpcodeTypeORA, FRBAddressModeDirectIndirectLongIndexed,    A | Y,         A         },
    /* $18 */ { FRBOpcodeTypeCLC, FRBAddressModeImplied,                      0,             0         },
    /* $19 */ { FRBOpcodeTypeORA, FRBAddressModeAbsoluteIndexedY,             A | Y,         A         },
    /* $1A */ { FRBOpcodeTypeINC, FRBAddressModeAccumulator,                  A,             A         },
    /* $1B */ { FRBOpcodeTypeTCS, FRBAddressModeImplied,                      C,             S         },
    /* $1C */ { FRBOpcodeTypeTRB, FRBAddressModeAbsolute,                     A,             0         },
    /* $1D */ { FRBOpcodeTypeORA, FRBAddressModeAbsoluteIndexedX,             A | X,         A         },
    /* $1E */ { FRBOpcodeTypeASL, FRBAddressModeAbsoluteIndexedX,             A | X,         0         },
    /* $1F */ { FRBOpcodeTypeORA, FRBAddressModeAbsoluteLongIndexed,          A,             A         },

    /* $20 */ { FRBOpcodeTypeJSR, FRBAddressModeAbsolute,                     0,             0         },
    /* $21 */ { FRBOpcodeTypeAND, FRBAddressModeDirectIndexedIndirect,        A | D | X,     A         },
    /* $22 */ { FRBOpcodeTypeJSL, FRBAddressModeAbsoluteLong,                 0,             0         },
    /* $23 */ { FRBOpcodeTypeAND, FRBAddressModeStackRelativeIndirectIndexed, A | D | Y | S, A         },
    /* $24 */ { FRBOpcodeTypeBIT, FRBAddressModeDirect,                       A | D,         P         },
    /* $25 */ { FRBOpcodeTypeAND, FRBAddressModeDirect,                       A | D,         A         },
    /* $26 */ { FRBOpcodeTypeROL, FRBAddressModeDirect,                       0,             0         },
    /* $27 */ { FRBOpcodeTypeAND, FRBAddressModeDirectIndirectLong,           A,             A         },
    /* $28 */ { FRBOpcodeTypePLP, FRBAddressModeStack,                        S,             P | S     },
    /* $29 */ { FRBOpcodeTypeAND, FRBAddressModeImmediate,                    A,             A         },
    /* $2A */ { FRBOpcodeTypeROL, FRBAddressModeAccumulator,                  A,             A         },
    /* $2B */ { FRBOpcodeTypePLD, FRBAddressModeStack,                        S,             D | S     },
    /* $2C */ { FRBOpcodeTypeBIT, FRBAddressModeAbsolute,                     A,             P         },
    /* $2D */ { FRBOpcodeTypeAND, FRBAddressModeAbsolute,                     A,             A         },
    /* $2E */ { FRBOpcodeTypeROL, FRBAddressModeAbsolute,                     0,             0         },
    /* $2F */ { FRBOpcodeTypeAND, FRBAddressModeAbsoluteLong,                 A,             A         },

    /* $30 */ { FRBOpcodeTypeBMI, FRBAddressModeProgramCounterRelative,       0,             0         },
    /* $31 */ { FRBOpcodeTypeAND, FRBAddressModeDirectIndirectIndexedY,       A | D | Y,     A         },
    /* $32 */ { FRBOpcodeTypeAND, FRBAddressModeDirectIndirect,               A | D,         A         },
    /* $33 */ { FRBOpcodeTypeAND, FRBAddressModeStackRelativeIndirectIndexed, A | D | S | Y, A         },
    /* $34 */ { FRBOpcodeTypeBIT, FRBAddressModeDirectIndexedX,               A | D | X,     P         },
    /* $35 */ { FRBOpcodeTypeAND, FRBAddressModeDirectIndexedX,               A | D | X,     A         },
    /* $36 */ { FRBOpcodeTypeROL, FRBAddressModeDirectIndexedX,               D | X,         0         },
    /* $37 */ { FRBOpcodeTypeAND, FRBAddressModeDirectIndirectLongIndexed,    A | D | Y,     A         },
    /* $38 */ { FRBOpcodeTypeSEC, FRBAddressModeImplied,                      0,             P         },
    /* $39 */ { FRBOpcodeTypeAND, FRBAddressModeAbsoluteIndexedY,             A | Y,         A         },
    /* $3A */ { FRBOpcodeTypeDEC, FRBAddressModeAccumulator,                  A,             A         },
    /* $3B */ { FRBOpcodeTypeTSC, FRBAddressModeImplied,                      S,             C         },
    /* $3C */ { FRBOpcodeTypeBIT, FRBAddressModeAbsoluteIndexedX,             A | X,         P         },
    /* $3D */ { FRBOpcodeTypeAND, FRBAddressModeAbsoluteIndexedX,             A | X,         A         },
    /* $3E */ { FRBOpcodeTypeROL, FRBAddressModeAbsoluteIndexedX,             A | X,         0         },
    /* $3F */ { FRBOpcodeTypeAND, FRBAddressModeAbsoluteLongIndexed,          A | X,         A         },

    /* $40 */ { FRBOpcodeTypeRTI, FRBAddressModeStack,                        0,             0         },
    /* $41 */ { FRBOpcodeTypeEOR, FRBAddressModeDirectIndexedX,               A | D | X,     A         },
    /* $42 */ { FRBOpcodeTypeWDM, FRBAddressModeImplied,                      0,             0         },
    /* $43 */ { FRBOpcodeTypeEOR, FRBAddressModeStackRelative,                A | D | S,     A         },
    /* $44 */ { FRBOpcodeTypeMVP, FRBAddressModeBlockMove,                    C | X | Y,     C | X | Y },
    /* $45 */ { FRBOpcodeTypeEOR, FRBAddressModeDirect,                       A | D,         A         },
    /* $46 */ { FRBOpcodeTypeLSR, FRBAddressModeDirect,                       D,             0         },
    /* $47 */ { FRBOpcodeTypeEOR, FRBAddressModeDirectIndirectLong,           A | D,         A         },
    /* $48 */ { FRBOpcodeTypePHA, FRBAddressModeStack,                        A | S,         S         },
    /* $49 */ { FRBOpcodeTypeEOR, FRBAddressModeImmediate,                    A,             A         },
    /* $4A */ { FRBOpcodeTypeLSR, FRBAddressModeAccumulator,                  A,             A         },
    /* $4B */ { FRBOpcodeTypePHK, FRBAddressModeStack,                        PBR | S,       S         },
    /* $4C */ { FRBOpcodeTypeJMP, FRBAddressModeAbsolute,                     0,             0         },
    /* $4D */ { FRBOpcodeTypeEOR, FRBAddressModeAbsolute,                     A,             A         },
    /* $4E */ { FRBOpcodeTypeLSR, FRBAddressModeAbsolute,                     0,             0         },
    /* $4F */ { FRBOpcodeTypeEOR, FRBAddressModeAbsoluteLong,                 A,             A         },

    /* $50 */ { FRBOpcodeTypeBVC, FRBAddressModeProgramCounterRelative,       0,             0         },
    /* $51 */ { FRBOpcodeTypeEOR, FRBAddressModeDirectIndirectIndexedY,       A | D | Y,     A         },
    /* $52 */ { FRBOpcodeTypeEOR, FRBAddressModeDirectIndirect,               A | D,         A         },
    /* $53 */ { FRBOpcodeTypeEOR, FRBAddressModeStackRelativeIndirectIndexed, A | D | S | Y, A         },
    /* $54 */ { FRBOpcodeTypeMVN, FRBAddressModeBlockMove,                    C | X | Y,     C | X | Y },
    /* $55 */ { FRBOpcodeTypeEOR, FRBAddressModeDirectIndexedX,               A | D | X,     A         },
    /* $56 */ { FRBOpcodeTypeLSR, FRBAddressModeDirectIndexedX,               X | D,         0         },
    /* $57 */ { FRBOpcodeTypeEOR, FRBAddressModeDirectIndirectLongIndexed,    A | D | Y,     A         },
    /* $58 */ { FRBOpcodeTypeCLI, FRBAddressModeImplied,                      0,             0         },
    /* $59 */ { FRBOpcodeTypeEOR, FRBAddressModeAbsoluteIndexedY,             A | Y,         A         },
    /* $5A */ { FRBOpcodeTypePHY, FRBAddressModeStack,                        Y | S,         S         },
    /* $5B */ { FRBOpcodeTypeTCD, FRBAddressModeImplied,                      A,             D         },
    /* $5C */ { FRBOpcodeTypeJML, FRBAddressModeAbsoluteLong,                 0,             0         },
    /* $5D */ { FRBOpcodeTypeEOR, FRBAddressModeAbsoluteIndexedX,             A | X,         A         },
    /* $5E */ { FRBOpcodeTypeLSR, FRBAddressModeAbsoluteIndexedX,             A | X,         0         },
    /* $5F */ { FRBOpcodeTypeEOR, FRBAddressModeAbsoluteLongIndexed,          A | X,         A         },

    /* $60 */ { FRBOpcodeTypeRTS, FRBAddressModeStack,                        0,             0         },
    /* $61 */ { FRBOpcodeTypeADC, FRBAddressModeDirectIndexedIndirect,        0,             0         },
    /* $62 */ { FRBOpcodeTypePER, FRBAddressModeProgramCounterRelativeLong,   S,             S         },
    /* $63 */ { FRBOpcodeTypeADC, FRBAddressModeStackRelative,                A | D | S,     A         },
    /* $64 */ { FRBOpcodeTypeSTZ, FRBAddressModeDirect,                       0,             0         },
    /* $65 */ { FRBOpcodeTypeADC, FRBAddressModeDirect,                       A | D,         A         },
    /* $66 */ { FRBOpcodeTypeROR, FRBAddressModeDirect,                       0,             0         },
    /* $67 */ { FRBOpcodeTypeADC, FRBAddressModeDirectIndirectLong,           A | D,         A         },
    /* $68 */ { FRBOpcodeTypePLA, FRBAddressModeStack,                        S,             A | S     },
    /* $69 */ { FRBOpcodeTypeADC, FRBAddressModeImmediate,                    A,             A         },
    /* $6A */ { FRBOpcodeTypeROR, FRBAddressModeAccumulator,                  A,             A         },
    /* $6B */ { FRBOpcodeTypeRTL, FRBAddressModeStack,                        0,             0         },
    /* $6C */ { FRBOpcodeTypeJMP, FRBAddressModeAbsoluteIndirect,             0,             0         },
    /* $6D */ { FRBOpcodeTypeADC, FRBAddressModeAbsolute,                     A,             A         },
    /* $6E */ { FRBOpcodeTypeROR, FRBAddressModeAbsolute,                     0,             0         },
    /* $6F */ { FRBOpcodeTypeADC, FRBAddressModeAbsoluteLong,                 A,             A         },

    /* $70 */ { FRBOpcodeTypeBVS, FRBAddressModeProgramCounterRelative,       0,             0         },
    /* $71 */ { FRBOpcodeTypeADC, FRBAddressModeDirectIndirectIndexedY,       A | D | Y,     A         },
    /* $72 */ { FRBOpcodeTypeADC, FRBAddressModeDirectIndirect,               A | D,         A         },
    /* $73 */ { FRBOpcodeTypeADC, FRBAddressModeStackRelativeIndirectIndexed, A | D | Y | S, A         },
    /* $74 */ { FRBOpcodeTypeSTZ, FRBAddressModeDirectIndexedX,               A | D | X,     0         },
    /* $75 */ { FRBOpcodeTypeADC, FRBAddressModeDirectIndexedX,               A | D | X,     A         },
    /* $76 */ { FRBOpcodeTypeROR, FRBAddressModeDirectIndexedX,               A | D | X,     0         },
    /* $77 */ { FRBOpcodeTypeADC, FRBAddressModeDirectIndirectLongIndexed,    A | D | Y,     A         },
    /* $78 */ { FRBOpcodeTypeSEI, FRBAddressModeImplied,                      0,             0         },
    /* $79 */ { FRBOpcodeTypeADC, FRBAddressModeAbsoluteIndexedY,             A | Y,         A         },
    /* $7A */ { FRBOpcodeTypePLY, FRBAddressModeStack,                        S,             Y | S     },
    /* $7B */ { FRBOpcodeTypeTDC, FRBAddressModeImplied,                      C | D,         C | D     },
    /* $7C */ { FRBOpcodeTypeJMP, FRBAddressModeAbsoluteIndexedIndirect,      X,             0         },
    /* $7D */ { FRBOpcodeTypeADC, FRBAddressModeAbsoluteIndexedX,             A | X,         A         },
    /* $7E */ { FRBOpcodeTypeROR, FRBAddressModeAbsoluteIndexedX,             X,             0         },
    /* $7F */ { FRBOpcodeTypeADC, FRBAddressModeAbsoluteLongIndexed,          A | X,         A         },

    /* $80 */ { FRBOpcodeTypeBRA, FRBAddressModeProgramCounterRelative,       0,             0         },
    /* $81 */ { FRBOpcodeTypeSTA, FRBAddressModeDirectIndexedIndirect,        A | D | X,     0         },
    /* $82 */ { FRBOpcodeTypeBRL, FRBAddressModeProgramCounterRelativeLong,   0,             0         },
    /* $83 */ { FRBOpcodeTypeSTA, FRBAddressModeStackRelative,                A | D | S,     0         },
    /* $84 */ { FRBOpcodeTypeSTY, FRBAddressModeDirect,                       Y | D,         0         },
    /* $85 */ { FRBOpcodeTypeSTA, FRBAddressModeDirect,                       A | D,         0         },
    /* $86 */ { FRBOpcodeTypeSTX, FRBAddressModeDirect,                       X | D,         0         },
    /* $87 */ { FRBOpcodeTypeSTA, FRBAddressModeDirectIndirectLong,           A | D,         0         },
    /* $88 */ { FRBOpcodeTypeDEY, FRBAddressModeImplied,                      Y,             Y         },
    /* $89 */ { FRBOpcodeTypeBIT, FRBAddressModeImmediate,                    A,             0         },
    /* $8A */ { FRBOpcodeTypeTXA, FRBAddressModeImplied,                      A | X,         A | X     },
    /* $8B */ { FRBOpcodeTypePHB, FRBAddressModeStack,                        D | S,         S         },
    /* $8C */ { FRBOpcodeTypeSTY, FRBAddressModeAbsolute,                     Y,             0         },
    /* $8D */ { FRBOpcodeTypeSTA, FRBAddressModeAbsolute,                     A,             0         },
    /* $8E */ { FRBOpcodeTypeSTX, FRBAddressModeAbsolute,                     X,             0         },
    /* $8F */ { FRBOpcodeTypeSTA, FRBAddressModeAbsoluteLong,                 A,             0         },

    /* $90 */ { FRBOpcodeTypeBCC, FRBAddressModeProgramCounterRelative,       0,             0         },
    /* $91 */ { FRBOpcodeTypeSTA, FRBAddressModeDirectIndirectIndexedY,       A | D | Y,     0         },
    /* $92 */ { FRBOpcodeTypeSTA, FRBAddressModeDirectIndirect,               A | D,         0         },
    /* $93 */ { FRBOpcodeTypeSTA, FRBAddressModeStackRelativeIndirectIndexed, A | D | Y | S, 0         },
    /* $94 */ { FRBOpcodeTypeSTY, FRBAddressModeDirectIndexedX,               D | X | Y,     0         },
    /* $95 */ { FRBOpcodeTypeSTA, FRBAddressModeDirectIndexedX,               A | D | X,     0         },
    /* $96 */ { FRBOpcodeTypeSTX, FRBAddressModeDirectIndexedY,               D | X | Y,     0         },
    /* $97 */ { FRBOpcodeTypeSTA, FRBAddressModeDirectIndirectLongIndexed,    A | D | Y,     0         },
    /* $98 */ { FRBOpcodeTypeTYA, FRBAddressModeImplied,                      A | Y,         A | Y     },
    /* $99 */ { FRBOpcodeTypeSTA, FRBAddressModeAbsoluteIndexedY,             A | Y,         0         },
    /* $9A */ { FRBOpcodeTypeTXS, FRBAddressModeImplied,                      X | S,         X | S     },
    /* $9B */ { FRBOpcodeTypeTXY, FRBAddressModeImplied,                      X | Y,         X | Y     },
    /* $9C */ { FRBOpcodeTypeSTZ, FRBAddressModeAbsolute,                     0,             0         },
    /* $9D */ { FRBOpcodeTypeSTA, FRBAddressModeAbsoluteIndexedX,             A | X,         0         },
    /* $9E */ { FRBOpcodeTypeSTZ, FRBAddressModeAbsoluteIndexedX,             X,             0         },
    /* $9F */ { FRBOpcodeTypeSTA, FRBAddressModeAbsoluteLongIndexed,          A | X,         0         },

    /* $A0 */ { FRBOpcodeTypeLDY, FRBAddressModeImmediate,                    0,             Y         },
    /* $A1 */ { FRBOpcodeTypeLDA, FRBAddressModeDirectIndexedX,               D | X,         A         },
    /* $A2 */ { FRBOpcodeTypeLDX, FRBAddressModeImmediate,                    0,             X         },
    /* $A3 */ { FRBOpcodeTypeLDA, FRBAddressModeStackRelative,                D | S,         A         },
    /* $A4 */ { FRBOpcodeTypeLDY, FRBAddressModeDirect,                       D,             Y         },
    /* $A9 */ { FRBOpcodeTypeLDA, FRBAddressModeDirect,                       D,             A         },
    /* $A6 */ { FRBOpcodeTypeLDX, FRBAddressModeDirect,                       D,             X         },
    /* $A7 */ { FRBOpcodeTypeLDA, FRBAddressModeDirectIndirectLong,           D,             A         },
    /* $A8 */ { FRBOpcodeTypeTAY, FRBAddressModeImplied,                      A | Y,         A | Y     },
    /* $A9 */ { FRBOpcodeTypeLDA, FRBAddressModeImmediate,                    0,             A         },
    /* $AA */ { FRBOpcodeTypeTAX, FRBAddressModeImplied,                      A | X,         A | X     },
    /* $AB */ { FRBOpcodeTypePLB, FRBAddressModeStack,                        S,             D | S     },
    /* $AC */ { FRBOpcodeTypeLDY, FRBAddressModeAbsolute,                     0,             Y         },
    /* $AD */ { FRBOpcodeTypeLDA, FRBAddressModeAbsolute,                     0,             A         },
    /* $AE */ { FRBOpcodeTypeLDX, FRBAddressModeAbsolute,                     0,             X         },
    /* $AF */ { FRBOpcodeTypeLDA, FRBAddressModeAbsoluteLong,                 0,             A         },

    /* $B0 */ { FRBOpcodeTypeBCS, FRBAddressModeProgramCounterRelative,       0,             0         },
    /* $B1 */ { FRBOpcodeTypeLDA, FRBAddressModeDirectIndirectIndexedY,       D | Y,         A         },
    /* $B2 */ { FRBOpcodeTypeLDA, FRBAddressModeDirectIndirect,               D,             A         },
    /* $B3 */ { FRBOpcodeTypeLDY, FRBAddressModeStackRelativeIndirectIndexed, D | Y | S,     Y         },
    /* $B4 */ { FRBOpcodeTypeLDY, FRBAddressModeDirectIndexedX,               D | X,         Y         },
    /* $B5 */ { FRBOpcodeTypeLDA, FRBAddressModeDirectIndexedX,               D | X,         A         },
    /* $B6 */ { FRBOpcodeTypeLDX, FRBAddressModeDirectIndexedY,               D | Y,         X         },
    /* $B7 */ { FRBOpcodeTypeLDA, FRBAddressModeDirectIndirectLongIndexed,    D | Y,         A         },
    /* $B8 */ { FRBOpcodeTypeCLV, FRBAddressModeImplied,                      0,             0         },
    /* $B9 */ { FRBOpcodeTypeLDA, FRBAddressModeAbsoluteIndexedY,             Y,             A         },
    /* $BA */ { FRBOpcodeTypeTSX, FRBAddressModeImplied,                      X | S,         X | S     },
    /* $BB */ { FRBOpcodeTypeTYX, FRBAddressModeImplied,                      X | Y,         X | Y     },
    /* $BC */ { FRBOpcodeTypeLDY, FRBAddressModeAbsoluteIndexedX,             X,             Y         },
    /* $BD */ { FRBOpcodeTypeLDA, FRBAddressModeAbsoluteIndexedX,             X,             A         },
    /* $BE */ { FRBOpcodeTypeLDX, FRBAddressModeAbsoluteIndexedY,             Y,             X         },
    /* $BF */ { FRBOpcodeTypeLDA, FRBAddressModeAbsoluteLongIndexed,          X,             A         },

    /* $C0 */ { FRBOpcodeTypeCPY, FRBAddressModeImmediate,                    Y,             0         },
    /* $C1 */ { FRBOpcodeTypeCMP, FRBAddressModeDirectIndexedIndirect,        A | D | X,     0         },
    /* $C2 */ { FRBOpcodeTypeREP, FRBAddressModeImmediate,                    0,             0         },
    /* $C3 */ { FRBOpcodeTypeCMP, FRBAddressModeStackRelative,                A | D | S,     0         },
    /* $C4 */ { FRBOpcodeTypeCPY, FRBAddressModeDirect,                       D | Y,         0         },
    /* $C5 */ { FRBOpcodeTypeCMP, FRBAddressModeDirect,                       A | D,         0         },
    /* $C6 */ { FRBOpcodeTypeDEC, FRBAddressModeDirect,                       D,             0         },
    /* $C7 */ { FRBOpcodeTypeCMP, FRBAddressModeDirectIndirectLong,           A | D,         0         },
    /* $C8 */ { FRBOpcodeTypeINY, FRBAddressModeImplied,                      Y,             Y         },
    /* $C9 */ { FRBOpcodeTypeCMP, FRBAddressModeImmediate,                    A,             0         },
    /* $CA */ { FRBOpcodeTypeDEX, FRBAddressModeImplied,                      X,             X         },
    /* $CB */ { FRBOpcodeTypeWAI, FRBAddressModeImplied,                      0,             0         },
    /* $CC */ { FRBOpcodeTypeCPY, FRBAddressModeAbsolute,                     Y,             0         },
    /* $CD */ { FRBOpcodeTypeCMP, FRBAddressModeAbsolute,                     A,             0         },
    /* $CE */ { FRBOpcodeTypeDEC, FRBAddressModeAbsolute,                     A,             A         },
    /* $CF */ { FRBOpcodeTypeCMP, FRBAddressModeAbsoluteLong,                 A,             0         },

    /* $D0 */ { FRBOpcodeTypeBNE, FRBAddressModeProgramCounterRelative,       0,             0         },
    /* $D1 */ { FRBOpcodeTypeCMP, FRBAddressModeDirectIndirectIndexedY,       A | D | Y,     0         },
    /* $D2 */ { FRBOpcodeTypeCMP, FRBAddressModeDirectIndirect,               A | D,         0         },
    /* $D3 */ { FRBOpcodeTypeCMP, FRBAddressModeStackRelativeIndirectIndexed, A | D | Y | S, 0         },
    /* $D4 */ { FRBOpcodeTypePEI, FRBAddressModeDirectIndirect,               S,             S         },
    /* $D5 */ { FRBOpcodeTypeCMP, FRBAddressModeDirectIndexedX,               A | D | X,     0         },
    /* $D6 */ { FRBOpcodeTypeDEC, FRBAddressModeDirectIndexedX,               D | X,         0         },
    /* $D7 */ { FRBOpcodeTypeCMP, FRBAddressModeDirectIndirectLongIndexed,    A | D | Y,     0         },
    /* $D8 */ { FRBOpcodeTypeCLD, FRBAddressModeImplied,                      0,             0         },
    /* $D9 */ { FRBOpcodeTypeCMP, FRBAddressModeAbsoluteIndexedY,             A | Y,         0         },
    /* $DA */ { FRBOpcodeTypePHX, FRBAddressModeStack,                        X,             X | S     },
    /* $DB */ { FRBOpcodeTypeSTP, FRBAddressModeImplied,                      0,             0         },
    /* $DC */ { FRBOpcodeTypeJML, FRBAddressModeAbsoluteIndirect,             0,             0         },
    /* $DD */ { FRBOpcodeTypeCMP, FRBAddressModeAbsoluteIndexedX,             A | X,         0         },
    /* $DE */ { FRBOpcodeTypeDEC, FRBAddressModeAbsoluteIndexedX,             X,             0         },
    /* $DF */ { FRBOpcodeTypeCMP, FRBAddressModeAbsoluteLongIndexed,          A | X,         0         },

    /* $E0 */ { FRBOpcodeTypeCPX, FRBAddressModeImmediate,                    X,             0         },
    /* $E1 */ { FRBOpcodeTypeSBC, FRBAddressModeDirectIndexedIndirect,        A | D | X,     A         },
    /* $E2 */ { FRBOpcodeTypeSEP, FRBAddressModeImmediate,                    0,             0         },
    /* $E3 */ { FRBOpcodeTypeSBC, FRBAddressModeStackRelative,                A | D | S,     A         },
    /* $E4 */ { FRBOpcodeTypeCPX, FRBAddressModeDirect,                       X | D,         0         },
    /* $E5 */ { FRBOpcodeTypeSBC, FRBAddressModeDirect,                       A | D,         A         },
    /* $E6 */ { FRBOpcodeTypeINC, FRBAddressModeDirect,                       D,             0         },
    /* $E7 */ { FRBOpcodeTypeSBC, FRBAddressModeDirectIndirectLong,           A | D,         A         },
    /* $E8 */ { FRBOpcodeTypeINX, FRBAddressModeImplied,                      X,             X         },
    /* $E9 */ { FRBOpcodeTypeSBC, FRBAddressModeImmediate,                    A,             A         },
    /* $EA */ { FRBOpcodeTypeNOP, FRBAddressModeImplied,                      0,             0         },
    /* $EB */ { FRBOpcodeTypeXBA, FRBAddressModeImplied,                      A | B,         A | B     },
    /* $EC */ { FRBOpcodeTypeCPX, FRBAddressModeAbsolute,                     X,             0         },
    /* $ED */ { FRBOpcodeTypeSBC, FRBAddressModeAbsolute,                     A,             A         },
    /* $EE */ { FRBOpcodeTypeINC, FRBAddressModeAbsolute,                     0,             0         },
    /* $EF */ { FRBOpcodeTypeSBC, FRBAddressModeAbsoluteLong,                 A,             A         },

    /* $F0 */ { FRBOpcodeTypeBEQ, FRBAddressModeProgramCounterRelative,       0,             0         },
    /* $F1 */ { FRBOpcodeTypeSBC, FRBAddressModeDirectIndirectIndexedY,       A | D | Y,     A         },
    /* $F2 */ { FRBOpcodeTypeSBC, FRBAddressModeDirectIndirect,               A | D,         A         },
    /* $F3 */ { FRBOpcodeTypeSBC, FRBAddressModeStackRelativeIndirectIndexed, A | D | Y | S, A         },
    /* $F4 */ { FRBOpcodeTypePEA, FRBAddressModeAbsolute,                     S,             S         },
    /* $F5 */ { FRBOpcodeTypeSBC, FRBAddressModeDirectIndexedX,               A | D | X,     A         },
    /* $F6 */ { FRBOpcodeTypeINC, FRBAddressModeDirectIndexedX,               D | X,         0         },
    /* $F7 */ { FRBOpcodeTypeSBC, FRBAddressModeDirectIndirectLongIndexed,    A | D | Y,     A         },
    /* $F8 */ { FRBOpcodeTypeSED, FRBAddressModeImplied,                      0,             0         },
    /* $F9 */ { FRBOpcodeTypeSBC, FRBAddressModeAbsoluteIndexedY,             A | Y,         A         },
    /* $FA */ { FRBOpcodeTypePLX, FRBAddressModeStack,                        S,             X | S     },
    /* $FB */ { FRBOpcodeTypeXCE, FRBAddressModeImplied,                      P,             P         },
    /* $FC */ { FRBOpcodeTypeJSR, FRBAddressModeAbsoluteIndexedIndirect,      X | S,         S         },
    /* $FD */ { FRBOpcodeTypeSBC, FRBAddressModeAbsoluteIndexedX,             A | X,         A         },
    /* $FE */ { FRBOpcodeTypeINC, FRBAddressModeAbsoluteIndexedX,             X,             0         },
    /* $FF */ { FRBOpcodeTypeSBC, FRBAddressModeAbsoluteLongIndexed,          A | X,         A         },
};
