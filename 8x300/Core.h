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

#import "HopperCommon.h"

#import "Definition.h"

/**
 * Available opcodes.
 */
typedef NS_ENUM(NSUInteger, FRBOpcode) {

  // Real opcodes.

  OpcodeMOVE,
  OpcodeADD,
  OpcodeAND,
  OpcodeXOR,
  OpcodeXEC,
  OpcodeNZT,
  OpcodeXMIT,
  OpcodeJMP,

  // Synthetic opcodes.

  OpcodeNOP,
  OpcodeHALT,
  OpcodeXML,
  OpcodeXMR,

  OpcodesCount
};

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedGlobalDeclarationInspection"

/**
 * Available registers.
 */
typedef NS_ENUM(NSUInteger, FRBRegister) {
  RegisterAUX = 0,
  RegisterR1,
  RegisterR2,
  RegisterR3,
  RegisterR4,
  RegisterR5,
  RegisterR6,
  RegisterIVL,
  RegisterOVF,
  RegisterR11,
  RegisterR12,
  RegisterR13,
  RegisterR14,
  RegisterR15,
  RegisterR16,
  RegisterIVR,
  RegisterLIV0,
  RegisterLIV1,
  RegisterLIV2,
  RegisterLIV3,
  RegisterLIV4,
  RegisterLIV5,
  RegisterLIV6,
  RegisterLIV7,
  RegisterRIV0,
  RegisterRIV1,
  RegisterRIV2,
  RegisterRIV3,
  RegisterRIV4,
  RegisterRIV5,
  RegisterRIV6,
  RegisterRIV7
};

#pragma clang diagnostic pop

/**
 * Instruction encodings.
 */
typedef NS_ENUM(uint32_t, EncodingType) {
  EncodingSingle = 0,
  EncodingWithRotation,
  EncodingWithLength,
  EncodingAssignment,
  EncodingOffsetWithLength,
  EncodingAssignmentWithLength,
  EncodingImplicit
};

/**
 * Base class for 8x300 CPU disassembler backends.
 */
@interface ItFrobHopper8x300Base8x300 : NSObject <CPUProvider>

/**
 * Handles a potential MOVE instruction.
 *
 * @param[in] opcode    the opcode word to handle.
 * @param[in] structure the structure to fill.
 * @param[in] file      the file to operate on.
 * @param[in] metadata  the metadata structure to fill.
 *
 * @return YES if the given opcode word is a valid MOVE operation, NO otherwise.
 */
- (BOOL)handleMOVEOpcode:(uint16_t)opcode
            forStructure:(DisasmStruct *_Nonnull)structure
                  onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handles a potential ADD instruction.
 *
 * @param[in] opcode    the opcode word to handle.
 * @param[in] structure the structure to fill.
 * @param[in] file      the file to operate on.
 * @param[in] metadata  the metadata structure to fill.
 *
 * @return YES if the given opcode word is a valid ADD operation, NO otherwise.
 */
- (BOOL)handleADDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handles a potential AND instruction.
 *
 * @param[in] opcode    the opcode word to handle.
 * @param[in] structure the structure to fill.
 * @param[in] file      the file to operate on.
 * @param[in] metadata  the metadata structure to fill.
 *
 * @return YES if the given opcode word is a valid AND operation, NO otherwise.
 */
- (BOOL)handleANDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handles a potential XOR instruction.
 *
 * @param[in] opcode    the opcode word to handle.
 * @param[in] structure the structure to fill.
 * @param[in] file      the file to operate on.
 * @param[in] metadata  the metadata structure to fill.
 *
 * @return YES if the given opcode word is a valid XOR operation, NO otherwise.
 */
- (BOOL)handleXOROpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handles a potential XEC instruction.
 *
 * @param[in] opcode    the opcode word to handle.
 * @param[in] structure the structure to fill.
 * @param[in] file      the file to operate on.
 * @param[in] metadata  the metadata structure to fill.
 *
 * @return YES if the given opcode word is a valid XEC operation, NO otherwise.
 */
- (BOOL)handleXECOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handles a potential NZT instruction.
 *
 * @param[in] opcode    the opcode word to handle.
 * @param[in] structure the structure to fill.
 * @param[in] file      the file to operate on.
 * @param[in] metadata  the metadata structure to fill.
 *
 * @return YES if the given opcode word is a valid NZT operation, NO otherwise.
 */
- (BOOL)handleNZTOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handles a potential XMIT instruction.
 *
 * @param[in] opcode    the opcode word to handle.
 * @param[in] structure the structure to fill.
 * @param[in] file      the file to operate on.
 * @param[in] metadata  the metadata structure to fill.
 *
 * @return YES if the given opcode word is a valid XMIT operation, NO otherwise.
 */
- (BOOL)handleXMITOpcode:(uint16_t)opcode
            forStructure:(DisasmStruct *_Nonnull)structure
                  onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handles a potential JMP instruction.
 *
 * @param[in] opcode    the opcode word to handle.
 * @param[in] structure the structure to fill.
 * @param[in] file      the file to operate on.
 * @param[in] metadata  the metadata structure to fill.
 *
 * @return YES if the given opcode word is a valid JMP operation, NO otherwise.
 */
- (BOOL)handleJMPOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata;

@end
