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

- (NSObject<HPTypeDesc> *)returnType;
- (void)setReturnType:(NSObject<HPTypeDesc> *)returnType;

- (NSString *)argumentNameAtIndex:(NSUInteger)index;
- (NSString *)argumentNameAtIndex:(NSUInteger)index withDefaultBasename:(NSString *)defaultBasename;

- (NSUInteger)argumentCount;
- (NSObject<HPMethodArgument> *)argumentAtIndex:(NSUInteger)index;
- (void)addArgument:(NSObject<HPMethodArgument> *)argument;
- (void)removeArgumentAtIndex:(NSUInteger)index;
- (NSArray<NSObject<HPMethodArgument> *> *)allArguments;

- (void)addArgumentWithType:(NSObject<HPTypeDesc> *)type;
- (void)addArgumentWithType:(NSObject<HPTypeDesc> *)type name:(NSString *)name;
- (void)insertArgumentWithType:(NSObject<HPTypeDesc> *)type atIndex:(NSUInteger)index;
- (void)insertArgumentWithType:(NSObject<HPTypeDesc> *)type andName:(NSString *)name atIndex:(NSUInteger)index;

- (NSString *)string;
- (NSString *)stringWithMethodName:(NSString *)name;
- (NSString *)stringWithMethodName:(NSString *)name andDefaultArgumentBasename:(NSString *)argBasename;

@end
