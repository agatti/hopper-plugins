/*
 Copyright (c) 2014-2015, Alessandro Gatti - frob.it
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
    return opcode->type == OpcodeBRK || opcode->type == OpcodeSTP;
}

@end

static const struct FRBOpcode kOpcodeTable[256] = {
    /* $00 */ { OpcodeBRK, ModeStack,                        0,             S | P     },
    /* $01 */ { OpcodeORA, ModeDirectIndexedIndirect,        A | D | X,     A         },
    /* $02 */ { OpcodeCOP, ModeImmediate,                    S,             S         },
    /* $03 */ { OpcodeORA, ModeStackRelative,                A | D | S,     A         },
    /* $04 */ { OpcodeTSB, ModeDirect,                       A | D,         0         },
    /* $05 */ { OpcodeORA, ModeDirect,                       A | D,         A         },
    /* $06 */ { OpcodeASL, ModeDirect,                       D,             0         },
    /* $07 */ { OpcodeORA, ModeDirectIndirectLong,           A | D,         A         },
    /* $08 */ { OpcodePHP, ModeStack,                        P | S,         S         },
    /* $09 */ { OpcodeORA, ModeImmediate,                    A,             A         },
    /* $0A */ { OpcodeASL, ModeAccumulator,                  A,             A         },
    /* $0B */ { OpcodePHD, ModeStack,                        D | S,         S         },
    /* $0C */ { OpcodeTSB, ModeAbsolute,                     A,             0         },
    /* $0D */ { OpcodeORA, ModeAbsolute,                     A,             A         },
    /* $0E */ { OpcodeASL, ModeAbsolute,                     0,             0         },
    /* $0F */ { OpcodeORA, ModeAbsoluteLong,                 A,             A         },

    /* $10 */ { OpcodeBPL, ModeProgramCounterRelative,       0,             0         },
    /* $11 */ { OpcodeORA, ModeDirectIndirectIndexedY,       A | D,         A         },
    /* $12 */ { OpcodeORA, ModeDirectIndirect,               A | D,         A         },
    /* $13 */ { OpcodeORA, ModeStackRelativeIndirectIndexed, A | D | Y | S, A         },
    /* $14 */ { OpcodeTRB, ModeDirect,                       A | D,         0         },
    /* $15 */ { OpcodeORA, ModeDirectIndexedX,               A | D | X,     A         },
    /* $16 */ { OpcodeASL, ModeDirectIndexedX,               D | X,         0         },
    /* $17 */ { OpcodeORA, ModeDirectIndirectLongIndexed,    A | Y,         A         },
    /* $18 */ { OpcodeCLC, ModeImplied,                      0,             0         },
    /* $19 */ { OpcodeORA, ModeAbsoluteIndexedY,             A | Y,         A         },
    /* $1A */ { OpcodeINC, ModeAccumulator,                  A,             A         },
    /* $1B */ { OpcodeTCS, ModeImplied,                      C,             S         },
    /* $1C */ { OpcodeTRB, ModeAbsolute,                     A,             0         },
    /* $1D */ { OpcodeORA, ModeAbsoluteIndexedX,             A | X,         A         },
    /* $1E */ { OpcodeASL, ModeAbsoluteIndexedX,             A | X,         0         },
    /* $1F */ { OpcodeORA, ModeAbsoluteLongIndexed,          A,             A         },

    /* $20 */ { OpcodeJSR, ModeAbsolute,                     0,             0         },
    /* $21 */ { OpcodeAND, ModeDirectIndexedIndirect,        A | D | X,     A         },
    /* $22 */ { OpcodeJSL, ModeAbsoluteLong,                 0,             0         },
    /* $23 */ { OpcodeAND, ModeStackRelativeIndirectIndexed, A | D | Y | S, A         },
    /* $24 */ { OpcodeBIT, ModeDirect,                       A | D,         P         },
    /* $25 */ { OpcodeAND, ModeDirect,                       A | D,         A         },
    /* $26 */ { OpcodeROL, ModeDirect,                       0,             0         },
    /* $27 */ { OpcodeAND, ModeDirectIndirectLong,           A,             A         },
    /* $28 */ { OpcodePLP, ModeStack,                        S,             P | S     },
    /* $29 */ { OpcodeAND, ModeImmediate,                    A,             A         },
    /* $2A */ { OpcodeROL, ModeAccumulator,                  A,             A         },
    /* $2B */ { OpcodePLD, ModeStack,                        S,             D | S     },
    /* $2C */ { OpcodeBIT, ModeAbsolute,                     A,             P         },
    /* $2D */ { OpcodeAND, ModeAbsolute,                     A,             A         },
    /* $2E */ { OpcodeROL, ModeAbsolute,                     0,             0         },
    /* $2F */ { OpcodeAND, ModeAbsoluteLong,                 A,             A         },

    /* $30 */ { OpcodeBMI, ModeProgramCounterRelative,       0,             0         },
    /* $31 */ { OpcodeAND, ModeDirectIndirectIndexedY,       A | D | Y,     A         },
    /* $32 */ { OpcodeAND, ModeDirectIndirect,               A | D,         A         },
    /* $33 */ { OpcodeAND, ModeStackRelativeIndirectIndexed, A | D | S | Y, A         },
    /* $34 */ { OpcodeBIT, ModeDirectIndexedX,               A | D | X,     P         },
    /* $35 */ { OpcodeAND, ModeDirectIndexedX,               A | D | X,     A         },
    /* $36 */ { OpcodeROL, ModeDirectIndexedX,               D | X,         0         },
    /* $37 */ { OpcodeAND, ModeDirectIndirectLongIndexed,    A | D | Y,     A         },
    /* $38 */ { OpcodeSEC, ModeImplied,                      0,             P         },
    /* $39 */ { OpcodeAND, ModeAbsoluteIndexedY,             A | Y,         A         },
    /* $3A */ { OpcodeDEC, ModeAccumulator,                  A,             A         },
    /* $3B */ { OpcodeTSC, ModeImplied,                      S,             C         },
    /* $3C */ { OpcodeBIT, ModeAbsoluteIndexedX,             A | X,         P         },
    /* $3D */ { OpcodeAND, ModeAbsoluteIndexedX,             A | X,         A         },
    /* $3E */ { OpcodeROL, ModeAbsoluteIndexedX,             A | X,         0         },
    /* $3F */ { OpcodeAND, ModeAbsoluteLongIndexed,          A | X,         A         },

    /* $40 */ { OpcodeRTI, ModeStack,                        0,             0         },
    /* $41 */ { OpcodeEOR, ModeDirectIndexedX,               A | D | X,     A         },
    /* $42 */ { OpcodeWDM, ModeImplied,                      0,             0         },
    /* $43 */ { OpcodeEOR, ModeStackRelative,                A | D | S,     A         },
    /* $44 */ { OpcodeMVP, ModeBlockMove,                    C | X | Y,     C | X | Y },
    /* $45 */ { OpcodeEOR, ModeDirect,                       A | D,         A         },
    /* $46 */ { OpcodeLSR, ModeDirect,                       D,             0         },
    /* $47 */ { OpcodeEOR, ModeDirectIndirectLong,           A | D,         A         },
    /* $48 */ { OpcodePHA, ModeStack,                        A | S,         S         },
    /* $49 */ { OpcodeEOR, ModeImmediate,                    A,             A         },
    /* $4A */ { OpcodeLSR, ModeAccumulator,                  A,             A         },
    /* $4B */ { OpcodePHK, ModeStack,                        PBR | S,       S         },
    /* $4C */ { OpcodeJMP, ModeAbsolute,                     0,             0         },
    /* $4D */ { OpcodeEOR, ModeAbsolute,                     A,             A         },
    /* $4E */ { OpcodeLSR, ModeAbsolute,                     0,             0         },
    /* $4F */ { OpcodeEOR, ModeAbsoluteLong,                 A,             A         },

    /* $50 */ { OpcodeBVC, ModeProgramCounterRelative,       0,             0         },
    /* $51 */ { OpcodeEOR, ModeDirectIndirectIndexedY,       A | D | Y,     A         },
    /* $52 */ { OpcodeEOR, ModeDirectIndirect,               A | D,         A         },
    /* $53 */ { OpcodeEOR, ModeStackRelativeIndirectIndexed, A | D | S | Y, A         },
    /* $54 */ { OpcodeMVN, ModeBlockMove,                    C | X | Y,     C | X | Y },
    /* $55 */ { OpcodeEOR, ModeDirectIndexedX,               A | D | X,     A         },
    /* $56 */ { OpcodeLSR, ModeDirectIndexedX,               X | D,         0         },
    /* $57 */ { OpcodeEOR, ModeDirectIndirectLongIndexed,    A | D | Y,     A         },
    /* $58 */ { OpcodeCLI, ModeImplied,                      0,             0         },
    /* $59 */ { OpcodeEOR, ModeAbsoluteIndexedY,             A | Y,         A         },
    /* $5A */ { OpcodePHY, ModeStack,                        Y | S,         S         },
    /* $5B */ { OpcodeTCD, ModeImplied,                      A,             D         },
    /* $5C */ { OpcodeJML, ModeAbsoluteLong,                 0,             0         },
    /* $5D */ { OpcodeEOR, ModeAbsoluteIndexedX,             A | X,         A         },
    /* $5E */ { OpcodeLSR, ModeAbsoluteIndexedX,             A | X,         0         },
    /* $5F */ { OpcodeEOR, ModeAbsoluteLongIndexed,          A | X,         A         },

    /* $60 */ { OpcodeRTS, ModeStack,                        0,             0         },
    /* $61 */ { OpcodeADC, ModeDirectIndexedIndirect,        0,             0         },
    /* $62 */ { OpcodePER, ModeProgramCounterRelativeLong,   S,             S         },
    /* $63 */ { OpcodeADC, ModeStackRelative,                A | D | S,     A         },
    /* $64 */ { OpcodeSTZ, ModeDirect,                       0,             0         },
    /* $65 */ { OpcodeADC, ModeDirect,                       A | D,         A         },
    /* $66 */ { OpcodeROR, ModeDirect,                       0,             0         },
    /* $67 */ { OpcodeADC, ModeDirectIndirectLong,           A | D,         A         },
    /* $68 */ { OpcodePLA, ModeStack,                        S,             A | S     },
    /* $69 */ { OpcodeADC, ModeImmediate,                    A,             A         },
    /* $6A */ { OpcodeROR, ModeAccumulator,                  A,             A         },
    /* $6B */ { OpcodeRTL, ModeStack,                        0,             0         },
    /* $6C */ { OpcodeJMP, ModeAbsoluteIndirect,             0,             0         },
    /* $6D */ { OpcodeADC, ModeAbsolute,                     A,             A         },
    /* $6E */ { OpcodeROR, ModeAbsolute,                     0,             0         },
    /* $6F */ { OpcodeADC, ModeAbsoluteLong,                 A,             A         },

    /* $70 */ { OpcodeBVS, ModeProgramCounterRelative,       0,             0         },
    /* $71 */ { OpcodeADC, ModeDirectIndirectIndexedY,       A | D | Y,     A         },
    /* $72 */ { OpcodeADC, ModeDirectIndirect,               A | D,         A         },
    /* $73 */ { OpcodeADC, ModeStackRelativeIndirectIndexed, A | D | Y | S, A         },
    /* $74 */ { OpcodeSTZ, ModeDirectIndexedX,               A | D | X,     0         },
    /* $75 */ { OpcodeADC, ModeDirectIndexedX,               A | D | X,     A         },
    /* $76 */ { OpcodeROR, ModeDirectIndexedX,               A | D | X,     0         },
    /* $77 */ { OpcodeADC, ModeDirectIndirectLongIndexed,    A | D | Y,     A         },
    /* $78 */ { OpcodeSEI, ModeImplied,                      0,             0         },
    /* $79 */ { OpcodeADC, ModeAbsoluteIndexedY,             A | Y,         A         },
    /* $7A */ { OpcodePLY, ModeStack,                        S,             Y | S     },
    /* $7B */ { OpcodeTDC, ModeImplied,                      C | D,         C | D     },
    /* $7C */ { OpcodeJMP, ModeAbsoluteIndexedIndirect,      X,             0         },
    /* $7D */ { OpcodeADC, ModeAbsoluteIndexedX,             A | X,         A         },
    /* $7E */ { OpcodeROR, ModeAbsoluteIndexedX,             X,             0         },
    /* $7F */ { OpcodeADC, ModeAbsoluteLongIndexed,          A | X,         A         },

    /* $80 */ { OpcodeBRA, ModeProgramCounterRelative,       0,             0         },
    /* $81 */ { OpcodeSTA, ModeDirectIndexedIndirect,        A | D | X,     0         },
    /* $82 */ { OpcodeBRL, ModeProgramCounterRelativeLong,   0,             0         },
    /* $83 */ { OpcodeSTA, ModeStackRelative,                A | D | S,     0         },
    /* $84 */ { OpcodeSTY, ModeDirect,                       Y | D,         0         },
    /* $85 */ { OpcodeSTA, ModeDirect,                       A | D,         0         },
    /* $86 */ { OpcodeSTX, ModeDirect,                       X | D,         0         },
    /* $87 */ { OpcodeSTA, ModeDirectIndirectLong,           A | D,         0         },
    /* $88 */ { OpcodeDEY, ModeImplied,                      Y,             Y         },
    /* $89 */ { OpcodeBIT, ModeImmediate,                    A,             0         },
    /* $8A */ { OpcodeTXA, ModeImplied,                      A | X,         A | X     },
    /* $8B */ { OpcodePHB, ModeStack,                        D | S,         S         },
    /* $8C */ { OpcodeSTY, ModeAbsolute,                     Y,             0         },
    /* $8D */ { OpcodeSTA, ModeAbsolute,                     A,             0         },
    /* $8E */ { OpcodeSTX, ModeAbsolute,                     X,             0         },
    /* $8F */ { OpcodeSTA, ModeAbsoluteLong,                 A,             0         },

    /* $90 */ { OpcodeBCC, ModeProgramCounterRelative,       0,             0         },
    /* $91 */ { OpcodeSTA, ModeDirectIndirectIndexedY,       A | D | Y,     0         },
    /* $92 */ { OpcodeSTA, ModeDirectIndirect,               A | D,         0         },
    /* $93 */ { OpcodeSTA, ModeStackRelativeIndirectIndexed, A | D | Y | S, 0         },
    /* $94 */ { OpcodeSTY, ModeDirectIndexedX,               D | X | Y,     0         },
    /* $95 */ { OpcodeSTA, ModeDirectIndexedX,               A | D | X,     0         },
    /* $96 */ { OpcodeSTX, ModeDirectIndexedY,               D | X | Y,     0         },
    /* $97 */ { OpcodeSTA, ModeDirectIndirectLongIndexed,    A | D | Y,     0         },
    /* $98 */ { OpcodeTYA, ModeImplied,                      A | Y,         A | Y     },
    /* $99 */ { OpcodeSTA, ModeAbsoluteIndexedY,             A | Y,         0         },
    /* $9A */ { OpcodeTXS, ModeImplied,                      X | S,         X | S     },
    /* $9B */ { OpcodeTXY, ModeImplied,                      X | Y,         X | Y     },
    /* $9C */ { OpcodeSTZ, ModeAbsolute,                     0,             0         },
    /* $9D */ { OpcodeSTA, ModeAbsoluteIndexedX,             A | X,         0         },
    /* $9E */ { OpcodeSTZ, ModeAbsoluteIndexedX,             X,             0         },
    /* $9F */ { OpcodeSTA, ModeAbsoluteLongIndexed,          A | X,         0         },

    /* $A0 */ { OpcodeLDY, ModeImmediate,                    0,             Y         },
    /* $A1 */ { OpcodeLDA, ModeDirectIndexedX,               D | X,         A         },
    /* $A2 */ { OpcodeLDX, ModeImmediate,                    0,             X         },
    /* $A3 */ { OpcodeLDA, ModeStackRelative,                D | S,         A         },
    /* $A4 */ { OpcodeLDY, ModeDirect,                       D,             Y         },
    /* $A9 */ { OpcodeLDA, ModeDirect,                       D,             A         },
    /* $A6 */ { OpcodeLDX, ModeDirect,                       D,             X         },
    /* $A7 */ { OpcodeLDA, ModeDirectIndirectLong,           D,             A         },
    /* $A8 */ { OpcodeTAY, ModeImplied,                      A | Y,         A | Y     },
    /* $A9 */ { OpcodeLDA, ModeImmediate,                    0,             A         },
    /* $AA */ { OpcodeTAX, ModeImplied,                      A | X,         A | X     },
    /* $AB */ { OpcodePLB, ModeStack,                        S,             D | S     },
    /* $AC */ { OpcodeLDY, ModeAbsolute,                     0,             Y         },
    /* $AD */ { OpcodeLDA, ModeAbsolute,                     0,             A         },
    /* $AE */ { OpcodeLDX, ModeAbsolute,                     0,             X         },
    /* $AF */ { OpcodeLDA, ModeAbsoluteLong,                 0,             A         },

    /* $B0 */ { OpcodeBCS, ModeProgramCounterRelative,       0,             0         },
    /* $B1 */ { OpcodeLDA, ModeDirectIndirectIndexedY,       D | Y,         A         },
    /* $B2 */ { OpcodeLDA, ModeDirectIndirect,               D,             A         },
    /* $B3 */ { OpcodeLDY, ModeStackRelativeIndirectIndexed, D | Y | S,     Y         },
    /* $B4 */ { OpcodeLDY, ModeDirectIndexedX,               D | X,         Y         },
    /* $B5 */ { OpcodeLDA, ModeDirectIndexedX,               D | X,         A         },
    /* $B6 */ { OpcodeLDX, ModeDirectIndexedY,               D | Y,         X         },
    /* $B7 */ { OpcodeLDA, ModeDirectIndirectLongIndexed,    D | Y,         A         },
    /* $B8 */ { OpcodeCLV, ModeImplied,                      0,             0         },
    /* $B9 */ { OpcodeLDA, ModeAbsoluteIndexedY,             Y,             A         },
    /* $BA */ { OpcodeTSX, ModeImplied,                      X | S,         X | S     },
    /* $BB */ { OpcodeTYX, ModeImplied,                      X | Y,         X | Y     },
    /* $BC */ { OpcodeLDY, ModeAbsoluteIndexedX,             X,             Y         },
    /* $BD */ { OpcodeLDA, ModeAbsoluteIndexedX,             X,             A         },
    /* $BE */ { OpcodeLDX, ModeAbsoluteIndexedY,             Y,             X         },
    /* $BF */ { OpcodeLDA, ModeAbsoluteLongIndexed,          X,             A         },

    /* $C0 */ { OpcodeCPY, ModeImmediate,                    Y,             0         },
    /* $C1 */ { OpcodeCMP, ModeDirectIndexedIndirect,        A | D | X,     0         },
    /* $C2 */ { OpcodeREP, ModeImmediate,                    0,             0         },
    /* $C3 */ { OpcodeCMP, ModeStackRelative,                A | D | S,     0         },
    /* $C4 */ { OpcodeCPY, ModeDirect,                       D | Y,         0         },
    /* $C5 */ { OpcodeCMP, ModeDirect,                       A | D,         0         },
    /* $C6 */ { OpcodeDEC, ModeDirect,                       D,             0         },
    /* $C7 */ { OpcodeCMP, ModeDirectIndirectLong,           A | D,         0         },
    /* $C8 */ { OpcodeINY, ModeImplied,                      Y,             Y         },
    /* $C9 */ { OpcodeCMP, ModeImmediate,                    A,             0         },
    /* $CA */ { OpcodeDEX, ModeImplied,                      X,             X         },
    /* $CB */ { OpcodeWAI, ModeImplied,                      0,             0         },
    /* $CC */ { OpcodeCPY, ModeAbsolute,                     Y,             0         },
    /* $CD */ { OpcodeCMP, ModeAbsolute,                     A,             0         },
    /* $CE */ { OpcodeDEC, ModeAbsolute,                     A,             A         },
    /* $CF */ { OpcodeCMP, ModeAbsoluteLong,                 A,             0         },

    /* $D0 */ { OpcodeBNE, ModeProgramCounterRelative,       0,             0         },
    /* $D1 */ { OpcodeCMP, ModeDirectIndirectIndexedY,       A | D | Y,     0         },
    /* $D2 */ { OpcodeCMP, ModeDirectIndirect,               A | D,         0         },
    /* $D3 */ { OpcodeCMP, ModeStackRelativeIndirectIndexed, A | D | Y | S, 0         },
    /* $D4 */ { OpcodePEI, ModeDirectIndirect,               S,             S         },
    /* $D5 */ { OpcodeCMP, ModeDirectIndexedX,               A | D | X,     0         },
    /* $D6 */ { OpcodeDEC, ModeDirectIndexedX,               D | X,         0         },
    /* $D7 */ { OpcodeCMP, ModeDirectIndirectLongIndexed,    A | D | Y,     0         },
    /* $D8 */ { OpcodeCLD, ModeImplied,                      0,             0         },
    /* $D9 */ { OpcodeCMP, ModeAbsoluteIndexedY,             A | Y,         0         },
    /* $DA */ { OpcodePHX, ModeStack,                        X,             X | S     },
    /* $DB */ { OpcodeSTP, ModeImplied,                      0,             0         },
    /* $DC */ { OpcodeJML, ModeAbsoluteIndirect,             0,             0         },
    /* $DD */ { OpcodeCMP, ModeAbsoluteIndexedX,             A | X,         0         },
    /* $DE */ { OpcodeDEC, ModeAbsoluteIndexedX,             X,             0         },
    /* $DF */ { OpcodeCMP, ModeAbsoluteLongIndexed,          A | X,         0         },

    /* $E0 */ { OpcodeCPX, ModeImmediate,                    X,             0         },
    /* $E1 */ { OpcodeSBC, ModeDirectIndexedIndirect,        A | D | X,     A         },
    /* $E2 */ { OpcodeSEP, ModeImmediate,                    0,             0         },
    /* $E3 */ { OpcodeSBC, ModeStackRelative,                A | D | S,     A         },
    /* $E4 */ { OpcodeCPX, ModeDirect,                       X | D,         0         },
    /* $E5 */ { OpcodeSBC, ModeDirect,                       A | D,         A         },
    /* $E6 */ { OpcodeINC, ModeDirect,                       D,             0         },
    /* $E7 */ { OpcodeSBC, ModeDirectIndirectLong,           A | D,         A         },
    /* $E8 */ { OpcodeINX, ModeImplied,                      X,             X         },
    /* $E9 */ { OpcodeSBC, ModeImmediate,                    A,             A         },
    /* $EA */ { OpcodeNOP, ModeImplied,                      0,             0         },
    /* $EB */ { OpcodeXBA, ModeImplied,                      A | B,         A | B     },
    /* $EC */ { OpcodeCPX, ModeAbsolute,                     X,             0         },
    /* $ED */ { OpcodeSBC, ModeAbsolute,                     A,             A         },
    /* $EE */ { OpcodeINC, ModeAbsolute,                     0,             0         },
    /* $EF */ { OpcodeSBC, ModeAbsoluteLong,                 A,             A         },

    /* $F0 */ { OpcodeBEQ, ModeProgramCounterRelative,       0,             0         },
    /* $F1 */ { OpcodeSBC, ModeDirectIndirectIndexedY,       A | D | Y,     A         },
    /* $F2 */ { OpcodeSBC, ModeDirectIndirect,               A | D,         A         },
    /* $F3 */ { OpcodeSBC, ModeStackRelativeIndirectIndexed, A | D | Y | S, A         },
    /* $F4 */ { OpcodePEA, ModeAbsolute,                     S,             S         },
    /* $F5 */ { OpcodeSBC, ModeDirectIndexedX,               A | D | X,     A         },
    /* $F6 */ { OpcodeINC, ModeDirectIndexedX,               D | X,         0         },
    /* $F7 */ { OpcodeSBC, ModeDirectIndirectLongIndexed,    A | D | Y,     A         },
    /* $F8 */ { OpcodeSED, ModeImplied,                      0,             0         },
    /* $F9 */ { OpcodeSBC, ModeAbsoluteIndexedY,             A | Y,         A         },
    /* $FA */ { OpcodePLX, ModeStack,                        S,             X | S     },
    /* $FB */ { OpcodeXCE, ModeImplied,                      P,             P         },
    /* $FC */ { OpcodeJSR, ModeAbsoluteIndexedIndirect,      X | S,         S         },
    /* $FD */ { OpcodeSBC, ModeAbsoluteIndexedX,             A | X,         A         },
    /* $FE */ { OpcodeINC, ModeAbsoluteIndexedX,             X,             0         },
    /* $FF */ { OpcodeSBC, ModeAbsoluteLongIndexed,          A | X,         A         },
};
