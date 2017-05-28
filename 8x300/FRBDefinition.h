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

@protocol FRBInstructionFormatter;

#import <Hopper/Hopper.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedGlobalDeclarationInspection"

typedef NS_ENUM(NSUInteger, FRBSyntaxType) {
  FRBSyntaxAS = 0,
  FRBSyntaxMCCAP,

  FRBSyntaxCount
};

#pragma clang diagnostic pop

typedef NS_ENUM(uint8_t, FRBInstructionType) {
  FRBInstructionType1 = 0,
  FRBInstructionType2,
  FRBInstructionType3,
  FRBInstructionType4,
  FRBInstructionType5
};

typedef struct {
  uint16_t opcode : 3;
  uint16_t source : 5;
  uint16_t rotation : 3;
  uint16_t destination : 5;
} FRBFieldsInstructionType1;

typedef struct {
  uint16_t opcode : 3;
  uint16_t source : 5;
  uint16_t length : 3;
  uint16_t destination : 5;
} FRBFieldsInstructionType2;

typedef struct {
  uint16_t opcode : 3;
  uint16_t source : 5;
  uint16_t literal : 8;
} FRBFieldsInstructionType3;

typedef struct {
  uint16_t opcode : 3;
  uint16_t source : 5;
  uint16_t length : 3;
  uint16_t literal : 5;
} FRBFieldsInstructionType4;

typedef struct {
  uint16_t opcode : 3;
  uint16_t immediate : 12;
} FRBFieldsInstructionType5;

typedef union {
  FRBFieldsInstructionType1 type1;
  FRBFieldsInstructionType2 type2;
  FRBFieldsInstructionType3 type3;
  FRBFieldsInstructionType4 type4;
  FRBFieldsInstructionType5 type5;
} FRBFieldsInstruction;

typedef struct {
  uintptr_t opcode : 4;
  uintptr_t encoding : 3;
  uintptr_t haltsExecution : 1;
  uintptr_t type : 3;
  uintptr_t reserved : 5;
  uintptr_t instruction : 16;
} FRBInstructionUserData;

/**
 * CPU Definition class for the 8x300 disassembler plugin.
 */
@interface ItFrobHopper8x300Definition : NSObject <CPUDefinition>

/**
 * Hopper Services instance.
 */
@property(strong, nonatomic, nonnull) NSObject<HPHopperServices> *services;

- (NSObject<FRBInstructionFormatter> *_Nullable)formatterForSyntax:
    (FRBSyntaxType)syntaxType;

@end

#pragma clang diagnostic pop
