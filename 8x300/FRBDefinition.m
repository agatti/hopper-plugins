/*
 Copyright (c) 2014-2015, Alessandro Gatti - frob.it
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

#import "FRBBase.h"
#import "FRBDefinition.h"
#import "FRBContext.h"
#import "FRBModelHandler.h"
#import "FRBInstructionColouriser.h"

/*!
 *	Backend model handler.
 */
static NAMESPACE(8x300ModelHandler) *kModelHandler;

@interface NAMESPACE(8x300Definition) () {

    /*!
     *  Hopper Services instance.
     */
    id<HPHopperServices> _services;

    /*!
     *	Instruction string colouriser.
     */
    NAMESPACE(8x300InstructionColouriser) *_colouriser;
}

@end

@implementation NAMESPACE(8x300Definition)

- (id<HopperPlugin>)initWithHopperServices:(id<HPHopperServices>)services {
    if (self = [super init]) {
        _services = services;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kModelHandler = [NAMESPACE(8x300ModelHandler) sharedModelHandler];

            NSMutableSet *opcodes = [NSMutableSet new];
            for (int index = 0; index < FRB8x300OpcodesCount; index++) {
                [opcodes addObject:[[NSString stringWithUTF8String:kOpcodeNames[index]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            _colouriser = [[NAMESPACE(8x300InstructionColouriser) alloc] initWithOpcodesSet:opcodes
                                                                                 andServices:services];

        });
    }

    return self;
}

- (id<CPUContext>)buildCPUContextForFile:(id<HPDisassembledFile>)file {
    return [[NAMESPACE(8x300Context) alloc] initWithCPU:self
                                                 andFile:file
                                            withServices:_services];
}

- (HopperUUID *)pluginUUID {
    return [_services UUIDWithString:@"DB4FB6C0-3D2B-11E4-916C-0800200C9A66"];
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
    return @"©2014-2015 Alessandro Gatti";
}

- (NSString *)pluginVersion {
    return @"0.0.2";
}

- (NSArray *)cpuFamilies {
    return [kModelHandler.models.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
}

- (NSArray *)cpuSubFamiliesForFamily:(NSString *)family {
    return [((NSDictionary *)kModelHandler.models[family]).allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
}

- (int)addressSpaceWidthInBitsForCPUFamily:(NSString *)family
                              andSubFamily:(NSString *)subFamily {
    NSDictionary *subFamilies = kModelHandler.models[family];
    if (subFamilies && subFamilies[subFamily]) {
            return 16;
    }

    return 0;
}

- (NSString *)registerIndexToString:(int)reg
                            ofClass:(RegClass)reg_class
                        withBitSize:(int)size
                        andPosition:(DisasmPosition)position {
    if (reg_class == RegClass_GeneralPurposeRegister) {
        return [NSString stringWithUTF8String:kRegisterNames[reg]];
    }

    return nil;
}

- (NSString *)cpuRegisterStateMaskToString:(uint32_t)cpuState {
    return @"";
}

- (BOOL)registerIndexIsStackPointer:(uint32_t)reg
                            ofClass:(RegClass)reg_class {
    return NO;
}

- (BOOL)registerIndexIsFrameBasePointer:(uint32_t)reg
                                ofClass:(RegClass)reg_class {
    return NO;
}

- (BOOL)registerIndexIsProgramCounter:(uint32_t)reg {
    return NO;
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
            return 0;

        case RegClass_PseudoRegisterSTACK:
            return 0;

        case RegClass_GeneralPurposeRegister:
            return FRB8x300RegisterCount;

        default:
            break;
    }

    return 0;
}

- (BOOL)registerIsStackPointer:(uint32_t)reg {
    return NO;
}

- (BOOL)registerIsFrameBasePointer:(uint32_t)reg {
    return NO;
}

- (NSString *)framePointerRegisterNameForFile:(NSObject<HPDisassembledFile>*)file {
    return nil;
}

- (NSUInteger)translateOperandIndex:(NSUInteger)index
                       operandCount:(NSUInteger)count
                  accordingToSyntax:(uint8_t)syntaxIndex {
    return index;
}

- (NSAttributedString *)colorizeInstructionString:(NSAttributedString *)string {
    return [_colouriser colouriseInstruction:string];
}

- (NSData *)nopWithSize:(NSUInteger)size
                andMode:(NSUInteger)cpuMode
                forFile:(NSObject<HPDisassembledFile> *)file {
    return nil;
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
