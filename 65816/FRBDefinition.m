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

#import "FRBDefinition.h"
#import "FRBBase.h"
#import "FRBContext.h"
#import "FRBModelManager.h"
#import "NSDataWithFill.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

/**
 * Assembler syntax variants.
 */
static NSString *const kSyntaxVariant = @"Generic";

/*
 * CPU modes
 */

static NSString *const kCPUModeAccumulator8Index8 = @"A8 I8";
static NSString *const kCPUModeAccumulator8Index16 = @"A8 I16";
static NSString *const kCPUModeAccumulator16Index8 = @"A16 I8";
static NSString *const kCPUModeAccumulator16Index16 = @"A16 I16";

@interface ItFrobHopper65816Definition ()

/**
 * Model manager instance.
 */
@property(strong, nonatomic, nonnull) FRBModelManager *modelManager;

@end

@implementation ItFrobHopper65816Definition

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
  return [self.services UUIDWithString:@"18D19920-2858-11E4-8C21-0800200C9A66"];
}

- (HopperPluginType)pluginType {
  return Plugin_CPU;
}

- (NSString *)pluginName {
  return @"65816";
}

- (NSString *)pluginDescription {
  return @"65816 CPU support";
}

- (NSString *)pluginAuthor {
  return @"Alessandro Gatti";
}

- (NSString *)pluginCopyright {
  return @"©2014-2017 Alessandro Gatti";
}

- (NSString *)pluginVersion {
  return @"0.1.0";
}

#pragma mark - CPUDefinition protocol implementation

- (Class)cpuContextClass {
  return [ItFrobHopper65816Context class];
}

- (NSObject<CPUContext> *)buildCPUContextForFile:
    (NSObject<HPDisassembledFile> *)file {

  return [[ItFrobHopper65816Context alloc]
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
  return FRBCPUModeCount;
}

- (NSArray *)syntaxVariantNames {
  return @[ kSyntaxVariant ];
}

- (NSArray *)cpuModeNames {
  return @[
    kCPUModeAccumulator8Index8, kCPUModeAccumulator8Index16,
    kCPUModeAccumulator16Index8, kCPUModeAccumulator16Index16
  ];
}

- (NSUInteger)registerClassCount {
  return RegClass_FirstUserClass;
}

- (NSUInteger)registerCountForClass:(RegClass)reg_class {
  switch (reg_class) {
  case RegClass_CPUState:
    return 1;

  case RegClass_PseudoRegisterSTACK:
    return 1;

  case RegClass_GeneralPurposeRegister:
    return 9;

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
    switch (reg) {
    case 0:
      return @"S";

    default:
      break;
    }
    break;

  case RegClass_GeneralPurposeRegister:
    switch (reg) {
    case 0:
      return @"A";

    case 1:
      return @"X";

    case 2:
      return @"Y";

    case 3:
      return @"DBR";

    case 4:
      return @"D";

    case 5:
      return @"S"; // Until there's a way to mark stack operations as such...

    case 6:
      return @"PBR";

    case 7:
      return @"C";

    case 8:
      return @"B";

    default:
      break;
    }
    break;

  default:
    switch (reg) {
    case 0:
      return @"P";

    default:
      break;
    }
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
                forFile:(NSObject<HPDisassembledFile> *)file {
  return NSDataWithFiller(0xEA, size);
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