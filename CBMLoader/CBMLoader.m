/*
 Copyright (c) 2014-2018, Alessandro Gatti - frob.it
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

#import "CBMLoader.h"
#import "BasicTokens.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

static NSString *kCPUFamily = @"Generic";
static NSString *kCPUSubFamily = @"6502";

static const uint8_t kBASICPrefixCE = 0xCE;
static const uint8_t kBASICPrefixFE = 0xFE;
static const uint8_t kQuoteMarker = 0x34;
static const uint8_t kTokensStart = 0x80;
static const uint8_t kSimonsBasicPrefix = 0x64;

typedef NS_ENUM(NSUInteger, BasicVersion) {
  BasicVersion10,
  BasicVersion20,
  BasicVersion20TurtleBasic10,
  BasicVersion20Expansion40C64,
  BasicVersion20Expansion40VIC20,
  BasicVersion20Expansion50,
  BasicVersion20SpeechBasic27,
  BasicVersion20Atbasic,
  BasicVersion20SimonsBasic,
  BasicVersion20FC3,
  BasicVersion20UltraBasic,
  BasicVersion20GraphicsBasic,
  BasicVersion20WSBasic,
  BasicVersion20WSBasicFinal,
  BasicVersion20PegasusBasic40,
  BasicVersion20XBasic,
  BasicVersion20DragoBasic22,
  BasicVersion20REUBasic,
  BasicVersion20BasicLightning,
  BasicVersion20MagicBasic,
  BasicVersion20Blarg,
  BasicVersion20GameBasic,
  BasicVersion20Basex,
  BasicVersion20SuperBasic,
  BasicVersion20ExpandedBasicC64,
  BasicVersion20ExpandedBasicVIC20,
  BasicVersion20WarsawBasic,
  BasicVersion20VicSuperExpander,
  BasicVersion20SuperExpanderChip,
  BasicVersion20MightyBasic,
  BasicVersion20EasyBasic,
  BasicVersion35,
  BasicVersion36,
  BasicVersion40,
  BasicVersion47,
  BasicVersion70,
  BasicVersion71,
  BasicVersion100
};

@interface ItFrobHopperCBMLoader ()

/**
 * Hopper Services instance.
 */
@property(strong, nonatomic, nonnull) NSObject<HPHopperServices> *services;

/**
 * Attempts to parse a CBM BASIC program into a human-readable form.
 *
 * @param data    the BASIC token stream.
 * @param address the offset in the data block to start reading from.
 * @param array   a list of lines with the decoded BASIC program.
 * @param size    a pointer to the amount of bytes that have been consumed.
 * @param version the BASIC version to decode.
 *
 * @return an instance of NSError if an error occurred, nil otherwise.
 */
- (NSError *)parseBasicProgram:(NSData *)data
                     atAddress:(NSUInteger)address
                       toArray:(NSMutableArray *)array
                          size:(NSUInteger *)size
                       version:(BasicVersion)version;
@end

@implementation ItFrobHopperCBMLoader

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
  if (self = [super init]) {
    _services = services;
  }

  return self;
}

- (HopperUUID *)pluginUUID {
  return [self.services UUIDWithString:@"92AF9450-09AD-11E4-9191-0800200C9A66"];
}

- (HopperPluginType)pluginType {
  return Plugin_Loader;
}

- (NSString *)pluginName {
  return @"CBM File";
}

- (NSString *)pluginDescription {
  return @"CBM File Loader";
}

- (NSString *)pluginAuthor {
  return @"Alessandro Gatti";
}

- (NSString *)pluginCopyright {
  return @"©2014-2018 Alessandro Gatti";
}

- (NSString *)pluginVersion {
  return @"0.2.2";
}

- (BOOL)canLoadDebugFiles {
  return NO;
}

- (NSArray *)detectedTypesForData:(NSData *)data {
  NSObject<HPDetectedFileType> *detectedType = self.services.detectedType;
  detectedType.fileDescription = @"CBM Executable code";
  detectedType.addressWidth = AW_16bits;
  detectedType.cpuFamily = kCPUFamily;
  detectedType.cpuSubFamily = kCPUSubFamily;
  detectedType.additionalParameters = @[
    [self.services checkboxComponentWithLabel:@"Contains BASIC code"
                                      checked:NO],
    [self.services
        stringListComponentWithLabel:@"BASIC version"
                             andList:@[
                               @"v1.0 (PET 2001)",
                               @"v2.0 (C64 / VIC-20)",
                               @"v2.0 with Turtle Basic v1.0 (VIC-20)",
                               @"v2.0 with BASIC v4.0 Expansion (C64)",
                               @"v2.0 with BASIC v4.0 Expansion (VIC-20)",
                               @"v2.0 with BASIC v5.0 Expansion (VIC-20)",
                               @"v2.0 with Speech Basic v2.7 (C64)",
                               @"v2.0 with @Basic (C64)",
                               @"v2.0 with Simons' Basic",
                               @"v2.0 with Final Cartdrige 3 (C64)",
                               @"v2.0 with Ultrabasic-64 (C64)",
                               @"v2.0 with Graphics Basic (C64)",
                               @"v2.0 with WS Basic (C64)",
                               @"v2.0 with WS Basic Final (C64)",
                               @"v2.0 with Pegasus Basic v4.0 (C64)",
                               @"v2.0 with Xbasic (C64)",
                               @"v2.0 with Drago basic 2.2 (C64)",
                               @"v2.0 with REU-basic (C64)",
                               @"v2.0 with Basic Lightning (C64)",
                               @"v2.0 with Magic basic (C64)",
                               @"v2.0 with Blarg (C64)",
                               @"v2.0 with Game Basic (C64)",
                               @"v2.0 with Basex (C64)",
                               @"v2.0 with Super Basic (C64)",
                               @"v2.0 with Expanded Basic (C64)",
                               @"v2.0 with Expanded Basic (VIC-20)",
                               @"v2.0 with Warsaw Basic (C64)",
                               @"v2.0 with Mighty Basic (VIC-20)",
                               @"v2.0 with Easy Basic (VIC-20)",
                               @"v2.0 with VIC Super Expander (VIC-20)",
                               @"v2.0 with Super Expander Chip (VIC-20)",
                               @"v3.5 (C16 / C116 / PLUS/4)",
                               @"v3.6 (Commodore LCD)",
                               @"v4.0 (CBM 4000)",
                               @"v4.7 (CBM-II)",
                               @"v7.0 (C128)",
                               @"v7.1 (C128)",
                               @"v10.0 (C65)",
                             ]]
  ];
  detectedType.shortDescriptionString = @"cbm";
  return @[ detectedType ];
}

- (FileLoaderLoadingStatus)loadData:(NSData *)data
              usingDetectedFileType:(NSObject<HPDetectedFileType> *)fileType
                            options:(FileLoaderOptions)options
                            forFile:(NSObject<HPDisassembledFile> *)file
                      usingCallback:(FileLoadingCallbackInfo)callback {
  NSObject<HPLoaderOptionComponents> *hasBasic =
      fileType.additionalParameters[0];
  NSObject<HPLoaderOptionComponents> *basicVersion =
      fileType.additionalParameters[1];

  if (data.length > 65538) {
    [self.services
        logMessage:[NSString stringWithFormat:@"File too big: %lu bytes",
                                              data.length]];
    return DIS_BadFormat;
  }

  uint16 startingAddress = OSReadLittleInt16(data.bytes, 0);
  unsigned long size = data.length - 2;
  uint16 endingAddress = (uint16)((startingAddress + size) & 0xFFFF);

  if (endingAddress > 65535) {
    [self.services
        logMessage:[NSString stringWithFormat:@"File too big: %lu bytes",
                                              data.length]];
    return DIS_BadFormat;
  }

  NSData *fileData = [NSData dataWithBytes:data.bytes + 2 length:size];

  NSObject<HPSegment> *segment = [file addSegmentAt:startingAddress size:size];
  segment.mappedData = fileData;
  segment.segmentName = @"CODE";
  segment.fileOffset = 2;
  segment.fileLength = size;

  size_t fileOffset = 2;
  unsigned long fileLength = size;

  if (hasBasic.isChecked) {
    const BasicVersion version = (BasicVersion)basicVersion.selectedStringIndex;
    NSMutableArray *lines = [NSMutableArray new];
    NSUInteger basicSize = 0;
    NSError *error = [self parseBasicProgram:fileData
                                   atAddress:startingAddress
                                     toArray:lines
                                        size:&basicSize
                                     version:version];
    if (!error) {
      NSObject<HPSection> *section =
          [segment addSectionAt:startingAddress size:basicSize];
      section.pureCodeSection = NO;
      section.fileOffset = fileOffset;
      section.fileLength = basicSize;
      section.sectionName = @"BASIC";

      [file setType:Type_Int8
          atVirtualAddress:startingAddress
                 forLength:basicSize];

      fileOffset += basicSize;
      fileLength -= basicSize;

      [file setComment:[NSString
                           stringWithFormat:@"Basic program:\n\n%@",
                                            [lines
                                                componentsJoinedByString:@"\n"]]
          atVirtualAddress:startingAddress
                    reason:CCReason_Script];
    }
  }

  NSObject<HPSection> *section =
      [segment addSectionAt:(startingAddress + fileOffset - 2) size:fileLength];
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

- (NSData *)extractFromData:(NSData *)data
      usingDetectedFileType:(NSObject<HPDetectedFileType> *)fileType
         returnAdjustOffset:(uint64_t *)adjustOffset {
  return nil;
}

- (void)fixupRebasedFile:(NSObject<HPDisassembledFile> *)file
               withSlide:(int64_t)slide
        originalFileData:(NSData *)fileData {
}

#pragma mark Private methods

- (NSError *)parseBasicProgram:(NSData *)data
                     atAddress:(NSUInteger)address
                       toArray:(NSMutableArray *)array
                          size:(NSUInteger *)size
                       version:(BasicVersion)version {

  const char *basicTokenTable;
  switch (version) {
  case BasicVersion10:
    basicTokenTable = (const char *)Basic10Tokens;
    break;

  case BasicVersion20:
  case BasicVersion20SimonsBasic:
    basicTokenTable = (const char *)Basic20Tokens;
    break;

  case BasicVersion20TurtleBasic10:
    basicTokenTable = (const char *)Basic20TurtleBasic10Tokens;
    break;

  case BasicVersion20Expansion40C64:
    basicTokenTable = (const char *)Basic20Basic40C64ExpansionTokens;
    break;

  case BasicVersion20Expansion40VIC20:
    basicTokenTable = (const char *)Basic20Basic40VIC20ExpansionTokens;
    break;

  case BasicVersion20Expansion50:
    basicTokenTable = (const char *)Basic20Basic50ExpansionTokens;
    break;

  case BasicVersion20SpeechBasic27:
    basicTokenTable = (const char *)Basic20SpeechBasic27Tokens;
    break;

  case BasicVersion20Atbasic:
    basicTokenTable = (const char *)Basic20AtbasicTokens;
    break;

  case BasicVersion20FC3:
    basicTokenTable = (const char *)Basic20FC3Tokens;
    break;

  case BasicVersion20UltraBasic:
    basicTokenTable = (const char *)Basic20Ultrabasic64Tokens;
    break;

  case BasicVersion20GraphicsBasic:
    basicTokenTable = (const char *)Basic20GraphicsBasicTokens;
    break;

  case BasicVersion20WSBasic:
    basicTokenTable = (const char *)Basic20WSBasicTokens;
    break;

  case BasicVersion20WSBasicFinal:
    basicTokenTable = (const char *)Basic20WSBasicFinalTokens;
    break;

  case BasicVersion20PegasusBasic40:
    basicTokenTable = (const char *)Basic20Pegasus40Tokens;
    break;

  case BasicVersion20XBasic:
    basicTokenTable = (const char *)Basic20XBasicTokens;
    break;

  case BasicVersion20DragoBasic22:
    basicTokenTable = (const char *)Basic20DragoBasic22Tokens;
    break;

  case BasicVersion20REUBasic:
    basicTokenTable = (const char *)Basic20REUBasicTokens;
    break;

  case BasicVersion20BasicLightning:
    basicTokenTable = (const char *)Basic20BasicLightningTokens;
    break;

  case BasicVersion20MagicBasic:
    basicTokenTable = (const char *)Basic20MagicBasicTokens;
    break;

  case BasicVersion20Blarg:
    basicTokenTable = (const char *)Basic20BlargTokens;
    break;

  case BasicVersion20GameBasic:
    basicTokenTable = (const char *)Basic20GameBasicTokens;
    break;

  case BasicVersion20Basex:
    basicTokenTable = (const char *)Basic20BasexTokens;
    break;

  case BasicVersion20SuperBasic:
    basicTokenTable = (const char *)Basic20SuperBasicTokens;
    break;

  case BasicVersion20ExpandedBasicC64:
    basicTokenTable = (const char *)Basic20ExpandedBasicC64Tokens;
    break;

  case BasicVersion20ExpandedBasicVIC20:
    basicTokenTable = (const char *)Basic20ExpandedBasicVIC20Tokens;
    break;

  case BasicVersion20WarsawBasic:
    basicTokenTable = (const char *)Basic20WarsawBasicTokens;
    break;

  case BasicVersion20VicSuperExpander:
    basicTokenTable = (const char *)Basic20VicSuperExpanderTokens;
    break;

  case BasicVersion20MightyBasic:
    basicTokenTable = (const char *)Basic20MightyBasicTokens;
    break;

  case BasicVersion20EasyBasic:
    basicTokenTable = (const char *)Basic20EasyBasicTokens;
    break;

  case BasicVersion35:
    basicTokenTable = (const char *)Basic35Tokens;
    break;

  case BasicVersion36:
    basicTokenTable = (const char *)Basic36Tokens;
    break;

  case BasicVersion40:
    basicTokenTable = (const char *)Basic40Tokens;
    break;

  case BasicVersion47:
    basicTokenTable = (const char *)Basic47Tokens;
    break;

  case BasicVersion70:
    basicTokenTable = (const char *)Basic70Tokens;
    break;

  case BasicVersion100:
    basicTokenTable = (const char *)Basic100Tokens;
    break;

  default:
    return [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier
                               code:NSInvalidIndexSpecifierError
                           userInfo:nil];
    break;
  }
  NSUInteger offset = 0;
  const uint8_t *buffer = (const uint8_t *)data.bytes;
  BOOL done = NO;
  while (offset < data.length && !done) {
    uint16_t link = OSReadLittleInt16(buffer, offset);
    offset += 2;
    if (link == 0 || link < 0x0800 || link > 0x9FFF) {
      break;
    }

    long linkAddress = link - (NSInteger)address;
    if (linkAddress <= 0 || linkAddress < offset) {
      return [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier
                                 code:NSInvalidIndexSpecifierError
                             userInfo:nil];
    }
    uint8_t linkTarget = buffer[linkAddress];
    if (!buffer[linkTarget]) {
      done = YES;
    }

    NSMutableString *line = [NSMutableString new];

    uint16_t lineNumber = OSReadLittleInt16(buffer, offset);
    offset += 2;
    [line appendFormat:@"%d ", lineNumber];

    BOOL quoteMode = NO;

    while (offset < data.length) {
      uint8_t byte = buffer[offset++];
      if (byte == 0x00) {
        break;
      }

      if (byte == kQuoteMarker) {
        quoteMode = !quoteMode;
        [line appendFormat:@"%c", byte];
      } else {
        if (!quoteMode && (((byte >= kTokensStart) &&
                            (version != BasicVersion20SimonsBasic)) ||
                           ((byte == kSimonsBasicPrefix) &&
                            (version == BasicVersion20SimonsBasic)))) {
          const char *opcode = &basicTokenTable[byte];
          if (!opcode) {
            switch (version) {
            case BasicVersion20SimonsBasic:
            case BasicVersion20SuperExpanderChip:
            case BasicVersion36:
            case BasicVersion70:
            case BasicVersion71:
            case BasicVersion100:
              if (data.length - offset > 0) {
                uint8_t nextByte = buffer[offset++];
                switch (byte) {
                case kSimonsBasicPrefix:
                  opcode = SimonsBasicPrefixLookupTable[nextByte];
                  break;

                case kBASICPrefixCE:
                  opcode = Basic3670100CEPrefixLookupTable[nextByte];
                  break;

                case kBASICPrefixFE:
                  switch (version) {

                  case BasicVersion20SuperExpanderChip:
                    opcode =
                        Basic20SuperExpanderChipFEPrefixLookupTable[nextByte];
                    break;

                  case BasicVersion36:
                    opcode = Basic36FEPrefixLookupTable[nextByte];
                    break;

                  case BasicVersion70:
                    opcode = Basic70FEPrefixLookupTable[nextByte];
                    break;

                  case BasicVersion71:
                    opcode = Basic71FEPrefixLookupTable[nextByte];
                    break;

                  case BasicVersion100:
                    opcode = Basic100FEPrefixLookupTable[nextByte];
                    break;

                  default:
                    break;
                  }
                  break;

                default:
                  break;
                }
              }
              break;

            default:
              break;
            }
          }

          if (!opcode) {
            [line appendString:@"{UNKNOWN}"];
          } else {
            [line appendFormat:@"%s", opcode];
          }
        } else {
          [line appendFormat:@"%s", PetsciiCharacters[byte]];
        }
      }
    }

    [array addObject:line];
  }

  *size = offset;
  return nil;
}

@end

#pragma clang diagnostic pop
