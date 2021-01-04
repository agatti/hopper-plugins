/*
 Copyright (c) 2014-2021, Alessandro Gatti - frob.it
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

#import "Generic8x305.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

@interface ItFrobHopper8x300Generic8x305 ()

/**
 * Performs some additional checks to allow for extended registers usage by the
 * 8x305.
 *
 * @param[in] opcode the opcode word to check.
 *
 * @return YES if the given opcode is valid, NO otherwise.
 */
- (BOOL)isValidALUOpcode:(uint16_t)opcode;

@end

@implementation ItFrobHopper8x300Generic8x305

+ (NSString *_Nonnull)family {
  return @"Generic";
}

+ (NSString *_Nonnull)model {
  return @"8x305";
}

+ (BOOL)exported {
  return YES;
}

+ (int)addressSpaceWidth {
  return 16;
}

#pragma mark - Private methods

- (BOOL)isValidALUOpcode:(uint16_t)opcode {
  NSUInteger destinationRegister = opcode & 0b11111;

  switch (opcode & 0x1010) {

  // Register to Register
  case 0x0000:
  // Intentional fall-through.

  // I/O bus to register
  case 0x1000:
    return destinationRegister != RegisterOVF;

  default:
    break;
  }

  return YES;
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

@end

#pragma clang diagnostic pop
