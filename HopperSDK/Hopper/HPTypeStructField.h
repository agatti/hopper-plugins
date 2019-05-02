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

@protocol HPTypeStructField

- (nullable NSString *)name;
- (void)setName:(nullable NSString *)name;

- (nullable NSString *)comment;
- (void)setComment:(nullable NSString *)comment;

- (ArgFormat)displayFormat;
- (void)setDisplayFormat:(ArgFormat)displayFormat;

- (NSUInteger)fieldIndex;
- (nonnull NSString *)string;
- (nonnull NSString *)shortString;

@end

