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

#import "C64Loader.h"
#import "C64Basic.h"

@interface C64Loader()

/*!
 Gets the Hopper version for the given services object instance as a hex value.

 The value is built as such: 0x00MMmmrr with MM being the major version,
 mm being the minor version, and rr being the revision.  This is exactly the
 same as what Python's sys.hexversion works.

 @param services The instance of Hopper services object.

 @return The version value.
 */
+ (NSUInteger)integerHopperVersion:(NSObject<HPHopperServices> *)services;

- (NSError *)parseBasicProgram:(NSData *)data
                     atAddress:(NSUInteger)address
                       toArray:(NSMutableArray *)array
                          size:(NSUInteger *)size;

@end

@implementation C64Loader {
    NSObject<HPHopperServices> *_services;
}

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
    NSUInteger version = [C64Loader integerHopperVersion:services];
    if (version > 0x00030303) {
        [services logMessage:[NSString stringWithFormat:@"Hopper version %@ is too new for this plugin",
                              [services hopperVersionString]]];
        return nil;
    }

    if (self = [super init]) {
        _services = services;
    }
    return self;
}

- (UUID *)pluginUUID {
    return [_services UUIDWithString:@"92AF9450-09AD-11E4-9191-0800200C9A66"];
}

- (HopperPluginType)pluginType {
    return Plugin_Loader;
}

- (NSString *)pluginName {
    return @"C64 File";
}

- (NSString *)pluginDescription {
    return @"C64 File Loader";
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

- (CPUEndianess)endianess {
    return CPUEndianess_Little;
}

- (BOOL)canLoadDebugFiles {
    return NO;
}

- (NSArray *)detectedTypesForData:(NSData *)data {
    NSObject<HPDetectedFileType> *detectedType = [_services detectedType];
    detectedType.fileDescription = @"C64 Executable code";
    detectedType.addressWidth = AW_16bits;
    detectedType.cpuFamily = @"MOS";
    detectedType.cpuSubFamily = @"6502";
    detectedType.additionalParameters = @[
                                          [_services checkboxComponentWithLabel:@"Contains BASIC code"
                                                                        checked:NO]
                                          ];
    return @[ detectedType ];
}

- (FileLoaderLoadingStatus)loadData:(NSData *)data
              usingDetectedFileType:(DetectedFileType *)fileType
                            options:(FileLoaderOptions)options
                            forFile:(NSObject<HPDisassembledFile> *)file
                      usingCallback:(FileLoadingCallbackInfo)callback {

    NSObject<HPDetectedFileType> *detectedType = (NSObject<HPDetectedFileType> *)fileType; // :(
    NSObject<HPLoaderOptionComponents> *hasBasic = detectedType.additionalParameters[0];

    if (data.length > 65538) {
        NSLog(@"File too big: %lu bytes", data.length);
        return DIS_BadFormat;
    }

    uint16 startingAddress = OSReadLittleInt16(data.bytes, 0);
    unsigned long size = data.length - 2;
    uint16 endingAddress = (uint16) ((startingAddress + size) & 0xFFFF);

    if (endingAddress > 65535) {
        NSLog(@"File too big: %lu bytes", data.length);
        return DIS_BadFormat;
    }

    NSData *fileData = [NSData dataWithBytes:data.bytes + 2
                                      length:size];

    NSObject<HPSegment> *segment = [file addSegmentAt:startingAddress
                                                 size:size];
    segment.mappedData = fileData;
    segment.segmentName = @"CODE";
    segment.fileOffset = 2;
    segment.fileLength = size;

    size_t fileOffset = 2;
    unsigned long fileLength = size;

    if (hasBasic.isChecked) {
        NSMutableArray *lines = [NSMutableArray new];
        NSUInteger basicSize = 0;
        NSError *error = [self parseBasicProgram:fileData
                                       atAddress:startingAddress
                                         toArray:lines
                                            size:&basicSize];
        if (!error) {
            NSObject<HPSection> *section = [segment addSectionAt:startingAddress
                                                            size:basicSize];
            section.pureCodeSection = NO;
            section.fileOffset = fileOffset;
            section.fileLength = basicSize;
            section.sectionName = @"basic";

            fileOffset += basicSize;
            fileLength -= basicSize;

            [segment setComment:[NSString stringWithFormat:@"Basic program:\n%@", [lines componentsJoinedByString:@"\n"]]
               atVirtualAddress:startingAddress];
        }
    }

    NSObject<HPSection> *section = [segment addSectionAt:(startingAddress + fileOffset - 2)
                                                    size:fileLength];
    section.pureCodeSection = NO;
    section.fileOffset = fileOffset;
    section.fileLength = fileLength;
    section.sectionName = @"code";

    file.cpuFamily = @"MOS";
    file.cpuSubFamily = @"6502";
    [file setAddressSpaceWidthInBits:16];
    [file addEntryPoint:section.startAddress];

    return DIS_OK;
}

- (FileLoaderLoadingStatus)loadDebugData:(NSData *)data
                                 forFile:(NSObject<HPDisassembledFile> *)file
                           usingCallback:(FileLoadingCallbackInfo)callback {
    return DIS_NotSupported;
}

- (NSData *)extractFromData:(NSData *)data
      usingDetectedFileType:(DetectedFileType *)fileType
         returnAdjustOffset:(uint64_t *)adjustOffset {
    return nil;
}

///////////////////////////////////////////////////////////////////////////////

#pragma mark Utility methods

- (NSError *)parseBasicProgram:(NSData *)data
                atAddress:(NSUInteger)address
                  toArray:(NSMutableArray *)array
                     size:(NSUInteger *)size {
    NSUInteger offset = 0;
    const uint8_t *buffer = (const uint8_t *) data.bytes;
    BOOL done = NO;
    while (offset < data.length && !done) {
        uint16_t link = OSReadLittleInt16(buffer, offset);
        if (link == 0 || link < 0x800 || link > 0x9FFF) {
            break;
        }
        offset += 2;

        long linkAddress = link - (NSInteger) address;
        if (linkAddress <= 0 || linkAddress < offset) {
            return [NSError errorWithDomain:@"C64Loader"
                                       code:NSInvalidIndexSpecifierError
                                   userInfo:nil];
        }
        uint8_t linkTarget = buffer[linkAddress];
        if (!buffer[linkTarget]) {
            done = YES;
        }

        NSMutableArray *line = [NSMutableArray new];

        uint16_t lineNumber = OSReadLittleInt16(buffer, offset);
        offset += 2;
        [line addObject:[NSString stringWithFormat:@"%d", lineNumber]];
        [line addObject:@" "];

        BOOL quoteMode = NO;

        while (offset < data.length) {
            uint8_t byte = buffer[offset++];
            if (byte == 0x00) {
                break;
            }

            if (byte == 0x34) {
                quoteMode = !quoteMode;
                [line addObject:[NSString stringWithFormat:@"%c", byte]];
            } else {
                if (!quoteMode && byte >= 0x80) {
                    const char *opcode = kC64BasicTokens[byte];
                    if (!opcode) {
                        [line addObject:@"{UNKNOWN}"];
                    } else {
                        [line addObject:[NSString stringWithUTF8String:opcode]];
                    }
                } else {
                    [line addObject:[NSString stringWithUTF8String:kC64PetsciiCharacters[byte]]];
                }
            }
        }

        [array addObject:[line componentsJoinedByString:@""]];
    }

    *size = offset;
    return nil;
}

+ (NSUInteger)integerHopperVersion:(NSObject<HPHopperServices> *)services {
    return (NSUInteger) (([services hopperMajorVersion] << 16) |
        ([services hopperMinorVersion] << 8) |
        [services hopperRevision]);
}

@end
