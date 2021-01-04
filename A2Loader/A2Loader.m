/*
 Copyright (c) 2014-2021, Alessandro Gatti - frob.it
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

#import "A2Loader.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static NSString *kCPUFamily = @"Generic";
static NSString *kCPUSubFamily = @"65c02";

@interface ItFrobHopperA2Loader ()

/**
 * Hopper Services instance.
 */
@property(strong, nonatomic, nonnull) NSObject<HPHopperServices> *services;

@end

@implementation ItFrobHopperA2Loader

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
  if (self = [super init]) {
    _services = services;
  }

  return self;
}

- (NSObject<HPHopperUUID> *)pluginUUID {
  return [self.services UUIDWithString:@"84648F44-2869-4563-99A3-36AA9466D381"];
}

- (HopperPluginType)pluginType {
  return Plugin_Loader;
}

- (NSString *)pluginName {
  return @"Apple ][ Binary File";
}

- (NSString *)pluginDescription {
  return @"Apple ][ Binary File Loader";
}

- (NSString *)pluginAuthor {
  return @"Alessandro Gatti";
}

- (NSString *)pluginCopyright {
  return @"©2014-2021 Alessandro Gatti";
}

- (NSString *)pluginVersion {
  return @"0.0.1";
}

- (nonnull NSArray<NSString *> *)commandLineIdentifiers {
  return @[ @"a2" ];
}

+ (int)sdkVersion {
  return HOPPER_CURRENT_SDK_VERSION;
}

- (BOOL)canLoadDebugFiles {
  return NO;
}

- (FileLoaderLoadingStatus)loadData:(NSData *)data
              usingDetectedFileType:(NSObject<HPDetectedFileType> *)fileType
                            options:(FileLoaderOptions)options
                            forFile:(NSObject<HPDisassembledFile> *)file
                      usingCallback:(FileLoadingCallbackInfo)callback {

  if (data.length > 65570) {
    [self.services
        logMessage:[NSString stringWithFormat:@"File too big: %lu bytes",
                                              data.length]];
    return DIS_BadFormat;
  }

  uint16 startingAddress = OSReadLittleInt16(data.bytes, 0);
  uint16 dataLength = OSReadLittleInt16(data.bytes, 2);
  unsigned long size = data.length - 4;

  if ((startingAddress + size) > 65536) {
    [self.services
        logMessage:[NSString stringWithFormat:@"File too big: %lu bytes",
                                              data.length]];
    return DIS_BadFormat;
  }

  NSData *fileData = [NSData dataWithBytes:data.bytes + 4 length:size];

  NSObject<HPSegment> *segment = [file addSegmentAt:startingAddress
                                               size:MAX(size, dataLength)];
  segment.mappedData = fileData;
  segment.segmentName = @"CODE";
  segment.fileOffset = 4;
  segment.fileLength = MIN(size, dataLength);

  size_t fileOffset = 4;
  unsigned long fileLength = size;

  NSObject<HPSection> *section =
      [segment addSectionAt:(startingAddress + fileOffset - 4) size:fileLength];
  section.pureDataSection = NO;
  section.pureCodeSection = NO;
  section.containsCode = YES;
  section.fileOffset = fileOffset;
  section.fileLength = fileLength;
  section.sectionName = @"CODE";

  file.cpuFamily = kCPUFamily;
  file.cpuSubFamily = kCPUSubFamily;
  [file setAddressSpaceWidthInBits:16];

  return DIS_OK;
}

- (FileLoaderLoadingStatus)loadDebugData:(NSData *)data
                                 forFile:(NSObject<HPDisassembledFile> *)file
                           usingCallback:(FileLoadingCallbackInfo)callback {
  return DIS_NotSupported;
}

- (void)fixupRebasedFile:(NSObject<HPDisassembledFile> *)file
               withSlide:(int64_t)slide
        originalFileData:(NSData *)fileData {
}

- (nullable NSArray<NSObject<HPDetectedFileType> *> *)
    detectedTypesForData:(nonnull NSData *)data
             ofFileNamed:(nullable NSString *)filename {
  NSObject<HPDetectedFileType> *detectedType = self.services.detectedType;
  detectedType.fileDescription = @"Apple ][ binary code";
  detectedType.addressWidth = AW_16bits;
  detectedType.cpuFamily = kCPUFamily;
  detectedType.cpuSubFamily = kCPUSubFamily;
  detectedType.additionalParameters = @[];
  detectedType.shortDescriptionString = @"a2";
  return @[ detectedType ];
}

- (nullable NSData *)extractFromData:(NSData *)data
               usingDetectedFileType:(NSObject <HPDetectedFileType> *)fileType
                    originalFileName:(NSString *)filename
                  returnAdjustOffset:(uint64_t *)adjustOffset
                returnAdjustFilename:(__autoreleasing NSString **)newFilename {
  return nil;
}

- (void)setupFile:(NSObject <HPDisassembledFile> *)file
afterExtractionOf:(NSString *)filename
             type:(NSObject <HPDetectedFileType> *)fileType {
}

#pragma mark Private methods

@end

#pragma clang diagnostic pop
