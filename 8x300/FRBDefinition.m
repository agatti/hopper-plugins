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
#import "FRBASFormat.h"
#import "FRBContext.h"
#import "FRBMCCAPFormat.h"
#import "FRBModelManager.h"
#import "NSDataWithFill.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

/**
 * CPU register names.
 */
static const char *kRegisterNames[] = {
    "AUX",  "R1",   "R2",   "R3",   "R4",   "R5",   "R6",   "IVL",
    "OVF",  "R11",  "R12",  "R13",  "R14",  "R15",  "R16",  "IVR",
    "LIV0", "LIV1", "LIV2", "LIV3", "LIV4", "LIV5", "LIV6", "LIV7",
    "RIV0", "RIV1", "RIV2", "RIV3", "RIV4", "RIV5", "RIV6", "RIV7",
};

@interface ItFrobHopper8x300Definition ()

/**
 * Model manager instance.
 */
@property(strong, nonatomic, nonnull) FRBModelManager *modelManager;

@property(strong, nonatomic, nonnull)
    NSArray<NSObject<FRBInstructionFormatter> *> *formatterInstances;

@property(strong, nonatomic, nonnull) NSArray<NSString *> *formatterNames;

@end

@implementation ItFrobHopper8x300Definition

#pragma mark - HopperPlugin protocol implementation

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
  if (self = [super init]) {
    _services = services;
    _formatterNames = @[ @"AS Macro Assembler", @"Signetics MCCAP" ];
    _formatterInstances = @[ [FRBASFormat new], [FRBMCCAPFormat new] ];

    NSAssert((_formatterNames.count == _formatterInstances.count) &&
                 (_formatterNames.count > 0),
             @"Formatter information mismatch");

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
  return [self.services UUIDWithString:@"DB4FB6C0-3D2B-11E4-916C-0800200C9A66"];
}

- (HopperPluginType)pluginType {
  return Plugin_CPU;
}

- (NSString *)pluginName {
  return @"8x300";
}

- (NSString *)pluginDescription {
  return @"8x300 CPU support";
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
  return [ItFrobHopper8x300Context class];
}

- (NSObject<CPUContext> *)buildCPUContextForFile:
    (NSObject<HPDisassembledFile> *)file {

  return [[ItFrobHopper8x300Context alloc]
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
  return self.formatterNames.count;
}

- (NSUInteger)cpuModeCount {
  return 1;
}

- (NSArray *)syntaxVariantNames {
  return self.formatterNames;
}

- (NSArray *)cpuModeNames {
  return @[ @"generic" ];
}

- (NSUInteger)registerClassCount {
  return RegClass_FirstUserClass;
}

- (NSUInteger)registerCountForClass:(RegClass)reg_class {
  return (reg_class == RegClass_GeneralPurposeRegister)
             ? ARRAY_SIZE(kRegisterNames)
             : 0;
}

- (NSString *)registerIndexToString:(NSUInteger)reg
                            ofClass:(RegClass)reg_class
                        withBitSize:(NSUInteger)size
                           position:(DisasmPosition)position
                     andSyntaxIndex:(NSUInteger)syntaxIndex {
  return ((reg < ARRAY_SIZE(kRegisterNames)) &&
          (reg_class == RegClass_GeneralPurposeRegister))
             ? @(kRegisterNames[reg])
             : nil;
}

- (NSString *)cpuRegisterStateMaskToString:(uint32_t)cpuState {
  return @"";
}

- (BOOL)registerIndexIsStackPointer:(NSUInteger)reg
                            ofClass:(RegClass)reg_class {
  return NO;
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
  return NSDataWithFiller(0, size);
}

- (BOOL)canAssembleInstructionsForCPUFamily:(NSString *)family
                               andSubFamily:(NSString *)subFamily {
  return NO;
}

- (BOOL)canDecompileProceduresForCPUFamily:(NSString *)family
                              andSubFamily:(NSString *)subFamily {
  return NO;
}

- (NSObject<FRBInstructionFormatter> *_Nullable)formatterForSyntax:
    (FRBSyntaxType)syntaxType {
  return (syntaxType != FRBSyntaxAS) && (syntaxType != FRBSyntaxMCCAP)
             ? nil
             : self.formatterInstances[syntaxType];
}

@end

#pragma clang diagnostic pop
