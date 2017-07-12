//
// Hopper Disassembler SDK
//
// (c)2017 - Cryptic Apps SARL. All Rights Reserved.
// https://www.hopperapp.com
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//

#import "CommonTypes.h"

@class HopperUUID;

@protocol HPASMLine;
@protocol HPDocument;
@protocol HPDetectedFileType;
@protocol HPLoaderOptionComponents;

@protocol HPHopperServices

// Global
- (NSInteger)hopperMajorVersion;
- (NSInteger)hopperMinorVersion;
- (NSInteger)hopperRevision;
- (NSString *)hopperVersionString;

- (NSObject<HPDocument> *)currentDocument;
- (void)logMessage:(NSString *)message;

// Build an UUID object from a string like XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
- (HopperUUID *)UUIDWithString:(NSString *)uuidString;

// New detected type
- (NSObject<HPDetectedFileType> *)detectedType;

// ASMLine Constructors
- (NSObject<HPASMLine> *)blankASMLine;

- (NSObject<HPASMLine> *)lineForFileHeader:(NSString *)fileHeader;
- (NSObject<HPASMLine> *)lineForSegmentHeader:(NSString *)segmentHeader;
- (NSObject<HPASMLine> *)lineForSectionHeader:(NSString *)sectionHeader;
- (NSObject<HPASMLine> *)lineForProcedureInfo:(NSString *)procedureInfo;
- (NSObject<HPASMLine> *)lineForSuffix:(NSString *)suffix;
- (NSObject<HPASMLine> *)lineWithRawString:(NSString *)string;
- (NSObject<HPASMLine> *)lineWithString:(NSString *)string;
- (NSObject<HPASMLine> *)lineWithName:(NSString *)name atAddress:(Address)address;
- (NSObject<HPASMLine> *)lineWithLocalName:(NSString *)name atAddress:(Address)address;
- (NSObject<HPASMLine> *)lineWithFormattedNumber:(NSString *)string withValue:(NSNumber *)number;
- (NSObject<HPASMLine> *)lineWithFormattedAddress:(NSString *)string withValue:(Address)address;

// Options for loaders
- (NSObject<HPLoaderOptionComponents> *)addressComponentWithLabel:(NSString *)label;
- (NSObject<HPLoaderOptionComponents> *)checkboxComponentWithLabel:(NSString *)label;
- (NSObject<HPLoaderOptionComponents> *)cpuComponentWithLabel:(NSString *)label;
- (NSObject<HPLoaderOptionComponents> *)addressComponentWithLabel:(NSString *)label andValue:(Address)value;
- (NSObject<HPLoaderOptionComponents> *)checkboxComponentWithLabel:(NSString *)label checked:(BOOL)checked;
- (NSObject<HPLoaderOptionComponents> *)stringListComponentWithLabel:(NSString *)label andList:(NSArray<NSString *> *)strings;
- (NSObject<HPLoaderOptionComponents> *)comboBoxComponentWithLabel:(NSString *)label andList:(NSArray<NSString *> *)strings;

@end
