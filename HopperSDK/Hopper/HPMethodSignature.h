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

@protocol HPTypeDesc;
@protocol HPMethodArgument;

@protocol HPMethodSignature

- (nullable NSObject<HPTypeDesc> *)returnType;
- (void)setReturnType:(nullable NSObject<HPTypeDesc> *)returnType;

- (nullable NSString *)argumentNameAtIndex:(NSUInteger)index;
- (nullable NSString *)argumentNameAtIndex:(NSUInteger)index withDefaultBasename:(nullable NSString *)defaultBasename;

- (NSUInteger)argumentCount;
- (nullable NSObject<HPMethodArgument> *)argumentAtIndex:(NSUInteger)index;
- (void)addArgument:(nonnull NSObject<HPMethodArgument> *)argument;
- (void)removeArgumentAtIndex:(NSUInteger)index;
- (nonnull NSArray<NSObject<HPMethodArgument> *> *)allArguments;

- (void)addArgumentWithType:(nonnull NSObject<HPTypeDesc> *)type;
- (void)addArgumentWithType:(nonnull NSObject<HPTypeDesc> *)type name:(nullable NSString *)name;
- (void)insertArgumentWithType:(nonnull NSObject<HPTypeDesc> *)type atIndex:(NSUInteger)index;
- (void)insertArgumentWithType:(nonnull NSObject<HPTypeDesc> *)type andName:(nullable NSString *)name atIndex:(NSUInteger)index;

- (nonnull NSString *)string;
- (nonnull NSString *)stringWithMethodName:(nullable NSString *)name;
- (nonnull NSString *)stringWithMethodName:(nullable NSString *)name andDefaultArgumentBasename:(nullable NSString *)argBasename;

@end
