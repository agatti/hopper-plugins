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
 * CPU mode string identifier for narrow accumulator and narrow index registers.
 */
static NSString *const kCPUModeAccumulator8Index8 = @"A8 I8";

/**
 * CPU mode string identifier for narrow accumulator and wide index registers.
 */
static NSString *const kCPUModeAccumulator8Index16 = @"A8 I16";

/**
 * CPU mode string identifier for wide accumulator and narrow index registers.
 */
static NSString *const kCPUModeAccumulator16Index8 = @"A16 I8";

/**
 * CPU mode string identifier for wide accumulator and wide index registers.
 */
static NSString *const kCPUModeAccumulator16Index16 = @"A16 I16";

@interface ItFrobHopper65816Definition ()

/**
 * General purpose register names.
 */
@property(strong, nonatomic, nonnull)
    NSArray<NSString *> *generalPurposeRegisterNames;

@end

@implementation ItFrobHopper65816Definition

#pragma mark - HopperPlugin protocol implementation

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
  if (self = [super initWithHopperServices:services]) {
    _generalPurposeRegisterNames =
        @[ @"A", @"X", @"Y", @"DBR", @"D", @"S", @"PBR", @"C", @"B" ];
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
  return @"0.2.0";
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

- (CPUEndianess)endianess {
  return CPUEndianess_Little;
}

- (NSUInteger)cpuModeCount {
  return FRBCPUModeCount;
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
    if (reg == 0) {
      return @"S";
    }
    break;

  case RegClass_GeneralPurposeRegister:
    if (reg < self.generalPurposeRegisterNames.count) {
      return self.generalPurposeRegisterNames[reg];
    }
    break;

  default:
    if (reg == 0) {
      return @"P";
    }
    break;
  }

  return nil;
}

- (BOOL)registerIndexIsStackPointer:(NSUInteger)reg
                            ofClass:(RegClass)reg_class {
  return reg == RegisterS && reg_class == RegClass_GeneralPurposeRegister;
}

- (NSData *)nopWithSize:(NSUInteger)size
                andMode:(NSUInteger)cpuMode
                forFile:(NSObject<HPDisassembledFile> *)file {

  NSData *opcode = [(Class<FRBCPUProvider>)[self.modelManager
      classForFamily:file.cpuFamily
            andModel:file.cpuSubFamily] nopOpcodeSignature];

  return NSDataWithFillerData(opcode, size);
}

@end

#pragma clang diagnostic pop