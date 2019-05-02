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
@protocol HPMethodSignature;

@protocol HPMethodArgument

- (nonnull NSObject<HPMethodSignature> *)owner;

- (nullable NSString *)name;
- (void)setName:(nullable NSString *)name;

- (nonnull NSObject<HPTypeDesc> *)type;
- (void)setType:(nonnull NSObject<HPTypeDesc> *)type;

@end
