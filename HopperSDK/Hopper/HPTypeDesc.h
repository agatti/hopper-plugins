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

- (nullable NSString *)name;
- (void)setName:(nullable NSString *)name;

- (BOOL)forwardDeclaration;
- (void)setForwardDeclaration:(BOOL)forward;
- (BOOL)incompleteType;
- (void)setIncompleteType:(BOOL)incomplete;
- (BOOL)singleLineDisplay;
- (void)setSingleLineDisplay:(BOOL)singleLine;

// String representation
- (nonnull NSString *)string;
- (nonnull NSString *)shortString;

// Arrays
- (NSUInteger)arrayItemCount;

// Struct fields
- (BOOL)addStructureField:(nonnull NSObject<HPTypeStructField> *)field;
- (nonnull NSObject<HPTypeStructField> *)addStructureFieldOfType:(nonnull NSObject<HPTypeDesc> *)type named:(nullable NSString *)name;
- (nonnull NSObject<HPTypeStructField> *)addStructureFieldOfType:(nonnull NSObject<HPTypeDesc> *)type named:(nullable NSString *)name withComment:(nullable NSString *)comment;
- (BOOL)removeStructureField:(nonnull NSObject<HPTypeStructField> *)field;
- (BOOL)removeAllStructureFields;

// Enum
- (nonnull NSObject<HPTypeEnumField> *)addEnumField;
- (nonnull NSObject<HPTypeEnumField> *)addEnumFieldWithName:(nonnull NSString *)name;
- (nonnull NSObject<HPTypeEnumField> *)addEnumFieldWithName:(nullable NSString *)name andValue:(int64_t)value;
- (nonnull NSObject<HPTypeEnumField> *)insertEnumFieldWithName:(nullable NSString *)name andValue:(int64_t)value atIndex:(NSUInteger)index;
- (BOOL)removeEnumField:(nonnull NSObject<HPTypeEnumField> *)field;
- (BOOL)removeAllEnumFields;
- (int)enumSize;
- (void)setEnumSize:(int)sizeInBytes;

// Function pointers
- (nullable NSObject<HPMethodSignature> *)signature;
- (void)setSignature:(nullable NSObject<HPMethodSignature> *)signature;

@end
