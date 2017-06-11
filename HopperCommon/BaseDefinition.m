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

#import "BaseDefinition.h"

#import "HopperCommon.h"
#import "ModelManager.h"

static NSString * const kDefaultCPUMode = @"Generic";
static NSString * const kDefaultSyntax = @"Generic";

@implementation ItFrobHopperBaseDefinition

- (Class)cpuContextClass {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSObject <CPUContext> *)buildCPUContextForFile:(NSObject <HPDisassembledFile> *)file {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSArray<NSString *> *)cpuFamilies {
    return [self.modelManager.families
            sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1,
                    NSString *obj2) {
                return [obj1 compare:obj2];
            }];
}

- (NSArray<NSString *> *)cpuSubFamiliesForFamily:(NSString *)family {
    return [[self.modelManager modelsForFamily:family]
            sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1,
                    NSString *obj2) {
                return [obj1 compare:obj2];
            }];
}

- (int)addressSpaceWidthInBitsForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
    Class<CPUProvider> class =
            [self.modelManager classForFamily:family andModel:subFamily];
    return (class != nil) ? [class addressSpaceWidth] : 0;
}

- (CPUEndianess)endianess {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSUInteger)syntaxVariantCount {
    return 1;
}

- (NSUInteger)cpuModeCount {
    return 1;
}

- (NSArray<NSString *> *)syntaxVariantNames {
    return @[ kDefaultSyntax ];
}

- (NSArray<NSString *> *)cpuModeNames {
    return @[ kDefaultCPUMode ];
}

- (NSUInteger)registerClassCount {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSUInteger)registerCountForClass:(RegClass)reg_class {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSString *)registerIndexToString:(NSUInteger)reg ofClass:(RegClass)reg_class withBitSize:(NSUInteger)size position:(DisasmPosition)position andSyntaxIndex:(NSUInteger)syntaxIndex {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSString *)cpuRegisterStateMaskToString:(uint32_t)cpuState {
    return @"";
}

- (BOOL)registerIndexIsStackPointer:(NSUInteger)reg ofClass:(RegClass)reg_class {
    return NO;
}

- (BOOL)registerIndexIsFrameBasePointer:(NSUInteger)reg ofClass:(RegClass)reg_class {
    return NO;
}

- (BOOL)registerIndexIsProgramCounter:(NSUInteger)reg {
    return NO;
}

- (NSString *)framePointerRegisterNameForFile:(NSObject <HPDisassembledFile> *)file {
    return nil;
}

- (NSData *)nopWithSize:(NSUInteger)size andMode:(NSUInteger)cpuMode forFile:(NSObject <HPDisassembledFile> *)file {
    return nil;
}

- (BOOL)canAssembleInstructionsForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
    return NO;
}

- (BOOL)canDecompileProceduresForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
    return NO;
}

- (instancetype)initWithHopperServices:(NSObject <HPHopperServices> *)services {
    if (self = [super init]) {
        _services = services;

        ItFrobHopperModelManager *manager = [ItFrobHopperModelManager
                modelManagerWithBundle:[NSBundle bundleForClass:self.class]];
        if (!manager) {
            return nil;
        }

        _modelManager = manager;
    }

    return self;
}

- (HopperUUID *)pluginUUID {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (HopperPluginType)pluginType {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSString *)pluginName {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSString *)pluginDescription {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSString *)pluginAuthor {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSString *)pluginCopyright {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

- (NSString *)pluginVersion {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
                       reason:[NSString stringWithFormat:@"Forgot to override %s",
                                       __PRETTY_FUNCTION__]
                     userInfo:nil];
}

@end
