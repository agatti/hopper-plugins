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

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

@interface ItFrobHopperTMS1000Definition ()

@end

@implementation ItFrobHopperTMS1000Definition

#pragma mark - HopperPlugin protocol implementation

- (HopperUUID *)pluginUUID {
  return [self.services UUIDWithString:@"53C4BE05-3378-4E38-9DBA-F939874E9B49"];
}

- (HopperPluginType)pluginType {
  return Plugin_CPU;
}

- (NSString *)pluginName {
  return @"TMS1000";
}

- (NSString *)pluginDescription {
  return @"TMS1000 Series CPU support";
}

- (NSString *)pluginAuthor {
  return @"Alessandro Gatti";
}

- (NSString *)pluginCopyright {
  return @"©2014-2017 Alessandro Gatti";
}

- (NSString *)pluginVersion {
  return @"0.0.1";
}

#pragma mark - CPUDefinition protocol implementation

- (Class)cpuContextClass {
  return [ItFrobHopperTMS1000Context class];
}

- (NSObject<CPUContext> *)buildCPUContextForFile:
    (NSObject<HPDisassembledFile> *)file {

  return [[ItFrobHopperTMS1000Context alloc]
        initWithCPU:self
            andFile:file
       withProvider:[self.modelManager providerForFamily:file.cpuFamily
                                                andModel:file.cpuSubFamily]
      usingServices:self.services];
}

- (CPUEndianess)endianess {
  return CPUEndianess_Little;
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
    case FRBRegisterA:
      return @"A";

    case FRBRegisterX:
      return @"X";

    case FRBRegisterY:
      return @"Y";

    case FRBRegisterO:
      return @"O";

    case FRBRegisterPB:
      return @"PB";

    default:
      break;
    }
    break;

  case RegClass_CPUState:
    break;

  default:
    break;
  }

  return nil;
}

- (NSData *)nopWithSize:(NSUInteger)size
                andMode:(NSUInteger)cpuMode
                forFile:(id<HPDisassembledFile>)file {
  return [NSData data];
}

@end

#pragma clang diagnostic pop