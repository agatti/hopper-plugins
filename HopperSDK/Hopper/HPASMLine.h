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

@protocol HPASMLine

- (NSUInteger)length;

- (nonnull NSString *)string;
- (nonnull NSAttributedString *)attributedString;

- (void)appendRawString:(nonnull NSString *)str;
- (void)appendNewLine;
- (void)appendSpaces:(NSUInteger)count;
- (void)appendSpacesUntil:(NSUInteger)minLength;
- (void)appendSpacesUntil:(NSUInteger)minLength withMinimumAdded:(NSUInteger)minAdded;
- (void)append:(nullable NSObject<HPASMLine> *)line;

- (void)appendMnemonic:(nonnull NSString *)name isJump:(BOOL)isJump;
- (void)appendMnemonic:(nonnull NSString *)name;
- (void)appendJumpMnemonic:(nonnull NSString *)name;
- (void)appendRegister:(nonnull NSString *)name;
- (void)appendRegister:(nonnull NSString *)name ofClass:(RegClass)regCls andIndex:(NSUInteger)regIndex;
- (void)appendName:(nonnull NSString *)name atAddress:(Address)address;
- (void)appendLocalName:(nonnull NSString *)name atAddress:(Address)address;
- (void)appendVariableName:(nonnull NSString *)name withDisplacement:(int64_t)disp;
- (void)appendComment:(nonnull NSString *)comment;
- (void)appendString:(nonnull NSString *)string;
- (void)appendCFString:(nonnull NSString *)string;
- (void)appendClass:(nonnull NSString *)string;
- (void)appendSelector:(nonnull NSString *)string;
- (void)appendProtocol:(nonnull NSString *)string;
- (void)appendAddress:(Address)address;
- (void)appendFormattedAddress:(nonnull NSString *)string withValue:(Address)addressValue;
- (void)appendHexByte:(uint8_t)byte;
- (void)appendFormattedNumber:(nonnull NSString *)string withValue:(nonnull NSNumber *)number;
- (void)appendDecimalNumber:(int64_t)number;
- (void)appendHexadecimalNumber:(int64_t)number;
- (void)appendOperandString:(nonnull NSString *)string forOperandIndex:(NSUInteger)operandIndex;

- (void)setIsOperand:(NSUInteger)operandIndex onLastBytes:(NSUInteger)count;
- (void)setIsOperand:(NSUInteger)operandIndex startingAtIndex:(NSUInteger)index;

@end
