/*
 Copyright (c) 2014, Alessandro Gatti - frob.it
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
#import "FRBContext.h"
#import "FRBBase.h"
#import "FRBModelHandler.h"

// 65xxCommon library imports

#import "FRBCPUSupport.h"
#import "FRBInstructionColouriser.h"

// HopperCommon library imports

#import "NSDataHopperAdditions.h"

/*!
 *	Backend model handler.
 */
static ItFrobHopper65816ModelHandler *kModelHandler;

@interface ItFrobHopper65816Definition () {

    /*!
     *  Hopper Services instance.
     */
    id<HPHopperServices> _services;

    /*!
     *	Instruction string colouriser.
     */
    ItFrobHopper65xxCommonInstructionColouriser *_colouriser;
}

@end

@implementation ItFrobHopper65816Definition

- (id<HopperPlugin>)initWithHopperServices:(id<HPHopperServices>)services {
    if (self = [super init]) {
        _services = services;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableSet *opcodes = [NSMutableSet new];
            for (int index = 0; index < FRBUniqueOpcodesCount; index++) {
                [opcodes addObject:[[NSString stringWithUTF8String:FRBInstructions[index].name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            _colouriser = [[ItFrobHopper65xxCommonInstructionColouriser alloc] initWithOpcodesSet:opcodes
                                                                                      andServices:services];
            kModelHandler = [ItFrobHopper65816ModelHandler sharedModelHandler];
        });
    }

    return self;
}

- (id<CPUContext>)buildCPUContextForFile:(id<HPDisassembledFile>)file {
    return [[ItFrobHopper65816Context alloc] initWithCPU:self
                                                 andFile:file
                                            withServices:_services];
}

- (UUID *)pluginUUID {
    return [_services UUIDWithString:@"18d19920-2858-11e4-8c21-0800200c9a66"];
}

- (HopperPluginType)pluginType {
    return Plugin_CPU;
}

- (NSString *)pluginName {
    return @"65816/65802";
}

- (NSString *)pluginDescription {
    return @"65816-family CPU support";
}

- (NSString *)pluginAuthor {
    return @"Alessandro Gatti";
}

- (NSString *)pluginCopyright {
    return @"©2014 Alessandro Gatti";
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

- (BOOL)registerIndexIsStackPointer:(uint32_t)reg
                            ofClass:(RegClass)reg_class {
    return reg == FRBRegisterS && reg_class == RegClass_GeneralPurposeRegister;
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
    return @[ FRBSyntaxVariant ];
}

- (NSArray *)cpuModeNames {
    return @[ FRBCPUMode ];
}

- (NSUInteger)registerClassCount {
    return RegClass_FirstUserClass;
}

- (NSUInteger)registerCountForClass:(NSUInteger)reg_class {
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

- (BOOL)registerIsStackPointer:(uint32_t)reg {
    return NO;
}

- (BOOL)registerIsFrameBasePointer:(uint32_t)reg {
    return NO;
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
