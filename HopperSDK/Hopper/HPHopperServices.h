//
// Hopper Disassembler SDK
//
// (c)2014 - Cryptic Apps SARL. All Rights Reserved.
// http://www.hopperapp.com
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//

#import "CommonTypes.h"

@class HopperUUID;

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

// Information about attributes used in the ASM view
- (NSDictionary *)ASMOperatorAttributes;
- (NSDictionary *)ASMNumberAttributes;
- (NSDictionary *)ASMLanguageAttributes;
- (NSDictionary *)ASMSubLanguageAttributes;
- (NSDictionary *)ASMCommentAttributes;

- (void)colorizeASMString:(NSMutableAttributedString *)string
        operatorPredicate:(BOOL(^)(unichar c))operatorPredicate
    languageWordPredicate:(BOOL(^)(NSString * s))languageWordPredicate
 subLanguageWordPredicate:(BOOL(^)(NSString * s))subLanguageWordPredicate;

// Options for loaders
- (NSObject<HPLoaderOptionComponents> *)addressComponentWithLabel:(NSString *)label;
- (NSObject<HPLoaderOptionComponents> *)checkboxComponentWithLabel:(NSString *)label;
- (NSObject<HPLoaderOptionComponents> *)cpuComponentWithLabel:(NSString *)label;
- (NSObject<HPLoaderOptionComponents> *)addressComponentWithLabel:(NSString *)label andValue:(Address)value;
- (NSObject<HPLoaderOptionComponents> *)checkboxComponentWithLabel:(NSString *)label checked:(BOOL)checked;

@end
