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
 *	CPU type and subtype model handler.
 */
static const ItFrobHopper6502ModelHandler *kModelHandler;

@interface ItFrobHopper6502Definition () {

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

@implementation ItFrobHopper6502Definition

- (id<HopperPlugin>)initWithHopperServices:(id<HPHopperServices>)services {
    if (self = [super init]) {
        _services = services;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableSet *opcodes = [NSMutableSet new];
            for (int index = 0; index < FRBUniqueOpcodesCount; index++) {
                [opcodes addObject:[[NSString stringWithUTF8String:FRBMnemonics[index].name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            _colouriser = [[ItFrobHopper65xxCommonInstructionColouriser alloc] initWithOpcodesSet:opcodes
                                                                                      andServices:services];
            kModelHandler = [ItFrobHopper6502ModelHandler sharedModelHandler];
        });
    }

    return self;
}

- (id<CPUContext>)buildCPUContextForFile:(id<HPDisassembledFile>)file {
    return [[ItFrobHopper6502Context alloc] initWithCPU:self
                                                andFile:file
                                           withServices:_services];
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
    return @"©2014 Alessandro Gatti";
}

- (NSString *)pluginVersion {
    return @"0.1.3";
}

- (NSArray *)cpuFamilies {
    NSMutableArray *remaining = [NSMutableArray arrayWithArray:[kModelHandler.models.allKeys sortedArrayUsingComparator:^NSComparisonResult(id first, id second) {
        return [first compare:second];
    }]];
    [remaining removeObject:kModelHandler.defaultModel];

    NSMutableArray *families = [NSMutableArray new];
    [families addObject:kModelHandler.defaultModel];
    [families addObjectsFromArray:remaining];

    return families;
}

- (NSArray *)cpuSubFamiliesForFamily:(NSString *)family {
    return [((NSDictionary *)kModelHandler.models[family]).allKeys sortedArrayUsingComparator:^NSComparisonResult(id first, id second) {
        return [first compare:second];
    }];
}

- (int)addressSpaceWidthInBitsForCPUFamily:(NSString *)family
                              andSubFamily:(NSString *)subFamily {
    const NSDictionary *subFamilies = kModelHandler.models[family];
    return subFamilies && subFamilies[subFamily] ? 16 : 0;
}

- (NSString *)registerIndexToString:(int)reg
                            ofClass:(RegClass)reg_class
                        withBitSize:(int)size
                        andPosition:(DisasmPosition)position {
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

                // Until the SDK allows to manipulate the stack pointer
                // directly, we have to consider the stack pointer as a
                // general purpose register for the sake of block register
                // usage markers.

                case FRBRegisterS:
                    return @"S";

                case FRBRegisterP:
                    return @"P";

                // R65C19 extended registers.

                case FRBRegisterW:
                    return @"W";

                case FRBRegisterI:
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
                forFile:(id<HPDisassembledFile>)file {

    uint8_t nop = [file.cpuFamily isEqualToString:@"Sunplus"] ? 0xF2 : 0xEA;
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
