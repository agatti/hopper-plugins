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

#import "FRBCPUSupport.h"

#import <Hopper/Hopper.h>

static BOOL IsBitsSizeValid(size_t size);

NSAttributedString *ColouriseInstructionString(NSAttributedString *string,
                                               const NSSet *validOpcodes,
                                               id<HPHopperServices> services) {
    NSMutableAttributedString *clone = [string mutableCopy];
    [clone beginEditing];

    NSString *rawString = clone.string;
    NSScanner *scanner = [NSScanner scannerWithString:clone.string];
    NSString *potentialOpcode;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet]
                            intoString:&potentialOpcode];
    if (![validOpcodes containsObject:potentialOpcode]) {
        return string;
    }

    NSDictionary *opcodeFormattingAttributes = [services ASMLanguageAttributes];
    NSDictionary *numberFormattingAttributes = [services ASMNumberAttributes];

    [clone setAttributes:opcodeFormattingAttributes
                   range:NSMakeRange(0, potentialOpcode.length)];

    if (!scanner.isAtEnd) {
        [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet]
                            intoString:nil];
        NSUInteger offset = scanner.scanLocation;
        const char *buffer = rawString.UTF8String;
        NSInteger componentStart = NSNotFound;
        BOOL numberFound = NO;
        BOOL negativeMarkerFound = NO;
        ArgFormat formatFound = Format_Decimal;
        BOOL asciiFound = NO;

        while (offset < rawString.length) {
            unichar character = buffer[offset];

            if (character == '#') {
                if (numberFound) {
                    // Duplicate immediate value markers should not appear, bail out.
                    [clone endEditing];
                    return clone;
                }

                [clone setAttributes:opcodeFormattingAttributes
                               range:NSMakeRange(offset, 1)];
                offset++;
                continue;
            }

            if (character == '-') {
                if (numberFound) {
                    // Duplicate negative markers should not appear, bail out.
                    [clone endEditing];
                    return clone;
                }

                componentStart = offset;
                numberFound = YES;
                negativeMarkerFound = YES;
                offset++;
                continue;
            }

            if (character == '%' || character == '$') {
                if (numberFound) {
                    // Duplicate format markers should not appear, bail out.
                    [clone endEditing];
                    return clone;
                }

                componentStart = offset;
                numberFound = YES;

                switch (character) {
                    case '$':
                        formatFound = Format_Hexadecimal;
                        break;

                    case '%':
                        formatFound = Format_Binary;
                        if (negativeMarkerFound) {
                            // Negative binary numbers should not appear, bail out.
                            [clone endEditing];
                            return clone;
                        }
                        break;

                    default:
                        // Should not happen!
                        break;
                }

                offset++;
                continue;
            }

            if (isdigit(character) && !asciiFound) {
                if (formatFound == Format_Binary) {
                    if (character != '0' && character != '1') {
                        // Non-binary digits found with a binary format marker, bail out.
                        [clone endEditing];
                        return clone;
                    }
                }

                if (!numberFound) {
                    componentStart = offset;
                    numberFound = YES;
                }
                offset++;
                continue;
            }

            if (formatFound == Format_Hexadecimal) {
                switch (character) {
                    case 'A':
                    case 'B':
                    case 'C':
                    case 'D':
                    case 'E':
                    case 'F':
                        offset++;
                        continue;

                    default:
                        // Non-hexadecimal digit found, mark and exit.
                        [clone setAttributes:numberFormattingAttributes
                                       range:NSMakeRange(componentStart, offset - componentStart)];
                        numberFound = NO;
                        negativeMarkerFound = NO;
                        asciiFound = NO;
                        formatFound = Format_Default;
                }
            }

            if (character == 'o' && formatFound != Format_Binary &&
                formatFound != Format_Hexadecimal && numberFound) {

                // Octal end marker found, mark and exit.
                offset++;
                [clone setAttributes:numberFormattingAttributes
                               range:NSMakeRange(componentStart, offset - componentStart)];
                numberFound = NO;
                negativeMarkerFound = NO;
                asciiFound = NO;
                formatFound = Format_Default;
            }

            if (numberFound && !asciiFound) {
                // Non-digit marker found, mark and exit.

                offset++;
                [clone setAttributes:numberFormattingAttributes
                               range:NSMakeRange(componentStart, offset - componentStart)];
                numberFound = NO;
                negativeMarkerFound = NO;
                asciiFound = NO;
                formatFound = Format_Default;
            }

            if (!asciiFound && isalnum(character)) {
                // Identifier found

                asciiFound = YES;
                componentStart = offset;
            }

            if (character == ',' || character == '(' || character == ')') {
                // New parameter, reset state

                numberFound = NO;
                negativeMarkerFound = NO;
                asciiFound = NO;
                formatFound = Format_Default;
            }

            // Nothing found yet, keep on iterating.
            offset++;
        }

        if ((numberFound || asciiFound) && componentStart != NSNotFound) {
            // Reached EOL whilst scanning for a number, mark and exit.
            [clone setAttributes:numberFormattingAttributes
                           range:NSMakeRange(componentStart, offset - componentStart)];
        }
    }
    
    [clone endEditing];
    
    return clone;
}

Address SetAddressOperand(id<HPDisassembledFile> file, DisasmStruct *disasm,
                          int operand, uint32_t size, uint32_t effectiveSize,
                          uint32_t offset, uint32_t indexRegisters) {

    if (!IsBitsSizeValid(size)) {
        @throw [NSException exceptionWithName:@"InternalErrorExcepton"
                                       reason:[NSString stringWithFormat:@"Internal error: invalid size for SetAddressOperand(): %d", size]
                                     userInfo:nil];
    }

    if (!IsBitsSizeValid(effectiveSize)) {
        @throw [NSException exceptionWithName:@"InternalErrorExcepton"
                                       reason:[NSString stringWithFormat:@"Internal error: invalid effectiveSize for SetAddressOperand(): %d", effectiveSize]
                                     userInfo:nil];
    }

    disasm->operand[operand].memory.baseRegister = 0;
    disasm->operand[operand].memory.indexRegister = indexRegisters;
    disasm->operand[operand].memory.scale = 1;
    disasm->operand[operand].memory.displacement = 0;
    disasm->operand[operand].type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
    disasm->operand[operand].size = effectiveSize;

    Address address;
    switch (size) {
        case 8:
            address = [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset];
            break;

        case 16:
            address = [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset];
            break;

        case 24:
            address = [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset] |
                [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset + sizeof(uint16_t)] << 16;
            break;

        case 32:
            address = [file readUInt32AtVirtualAddress:disasm->virtualAddr + offset];
            break;

        default:
            break;
    }

    disasm->operand[operand].immediateValue = address;
    [file setFormat:Format_Address
        forArgument:operand
   atVirtualAddress:disasm->virtualAddr];

    return address;
}

Address SetRelativeAddressOperand(id<HPDisassembledFile> file,
                                  DisasmStruct *disasm, int operand,
                                  uint32_t size, uint32_t effectiveSize,
                                  uint32_t offset) {

    if (!IsBitsSizeValid(size)) {
        @throw [NSException exceptionWithName:@"InternalErrorExcepton"
                                       reason:[NSString stringWithFormat:@"Internal error: invalid size for SetRelativeAddressOperand(): %d", size]
                                     userInfo:nil];
    }

    if (!IsBitsSizeValid(effectiveSize)) {
        @throw [NSException exceptionWithName:@"InternalErrorExcepton"
                                       reason:[NSString stringWithFormat:@"Internal error: invalid effectiveSize for SetRelativeAddressOperand(): %d", effectiveSize]
                                     userInfo:nil];
    }

    int64_t displacement;
    switch (size) {
        case 8:
            displacement = [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset];
            break;

        case 16:
            displacement = [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset];
            break;

        case 24:
            displacement = [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset] |
                [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset + sizeof(uint16_t)] << 16;
            break;

        case 32:
            displacement = [file readUInt32AtVirtualAddress:disasm->virtualAddr + offset];
            break;

        default:
            break;
    }

    Address address = disasm->instruction.pcRegisterValue +
        CalculateRelativeJumpTarget(displacement) + disasm->instruction.length;
    disasm->operand[operand].type = DISASM_OPERAND_CONSTANT_TYPE;
    disasm->operand[operand].size = effectiveSize;
    disasm->operand[operand].immediateValue = address;
    disasm->instruction.addressValue = address;
    [file setFormat:Format_Address
        forArgument:operand
   atVirtualAddress:disasm->virtualAddr];

    return address;
}

void SetConstantOperand(id<HPDisassembledFile> file, DisasmStruct *disasm,
                        int operand, uint32_t size, uint32_t offset) {

    disasm->operand[operand].type = DISASM_OPERAND_CONSTANT_TYPE;
    disasm->operand[operand].size = size;

    switch (size) {
        case 8:
            disasm->operand[operand].immediateValue = [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset];
            break;

        case 16:
            disasm->operand[operand].immediateValue = [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset];
            break;

        case 24:
            disasm->operand[operand].immediateValue = [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset] |
                [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset + sizeof(uint16_t)] << 16;
            break;

        case 32:
            disasm->operand[operand].immediateValue = [file readUInt32AtVirtualAddress:disasm->virtualAddr + offset];
            break;

        default:
            @throw [NSException exceptionWithName:@"InternalErrorExcepton"
                                           reason:[NSString stringWithFormat:@"Internal error: invalid size for SetConstantOperand(): %d", size]
                                         userInfo:nil];
            
            break;
    }
}

BOOL CanReadBytes(id<HPDisassembledFile> file, Address address, size_t bytes) {
    id<HPSegment> segment = [file segmentForVirtualAddress:address];
    if (!segment) {
        return NO;
    }
    
    return ([segment endAddress] < (address + bytes));
}

int64_t CalculateRelativeJumpTarget(int64_t target) {
    int64_t output = target;
    if (target & (1 << 7)) {
        output = target & 0x7F;
        output = -((~output + 1) & 0x7F);
    }

    return output;
}

BOOL IsBitsSizeValid(size_t size) {
    return (size == 8) || (size == 16) || (size == 24) || (size == 32);
}
