/*
 Copyright (c) 2014, Alessandro Gatti - frob.it
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "FRBOperandFormatter.h"

// HopperCommon library imports

#import "FRBHopperCommon.h"

NSString *FormatValue(NSNumber *value, const DisasmStruct *source,
                      ArgFormat format, size_t size,
                      id<HPHopperServices> services) {

    switch (format & FORMAT_TYPE_MASK) {
        case Format_Hexadecimal:
        default:
            return FormatHexadecimal(value, size, format & Format_Signed,
                                     format & Format_LeadingZeroes,
                                     format & Format_Negate);

        case Format_Decimal:
            return FormatDecimal(value, size, format & Format_Signed,
                                 format & Format_Negate);

        case Format_Octal:
            return FormatOctal(value, size, format & Format_Signed,
                               format & Format_Negate);

        case Format_Binary:
            return FormatBinary(value, size, format & Format_LeadingZeroes,
                                format & Format_Negate);

        case Format_Offset:
        case Format_Address: {
            NSString *address = [[services currentDocument].disassembledFile nameForVirtualAddress:value.unsignedLongLongValue];
            return address ? address : [FormatHexadecimal(value, size, NO, format & Format_LeadingZeroes, NO) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }

        case Format_Character:
            return FormatCharacters(value, size);
    }
    
    return @"";
}

NSString *FormatHexadecimal(NSNumber *value, size_t size, BOOL isSigned,
                            BOOL fillZeroes, BOOL negate) {
    NSString *formatString = [NSString stringWithFormat:@"%@%%@$%%%@llX", negate ? @"~" : @"",
                              fillZeroes ? [NSString stringWithFormat:@"0%zu", size / 4] : @""];

    int64_t number;
    BOOL negative = NO;
    if (isSigned) {
        number = SignedValue(value, size);
        negative = number < 0;
        number = llabs(number);
    } else {
        number = value.longLongValue;
    }

    return [[NSString stringWithFormat:formatString, negative ? @"-" : @"", number] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

NSString *FormatDecimal(NSNumber *value, size_t size, BOOL isSigned,
                        BOOL negate) {
    NSString *formatString = [NSString stringWithFormat:@"%@%%@%%lld", negate ? @"~" : @""];

    int64_t number;
    BOOL negative = NO;
    if (isSigned) {
        number = SignedValue(value, size);
        negative = number < 0;
        number = llabs(number);
    } else {
        number = value.longLongValue;
    }

    return [[NSString stringWithFormat:formatString, negative ? @"-" : @"", number] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

NSString *FormatOctal(NSNumber *value, size_t size, BOOL isSigned,
                      BOOL negate) {

    NSString *formatString = [NSString stringWithFormat:@"%@%%@%%lloo", negate ? @"~" : @""];

    int64_t number;
    BOOL negative = NO;
    if (isSigned) {
        number = SignedValue(value, size);
        negative = number < 0;
        number = llabs(number);
    } else {
        number = value.longLongValue;
    }

    return [NSString stringWithFormat:formatString, negative ? @"-" : @"", number];
}

NSString *FormatBinary(NSNumber *value, size_t size, BOOL fillZeroes,
                       BOOL negate) {

    switch (size) {
        case 8:
        case 16:
        case 24:
        case 32:
            break;

        default:
            @throw [NSException exceptionWithName:FRBHopperExceptionName
                                           reason:[NSString stringWithFormat:@"Internal error: invalid binary value size %zu", size]
                                         userInfo:nil];
    }

    uint64_t number = negate ? ~value.unsignedLongLongValue : value.unsignedLongLongValue;
    NSMutableString *output = [NSMutableString stringWithString:ConvertToBinary(number, size)];
    if (output.length < size && fillZeroes) {
        NSMutableString *padded = [NSMutableString new];
        for (int index = 0; index < size - output.length; index++) {
            [padded appendString:@"0"];
        }
        [padded appendString:output];

        output = padded;
    }

    return [NSString stringWithFormat:@"%@%%%@", negate ? @"~" : @"", output];
}

NSString *FormatCharacters(NSNumber *value, size_t size) {
    NSMutableString *bytes = [NSMutableString new];

    uint32_t number = value.unsignedIntValue;
    switch (size) {
        case 32:
            [bytes appendFormat:@"%c", (number >> 24) & 0xFF];

        case 24:
            [bytes appendFormat:@"%c", (number >> 16) & 0xFF];

        case 16:
            [bytes appendFormat:@"%c", (number >> 8) & 0xFF];

        case 8:
            [bytes appendFormat:@"%c", number & 0xFF];
            break;

        default:
            @throw [NSException exceptionWithName:FRBHopperExceptionName
                                           reason:[NSString stringWithFormat:@"Internal error: invalid character value size %zu", size]
                                         userInfo:nil];
    }

    return EscapeWithQuotes(bytes, (size == 8) ? '\'' : '\"');
}

NSString *ConvertToBinary(uint64_t value, size_t size) {
    NSMutableString *output = [NSMutableString new];
    long startBit = size - 1;
    BOOL firstBitSet = NO;
    while (startBit >= 0) {
        BOOL bitSet = (value & (1 << startBit)) == (1 << startBit);
        startBit--;
        if (bitSet) {
            firstBitSet = YES;
        } else {
            if (!firstBitSet) {
                continue;
            }
        }

        [output appendFormat:@"%c", bitSet ? '1' : '0'];
    }

    return output.length > 0 ? output : @"0";
}

NSString *EscapeWithQuotes(NSString *content, unichar marker) {
    NSMutableString *output = [NSMutableString stringWithFormat:@"%c", marker];
    for (int index = 0; index < content.length; index++) {
        unichar character = [content characterAtIndex:index];
        if (!isprint(character)) {
            [output appendFormat:@"\\x%02X", character];
        } else {
            if (character == marker) {
                [output appendFormat:@"\\%c", character];
            } else {
                if (character == '\\') {
                    [output appendString:@"\\\\"];
                } else {
                    [output appendFormat:@"%c", character];
                }
            }
        }
    }

    [output appendFormat:@"%c", marker];

    return output;
}
