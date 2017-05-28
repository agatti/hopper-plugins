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

#import "FRBCPUProvider.h"
#import "FRBDefinition.h"
#import "FRBHopperCommon.h"

typedef NS_ENUM(NSUInteger, FRBOpcode) {
  FRBOpcodeMOVE,
  FRBOpcodeADD,
  FRBOpcodeAND,
  FRBOpcodeXOR,
  FRBOpcodeXEC,
  FRBOpcodeNZT,
  FRBOpcodeXMIT,
  FRBOpcodeJMP,

  FRBOpcodeNOP,
  FRBOpcodeHALT,
  FRBOpcodeXML,
  FRBOpcodeXMR,

  FRBOpcodesCount
};

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedGlobalDeclarationInspection"

typedef NS_ENUM(NSUInteger, FRBRegister) {
  FRBRegisterAUX = 0,
  FRBRegisterR1,
  FRBRegisterR2,
  FRBRegisterR3,
  FRBRegisterR4,
  FRBRegisterR5,
  FRBRegisterR6,
  FRBRegisterIVL,
  FRBRegisterOVF,
  FRBRegisterR11,
  FRBRegisterR12,
  FRBRegisterR13,
  FRBRegisterR14,
  FRBRegisterR15,
  FRBRegisterR16,
  FRBRegisterIVR,
  FRBRegisterLIV0,
  FRBRegisterLIV1,
  FRBRegisterLIV2,
  FRBRegisterLIV3,
  FRBRegisterLIV4,
  FRBRegisterLIV5,
  FRBRegisterLIV6,
  FRBRegisterLIV7,
  FRBRegisterRIV0,
  FRBRegisterRIV1,
  FRBRegisterRIV2,
  FRBRegisterRIV3,
  FRBRegisterRIV4,
  FRBRegisterRIV5,
  FRBRegisterRIV6,
  FRBRegisterRIV7
};

#pragma clang diagnostic pop

typedef NS_ENUM(uint32_t, FRBEncodingType) {
  FRBEncodingTypeSingle = 0,
  FRBEncodingTypeWithRotation,
  FRBEncodingTypeWithLength,
  FRBEncodingTypeAssignment,
  FRBEncodingTypeOffsetWithLength,
  FRBEncodingTypeAssignmentWithLength,
  FRBEncodingTypeImplicit
};

@interface ItFrobHopper8x300Base8x300 : NSObject <FRBCPUProvider>

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
                metadata:(FRBInstructionUserData *_Nonnull)metadata;

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
               metadata:(FRBInstructionUserData *_Nonnull)metadata;

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
               metadata:(FRBInstructionUserData *_Nonnull)metadata;

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
               metadata:(FRBInstructionUserData *_Nonnull)metadata;

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
               metadata:(FRBInstructionUserData *_Nonnull)metadata;

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
               metadata:(FRBInstructionUserData *_Nonnull)metadata;

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
                metadata:(FRBInstructionUserData *_Nonnull)metadata;

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
               metadata:(FRBInstructionUserData *_Nonnull)metadata;

@end
