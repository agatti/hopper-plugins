//
// Hopper Disassembler SDK
//
// (c) Cryptic Apps SARL. All Rights Reserved.
// https://www.hopperapp.com
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//

#import "CommonTypes.h"

@protocol HPHopperUUID;
@protocol HPASMLine;
@protocol HPDocument;
@protocol HPDetectedFileType;
@protocol HPLoaderOptionComponents;
@protocol HPCallDestination;

@protocol HPHopperServices

// Global
- (NSInteger)hopperMajorVersion;
- (NSInteger)hopperMinorVersion;
- (NSInteger)hopperRevision;
- (nonnull NSString *)hopperVersionString;

- (nullable NSObject<HPDocument> *)currentDocument;
- (void)logMessage:(nonnull NSString *)message;

// Build an UUID object from a string like XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
- (nonnull NSObject<HPHopperUUID> *)UUIDWithString:(nonnull NSString *)uuidString;

// New detected type
- (nullable NSObject<HPDetectedFileType> *)detectedType;

// ASMLine Constructors
- (nonnull NSObject<HPASMLine> *)blankASMLine;

- (nonnull NSObject<HPASMLine> *)lineForFileHeader:(nonnull NSString *)fileHeader;
- (nonnull NSObject<HPASMLine> *)lineForSegmentHeader:(nonnull NSString *)segmentHeader;
- (nonnull NSObject<HPASMLine> *)lineForSectionHeader:(nonnull NSString *)sectionHeader;
- (nonnull NSObject<HPASMLine> *)lineForProcedureInfo:(nonnull NSString *)procedureInfo;
- (nonnull NSObject<HPASMLine> *)lineForSuffix:(nonnull NSString *)suffix;
- (nonnull NSObject<HPASMLine> *)lineWithRawString:(nonnull NSString *)string;
- (nonnull NSObject<HPASMLine> *)lineWithString:(nonnull NSString *)string;
- (nonnull NSObject<HPASMLine> *)lineWithName:(nonnull NSString *)name atAddress:(Address)address;
- (nonnull NSObject<HPASMLine> *)lineWithLocalName:(nonnull NSString *)name atAddress:(Address)address;
- (nonnull NSObject<HPASMLine> *)lineWithFormattedNumber:(nonnull NSString *)string withValue:(nonnull NSNumber *)number;
- (nonnull NSObject<HPASMLine> *)lineWithFormattedAddress:(nonnull NSString *)string withValue:(Address)address;

// Options for loaders
- (nonnull NSObject<HPLoaderOptionComponents> *)addressComponentWithLabel:(nonnull NSString *)label;
- (nonnull NSObject<HPLoaderOptionComponents> *)checkboxComponentWithLabel:(nonnull NSString *)label;
- (nonnull NSObject<HPLoaderOptionComponents> *)cpuComponentWithLabel:(nonnull NSString *)label;
- (nonnull NSObject<HPLoaderOptionComponents> *)addressComponentWithLabel:(nonnull NSString *)label andValue:(Address)value;
- (nonnull NSObject<HPLoaderOptionComponents> *)checkboxComponentWithLabel:(nonnull NSString *)label checked:(BOOL)checked;
- (nonnull NSObject<HPLoaderOptionComponents> *)stringListComponentWithLabel:(nonnull NSString *)label andList:(nonnull NSArray<NSString *> *)strings;
- (nonnull NSObject<HPLoaderOptionComponents> *)comboBoxComponentWithLabel:(nonnull NSString *)label andList:(nonnull NSArray<NSString *> *)strings;

// Call Destination
- (nullable NSObject<HPCallDestination> *)callDestination:(Address)address;
- (nullable NSObject<HPCallDestination> *)callDestination:(Address)address withCPUMode:(uint8_t)cpuMode;

@end
