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

#import "FRBBase.h"
#import "FRBGeneric8x300.h"
#import "FRBModelHandler.h"
#import "FRBOperandFormatter.h"
#import "FRBHopperCommon.h"

typedef NS_ENUM(uint32_t, FRBEncodingType) {
    FRBEncodingTypeSingle = 0,
    FRBEncodingTypeWithRotation,
    FRBEncodingTypeWithLength,
    FRBEncodingTypeAssignment,
    FRBEncodingTypeOffset,
    FRBEncodingTypeOffsetWithLength,
};

@interface ItFrobHopper8x300Generic8x300 () {
    NSArray *_instructionFormats;
}

- (BOOL)handleALUInstruction:(DisasmStruct *)structure
                      onFile:(id<HPDisassembledFile>)file;
- (BOOL)handleNZT:(DisasmStruct *)structure
           onFile:(id<HPDisassembledFile>)file;
- (BOOL)handleBranchInstruction:(DisasmStruct *)structure
                         onFile:(id<HPDisassembledFile>)file;
- (BOOL)handleAssignmentInstruction:(DisasmStruct *)structure
                             onFile:(id<HPDisassembledFile>)file;
- (BOOL)handleJumpInstruction:(DisasmStruct *)structure
                       onFile:(id<HPDisassembledFile>)file;

@end

@implementation ItFrobHopper8x300Generic8x300

static NSString * const kProviderName = @"it.frob.hopper.generic8x300";

@synthesize name;

- (instancetype)init {
    if (self = [super init]) {
        name = kProviderName;

        _instructionFormats = [NSArray arrayWithObjects:
                               @"%s    %@",        // FRBEncodingTypeSingle
                               @"%s    %@(%@),%@", // FRBEncodingTypeWithRotation
                               @"%s    %@,%@,%@",  // FRBEncodingTypeWithLength
                               @"%s    %@,%@",     // FRBEncodingTypeAssignment
                               @"%s    %@(%@)",    // FRBEncodingTypeOffset
                               @"%s    %@(%@),%@", // FRBEncodingTypeOffsetWithLength
                               nil];
    }

    return self;
}

+ (void)load {
    [[ItFrobHopper8x300ModelHandler sharedModelHandler] registerProvider:[ItFrobHopper8x300Generic8x300 class]
                                                                 forName:kProviderName];
}

- (int)processStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    InitialiseDisasmStruct(structure);

    structure->instruction.length = 2;
    uint16_t opcodeWord = [file readUInt16AtVirtualAddress:structure->virtualAddr];

    switch (opcodeWord >> 13) {
        case FRBOpcodeMOVE:
            if (![self handleALUInstruction:structure
                                     onFile:file]) {
                return DISASM_UNKNOWN_OPCODE;
            }
            break;

        case FRBOpcodeADD:
            if (![self handleALUInstruction:structure
                                     onFile:file]) {
                return DISASM_UNKNOWN_OPCODE;
            }
            structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] |= 1 << FRB8x300RegisterAUX;
            break;

        case FRBOpcodeAND:
            if (![self handleALUInstruction:structure
                                     onFile:file]) {
                return DISASM_UNKNOWN_OPCODE;
            }
            structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] |= 1 << FRB8x300RegisterAUX;
            break;

        case FRBOpcodeXOR:
            if (![self handleALUInstruction:structure
                                     onFile:file]) {
                return DISASM_UNKNOWN_OPCODE;
            }
            structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] |= 1 << FRB8x300RegisterAUX;
            break;

        case FRBOpcodeXEC:
            if (![self handleBranchInstruction:structure
                                        onFile:file]) {
                return DISASM_UNKNOWN_OPCODE;
            }
            break;

        case FRBOpcodeNZT:
            if (![self handleNZT:structure
                          onFile:file]) {
                return DISASM_UNKNOWN_OPCODE;
            }
            break;

        case FRBOpcodeXMIT:
            if (![self handleAssignmentInstruction:structure
                                            onFile:file]) {
                return DISASM_UNKNOWN_OPCODE;
            }
            break;

        case FRBOpcodeJMP:
            if (![self handleJumpInstruction:structure
                                      onFile:file]) {
                return DISASM_UNKNOWN_OPCODE;
            }
            break;

        default:
            break;
    }

    const char *opcodeName = kOpcodeNames[opcodeWord >> 13];

    strcpy(structure->instruction.mnemonic, opcodeName);
    strcpy(structure->instruction.unconditionalMnemonic, opcodeName);

    return structure->instruction.length;
}

- (BOOL)haltsExecutionFlow:(const DisasmStruct *)structure {
    return NO;
}

- (const char *)formatInstruction:(const DisasmStruct *)structure
                           onFile:(id<HPDisassembledFile>)file
                     withServices:(id<HPHopperServices>)services {

    NSMutableArray *strings = [NSMutableArray new];

    for (int index = 0; index < DISASM_MAX_OPERANDS; index++) {
        if (structure->operand[index].type == DISASM_OPERAND_NO_OPERAND) {
            continue;
        }

        if (structure->operand[index].type == DISASM_OPERAND_REGISTER_TYPE) {
            [strings addObject:[NSString stringWithUTF8String:structure->operand[index].mnemonic]];
            continue;
        }

        NSNumber *number;
        if (structure->operand[index].size == 64 && structure->operand[index].immediateValue < 0) {
            // TODO: Check this!
            number = [NSNumber numberWithUnsignedLongLong:(structure->operand[index].immediateValue - 18446744073709551615ULL) - 1ULL];
        } else {
            number = [NSNumber numberWithLongLong:structure->operand[index].immediateValue];
        }

        ArgFormat format = [file formatForArgument:index
                                  atVirtualAddress:structure->virtualAddr];
        [strings addObject:FormatValue(number, structure, format,
                                       structure->operand[index].size, services)];
    }

    NSString *format = _instructionFormats[structure->instruction.userData];

    switch (structure->instruction.userData) {
        case FRBEncodingTypeSingle:
            return [NSString stringWithFormat:format,
                    structure->instruction.mnemonic, strings[0]].UTF8String;

        case FRBEncodingTypeOffset:
        case FRBEncodingTypeAssignment:
            return [NSString stringWithFormat:format,
                    structure->instruction.mnemonic, strings[0],
                    strings[1]].UTF8String;

        case FRBEncodingTypeWithRotation:
        case FRBEncodingTypeWithLength:
        case FRBEncodingTypeOffsetWithLength:
            return [NSString stringWithFormat:format,
                    structure->instruction.mnemonic, strings[0], strings[1],
                    strings[2]].UTF8String;

        default:
            return nil;
    }
}

#pragma mark Private methods

- (BOOL)handleALUInstruction:(DisasmStruct *)structure
                      onFile:(id<HPDisassembledFile>)file {

    uint16_t opcode = [file readUInt16AtVirtualAddress:structure->virtualAddr];

    int sourceRegister = (opcode >> 8) & 0x001F;
    int destinationRegister = opcode & 0x001F;
    int rotationOrLength = (opcode >> 5) & 0x0007;

    if (kRegisterNames[sourceRegister] == NULL ||
        kRegisterNames[destinationRegister] == NULL) {
        return NO;
    }

    switch (opcode & 0x1010) {
        case 0x0000:

            // Register to Register

            if (sourceRegister == FRB8x300RegisterIVL ||
                sourceRegister == FRB8x300RegisterIVR ||
                destinationRegister == FRB8x300RegisterOVF) {

                return NO;
            }
            structure->instruction.userData = FRBEncodingTypeWithRotation;
            break;

        case 0x0010:

            // Register to I/O bus

            if (sourceRegister == FRB8x300RegisterIVL ||
                sourceRegister == FRB8x300RegisterIVR) {

                return NO;
            }
            structure->instruction.userData = FRBEncodingTypeWithLength;
            break;

        case 0x1000:

            // I/O bus to register

            if (destinationRegister == FRB8x300RegisterOVF) {
                return NO;
            }
            structure->instruction.userData = FRBEncodingTypeWithLength;
            break;

        case 0x1010:

            // I/O bus to I/O bus

            structure->instruction.userData = FRBEncodingTypeWithLength;
            break;

        default:
            break;
    }

    structure->operand[0].type = DISASM_OPERAND_REGISTER_TYPE;
    strcpy(structure->operand[0].mnemonic, kRegisterNames[sourceRegister]);

    structure->operand[1].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[1].immediateValue = rotationOrLength;
    structure->operand[1].size = 8;

    structure->operand[2].type = DISASM_OPERAND_REGISTER_TYPE;
    strcpy(structure->operand[2].mnemonic, kRegisterNames[destinationRegister]);

    structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = (1 << sourceRegister) | FRB8x300RegisterFlagAUX;
    structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = 1 << destinationRegister | FRB8x300RegisterFlagOVF;

    SetDefaultFormatForArgument(file, structure->virtualAddr, 1, Format_Decimal);

    return YES;
}

- (BOOL)handleNZT:(DisasmStruct *)structure
           onFile:(id<HPDisassembledFile>)file {

    uint16_t opcode = [file readUInt16AtVirtualAddress:structure->virtualAddr];

    uint8_t registerId = (opcode >> 8) & 0x001F;
    if (!kRegisterNames[registerId]) {
        return NO;
    }

    structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = 1 << registerId;

    if ((opcode & 0x1000) == 0x0000) {
        // Register immediate

        if (registerId == FRB8x300RegisterIVL || registerId == FRB8x300RegisterIVR) {
            return NO;
        }

        Address address = (structure->virtualAddr & 0xFFFFFF00) | ((opcode & 0x00FF) * 2);
        structure->operand[0].memory.baseRegister = 0;
        structure->operand[0].memory.indexRegister = 0;
        structure->operand[0].memory.scale = 1;
        structure->operand[0].memory.displacement = 0;
        structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_RELATIVE;
        structure->operand[0].size = 16;
        structure->operand[0].immediateValue = address;

        structure->instruction.addressValue = address;
        structure->instruction.branchType = DISASM_BRANCH_JNE;
        [file setFormat:Format_Address
            forArgument:0
       atVirtualAddress:structure->virtualAddr];
        
        structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
        strcpy(structure->operand[1].mnemonic, kRegisterNames[registerId]);

        structure->instruction.userData = FRBEncodingTypeOffset;

        return YES;
    }

    // I/O bus immediate

    Address address = (structure->virtualAddr & 0xFFFFFFE0) | ((opcode & 0x001F) * 2);

    structure->operand[0].memory.baseRegister = 0;
    structure->operand[0].memory.indexRegister = 0;
    structure->operand[0].memory.scale = 1;
    structure->operand[0].memory.displacement = 0;
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_RELATIVE;
    structure->operand[0].size = 16;
    structure->operand[0].immediateValue = address;
    structure->instruction.addressValue = address;
    structure->instruction.branchType = DISASM_BRANCH_JNE;
    [file setFormat:Format_Address
        forArgument:0
   atVirtualAddress:structure->virtualAddr];

    structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
    strcpy(structure->operand[1].mnemonic, kRegisterNames[registerId]);

    structure->operand[2].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[2].immediateValue = (opcode >> 5) & 0x0007;
    structure->operand[2].size = 8;
    SetDefaultFormatForArgument(file, structure->virtualAddr, 2, Format_Decimal);

    structure->instruction.branchType = DISASM_BRANCH_JNE;
    structure->instruction.userData = FRBEncodingTypeOffsetWithLength;
    
    return YES;
}

- (BOOL)handleBranchInstruction:(DisasmStruct *)structure
                         onFile:(id<HPDisassembledFile>)file {

    uint16_t opcode = [file readUInt16AtVirtualAddress:structure->virtualAddr];

    uint8_t registerId = (opcode >> 8) & 0x001F;
    if (!kRegisterNames[registerId]) {
        return NO;
    }

    structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = 1 << registerId;
    structure->instruction.branchType = DISASM_BRANCH_JNE;

    if ((opcode & 0x1000) == 0x0000) {
        // Register immediate

        if (registerId == FRB8x300RegisterIVL || registerId == FRB8x300RegisterIVR) {
            return NO;
        }

        structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
        structure->operand[0].immediateValue = opcode & 0x00FF;
        structure->operand[0].size = 8;

        structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
        strcpy(structure->operand[1].mnemonic, kRegisterNames[registerId]);

        structure->instruction.userData = FRBEncodingTypeOffset;

        return YES;
    }

    // I/O bus immediate

    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].immediateValue = opcode & 0x001F;
    structure->operand[0].size = 8;

    structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
    strcpy(structure->operand[1].mnemonic, kRegisterNames[registerId]);

    structure->operand[2].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[2].immediateValue = (opcode >> 5) & 0x0007;
    structure->operand[2].size = 8;
    SetDefaultFormatForArgument(file, structure->virtualAddr, 2, Format_Decimal);

    structure->instruction.userData = FRBEncodingTypeOffsetWithLength;

    return YES;
}

- (BOOL)handleAssignmentInstruction:(DisasmStruct *)structure
                             onFile:(id<HPDisassembledFile>)file {

    uint16_t opcode = [file readUInt16AtVirtualAddress:structure->virtualAddr];

    uint8_t registerId = (opcode >> 8) & 0x001F;
    if (!kRegisterNames[registerId]) {
        return NO;
    }

    structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = 1 << registerId;

    if ((opcode & 0x1000) == 0x0000) {
        // Register immediate

        if (registerId == FRB8x300RegisterIVL) {
            return NO;
        }

        structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
        structure->operand[0].immediateValue = opcode & 0x00FF;
        structure->operand[0].size = 8;

        structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
        strcpy(structure->operand[1].mnemonic, kRegisterNames[registerId]);

        structure->instruction.userData = FRBEncodingTypeAssignment;

        return YES;
    }

    // I/O bus immediate

    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[0].immediateValue = opcode & 0x001F;
    structure->operand[0].size = 8;

    structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
    strcpy(structure->operand[1].mnemonic, kRegisterNames[registerId]);

    structure->operand[2].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[2].immediateValue = (opcode >> 5) & 0x0007;
    structure->operand[2].size = 8;

    SetDefaultFormatForArgument(file, structure->virtualAddr, 2, Format_Decimal);

    structure->instruction.userData = FRBEncodingTypeOffsetWithLength;

    return YES;
}

- (BOOL)handleJumpInstruction:(DisasmStruct *)structure
                       onFile:(id<HPDisassembledFile>)file {

    uint16_t opcode = [file readUInt16AtVirtualAddress:structure->virtualAddr];

    // Address immediate

    Address address = opcode & 0x1FFFF;

    structure->operand[0].memory.baseRegister = 0;
    structure->operand[0].memory.indexRegister = 0;
    structure->operand[0].memory.scale = 1;
    structure->operand[0].memory.displacement = 0;
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_ABSOLUTE;
    structure->operand[0].size = 16;
    structure->operand[0].immediateValue = address;

    structure->instruction.addressValue = address;
    structure->instruction.branchType = DISASM_BRANCH_JMP;
    structure->instruction.userData = FRBEncodingTypeSingle;
    [file setFormat:Format_Address
        forArgument:0
   atVirtualAddress:structure->virtualAddr];

    return YES;
}

@end
