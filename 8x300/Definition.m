/*
 Copyright (c) 2014-2020, Alessandro Gatti - frob.it
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

#import "HopperCommon/HopperCommon.h"

#import "ASFormat.h"
#import "Context.h"
#import "Definition.h"
#import "MCCAPFormat.h"

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
 * Instruction formatter instances.
 */
@property(strong, nonatomic, nonnull)
    NSArray<NSObject<ItFrobHopper8x300InstructionFormatter> *>
        *formatterInstances;

@end

@implementation ItFrobHopper8x300Definition

#pragma mark - HopperPlugin protocol implementation

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
  if (self = [super initWithHopperServices:services]) {
    _formatterInstances = @[
      [ItFrobHopper8x300ASFormat new], [ItFrobHopper8x300MCCAPFormat new]
    ];
  }

  return self;
}

- (NSObject<HPHopperUUID> *)pluginUUID {
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
  return @"©2014-2020 Alessandro Gatti";
}

- (NSString *)pluginVersion {
  return @"0.1.1";
}

- (nonnull NSArray<NSString *> *)commandLineIdentifiers {
  return @[ @"8x300" ];
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

- (CPUEndianess)endianess {
  return CPUEndianess_Little;
}

- (NSUInteger)syntaxVariantCount {
  return SyntaxTypeCount;
}

- (NSArray *)syntaxVariantNames {
  NSMutableArray *names =
      [[NSMutableArray alloc] initWithCapacity:self.formatterInstances.count];

  for (NSObject<ItFrobHopper8x300InstructionFormatter> *formatter in self
           .formatterInstances) {
    [names addObject:formatter.name];
  }

  return names;
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

- (NSData *)nopWithSize:(NSUInteger)size
                andMode:(NSUInteger)cpuMode
                forFile:(NSObject<HPDisassembledFile> *)file {
  return NSDataWithFiller(0, size);
}

- (NSObject<ItFrobHopper8x300InstructionFormatter> *_Nullable)
    formatterForSyntax:(SyntaxType)syntaxType {
  return (syntaxType != SyntaxTypeAS) && (syntaxType != SyntaxTypeMCCAP)
             ? nil
             : self.formatterInstances[syntaxType];
}

- (int)integerWidthInBitsForCPUFamily:(nullable NSString *)family
                         andSubFamily:(nullable NSString *)subFamily {
  return 16;
}

@end

#pragma clang diagnostic pop
