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

#import "FRBInstructionColouriser.h"

/*!
 *	Instruction parser states.
 */
typedef NS_ENUM(NSUInteger, FRBInstructionParserState) {
    /*!
     *	Looking for the beginning of the opcode.
     */
    FRBInstructionParserStateLookingForOpcode = 0,

    /*!
     *	Parsing the opcode characters.
     */
    FRBInstructionParserStateParsingOpcode,

    /*!
     *	Skipping whitespace.
     */
    FRBInstructionParserStateSkippingSpace,

    /*!
     *	Parsing the operand characters.
     */
    FRBInstructionParserStateParsingOperand,

    /*!
     *	Inside a double-quoted operand.
     */
    FRBInstructionParserStateInsideOperandDoubleQuote,

    /*!
     *	Inside a single-quoted operand.
     */
    FRBInstructionParserStateInsideOperandSingleQuote
};

@interface ItFrobHopper8x300InstructionColouriser () {
    /*!
     *	A list of valid opcodes for the CPU in use.
     */
    const NSSet *_validOpcodes;

    /*!
     *	The formatting attributes for opcodes.
     */
    NSDictionary *_opcodeFormattingAttributes;

    /*!
     *	The formatting attributes for operands.
     */
    NSDictionary *_numberFormattingAttributes;
}
@end

@implementation ItFrobHopper8x300InstructionColouriser

- (instancetype)initWithOpcodesSet:(const NSSet *)validOpcodes
                       andServices:(id<HPHopperServices>)services {
    if (self = [super init]) {
        _validOpcodes = validOpcodes;
        _opcodeFormattingAttributes = [services ASMLanguageAttributes];
        _numberFormattingAttributes = [services ASMNumberAttributes];
    }

    return self;
}

- (NSAttributedString *)colouriseInstruction:(NSAttributedString *)source {
    NSMutableAttributedString *clone = [source mutableCopy];
    [clone beginEditing];

    NSString *rawString = clone.string;
    NSMutableArray *ranges = [NSMutableArray new];

    BOOL escaped = NO;
    FRBInstructionParserState state = FRBInstructionParserStateLookingForOpcode;
    NSUInteger stringOffset = 0;
    NSRange currentRange = NSMakeRange(NSNotFound, 0);

    while (stringOffset < rawString.length) {
        unichar character = [rawString characterAtIndex:stringOffset];

        switch (state) {
            case FRBInstructionParserStateLookingForOpcode:
                if (isspace(character)) {
                    stringOffset++;
                    continue;
                }

                state = FRBInstructionParserStateParsingOpcode;

                // Intentional Fallthrough

            case FRBInstructionParserStateParsingOpcode:
                if (currentRange.location == NSNotFound) {
                    currentRange.location = stringOffset;
                    continue;
                }

                if (!isalnum(character)) {
                    if (![_validOpcodes containsObject:[rawString substringWithRange:currentRange]]) {
                        [clone endEditing];
                        return source;
                    }

                    [ranges addObject:[NSValue valueWithRange:currentRange]];
                    state = FRBInstructionParserStateSkippingSpace;
                    currentRange = NSMakeRange(NSNotFound, 0);
                    continue;
                }

                currentRange.length++;
                stringOffset++;
                break;

            case FRBInstructionParserStateSkippingSpace:
                if (isspace(character)) {
                    stringOffset++;
                    continue;
                }

                state = FRBInstructionParserStateParsingOperand;

                // Intentional Fallthrough

            case FRBInstructionParserStateParsingOperand: {
                BOOL alreadyIncremented = NO;
                BOOL operandFound = NO;

                if (currentRange.location == NSNotFound) {
                    currentRange.location = stringOffset;
                    currentRange.length++;
                    alreadyIncremented = YES;
                }

                switch (character) {
                    case '\'':
                        state = FRBInstructionParserStateInsideOperandSingleQuote;
                        break;

                    case '"':
                        state = FRBInstructionParserStateInsideOperandDoubleQuote;
                        break;

                    case '\\':
                        escaped = YES;
                        break;

                    case '(':
                    case ',':
                        operandFound = YES;
                        break;

                    default:
                        break;
                }

                stringOffset++;
                if (!alreadyIncremented && !operandFound) {
                    currentRange.length++;
                }

                if (operandFound) {
                    [ranges addObject:[NSValue valueWithRange:currentRange]];
                    state = FRBInstructionParserStateSkippingSpace;
                    currentRange = NSMakeRange(NSNotFound, 0);
                }

                break;
            }

            case FRBInstructionParserStateInsideOperandSingleQuote:
                currentRange.length++;
                stringOffset++;
                if (character != '\'') {
                    continue;
                }

                if (escaped) {
                    escaped = NO;
                }

                state = FRBInstructionParserStateParsingOperand;
                break;

            case FRBInstructionParserStateInsideOperandDoubleQuote:
                currentRange.length++;
                stringOffset++;
                if (character != '"') {
                    continue;
                }

                if (escaped) {
                    escaped = NO;
                }

                state = FRBInstructionParserStateParsingOperand;
                break;

            default:
                break;
        }
    }

    if (currentRange.location != NSNotFound) {
        [ranges addObject:[NSValue valueWithRange:currentRange]];
    }

    BOOL isOpcode = YES;
    for (NSValue *rangeValue in ranges) {
        BOOL done = NO;
        NSRange range = rangeValue.rangeValue;
        NSUInteger firstValidOffset = range.location;
            
        while ((firstValidOffset - range.location) <= range.length && !done) {
            unichar character = [rawString characterAtIndex:firstValidOffset];
                
            if (isspace(character) || character == '(' || character == '[') {
                firstValidOffset++;
                range.location++;
                range.length--;
                continue;
            }
                
            done = true;
        }
            
        done = NO;
        NSUInteger lastValidOffset = range.location + range.length - 1;
        while (lastValidOffset != range.location && !done) {
            unichar character = [rawString characterAtIndex:lastValidOffset];

            if (!isspace(character) && character != ')' && character != ']') {
                done = true;
                continue;
            }
                
            range.length--;
            lastValidOffset--;
        }

        [clone setAttributes:isOpcode ? _opcodeFormattingAttributes : _numberFormattingAttributes
                       range:range];
        isOpcode = NO;
    }
        
    [clone endEditing];
        
    return clone;
}

@end
