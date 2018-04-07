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

@protocol HPTypeStructField;
@protocol HPTypeEnumField;
@protocol HPMethodSignature;

@protocol HPTypeDesc

- (int)sizeOf;

- (BOOL)isPrimitive;
- (BOOL)isVoid;
- (BOOL)isFloatOrDouble;
- (BOOL)isPointer;
- (BOOL)isFunctionPointer;
- (BOOL)isArray;
- (BOOL)isStructured;
- (BOOL)isEnum;

- (NSString *)name;
- (void)setName:(NSString *)name;

- (BOOL)forwardDeclaration;
- (void)setForwardDeclaration:(BOOL)forward;
- (BOOL)incompleteType;
- (void)setIncompleteType:(BOOL)incomplete;
- (BOOL)singleLineDisplay;
- (void)setSingleLineDisplay:(BOOL)singleLine;

// String representation
- (NSString *)string;
- (NSString *)shortString;

// Arrays
- (NSUInteger)arrayItemCount;

// Struct fields
- (BOOL)addStructureField:(NSObject<HPTypeStructField> *)field;
- (NSObject<HPTypeStructField> *)addStructureFieldOfType:(NSObject<HPTypeDesc> *)type named:(NSString *)name;
- (NSObject<HPTypeStructField> *)addStructureFieldOfType:(NSObject<HPTypeDesc> *)type named:(NSString *)name withComment:(NSString *)comment;
- (BOOL)removeStructureField:(NSObject<HPTypeStructField> *)field;
- (BOOL)removeAllStructureFields;

// Enum
- (NSObject<HPTypeEnumField> *)addEnumField;
- (NSObject<HPTypeEnumField> *)addEnumFieldWithName:(NSString *)name;
- (NSObject<HPTypeEnumField> *)addEnumFieldWithName:(NSString *)name andValue:(int64_t)value;
- (NSObject<HPTypeEnumField> *)insertEnumFieldWithName:(NSString *)name andValue:(int64_t)value atIndex:(NSUInteger)index;
- (BOOL)removeEnumField:(NSObject<HPTypeEnumField> *)field;
- (BOOL)removeAllEnumFields;
- (int)enumSize;
- (void)setEnumSize:(int)sizeInBytes;

// Function pointers
- (NSObject<HPMethodSignature> *)signature;
- (void)setSignature:(NSObject<HPMethodSignature> *)signature;

@end
