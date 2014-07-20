/*!
 Copyright (c) 2014, Alessandro Gatti
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

#import "MOS6502CPU.h"
#import "MOS6502Ctx.h"
#import "MOS6502Opcodes.h"

static NSString * const kCpuFamily = @"MOS";
static NSString * const kCpuSubFamily = @"6502";
static NSString * const kSyntaxVariant = @"Generic";
static NSString * const kCpuMode = @"generic";

@interface MOS6502CPU()

/*!
 Gets the Hopper version for the given services object instance as a hex value.

 The value is built as such: 0x00MMmmrr with MM being the major version,
 mm being the minor version, and rr being the revision.  This is exactly the
 same as what Python's sys.hexversion works.

 @param services The instance of Hopper services object.

 @return The version value.
 */
+ (NSUInteger)integerHopperVersion:(NSObject<HPHopperServices> *)services;

@property (strong, nonatomic, readonly) NSSet *validOpcodes;

@end

@implementation MOS6502CPU {
    NSObject<HPHopperServices> *_services;
}

- (NSObject<HopperPlugin> *)initWithHopperServices:(NSObject<HPHopperServices> *)services {
    NSUInteger version = [MOS6502CPU integerHopperVersion:services];
    if (version > 0x00030303) {
        [services logMessage:[NSString stringWithFormat:@"Hopper version %@ is too new for this plugin",
                              [services hopperVersionString]]];
        return nil;
    }

    if (self = [super init]) {
        _services = services;

        NSMutableSet *opcodes = [NSMutableSet new];
        for (int index = 0; index < kOpcodeNamesCount; index++) {
            [opcodes addObject:[NSString stringWithUTF8String:kOpcodeNames[index]]];
        }
        _validOpcodes = opcodes;
    }

    return self;
}

- (NSObject<CPUContext> *)buildCPUContextForFile:(NSObject<HPDisassembledFile> *)file {
    return [[MOS6502Ctx alloc] initWithCPU:self
                                   andFile:file];
}

- (UUID *)pluginUUID {
    return [_services UUIDWithString:@"00E347A0-0931-11E4-9191-0800200C9A66"];
}

- (HopperPluginType)pluginType {
    return Plugin_CPU;
}

- (NSString *)pluginName {
    return @"6502";
}

- (NSString *)pluginDescription {
    return @"MOS 6502/6510 CPU support";
}

- (NSString *)pluginAuthor {
    return @"Alessandro Gatti";
}

- (NSString *)pluginCopyright {
    return @"©2014 Alessandro Gatti";
}

- (NSString *)pluginVersion {
    return @"0.0.3";
}

- (NSArray *)cpuFamilies {
    return @[ kCpuFamily ];
}

- (NSArray *)cpuSubFamiliesForFamily:(NSString *)family {
    return [kCpuFamily isEqualToString:family] ? @[ kCpuSubFamily ] : nil;
}

- (int)addressSpaceWidthInBitsForCPUFamily:(NSString *)family
                              andSubFamily:(NSString *)subFamily {
    return ([kCpuFamily isEqualToString:family] &&
            [kCpuSubFamily isEqualToString:kCpuSubFamily]) ? 16 : 0;
}

- (NSString *)registerIndexToString:(int)reg
                            ofClass:(RegClass)reg_class
                        withBitSize:(int)size
                        andPosition:(DisasmPosition)position {
    switch (reg_class) {
        case RegClass_PseudoRegisterSTACK:
            return @"SP";

        case RegClass_GeneralPurposeRegister:
            switch (reg) {
                case 0:
                    return @"A";

                case 1:
                    return @"X";

                case 2:
                    return @"Y";

                default:
                    break;
            }
            break;

        default:
            break;
    }

    return nil;
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
    return @[ kCpuMode ];
}

- (NSUInteger)registerClassCount {
    return RegClass_FirstUserClass;
}

- (NSUInteger)registerCountForClass:(NSUInteger)reg_class {
    switch (reg_class) {
        case RegClass_CPUState:
            return 0;

        case RegClass_PseudoRegisterSTACK:
            return 1;

        case RegClass_GeneralPurposeRegister:
            return 3;

        default:
            break;
    }

    return 0;
}

- (NSUInteger)translateOperandIndex:(NSUInteger)index
                       operandCount:(NSUInteger)count
                  accordingToSyntax:(uint8_t)syntaxIndex {
    return index;
}

- (NSAttributedString *)colorizeInstructionString:(NSAttributedString *)string {

    // Extremely simplistic, to be changed later - possibly when access
    // to DisasmStruct is available from here.

    NSMutableAttributedString *clone = [string mutableCopy];
    [clone beginEditing];

    NSString *rawString = clone.string;
    if (string.length < 3) {
        return string;
    }

    NSRange opcodeRange = NSMakeRange(0, 3);
    NSString *potentialOpcode = [rawString substringWithRange:opcodeRange];
    if (![self.validOpcodes containsObject:potentialOpcode]) {
        return string;
    }

    [clone setAttributes:(NSDictionary *)[_services ASMLanguageColor] // :(
                   range:opcodeRange];

    if (string.length > 3) {
        int offset = 4;
        const char *buffer = rawString.UTF8String;
        NSInteger numberStart = NSNotFound;
        BOOL numberFound = NO;
        BOOL negativeMarkerFound = NO;
        ArgFormat formatFound = Format_Decimal;

        while (offset < rawString.length) {
            unichar character = buffer[offset];

            if (character == '#') {
                if (numberFound) {
                    // Duplicate immediate value markers should not appear, bail out.
                    [clone endEditing];
                    return clone;
                }

                [clone setAttributes:(NSDictionary *)[_services ASMLanguageColor] // :(
                               range:NSMakeRange(offset, 1)];
                offset++;
                continue;
            }

            if (character == '-') {
                if (numberFound) {
                    // Duplicate negative markers should not appear, bail out.
                    [clone endEditing];
                    return clone;
                }

                numberStart = offset;
                numberFound = YES;
                negativeMarkerFound = YES;
                offset++;
                continue;
            }

            if (character == '%' || character == '$') {
                if (numberFound) {
                    // Duplicate format markers should not appear, bail out.
                    [clone endEditing];
                    return clone;
                }

                numberStart = offset;
                numberFound = YES;

                switch (character) {
                    case '$':
                        formatFound = Format_Hexadecimal;
                        break;

                    case '%':
                        formatFound = Format_Binary;
                        if (negativeMarkerFound) {
                            // Negative binary numbers should not appear, bail out.
                            [clone endEditing];
                            return clone;
                        }
                        break;

                    default:
                        // Should not happen!
                        break;
                }

                offset++;
                continue;
            }

            if (isdigit(character)) {
                if (formatFound == Format_Binary) {
                    if (character != '0' && character != '1') {
                        // Non-binary digits found with a binary format marker, bail out.
                        [clone endEditing];
                        return clone;
                    }
                }

                if (!numberFound) {
                    numberStart = offset;
                    numberFound = YES;
                }
                offset++;
                continue;
            }

            if (formatFound == Format_Hexadecimal) {
                switch (character) {
                    case 'A':
                    case 'B':
                    case 'C':
                    case 'D':
                    case 'E':
                    case 'F':
                        offset++;
                        continue;

                    default:
                        // Non-hexadecimal digit found, mark and exit.
                        [clone setAttributes:(NSDictionary *)[_services ASMNumberColor] // :(
                                       range:NSMakeRange(numberStart, offset - numberStart)];
                        break;
                }
            }

            if (character == 'o' && formatFound != Format_Binary &&
                formatFound != Format_Hexadecimal && numberFound) {

                // Octal end marker found, mark and exit.
                offset++;
                [clone setAttributes:(NSDictionary *)[_services ASMNumberColor] // :(
                               range:NSMakeRange(numberStart, offset - numberStart)];
                break;
            }

            if (numberFound) {
                // Non-digit marker found, mark and exit.

                offset++;
                [clone setAttributes:(NSDictionary *)[_services ASMNumberColor] // :(
                               range:NSMakeRange(numberStart, offset - numberStart)];
                break;
            }

            // Nothing found yet, keep on iterating.
            offset++;
        }

        if (numberFound) {
            // Reached EOL whilst scanning for a number, mark and exit.
            [clone setAttributes:(NSDictionary *)[_services ASMNumberColor] // :(
                           range:NSMakeRange(numberStart, offset - numberStart)];
        }
    }

    [clone endEditing];

    return clone;
}

- (NSData *)nopWithSize:(NSUInteger)size
                andMode:(NSUInteger)cpuMode
                forFile:(NSObject<HPDisassembledFile> *)file {
    NSMutableData *nopBuffer = [[NSMutableData alloc] initWithCapacity:size];
    memset(nopBuffer.mutableBytes, 0xEA, size);
    return nopBuffer;
}

- (BOOL)canAssembleInstructionsForCPUFamily:(NSString *)family
                               andSubFamily:(NSString *)subFamily {
    return NO;
}

- (BOOL)canDecompileProceduresForCPUFamily:(NSString *)family
                              andSubFamily:(NSString *)subFamily {
    return NO;
}

#pragma mark Utility methods

+ (NSUInteger)integerHopperVersion:(NSObject<HPHopperServices> *)services {
    return (NSUInteger) (([services hopperMajorVersion] << 16) |
                ([services hopperMinorVersion] << 8) |
                [services hopperRevision]);
}

@end
