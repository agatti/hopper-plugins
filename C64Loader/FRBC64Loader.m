/*
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

#import "FRBC64Loader.h"
#import "FRBC64Basic.h"

@interface ItFrobHopperC64Loader() {

    /*!
     *	Hopper Services provider instance.
     */
    id<HPHopperServices> _services;
}

/*!
 *	Attempts to parse a C64 BASIC program into a human-readable form.
 *
 *	@param data    the BASIC token stream.
 *	@param address the offset in the data block to start reading from.
 *	@param array   a list of lines with the decoded BASIC program.
 *	@param size    a pointer to the amount of bytes that have been consumed.
 *
 *	@return an instance of NSError if an error occurred, nil otherwise.
 */
- (NSError *)parseBasicProgram:(NSData *)data
                     atAddress:(NSUInteger)address
                       toArray:(NSMutableArray *)array
                          size:(NSUInteger *)size;
@end

@implementation ItFrobHopperC64Loader

- (instancetype)initWithHopperServices:(id<HPHopperServices>)services {
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
    return @"0.1.0";
}

- (CPUEndianess)endianess {
    return CPUEndianess_Little;
}

- (BOOL)canLoadDebugFiles {
    return NO;
}

- (NSArray *)detectedTypesForData:(NSData *)data {
    id<HPDetectedFileType> detectedType = [_services detectedType];
    detectedType.fileDescription = @"C64 Executable code";
    detectedType.addressWidth = AW_16bits;
    detectedType.cpuFamily = @"Generic";
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
                            forFile:(id<HPDisassembledFile>)file
                      usingCallback:(FileLoadingCallbackInfo)callback {

    id<HPDetectedFileType> detectedType = (id<HPDetectedFileType>)fileType; // :(
    id<HPLoaderOptionComponents> hasBasic = detectedType.additionalParameters[0];

    if (data.length > 65538) {
        [_services logMessage:[NSString stringWithFormat:@"File too big: %lu bytes", data.length]];
        return DIS_BadFormat;
    }

    uint16 startingAddress = OSReadLittleInt16(data.bytes, 0);
    unsigned long size = data.length - 2;
    uint16 endingAddress = (uint16) ((startingAddress + size) & 0xFFFF);

    if (endingAddress > 65535) {
        [_services logMessage:[NSString stringWithFormat:@"File too big: %lu bytes", data.length]];
        return DIS_BadFormat;
    }

    NSData *fileData = [NSData dataWithBytes:data.bytes + 2
                                      length:size];

    id<HPSegment> segment = [file addSegmentAt:startingAddress
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
            id<HPSection> section = [segment addSectionAt:startingAddress
                                                     size:basicSize];
            section.pureCodeSection = NO;
            section.fileOffset = fileOffset;
            section.fileLength = basicSize;
            section.sectionName = @"basic";

            fileOffset += basicSize;
            fileLength -= basicSize;

            // :(

            [file setComment:[NSString stringWithFormat:@"Basic program:\n%@", [lines componentsJoinedByString:@"\n"]]
            atVirtualAddress:startingAddress
                      reason:CCReason_Script];
        }
    }

    id<HPSection> section = [segment addSectionAt:(startingAddress + fileOffset - 2)
                                             size:fileLength];
    section.pureCodeSection = NO;
    section.fileOffset = fileOffset;
    section.fileLength = fileLength;
    section.sectionName = @"code";

    file.cpuFamily = @"Generic";
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
                    const char *opcode = FRBC64BasicTokens[byte];
                    if (!opcode) {
                        [line addObject:@"{UNKNOWN}"];
                    } else {
                        [line addObject:[NSString stringWithUTF8String:opcode]];
                    }
                } else {
                    [line addObject:[NSString stringWithUTF8String:FRBC64PetsciiCharacters[byte]]];
                }
            }
        }

        [array addObject:[line componentsJoinedByString:@""]];
    }

    *size = offset;
    return nil;
}

@end
