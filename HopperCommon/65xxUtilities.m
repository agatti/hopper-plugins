/*
 Copyright (c) 2014-2020, Alessandro Gatti - frob.it
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

#import "65xxUtilities.h"
#import "HopperCommon.h"

static BOOL IsBitsSizeValid(size_t size);

@implementation ItFrobHopperCommonHopper65xxUtilities

+ (Address)fillAddressOperand:(NSUInteger)operand
                       inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                    forStruct:(DisasmStruct *_Nonnull)disasm
                     withSize:(NSUInteger)size
             andEffectiveSize:(NSUInteger)effectiveSize
                   withOffset:(NSUInteger)offset
      usingIndexRegistersMask:(NSUInteger)indexRegisters {

  if (!IsBitsSizeValid(size)) {
    static NSString *internalErrorString =
        @"Internal error: invalid size for SetAddressOperand(): %lu";
    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
                   reason:[NSString stringWithFormat:internalErrorString,
                                                     (unsigned long)size]
                 userInfo:nil];
  }

  disasm->operand[operand].memory.baseRegistersMask = 0;
  disasm->operand[operand].memory.indexRegistersMask = indexRegisters;
  disasm->operand[operand].memory.scale = 1;
  disasm->operand[operand].memory.displacement = 0;
  disasm->operand[operand].type =
      DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
  disasm->operand[operand].size = (uint32_t)effectiveSize;

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
              [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset +
                                              sizeof(uint16_t)]
                  << 16;
    break;

  default: {
    static NSString *internalErrorString = @"Internal error: invalid "
                                           @"effectiveSize for "
                                           @"SetAddressOperand(): "
                                           @"%lu";
    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
                   reason:[NSString
                              stringWithFormat:internalErrorString,
                                               (unsigned long)effectiveSize]
                 userInfo:nil];
  }
  }

  disasm->operand[operand].immediateValue = address;
  disasm->operand[operand].userData[0] = (uint8_t)Format_Address;

  return address;
}

+ (Address)fillRelativeAddressOperand:(NSUInteger)operand
                               inFile:
                                   (NSObject<HPDisassembledFile> *_Nonnull)file
                            forStruct:(DisasmStruct *_Nonnull)disasm
                             withSize:(NSUInteger)size
                     andEffectiveSize:(NSUInteger)effectiveSize
                           withOffset:(NSUInteger)offset {

  if (!IsBitsSizeValid(effectiveSize)) {
    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
                   reason:[NSString
                              stringWithFormat:@"Internal error: invalid "
                                               @"effectiveSize for "
                                               @"SetRelativeAddressOpera"
                                               @"nd(): %lu",
                                               (unsigned long)effectiveSize]
                 userInfo:nil];
  }

  int64_t displacement;
  switch (size) {
  case 8:
    displacement =
        [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset];
    break;

  case 16:
    displacement =
        [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset];
    break;

  case 24:
    displacement =
        [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset] |
        [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset +
                                        sizeof(uint16_t)]
            << 16;
    break;

  default:
    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
                   reason:[NSString stringWithFormat:@"Internal error: invalid "
                                                     @"size for "
                                                     @"SetRelativeAddressOpera"
                                                     @"nd(): %lu",
                                                     (unsigned long)size]
                 userInfo:nil];
  }

  Address address = disasm->instruction.pcRegisterValue +
                    [ItFrobHopperCommonHopper65xxUtilities
                        calculateRelativeJumpTarget:displacement] +
                    disasm->instruction.length;
  disasm->operand[operand].type = DISASM_OPERAND_CONSTANT_TYPE;
  disasm->operand[operand].size = (uint32_t)effectiveSize;
  disasm->operand[operand].immediateValue = address;
  disasm->instruction.addressValue = address;
  disasm->operand[operand].userData[0] = (uint8_t)Format_Address;

  return address;
}

+ (void)fillConstantOperand:(NSUInteger)operand
                     inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                  forStruct:(DisasmStruct *_Nonnull)disasm
                   withSize:(NSUInteger)size
                  andOffset:(NSUInteger)offset {

  disasm->operand[operand].type = DISASM_OPERAND_CONSTANT_TYPE;
  disasm->operand[operand].size = (uint32_t)size;

  switch (size) {
  case 8:
    disasm->operand[operand].immediateValue =
        [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset];
    break;

  case 16:
    disasm->operand[operand].immediateValue =
        [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset];
    break;

  case 24:
    disasm->operand[operand].immediateValue =
        [file readUInt16AtVirtualAddress:disasm->virtualAddr + offset] |
        [file readUInt8AtVirtualAddress:disasm->virtualAddr + offset +
                                        sizeof(uint16_t)]
            << 16;
    break;

  default:
    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
                   reason:[NSString
                              stringWithFormat:@"Internal error: invalid size "
                                               @"for SetConstantOperand(): %lu",
                                               (unsigned long)size]
                 userInfo:nil];
  }
}

+ (int64_t)calculateRelativeJumpTarget:(int64_t)target {
  int64_t output = target;
  if (target & (1 << 7)) {
    output = target & 0x7F;
    output = -((~output + 1) & 0x7F);
  }

  return output;
}

+ (NSString *_Nullable)formatHexadecimalValue:(int64_t)value
                                displaySigned:(BOOL)isSigned
                            showLeadingZeroes:(BOOL)hasLeadingZeroes
                                   usingWidth:(NSUInteger)bits {

  if ((bits == 0) || (bits > 24)) {
    return nil;
  }

  char buffer[6 + 1 + 1 + 1] = {0};
  size_t index = 0;

  if (isSigned && ((value & (1 << (bits - 1))) != 0)) {
    value = -(value & ((1 << bits) - 1));
  }

  buffer[index++] = '$';

  if (value < 0) {
    buffer[index++] = '-';
    value = (labs(value) + 2) & ((1 << (bits - 2)) - 1);
  }

  if (bits > 16) {
    snprintf(&buffer[index], sizeof(buffer), hasLeadingZeroes ? "%06X" : "%X",
             (uint32_t)(value & 0xFFFFFF));
  } else {
    if (bits > 8) {
      snprintf(&buffer[index], sizeof(buffer), hasLeadingZeroes ? "%04X" : "%X",
               (uint16_t)(value & 0xFFFF));
    } else {
      snprintf(&buffer[index], sizeof(buffer), hasLeadingZeroes ? "%02X" : "%X",
               (uint8_t)(value & 0xFF));
    }
  }

  return [NSString stringWithUTF8String:buffer];
}

@end

BOOL IsBitsSizeValid(size_t size) {
  return (size == 8) || (size == 16) || (size == 24);
}
