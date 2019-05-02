/*
 Copyright (c) 2014-2019, Alessandro Gatti - frob.it
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

#import "HexLoader.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

#define PREFIXCLASS(name) ItFrobHopper##name

#define IntelHexRecord PREFIXCLASS(IntelHexRecord)
#define DataBlock PREFIXCLASS(DataBlock)

typedef NS_ENUM(NSUInteger, HexFileType) {
  UnknownFileType = 0,
  IntelHexFileType,
};

typedef NS_ENUM(NSUInteger, IntelHexRecordType) {
  IntelRecordTypeData = 0,
  IntelRecordTypeEOF,
  IntelRecordTypeExtendedSegment,
  IntelRecordTypeStartSegment,
  IntelRecordTypeExtendedLinear,
  IntelRecordTypeStartLinear
};

@interface IntelHexRecord : NSObject

@property(nonatomic, assign) NSUInteger address;
@property(nonatomic, assign) IntelHexRecordType type;
@property(nonatomic, strong) NSData *_Nonnull data;

- (NSUInteger)size;

@end

@implementation IntelHexRecord

- (NSUInteger)size {
  return self.data.length;
}

@end

@interface DataBlock : NSObject

@property(nonatomic, assign) NSUInteger address;
@property(nonatomic, nonnull, strong) NSMutableData *data;

- (instancetype)initWithIntelHexRecord:(IntelHexRecord *_Nonnull)record;

- (NSRange)range;

- (Address)start;

- (Address)end;

- (NSUInteger)size;

@end

@implementation DataBlock

- (instancetype)initWithIntelHexRecord:(IntelHexRecord *_Nonnull)record {
  if (self = [super init]) {
    _address = record.address;
    _data = [[NSMutableData alloc] initWithData:record.data];
  }

  return self;
}

- (NSRange)range {
  return NSMakeRange(self.address, self.data.length);
}

- (Address)start {
  return self.address;
}

- (Address)end {
  return self.address + self.data.length;
}

- (NSUInteger)size {
  return self.data.length;
}

@end

static const uint8_t kHexTable[16] = {'0', '1', '2', '3', '4', '5', '6', '7',
                                      '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

@interface ItFrobHopperHexLoader ()

/**
 * Hopper Services instance.
 */
@property(strong, nonatomic, nonnull) NSObject<HPHopperServices> *services;

- (HexFileType)detectFileType:(NSData *_Nonnull)data;

- (IntelHexRecord *_Nullable)recordInData:(NSData *_Nonnull)data
                                 atOffset:(NSUInteger)offset
                                consuming:(NSUInteger *_Nonnull)consumed;

- (NSInteger)nextHexByte:(NSData *_Nonnull)data atOffset:(NSUInteger)offset;

@end

@implementation ItFrobHopperHexLoader

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
  if (self = [super init]) {
    _services = services;
  }
  return self;
}

- (NSObject<HPHopperUUID> *)pluginUUID {
  return [self.services UUIDWithString:@"8960E92F-7292-4726-B2A6-EC4B329FD945"];
}

- (HopperPluginType)pluginType {
  return Plugin_Loader;
}

- (NSString *)pluginName {
  return @"Hex File";
}

- (NSString *)pluginDescription {
  return @"Hex File Loader";
}

- (NSString *)pluginAuthor {
  return @"Alessandro Gatti";
}

- (NSString *)pluginCopyright {
  return @"©2014-2019 Alessandro Gatti";
}

- (NSString *)pluginVersion {
  return @"0.0.1";
}

- (NSString *)commandLineIdentifier {
  return @"hex";
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

  NSMutableArray<DataBlock *> *_Nullable blocks =
      [NSMutableArray<DataBlock *> new];

  BOOL finished = NO;
  BOOL startAddressFound = NO;
  NSUInteger linearAddress = 0;
  NSUInteger startAddress = 0;
  NSUInteger offset = 0;
  NSUInteger consumed = 0;

  do {
    IntelHexRecord *record = [self recordInData:data
                                       atOffset:offset
                                      consuming:&consumed];

    if (!record) {
      return DIS_BadFormat;
    }

    offset += consumed;

    switch (record.type) {
    case IntelRecordTypeData: {
      [blocks addObject:[[DataBlock alloc] initWithIntelHexRecord:record]];
      break;
    }

    case IntelRecordTypeEOF:
      if (record.size != 0) {
        return DIS_BadFormat;
      }

      finished = YES;
      break;

    case IntelRecordTypeExtendedSegment:
      if (record.data.length != 2) {
        return DIS_BadFormat;
      }

      linearAddress = (linearAddress & 0xFFFF) +
                      (OSReadBigInt16(record.data.bytes, 0) << 16);
      break;

    case IntelRecordTypeStartSegment:
      break;

    case IntelRecordTypeExtendedLinear:
      if (record.size != 4) {
        return DIS_BadFormat;
      }

      startAddress = OSReadBigInt32(record.data.bytes, 0);
      startAddressFound = YES;
      break;

    case IntelRecordTypeStartLinear:
      break;

    default:
      return DIS_BadFormat;
    }
  } while (!finished);

  if (blocks.count == 0) {
    return DIS_BadFormat;
  }

  // Sort and coalesce contiguous ranges

  [blocks sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    NSUInteger obj1Address = ((DataBlock *)obj1).address;
    NSUInteger obj2Address = ((DataBlock *)obj2).address;

    if (obj1Address < obj2Address) {
      return NSOrderedAscending;
    }

    if (obj2Address > obj1Address) {
      return NSOrderedDescending;
    }

    return NSOrderedSame;
  }];

  NSUInteger currentBlockIndex = 0;

  do {
    // Last item?
    if ((currentBlockIndex + 1) >= blocks.count) {
      break;
    }

    // Overlapping item?
    if (NSIntersectionRange(blocks[currentBlockIndex].range,
                            blocks[currentBlockIndex + 1].range)
            .length != 0) {
      [[self.services currentDocument]
          displayAlertWithMessageText:@"Overlapping data ranges"
                        defaultButton:@"Stop"
                      alternateButton:nil
                          otherButton:nil
                      informativeText:
                          [NSString stringWithFormat:
                                        @"Overlapping data ranges in HEX files "
                                        @"are currently not supported (ranges "
                                        @"%llX..%llX and %llX..%llX overlap).",
                                        blocks[currentBlockIndex].start,
                                        blocks[currentBlockIndex].end,
                                        blocks[currentBlockIndex + 1].start,
                                        blocks[currentBlockIndex + 1].end]];
      return DIS_BadFormat;
    }

    // Contiguous block?

    if ((blocks[currentBlockIndex + 1].start - blocks[currentBlockIndex].end) ==
        0) {
      [blocks[currentBlockIndex].data
          appendData:blocks[currentBlockIndex + 1].data];
      [blocks removeObjectAtIndex:currentBlockIndex + 1];
    } else {
      currentBlockIndex++;
    }
  } while (currentBlockIndex < blocks.count);

  // Create segments

  for (DataBlock *block in blocks) {
    NSObject<HPSegment> *segment = [file addSegmentAt:block.start
                                                 size:block.size];
    NSObject<HPSection> *section = [segment addSectionAt:block.start
                                                    size:block.size];
    section.pureCodeSection = YES;
    section.containsCode = YES;
    [segment setMappedData:block.data];
  }

  if (startAddressFound) {
    [file addEntryPoint:startAddress];
  }

  NSObject<HPLoaderOptionComponents> *cpuType =
      fileType.additionalParameters[0];
  file.cpuFamily = cpuType.cpuFamily;
  file.cpuSubFamily = cpuType.cpuSubFamily;

  // @todo How to get address space width from here?
  [file setAddressSpaceWidthInBits:32];

  return DIS_OK;
}

- (void)fixupRebasedFile:(NSObject<HPDisassembledFile> *)file
               withSlide:(int64_t)slide
        originalFileData:(NSData *)fileData {
}

- (FileLoaderLoadingStatus)loadDebugData:(NSData *)data
                                 forFile:(NSObject<HPDisassembledFile> *)file
                           usingCallback:(FileLoadingCallbackInfo)callback {
  return DIS_NotSupported;
}

- (nullable NSArray<NSObject<HPDetectedFileType> *> *)
    detectedTypesForData:(nonnull NSData *)data
             ofFileNamed:(nullable NSString *)filename {
  NSObject<HPDetectedFileType> *detectedType = self.services.detectedType;
  detectedType.additionalParameters = @[
    [self.services cpuComponentWithLabel:@"Processor type"],
  ];

  switch ([self detectFileType:data]) {
  case IntelHexFileType:
    detectedType.fileDescription = @"Intel HEX";
    detectedType.shortDescriptionString = @"intelhex";
    detectedType.internalId = IntelHexFileType;
    break;

  case UnknownFileType:
  default:
    return @[];
  }

  return @[ detectedType ];
}

- (nullable NSData *)
          extractFromData:(nonnull NSData *)data
    usingDetectedFileType:(nonnull NSObject<HPDetectedFileType> *)fileType
       returnAdjustOffset:(nullable uint64_t *)adjustOffset
     returnAdjustFilename:
         (NSString *__autoreleasing _Nullable *_Nullable)newFilename {
  return nil;
}

- (HexFileType)detectFileType:(NSData *_Nonnull)data {
  if (data.length <= 11) {
    return UnknownFileType;
  }

  const uint8_t *bytes = (const uint8_t *)data.bytes;
  size_t offset = 0;
  bool carriageReturnFound = NO;
  bool lineFeedFound = NO;
  bool lineRead = NO;
  HexFileType type;

  switch (bytes[offset]) {
  case ':':
    type = IntelHexFileType;
    break;

  default:
    return UnknownFileType;
  }

  offset++;

  while (offset < data.length && !lineRead) {
    switch (bytes[offset]) {
    case '\r':
      if (!carriageReturnFound) {
        carriageReturnFound = YES;
      } else {
        return UnknownFileType;
      }
      break;

    case '\n':
      if (!carriageReturnFound) {
        return UnknownFileType;
      } else {
        lineFeedFound = YES;
        lineRead = YES;
      }
      break;

    default:
      if (!isxdigit(bytes[offset])) {
        return UnknownFileType;
      }
      break;
    }

    offset++;
  }

  return lineFeedFound ? type : UnknownFileType;
}

- (IntelHexRecord *_Nullable)recordInData:(NSData *_Nonnull)data
                                 atOffset:(NSUInteger)offset
                                consuming:(NSUInteger *_Nonnull)consumed {

  if ((offset > data.length) || ((data.length - offset) < 12)) {
    return nil;
  }

  const uint8_t *bytes = (const uint8_t *)data.bytes;
  NSUInteger current = 0;

  if (bytes[current + offset] != ':') {
    return nil;
  }
  current++;

  IntelHexRecord *record = [IntelHexRecord new];

  NSUInteger checksum = 0;
  NSUInteger dataBytes;
  NSInteger value;

  value = [self nextHexByte:data atOffset:current + offset];
  if (value < 0) {
    return nil;
  }
  current += 2;

  checksum += value;
  dataBytes = (NSUInteger)value;

  value = [self nextHexByte:data atOffset:(current + offset)];
  if (value < 0) {
    return nil;
  }
  current += 2;

  checksum += value;

  record.address = (NSUInteger)(value << 8);

  value = [self nextHexByte:data atOffset:(current + offset)];
  if (value < 0) {
    return nil;
  }
  current += 2;

  checksum += value;

  record.address |= (NSUInteger)value;

  value = [self nextHexByte:data atOffset:(current + offset)];
  if (value < 0) {
    return nil;
  }
  current += 2;

  checksum += value;

  switch ((IntelHexRecordType)value) {
  case IntelRecordTypeData:
  case IntelRecordTypeEOF:
  case IntelRecordTypeExtendedSegment:
  case IntelRecordTypeStartSegment:
  case IntelRecordTypeExtendedLinear:
  case IntelRecordTypeStartLinear:
    record.type = (IntelHexRecordType)value;
    break;

  default:
    return nil;
  }

  NSMutableData *dataBlock = [[NSMutableData alloc] initWithCapacity:dataBytes];
  [dataBlock increaseLengthBy:dataBytes];
  uint8_t *block = dataBlock.mutableBytes;

  for (NSUInteger count = 0; count < dataBytes; count++) {
    value = [self nextHexByte:data atOffset:(current + offset)];
    if (value < 0) {
      return nil;
    }
    current += 2;
    checksum += value;
    block[count] = (uint8_t)value;
  }

  value = [self nextHexByte:data atOffset:(current + offset)];
  if (value < 0) {
    return nil;
  }
  current += 2;

  checksum += value;

  if ((checksum & 0xFF) != 0) {
    return nil;
  }

  if ((current + offset) < data.length) {
    switch (bytes[current + offset]) {
    case '\n':
      record.data = dataBlock;
      *consumed = current + 1;
      return record;

    case '\r':
      current++;
      break;

    default:
      return nil;
    }
  }

  if (((current + offset) < data.length) && (bytes[current + offset] == '\n')) {
    record.data = dataBlock;
    *consumed = current + 1;
    return record;
  }

  return nil;
}

- (NSInteger)nextHexByte:(NSData *_Nonnull)data atOffset:(NSUInteger)offset {
  NSInteger result = -1;

  if ((data.length - offset) < 2) {
    return -1;
  }

  const uint8_t *bytes = (const uint8_t *)data.bytes;
  if (!isxdigit(bytes[offset]) || !isxdigit(bytes[offset + 1])) {
    return -1;
  }

  for (size_t index = 0; index < sizeof(kHexTable); index++) {
    if (kHexTable[index] == tolower(bytes[offset])) {
      result = index << 4;
      break;
    }
  }

  if (result == -1) {
    return -1;
  }

  for (size_t index = 0; index < sizeof(kHexTable); index++) {
    if (kHexTable[index] == tolower(bytes[offset + 1])) {
      return result | index;
    }
  }

  return -1;
}

@end

#pragma clang diagnostic pop
