/*
 Copyright (c) 2014-2015, Alessandro Gatti - frob.it
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
#import "FRBBase8x300.h"
#import "FRBModelHandler.h"
#import "FRBOperandFormatter.h"
#import "FRBHopperCommon.h"

typedef NS_ENUM(uint32_t, EncodingType) {
    FRB8x300EncodingTypeSingle = 0,
    FRB8x300EncodingTypeWithRotation,
    FRB8x300EncodingTypeWithLength,
    FRB8x300EncodingTypeAssignment,
    FRB8x300EncodingTypeOffset,
    FRB8x300EncodingTypeOffsetWithLength,
};

@interface NAMESPACE(8x300Base8x300) () {
    NSArray *_instructionFormats;
}

- (BOOL)handleALUInstruction:(DisasmStruct *)structure
                      onFile:(id<HPDisassembledFile>)file
                  withOpcode:(uint16_t)opcode;
- (BOOL)handleNZTInstruction:(DisasmStruct *)structure
                      onFile:(id<HPDisassembledFile>)file
                  withOpcode:(uint16_t)opcode;
- (BOOL)handleXECInstruction:(DisasmStruct *)structure
                      onFile:(id<HPDisassembledFile>)file
                  withOpcode:(uint16_t)opcode;
- (BOOL)handleXMITInstruction:(DisasmStruct *)structure
                       onFile:(id<HPDisassembledFile>)file
                   withOpcode:(uint16_t)opcode;
- (BOOL)handleJMPInstruction:(DisasmStruct *)structure
                      onFile:(id<HPDisassembledFile>)file
                  withOpcode:(uint16_t)opcode;

@end

@implementation NAMESPACE(8x300Base8x300)

static NSString * const kProviderName = @"it.frob.hopper.generic8x300";

@synthesize name;

- (instancetype)init {
    if (self = [super init]) {
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

- (int)processStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    InitialiseDisasmStruct(structure);

    structure->instruction.length = 2;
    uint16_t opcodeWord = [file readUInt16AtVirtualAddress:structure->virtualAddr];

    const char *opcodeName = kOpcodeNames[opcodeWord >> 13];

    strcpy(structure->instruction.mnemonic, opcodeName);
    strcpy(structure->instruction.unconditionalMnemonic, opcodeName);

    BOOL result = NO;

    switch (opcodeWord >> 13) {
        case FRBOpcodeMOVE:
            result = [self handleMOVEOpcode:opcodeWord
                               forStructure:structure
                                     onFile:file];
            break;

        case FRBOpcodeADD:
            result = [self handleADDOpcode:opcodeWord
                              forStructure:structure
                                    onFile:file];
            break;

        case FRBOpcodeAND:
            result = [self handleANDOpcode:opcodeWord
                              forStructure:structure
                                    onFile:file];
            break;

        case FRBOpcodeXOR:
            result = [self handleXOROpcode:opcodeWord
                              forStructure:structure
                                    onFile:file];
            break;

        case FRBOpcodeXEC:
            result = [self handleXECOpcode:opcodeWord
                              forStructure:structure
                                    onFile:file];
            break;

        case FRBOpcodeNZT:
            result = [self handleNZTOpcode:opcodeWord
                              forStructure:structure
                                    onFile:file];
            break;

        case FRBOpcodeXMIT:
            result = [self handleXMITOpcode:opcodeWord
                               forStructure:structure
                                     onFile:file];
            break;

        case FRBOpcodeJMP:
            result = [self handleJMPOpcode:opcodeWord
                              forStructure:structure
                                    onFile:file];
            break;

        default:
            break;
    }

    return result ? structure->instruction.length : DISASM_UNKNOWN_OPCODE;
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
        case FRB8x300EncodingTypeSingle:
            return [NSString stringWithFormat:format,
                    structure->instruction.mnemonic, strings[0]].UTF8String;

        case FRB8x300EncodingTypeOffset:
        case FRB8x300EncodingTypeAssignment:
            return [NSString stringWithFormat:format,
                    structure->instruction.mnemonic, strings[0],
                    strings[1]].UTF8String;

        case FRB8x300EncodingTypeWithRotation:
        case FRB8x300EncodingTypeWithLength:
        case FRB8x300EncodingTypeOffsetWithLength:
            return [NSString stringWithFormat:format,
                    structure->instruction.mnemonic, strings[0], strings[1],
                    strings[2]].UTF8String;

        default:
            return nil;
    }
}

#pragma mark - Private methods

- (BOOL)handleALUInstruction:(DisasmStruct *)structure
                      onFile:(id<HPDisassembledFile>)file
                  withOpcode:(uint16_t)opcode {

    int sourceRegister = (opcode >> 8) & 0x001F;
    int destinationRegister = opcode & 0x001F;
    int rotationOrLength = (opcode >> 5) & 0x0007;

    switch (opcode & 0x1010) {

        // Register to Register
        case 0x0000:
            structure->instruction.userData = FRB8x300EncodingTypeWithRotation;
            break;

        // Register to I/O bus
        case 0x0010:
            structure->instruction.userData = FRB8x300EncodingTypeWithLength;
            break;

        // I/O bus to register
        case 0x1000:
            structure->instruction.userData = FRB8x300EncodingTypeWithLength;
            break;

        // I/O bus to I/O bus
        case 0x1010:
            structure->instruction.userData = FRB8x300EncodingTypeWithLength;
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

- (BOOL)handleNZTInstruction:(DisasmStruct *)structure
                      onFile:(id<HPDisassembledFile>)file
                  withOpcode:(uint16_t)opcode {

    uint8_t registerId = (opcode >> 8) & 0x001F;

    structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = 1 << registerId;

    if ((opcode & 0x1000) == 0x0000) {
        // Register immediate

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

        structure->instruction.userData = FRB8x300EncodingTypeOffset;

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
    structure->instruction.userData = FRB8x300EncodingTypeOffsetWithLength;
    
    return YES;
}

- (BOOL)handleXECInstruction:(DisasmStruct *)structure
                         onFile:(id<HPDisassembledFile>)file
                  withOpcode:(uint16_t)opcode {

    uint8_t registerId = (opcode >> 8) & 0x001F;

    structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = 1 << registerId;
    structure->instruction.branchType = DISASM_BRANCH_JNE;

    if ((opcode & 0x1000) == 0x0000) {
        // Register immediate

        structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
        structure->operand[0].immediateValue = opcode & 0x00FF;
        structure->operand[0].size = 8;

        structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
        strcpy(structure->operand[1].mnemonic, kRegisterNames[registerId]);

        structure->instruction.userData = FRB8x300EncodingTypeOffset;

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

    structure->instruction.userData = FRB8x300EncodingTypeOffsetWithLength;

    return YES;
}

- (BOOL)handleXMITInstruction:(DisasmStruct *)structure
                             onFile:(id<HPDisassembledFile>)file
                   withOpcode:(uint16_t)opcode {

    uint8_t registerId = (opcode >> 8) & 0x001F;

    structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = 1 << registerId;

    if ((opcode & 0x1000) == 0x0000) {
        // Register immediate

        structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
        structure->operand[0].immediateValue = opcode & 0x00FF;
        structure->operand[0].size = 8;

        structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
        strcpy(structure->operand[1].mnemonic, kRegisterNames[registerId]);

        structure->instruction.userData = FRB8x300EncodingTypeAssignment;

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

    structure->instruction.userData = FRB8x300EncodingTypeOffsetWithLength;

    return YES;
}

- (BOOL)handleJMPInstruction:(DisasmStruct *)structure
                      onFile:(id<HPDisassembledFile>)file
                  withOpcode:(uint16_t)opcode {

    // Address immediate

    Address address = opcode & 0x1FFF;

    structure->operand[0].memory.baseRegister = 0;
    structure->operand[0].memory.indexRegister = 0;
    structure->operand[0].memory.scale = 1;
    structure->operand[0].memory.displacement = 0;
    structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_ABSOLUTE;
    structure->operand[0].size = 16;
    structure->operand[0].immediateValue = address;

    structure->instruction.addressValue = address;
    structure->instruction.branchType = DISASM_BRANCH_JMP;
    structure->instruction.userData = FRB8x300EncodingTypeSingle;
    [file setFormat:Format_Address
        forArgument:0
   atVirtualAddress:structure->virtualAddr];

    return YES;
}

#pragma mark - Overridable opcode handling methods

- (BOOL)handleMOVEOpcode:(uint16_t)opcode
            forStructure:(DisasmStruct *)structure
                  onFile:(id<HPDisassembledFile>)file {
    return [self handleALUInstruction:structure
                               onFile:file
                           withOpcode:opcode];
}

- (BOOL)handleADDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    BOOL result = [self handleALUInstruction:structure
                                      onFile:file
                                  withOpcode:opcode];

    if (result) {
        structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] |= 1 << FRB8x300RegisterAUX;
    }

    return result;
}

- (BOOL)handleANDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    BOOL result = [self handleALUInstruction:structure
                                      onFile:file
                                  withOpcode:opcode];

    if (result) {
        structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] |= 1 << FRB8x300RegisterAUX;
    }

    return result;
}

- (BOOL)handleXOROpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    BOOL result = [self handleALUInstruction:structure
                                      onFile:file
                                  withOpcode:opcode];

    if (result) {
        structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] |= 1 << FRB8x300RegisterAUX;
    }

    return result;
}

- (BOOL)handleXECOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    return [self handleXECInstruction:structure
                               onFile:file
                           withOpcode:opcode];
}

- (BOOL)handleNZTOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    return [self handleNZTInstruction:structure
                               onFile:file
                           withOpcode:opcode];
}

- (BOOL)handleXMITOpcode:(uint16_t)opcode
            forStructure:(DisasmStruct *)structure
                  onFile:(id<HPDisassembledFile>)file {
    return [self handleXMITInstruction:structure
                                onFile:file
                            withOpcode:opcode];
}

- (BOOL)handleJMPOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    return [self handleJMPInstruction:structure
                               onFile:file
                           withOpcode:opcode];
}

@end
