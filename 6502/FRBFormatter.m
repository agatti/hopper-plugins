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

#import "FRBFormatter.h"

static const NSArray *FRBOpcodeFormats;

@interface FRBFormatter ()

+ (NSString *)formatHexadecimal:(DisasmStruct *)source
                        operand:(NSUInteger)operand
                    signedValue:(BOOL)signedValue;

+ (NSString *)formatDecimal:(DisasmStruct *)source
                    operand:(NSUInteger)operand
                signedValue:(BOOL)signedValue;

+ (NSString *)formatOctal:(DisasmStruct *)source
                  operand:(NSUInteger)operand
              signedValue:(BOOL)signedValue;

+ (NSString *)formatBinary:(DisasmStruct *)source
                   operand:(NSUInteger)operand
               signedValue:(BOOL)signedValue; // Ignored

+ (NSString *)formatAddress:(DisasmStruct *)source
                    operand:(NSUInteger)operand
               withServices:(id<HPHopperServices>)services;

+ (NSString *)convertToBinary:(uint64_t)value
                   sizeInBits:(size_t)bits;

@end

@implementation FRBFormatter

+ (void)load {
    FRBOpcodeFormats = [NSArray arrayWithObjects:@"%@    %@", @"%@    %@,X",
                        @"%@    %@,Y", @"%@    #%@", @"%@", @"%@", @"%@",
                        @"%@    (%@)", @"%@    %@", @"%@    %@", @"%@    %@,X",
                        @"%@    %@,Y", @"%@    (%@,X)", @"%@    (%@),Y",
                        @"%@    (%@)", @"%@    (%@,X)", @"%@    %@,%@",
                        @"%@    %@,%@,%@", @"%@    %@,%@", @"%@    %@,%@,X",
                        @"%@    %@,%@", @"%@    %@,%@,X", @"%@", nil];
}

+ (NSString *)format:(FRBAddressMode)addressMode
              opcode:(NSString *)opcode
            operands:(NSArray *)operands {

    NSString *format = FRBOpcodeFormats[addressMode];

    switch (addressMode) {
        case FRBAddressModeAbsolute:
        case FRBAddressModeAbsoluteIndexedX:
        case FRBAddressModeAbsoluteIndexedY:
        case FRBAddressModeImmediate:
        case FRBAddressModeAbsoluteIndirect:
        case FRBAddressModeProgramCounterRelative:
        case FRBAddressModeZeroPage:
        case FRBAddressModeZeroPageIndexedX:
        case FRBAddressModeZeroPageIndexedY:
        case FRBAddressModeZeroPageIndexedIndirect:
        case FRBAddressModeZeroPageIndirectIndexedY:
        case FRBAddressModeZeroPageIndirect:
        case FRBAddressModeAbsoluteIndexedIndirect:
            return [NSString stringWithFormat:format, opcode, operands[0]];

        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            return [NSString stringWithFormat:format, opcode];

        case FRBAddressModeZeroPageProgramCounterRelative:
        case FRBAddressModeImmediateZeroPage:
        case FRBAddressModeImmediateZeroPageX:
        case FRBAddressModeImmediateAbsolute:
        case FRBAddressModeImmediateAbsoluteX:
            return [NSString stringWithFormat:format, opcode, operands[0],
                    operands[1]];

        case FRBAddressModeBlockTransfer:
            return [NSString stringWithFormat:format, opcode, operands[0],
                    operands[1], operands[2]];

        default:
            return nil;
    }
}

+ (NSString *)format:(DisasmStruct *)source
             operand:(NSUInteger)operand
      argumentFormat:(ArgFormat)format
        withServices:(NSObject<HPHopperServices> *)services {

    switch ((int) format) { // :(
        case Format_Hexadecimal | Format_Signed:
            return [FRBFormatter formatHexadecimal:source
                                           operand:operand
                                       signedValue:YES];

        case Format_Hexadecimal:
            return [FRBFormatter formatHexadecimal:source
                                           operand:operand
                                       signedValue:NO];

        case Format_Decimal | Format_Signed:
            return [FRBFormatter formatDecimal:source
                                       operand:operand
                                   signedValue:YES];

        case Format_Decimal:
            return [FRBFormatter formatDecimal:source
                                       operand:operand
                                   signedValue:NO];

        case Format_Octal:
            return [FRBFormatter formatOctal:source
                                     operand:operand
                                 signedValue:NO];

        case Format_Binary:
            return [FRBFormatter formatBinary:source
                                      operand:operand
                                  signedValue:NO];

        case Format_Address:
            return [FRBFormatter formatAddress:source
                                       operand:operand
                                  withServices:services];

        default:
            return [FRBFormatter formatAddress:source
                                       operand:operand
                                  withServices:services];
    }
}

+ (NSString *)formatHexadecimal:(DisasmStruct *)source
                        operand:(NSUInteger)operand
                    signedValue:(BOOL)signedValue {

    if (source->operand[operand].type == DISASM_OPERAND_NO_OPERAND) {
        return nil;
    }

    int64_t andMask = (1 << source->operand[operand].size) - 1;

    int64_t operandValue = source->operand[operand].immediateValue;
    int64_t value;
    BOOL negative;
    if ((operandValue & andMask) && signedValue) {
        value = ~operandValue + 1;
        negative = YES;
    } else {
        value = operandValue;
        negative = NO;
    }

    if (source->operand[operand].size > 8) {
        return [NSString stringWithFormat:@"%@$%04llX", negative ? @"-" : @"",
                (uint64_t) (value & andMask)];
    }

    return [NSString stringWithFormat:@"%@$%02llX", negative ? @"-" : @"",
            (uint64_t) (value & andMask)];
}

+ (NSString *)formatDecimal:(DisasmStruct *)source
                    operand:(NSUInteger)operand
                signedValue:(BOOL)signedValue {

    if (source->operand[operand].type == DISASM_OPERAND_NO_OPERAND) {
        return nil;
    }

    int64_t andMask = (1 << source->operand[operand].size) - 1;

    int64_t operandValue = source->operand[operand].immediateValue;
    int64_t value;
    BOOL negative;
    if ((operandValue & andMask) && signedValue) {
        value = ~operandValue + 1;
        negative = YES;
    } else {
        value = operandValue;
        negative = NO;
    }

    return [NSString stringWithFormat:@"%@%llu", negative ? @"-" : @"",
            (uint64_t) (value & andMask)];
}

+ (NSString *)formatOctal:(DisasmStruct *)source
                  operand:(NSUInteger)operand
              signedValue:(BOOL)signedValue {

    if (source->operand[operand].type == DISASM_OPERAND_NO_OPERAND) {
        return nil;
    }

    int64_t andMask = (1 << source->operand[operand].size) - 1;

    int64_t operandValue = source->operand[operand].immediateValue;
    int64_t value;
    BOOL negative;
    if ((operandValue & andMask) && signedValue) {
        value = ~operandValue + 1;
        negative = YES;
    } else {
        value = operandValue;
        negative = NO;
    }

    return [NSString stringWithFormat:@"%@%lloo", negative ? @"-" : @"",
            (uint64_t) (value & andMask)];
}

+ (NSString *)formatBinary:(DisasmStruct *)source
                   operand:(NSUInteger)operand
               signedValue:(BOOL)signedValue {

    return [FRBFormatter convertToBinary:source->operand[operand].immediateValue
                              sizeInBits:source->operand[operand].size];
}

+ (NSString *)formatAddress:(DisasmStruct *)source
                    operand:(NSUInteger)operand
               withServices:(id<HPHopperServices>)services {

    NSString *name = [[services currentDocument].disassembledFile nameForVirtualAddress:source->operand[operand].immediateValue];
    if (!name) {
        return [FRBFormatter formatHexadecimal:source
                                       operand:operand
                                   signedValue:NO];
    }

    return name;
}

+ (NSString *)convertToBinary:(uint64_t)value
                   sizeInBits:(size_t)bits {

    NSMutableString *output = [NSMutableString new];
    long startBit = bits - 1;
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

        [output appendFormat:@"%c", bitSet ? '1' : '0' ];
    }

    if (output.length == 0) {
        [output appendFormat:@"0"];
    }

    return output;
}

@end
