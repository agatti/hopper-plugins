/*
 Copyright (c) 2014-2018, Alessandro Gatti - frob.it
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

#import "Generic8x300.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

@interface ItFrobHopper8x300Generic8x300 ()

/**
 * Checks if the given register identifier is valid.
 *
 * @param[in] registerNumber the register identifier to check.
 *
 * @return YES if the given register identifier is valid, NO otherwise.
 */
- (BOOL)isRegisterValid:(NSUInteger)registerNumber;

/**
 * Performs some additional checks to make sure the ALU opcode is valid.
 *
 * @param[in] opcode the opcode word to check.
 *
 * @return YES if the given opcode is valid, NO otherwise.
 */
- (BOOL)isValidALUOpcode:(uint16_t)opcode;

/**
 * Performs some additional checks to make sure the target in the opcode is
 * valid.
 *
 * @param[in] opcode the opcode word to check.
 *
 * @return YES if the given opcode's target is valid, NO otherwise.
 */
- (BOOL)isValidTargetOpcode:(uint16_t)opcode;

@end

@implementation ItFrobHopper8x300Generic8x300

+ (NSString *_Nonnull)family {
  return @"Generic";
}

+ (NSString *_Nonnull)model {
  return @"8x300";
}

+ (BOOL)exported {
  return YES;
}

+ (int)addressSpaceWidth {
  return 16;
}

#pragma mark - Private methods

- (BOOL)isRegisterValid:(NSUInteger)registerNumber {
  switch (registerNumber) {
  case RegisterR12:
  case RegisterR13:
  case RegisterR14:
  case RegisterR15:
  case RegisterR16:
    return NO;

  default:
    return YES;
  }
}

- (BOOL)isValidALUOpcode:(uint16_t)opcode {
  int sourceRegister = (opcode >> 8) & 0x001F;
  int destinationRegister = opcode & 0x001F;

  if (![self isRegisterValid:(NSUInteger)sourceRegister] ||
      ![self isRegisterValid:(NSUInteger)destinationRegister]) {
    return NO;
  }

  switch (opcode & 0x1010) {
  case 0x0000:

    // Register to Register

    if (sourceRegister == RegisterIVL || sourceRegister == RegisterIVR ||
        destinationRegister == RegisterOVF) {
      return NO;
    }
    break;

  case 0x0010:

    // Register to I/O bus

    if (sourceRegister == RegisterIVL || sourceRegister == RegisterIVR) {
      return NO;
    }
    break;

  case 0x1000:

    // I/O bus to register

    if (destinationRegister == RegisterOVF) {
      return NO;
    }
    break;

  default:
    break;
  }

  return YES;
}

- (BOOL)isValidTargetOpcode:(uint16_t)opcode {
  NSUInteger registerId = (NSUInteger)((opcode >> 8) & 0x001F);

  return [self isRegisterValid:registerId] &&
         !(((opcode & 0x1000) == 0x0000) &&
           (registerId == RegisterIVL || registerId == RegisterIVR));
}

#pragma mark - Opcode handlers

- (BOOL)handleMOVEOpcode:(uint16_t)opcode
            forStructure:(DisasmStruct *_Nonnull)structure
                  onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                metadata:(InstructionMetadata *_Nonnull)metadata {

  return [self isValidALUOpcode:opcode] && [super handleMOVEOpcode:opcode
                                                      forStructure:structure
                                                            onFile:file
                                                          metadata:metadata];
}

- (BOOL)handleADDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  return [self isValidALUOpcode:opcode] && [super handleADDOpcode:opcode
                                                     forStructure:structure
                                                           onFile:file
                                                         metadata:metadata];
}

- (BOOL)handleANDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  return [self isValidALUOpcode:opcode] && [super handleANDOpcode:opcode
                                                     forStructure:structure
                                                           onFile:file
                                                         metadata:metadata];
}

- (BOOL)handleXOROpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  return [self isValidALUOpcode:opcode] && [super handleXOROpcode:opcode
                                                     forStructure:structure
                                                           onFile:file
                                                         metadata:metadata];
}

- (BOOL)handleXECOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  return [self isValidTargetOpcode:opcode] && [super handleXECOpcode:opcode
                                                        forStructure:structure
                                                              onFile:file
                                                            metadata:metadata];
}

- (BOOL)handleNZTOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  return [self isValidTargetOpcode:opcode] && [super handleNZTOpcode:opcode
                                                        forStructure:structure
                                                              onFile:file
                                                            metadata:metadata];
}

- (BOOL)handleXMITOpcode:(uint16_t)opcode
            forStructure:(DisasmStruct *_Nonnull)structure
                  onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                metadata:(InstructionMetadata *_Nonnull)metadata {

  NSUInteger registerId = (NSUInteger)((opcode >> 8) & 0b11111);
  return !(![self isRegisterValid:registerId] ||
           (((opcode & 0x1000) == 0x0000) && (registerId == RegisterIVL))) &&
         [super handleXMITOpcode:opcode
                    forStructure:structure
                          onFile:file
                        metadata:metadata];
}

@end

#pragma clang diagnostic pop
