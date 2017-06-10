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

#import "Definition.h"
#import "Common.h"
#import "Context.h"
#import "FRBModelManager.h"

#import "NSDataWithFill.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

@interface ItFrobHopper6502Definition ()

/**
 * Model manager instance.
 */
@property(strong, nonatomic, nonnull) FRBModelManager *modelManager;

@end

@implementation ItFrobHopper6502Definition

#pragma mark - HopperPlugin protocol implementation

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
  if (self = [super init]) {
    _services = services;

    FRBModelManager *manager = [FRBModelManager
        modelManagerWithBundle:[NSBundle bundleForClass:self.class]];
    if (!manager) {
      return nil;
    }

    _modelManager = manager;
  }

  return self;
}

- (HopperUUID *)pluginUUID {
  return [_services UUIDWithString:@"00E347A0-0931-11E4-9191-0800200C9A66"];
}

- (HopperPluginType)pluginType {
  return Plugin_CPU;
}

- (NSString *)pluginName {
  return @"6502";
}

- (NSString *)pluginDescription {
  return @"6502-family CPU support";
}

- (NSString *)pluginAuthor {
  return @"Alessandro Gatti";
}

- (NSString *)pluginCopyright {
  return @"©2014-2017 Alessandro Gatti";
}

- (NSString *)pluginVersion {
  return @"0.2.0";
}

#pragma mark - CPUDefinition protocol implementation

- (Class)cpuContextClass {
  return [ItFrobHopper6502Context class];
}

- (NSObject<CPUContext> *)buildCPUContextForFile:
    (NSObject<HPDisassembledFile> *)file {

  return [[ItFrobHopper6502Context alloc]
        initWithCPU:self
            andFile:file
       withProvider:[self.modelManager providerForFamily:file.cpuFamily
                                                andModel:file.cpuSubFamily]
      usingServices:self.services];
}

- (NSArray *)cpuFamilies {
  return [self.modelManager.families
      sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1,
                                                     NSString *obj2) {
        return [obj1 compare:obj2];
      }];
}

- (NSArray *)cpuSubFamiliesForFamily:(NSString *)family {
  return [[self.modelManager modelsForFamily:family]
      sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1,
                                                     NSString *obj2) {
        return [obj1 compare:obj2];
      }];
}

- (int)addressSpaceWidthInBitsForCPUFamily:(NSString *)family
                              andSubFamily:(NSString *)subFamily {
  Class<FRBCPUProvider> class =
      [self.modelManager classForFamily:family andModel:subFamily];
  return (class != nil) ? [class addressSpaceWidth] : 0;
}

- (CPUEndianess)endianess {
  return CPUEndianess_Little;
}

- (NSUInteger)syntaxVariantCount {
  return 1;
}

- (NSUInteger)cpuModeCount {
  return 1;
}

- (NSArray *)syntaxVariantNames {
  return @[ kSyntaxVariant ];
}

- (NSArray *)cpuModeNames {
  return @[ kCPUMode ];
}

- (NSUInteger)registerClassCount {
  return RegClass_FirstUserClass;
}

- (NSUInteger)registerCountForClass:(RegClass)reg_class {
  switch (reg_class) {
  case RegClass_CPUState:
    return 1;

  case RegClass_PseudoRegisterSTACK:
    return 0;

  case RegClass_GeneralPurposeRegister:
    return 6;

  default:
    break;
  }

  return 0;
}

- (NSString *)registerIndexToString:(NSUInteger)reg
                            ofClass:(RegClass)reg_class
                        withBitSize:(NSUInteger)size
                           position:(DisasmPosition)position
                     andSyntaxIndex:(NSUInteger)syntaxIndex {
  switch (reg_class) {
  case RegClass_PseudoRegisterSTACK:
    break;

  case RegClass_GeneralPurposeRegister:
    switch (reg) {
    case RegisterA:
      return @"A";

    case RegisterX:
      return @"X";

    case RegisterY:
      return @"Y";

    // Until the SDK allows to manipulate the stack pointer
    // directly, we have to consider the stack pointer as a
    // general purpose register for the sake of block register
    // usage markers.

    case RegisterS:
      return @"S";

    case RegisterP:
      return @"P";

    // R65C19 extended registers.

    case RegisterW:
      return @"W";

    case RegisterI:
      return @"I";

    default:
      break;
    }
    break;

  case RegClass_CPUState:
    switch (reg) {
    case 0:
      return @"P";

    default:
      break;
    }

  default:
    break;
  }

  return nil;
}

- (NSString *)cpuRegisterStateMaskToString:(uint32_t)cpuState {
  return @"";
}

- (BOOL)registerIndexIsStackPointer:(NSUInteger)reg
                            ofClass:(RegClass)reg_class {
  return reg == RegisterS && reg_class == RegClass_GeneralPurposeRegister;
}

- (BOOL)registerIndexIsFrameBasePointer:(NSUInteger)reg
                                ofClass:(RegClass)reg_class {
  return NO;
}

- (BOOL)registerIndexIsProgramCounter:(NSUInteger)reg {
  return NO;
}

- (NSString *)framePointerRegisterNameForFile:
    (NSObject<HPDisassembledFile> *)file {
  return nil;
}

- (NSData *)nopWithSize:(NSUInteger)size
                andMode:(NSUInteger)cpuMode
                forFile:(id<HPDisassembledFile>)file {

  uint8_t nop =
      (uint8_t)([file.cpuFamily isEqualToString:@"Sunplus"] ? 0xF2 : 0xEA);
  return NSDataWithFiller(nop, size);
}

- (BOOL)canAssembleInstructionsForCPUFamily:(NSString *)family
                               andSubFamily:(NSString *)subFamily {
  return NO;
}

- (BOOL)canDecompileProceduresForCPUFamily:(NSString *)family
                              andSubFamily:(NSString *)subFamily {
  return NO;
}

@end

#pragma clang diagnostic pop
