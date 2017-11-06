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

#import "Generic65816.h"
#import "Common.h"
#import "Core.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static const Opcode kOpcodeTable[256];

static NSData *_Nonnull kNOPSequence;

@implementation ItFrobHopper65816Generic65816

+ (void)load {
  const uint8_t kNOPByte = 0xEA;
  kNOPSequence = [NSData dataWithBytes:(const void *)&kNOPByte length:1];
}

+ (NSString *_Nonnull)family {
  return @"Generic";
}

+ (NSString *_Nonnull)model {
  return @"65816";
}

+ (BOOL)exported {
  return YES;
}

+ (int)addressSpaceWidth {
  return 24;
}

- (const Opcode *_Nonnull)
  opcodeForFile:(NSObject<HPDisassembledFile> *_Nonnull)file
      atAddress:(Address)address
andFillMetadata:(FRBInstructionUserData *_Nonnull)metadata {

  uint8_t byte = [file readUInt8AtVirtualAddress:address];
  metadata->wideOpcode = NO;
  return &kOpcodeTable[byte];
}

+ (NSData *_Nonnull)nopOpcodeSignature {
  return kNOPSequence;
}

@end

static const Opcode kOpcodeTable[256] = {
    {OpcodeBRK, ModeStack, N, S | P, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndexedIndirect, A | D | X, A, AccumulatorDefault},
    {OpcodeCOP, ModeImmediate, S, S, AccumulatorDefault},
    {OpcodeORA, ModeStackRelative, A | D | S, A, AccumulatorDefault},
    {OpcodeTSB, ModeDirect, A | D, N, AccumulatorDefault},
    {OpcodeORA, ModeDirect, A | D, A, AccumulatorDefault},
    {OpcodeASL, ModeDirect, D, N, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndirectLong, A | D, A, AccumulatorDefault},
    {OpcodePHP, ModeStack, P | S, S, AccumulatorDefault},
    {OpcodeORA, ModeImmediate, A, A, AccumulatorDefault},
    {OpcodeASL, ModeAccumulator, A, A, AccumulatorDefault},
    {OpcodePHD, ModeStack, D | S, S, AccumulatorDefault},
    {OpcodeTSB, ModeAbsolute, A, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsolute, A, A, AccumulatorDefault},
    {OpcodeASL, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsoluteLong, A, A, AccumulatorDefault},
    {OpcodeBPL, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndirectIndexedY, A | D, A, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndirect, A | D, A, AccumulatorDefault},
    {OpcodeORA, ModeStackRelativeIndirectIndexed, A | D | Y | S, A,
     AccumulatorDefault},
    {OpcodeTRB, ModeDirect, A | D, N, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndexedX, A | D | X, A, AccumulatorDefault},
    {OpcodeASL, ModeDirectIndexedX, D | X, N, AccumulatorDefault},
    {OpcodeORA, ModeDirectIndirectLongIndexed, A | Y, A, AccumulatorDefault},
    {OpcodeCLC, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsoluteIndexedY, A | Y, A, AccumulatorDefault},
    {OpcodeINC, ModeAccumulator, A, A, AccumulatorDefault},
    {OpcodeTCS, ModeImplied, C, S, AccumulatorDefault},
    {OpcodeTRB, ModeAbsolute, A, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsoluteIndexedX, A | X, A, AccumulatorDefault},
    {OpcodeASL, ModeAbsoluteIndexedX, A | X, N, AccumulatorDefault},
    {OpcodeORA, ModeAbsoluteLongIndexed, A, A, AccumulatorDefault},
    {OpcodeJSR, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndexedIndirect, A | D | X, A, AccumulatorDefault},
    {OpcodeJSL, ModeAbsoluteLong, N, N, AccumulatorDefault},
    {OpcodeAND, ModeStackRelativeIndirectIndexed, A | D | Y | S, A,
     AccumulatorDefault},
    {OpcodeBIT, ModeDirect, A | D, P, AccumulatorDefault},
    {OpcodeAND, ModeDirect, A | D, A, AccumulatorDefault},
    {OpcodeROL, ModeDirect, N, N, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndirectLong, A, A, AccumulatorDefault},
    {OpcodePLP, ModeStack, S, P | S, AccumulatorDefault},
    {OpcodeAND, ModeImmediate, A, A, AccumulatorDefault},
    {OpcodeROL, ModeAccumulator, A, A, AccumulatorDefault},
    {OpcodePLD, ModeStack, S, D | S, AccumulatorDefault},
    {OpcodeBIT, ModeAbsolute, A, P, AccumulatorDefault},
    {OpcodeAND, ModeAbsolute, A, A, AccumulatorDefault},
    {OpcodeROL, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeAND, ModeAbsoluteLong, A, A, AccumulatorDefault},
    {OpcodeBMI, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndirectIndexedY, A | D | Y, A, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndirect, A | D, A, AccumulatorDefault},
    {OpcodeAND, ModeStackRelativeIndirectIndexed, A | D | S | Y, A,
     AccumulatorDefault},
    {OpcodeBIT, ModeDirectIndexedX, A | D | X, P, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndexedX, A | D | X, A, AccumulatorDefault},
    {OpcodeROL, ModeDirectIndexedX, D | X, N, AccumulatorDefault},
    {OpcodeAND, ModeDirectIndirectLongIndexed, A | D | Y, A,
     AccumulatorDefault},
    {OpcodeSEC, ModeImplied, N, P, AccumulatorDefault},
    {OpcodeAND, ModeAbsoluteIndexedY, A | Y, A, AccumulatorDefault},
    {OpcodeDEC, ModeAccumulator, A, A, AccumulatorDefault},
    {OpcodeTSC, ModeImplied, S, C, AccumulatorDefault},
    {OpcodeBIT, ModeAbsoluteIndexedX, A | X, P, AccumulatorDefault},
    {OpcodeAND, ModeAbsoluteIndexedX, A | X, A, AccumulatorDefault},
    {OpcodeROL, ModeAbsoluteIndexedX, A | X, N, AccumulatorDefault},
    {OpcodeAND, ModeAbsoluteLongIndexed, A | X, A, AccumulatorDefault},
    {OpcodeRTI, ModeStack, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndexedX, A | D | X, A, AccumulatorDefault},
    {OpcodeWDM, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeStackRelative, A | D | S, A, AccumulatorDefault},
    {OpcodeMVP, ModeBlockMove, C | X | Y, C | X | Y, AccumulatorDefault},
    {OpcodeEOR, ModeDirect, A | D, A, AccumulatorDefault},
    {OpcodeLSR, ModeDirect, D, N, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndirectLong, A | D, A, AccumulatorDefault},
    {OpcodePHA, ModeStack, A | S, S, AccumulatorDefault},
    {OpcodeEOR, ModeImmediate, A, A, AccumulatorDefault},
    {OpcodeLSR, ModeAccumulator, A, A, AccumulatorDefault},
    {OpcodePHK, ModeStack, PBR | S, S, AccumulatorDefault},
    {OpcodeJMP, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsolute, A, A, AccumulatorDefault},
    {OpcodeLSR, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsoluteLong, A, A, AccumulatorDefault},
    {OpcodeBVC, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndirectIndexedY, A | D | Y, A, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndirect, A | D, A, AccumulatorDefault},
    {OpcodeEOR, ModeStackRelativeIndirectIndexed, A | D | S | Y, A,
     AccumulatorDefault},
    {OpcodeMVN, ModeBlockMove, C | X | Y, C | X | Y, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndexedX, A | D | X, A, AccumulatorDefault},
    {OpcodeLSR, ModeDirectIndexedX, X | D, N, AccumulatorDefault},
    {OpcodeEOR, ModeDirectIndirectLongIndexed, A | D | Y, A,
     AccumulatorDefault},
    {OpcodeCLI, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsoluteIndexedY, A | Y, A, AccumulatorDefault},
    {OpcodePHY, ModeStack, Y | S, S, AccumulatorDefault},
    {OpcodeTCD, ModeImplied, A, D, AccumulatorDefault},
    {OpcodeJML, ModeAbsoluteLong, N, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsoluteIndexedX, A | X, A, AccumulatorDefault},
    {OpcodeLSR, ModeAbsoluteIndexedX, A | X, N, AccumulatorDefault},
    {OpcodeEOR, ModeAbsoluteLongIndexed, A | X, A, AccumulatorDefault},
    {OpcodeRTS, ModeStack, N, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndexedIndirect, N, N, AccumulatorDefault},
    {OpcodePER, ModeProgramCounterRelativeLong, S, S, AccumulatorDefault},
    {OpcodeADC, ModeStackRelative, A | D | S, A, AccumulatorDefault},
    {OpcodeSTZ, ModeDirect, N, N, AccumulatorDefault},
    {OpcodeADC, ModeDirect, A | D, A, AccumulatorDefault},
    {OpcodeROR, ModeDirect, N, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndirectLong, A | D, A, AccumulatorDefault},
    {OpcodePLA, ModeStack, S, A | S, AccumulatorDefault},
    {OpcodeADC, ModeImmediate, A, A, AccumulatorDefault},
    {OpcodeROR, ModeAccumulator, A, A, AccumulatorDefault},
    {OpcodeRTL, ModeStack, N, N, AccumulatorDefault},
    {OpcodeJMP, ModeAbsoluteIndirect, N, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsolute, A, A, AccumulatorDefault},
    {OpcodeROR, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsoluteLong, A, A, AccumulatorDefault},
    {OpcodeBVS, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndirectIndexedY, A | D | Y, A, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndirect, A | D, A, AccumulatorDefault},
    {OpcodeADC, ModeStackRelativeIndirectIndexed, A | D | Y | S, A,
     AccumulatorDefault},
    {OpcodeSTZ, ModeDirectIndexedX, A | D | X, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndexedX, A | D | X, A, AccumulatorDefault},
    {OpcodeROR, ModeDirectIndexedX, A | D | X, N, AccumulatorDefault},
    {OpcodeADC, ModeDirectIndirectLongIndexed, A | D | Y, A,
     AccumulatorDefault},
    {OpcodeSEI, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsoluteIndexedY, A | Y, A, AccumulatorDefault},
    {OpcodePLY, ModeStack, S, Y | S, AccumulatorDefault},
    {OpcodeTDC, ModeImplied, C | D, C | D, AccumulatorDefault},
    {OpcodeJMP, ModeAbsoluteIndexedIndirect, X, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsoluteIndexedX, A | X, A, AccumulatorDefault},
    {OpcodeROR, ModeAbsoluteIndexedX, X, N, AccumulatorDefault},
    {OpcodeADC, ModeAbsoluteLongIndexed, A | X, A, AccumulatorDefault},
    {OpcodeBRA, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndexedIndirect, A | D | X, N, AccumulatorDefault},
    {OpcodeBRL, ModeProgramCounterRelativeLong, N, N, AccumulatorDefault},
    {OpcodeSTA, ModeStackRelative, A | D | S, N, AccumulatorDefault},
    {OpcodeSTY, ModeDirect, Y | D, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirect, A | D, N, AccumulatorDefault},
    {OpcodeSTX, ModeDirect, X | D, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndirectLong, A | D, N, AccumulatorDefault},
    {OpcodeDEY, ModeImplied, Y, Y, AccumulatorDefault},
    {OpcodeBIT, ModeImmediate, A, N, AccumulatorDefault},
    {OpcodeTXA, ModeImplied, A | X, A | X, AccumulatorDefault},
    {OpcodePHB, ModeStack, D | S, S, AccumulatorDefault},
    {OpcodeSTY, ModeAbsolute, Y, N, AccumulatorDefault},
    {OpcodeSTA, ModeAbsolute, A, N, AccumulatorDefault},
    {OpcodeSTX, ModeAbsolute, X, N, AccumulatorDefault},
    {OpcodeSTA, ModeAbsoluteLong, A, N, AccumulatorDefault},
    {OpcodeBCC, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndirectIndexedY, A | D | Y, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndirect, A | D, N, AccumulatorDefault},
    {OpcodeSTA, ModeStackRelativeIndirectIndexed, A | D | Y | S, N,
     AccumulatorDefault},
    {OpcodeSTY, ModeDirectIndexedX, D | X | Y, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndexedX, A | D | X, N, AccumulatorDefault},
    {OpcodeSTX, ModeDirectIndexedY, D | X | Y, N, AccumulatorDefault},
    {OpcodeSTA, ModeDirectIndirectLongIndexed, A | D | Y, N,
     AccumulatorDefault},
    {OpcodeTYA, ModeImplied, A | Y, A | Y, AccumulatorDefault},
    {OpcodeSTA, ModeAbsoluteIndexedY, A | Y, N, AccumulatorDefault},
    {OpcodeTXS, ModeImplied, X | S, X | S, AccumulatorDefault},
    {OpcodeTXY, ModeImplied, X | Y, X | Y, AccumulatorDefault},
    {OpcodeSTZ, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeSTA, ModeAbsoluteIndexedX, A | X, N, AccumulatorDefault},
    {OpcodeSTZ, ModeAbsoluteIndexedX, X, N, AccumulatorDefault},
    {OpcodeSTA, ModeAbsoluteLongIndexed, A | X, N, AccumulatorDefault},
    {OpcodeLDY, ModeImmediate, N, Y, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndexedX, D | X, A, AccumulatorDefault},
    {OpcodeLDX, ModeImmediate, N, X, AccumulatorDefault},
    {OpcodeLDA, ModeStackRelative, D | S, A, AccumulatorDefault},
    {OpcodeLDY, ModeDirect, D, Y, AccumulatorDefault},
    {OpcodeLDA, ModeDirect, D, A, AccumulatorDefault},
    {OpcodeLDX, ModeDirect, D, X, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndirectLong, D, A, AccumulatorDefault},
    {OpcodeTAY, ModeImplied, A | Y, A | Y, AccumulatorDefault},
    {OpcodeLDA, ModeImmediate, N, A, AccumulatorDefault},
    {OpcodeTAX, ModeImplied, A | X, A | X, AccumulatorDefault},
    {OpcodePLB, ModeStack, S, D | S, AccumulatorDefault},
    {OpcodeLDY, ModeAbsolute, N, Y, AccumulatorDefault},
    {OpcodeLDA, ModeAbsolute, N, A, AccumulatorDefault},
    {OpcodeLDX, ModeAbsolute, N, X, AccumulatorDefault},
    {OpcodeLDA, ModeAbsoluteLong, N, A, AccumulatorDefault},
    {OpcodeBCS, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndirectIndexedY, D | Y, A, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndirect, D, A, AccumulatorDefault},
    {OpcodeLDY, ModeStackRelativeIndirectIndexed, D | Y | S, Y,
     AccumulatorDefault},
    {OpcodeLDY, ModeDirectIndexedX, D | X, Y, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndexedX, D | X, A, AccumulatorDefault},
    {OpcodeLDX, ModeDirectIndexedY, D | Y, X, AccumulatorDefault},
    {OpcodeLDA, ModeDirectIndirectLongIndexed, D | Y, A, AccumulatorDefault},
    {OpcodeCLV, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeLDA, ModeAbsoluteIndexedY, Y, A, AccumulatorDefault},
    {OpcodeTSX, ModeImplied, X | S, X | S, AccumulatorDefault},
    {OpcodeTYX, ModeImplied, X | Y, X | Y, AccumulatorDefault},
    {OpcodeLDY, ModeAbsoluteIndexedX, X, Y, AccumulatorDefault},
    {OpcodeLDA, ModeAbsoluteIndexedX, X, A, AccumulatorDefault},
    {OpcodeLDX, ModeAbsoluteIndexedY, Y, X, AccumulatorDefault},
    {OpcodeLDA, ModeAbsoluteLongIndexed, X, A, AccumulatorDefault},
    {OpcodeCPY, ModeImmediate, Y, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndexedIndirect, A | D | X, N, AccumulatorDefault},
    {OpcodeREP, ModeImmediate, N, N, AccumulatorDefault},
    {OpcodeCMP, ModeStackRelative, A | D | S, N, AccumulatorDefault},
    {OpcodeCPY, ModeDirect, D | Y, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirect, A | D, N, AccumulatorDefault},
    {OpcodeDEC, ModeDirect, D, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndirectLong, A | D, N, AccumulatorDefault},
    {OpcodeINY, ModeImplied, Y, Y, AccumulatorDefault},
    {OpcodeCMP, ModeImmediate, A, N, AccumulatorDefault},
    {OpcodeDEX, ModeImplied, X, X, AccumulatorDefault},
    {OpcodeWAI, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeCPY, ModeAbsolute, Y, N, AccumulatorDefault},
    {OpcodeCMP, ModeAbsolute, A, N, AccumulatorDefault},
    {OpcodeDEC, ModeAbsolute, A, A, AccumulatorDefault},
    {OpcodeCMP, ModeAbsoluteLong, A, N, AccumulatorDefault},
    {OpcodeBNE, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndirectIndexedY, A | D | Y, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndirect, A | D, N, AccumulatorDefault},
    {OpcodeCMP, ModeStackRelativeIndirectIndexed, A | D | Y | S, N,
     AccumulatorDefault},
    {OpcodePEI, ModeDirectIndirect, S, S, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndexedX, A | D | X, N, AccumulatorDefault},
    {OpcodeDEC, ModeDirectIndexedX, D | X, N, AccumulatorDefault},
    {OpcodeCMP, ModeDirectIndirectLongIndexed, A | D | Y, N,
     AccumulatorDefault},
    {OpcodeCLD, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeCMP, ModeAbsoluteIndexedY, A | Y, N, AccumulatorDefault},
    {OpcodePHX, ModeStack, X, X | S, AccumulatorDefault},
    {OpcodeSTP, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeJML, ModeAbsoluteIndirect, N, N, AccumulatorDefault},
    {OpcodeCMP, ModeAbsoluteIndexedX, A | X, N, AccumulatorDefault},
    {OpcodeDEC, ModeAbsoluteIndexedX, X, N, AccumulatorDefault},
    {OpcodeCMP, ModeAbsoluteLongIndexed, A | X, N, AccumulatorDefault},
    {OpcodeCPX, ModeImmediate, X, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndexedIndirect, A | D | X, A, AccumulatorDefault},
    {OpcodeSEP, ModeImmediate, N, N, AccumulatorDefault},
    {OpcodeSBC, ModeStackRelative, A | D | S, A, AccumulatorDefault},
    {OpcodeCPX, ModeDirect, X | D, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirect, A | D, A, AccumulatorDefault},
    {OpcodeINC, ModeDirect, D, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndirectLong, A | D, A, AccumulatorDefault},
    {OpcodeINX, ModeImplied, X, X, AccumulatorDefault},
    {OpcodeSBC, ModeImmediate, A, A, AccumulatorDefault},
    {OpcodeNOP, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeXBA, ModeImplied, A | B, A | B, AccumulatorDefault},
    {OpcodeCPX, ModeAbsolute, X, N, AccumulatorDefault},
    {OpcodeSBC, ModeAbsolute, A, A, AccumulatorDefault},
    {OpcodeINC, ModeAbsolute, N, N, AccumulatorDefault},
    {OpcodeSBC, ModeAbsoluteLong, A, A, AccumulatorDefault},
    {OpcodeBEQ, ModeProgramCounterRelative, N, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndirectIndexedY, A | D | Y, A, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndirect, A | D, A, AccumulatorDefault},
    {OpcodeSBC, ModeStackRelativeIndirectIndexed, A | D | Y | S, A,
     AccumulatorDefault},
    {OpcodePEA, ModeAbsolute, S, S, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndexedX, A | D | X, A, AccumulatorDefault},
    {OpcodeINC, ModeDirectIndexedX, D | X, N, AccumulatorDefault},
    {OpcodeSBC, ModeDirectIndirectLongIndexed, A | D | Y, A,
     AccumulatorDefault},
    {OpcodeSED, ModeImplied, N, N, AccumulatorDefault},
    {OpcodeSBC, ModeAbsoluteIndexedY, A | Y, A, AccumulatorDefault},
    {OpcodePLX, ModeStack, S, X | S, AccumulatorDefault},
    {OpcodeXCE, ModeImplied, P, P, AccumulatorDefault},
    {OpcodeJSR, ModeAbsoluteIndexedIndirect, X | S, S, AccumulatorDefault},
    {OpcodeSBC, ModeAbsoluteIndexedX, A | X, A, AccumulatorDefault},
    {OpcodeINC, ModeAbsoluteIndexedX, X, N, AccumulatorDefault},
    {OpcodeSBC, ModeAbsoluteLongIndexed, A | X, A, AccumulatorDefault}};

#pragma clang diagnostic pop
