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
#import "FRBHopperCommon.h"

#import <Hopper/Hopper.h>

static BOOL IsBitsSizeValid(size_t size);

Address SetAddressOperand(id<HPDisassembledFile> file, DisasmStruct *disasm,
                          int operand, uint32_t size, uint32_t effectiveSize,
                          uint32_t offset, uint32_t indexRegisters) {

    if (!IsBitsSizeValid(size)) {
        @throw [NSException exceptionWithName:FRBHopperExceptionName
                                       reason:[NSString stringWithFormat:@"Internal error: invalid size for SetAddressOperand(): %d", size]
                                     userInfo:nil];
    }

    if (!IsBitsSizeValid(effectiveSize)) {
        @throw [NSException exceptionWithName:FRBHopperExceptionName
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
        @throw [NSException exceptionWithName:FRBHopperExceptionName
                                       reason:[NSString stringWithFormat:@"Internal error: invalid size for SetRelativeAddressOperand(): %d", size]
                                     userInfo:nil];
    }

    if (!IsBitsSizeValid(effectiveSize)) {
        @throw [NSException exceptionWithName:FRBHopperExceptionName
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
            @throw [NSException exceptionWithName:FRBHopperExceptionName
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
