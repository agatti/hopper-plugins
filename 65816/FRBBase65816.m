/*
 Copyright (c) 2014-2017, Alessandro Gatti - frob.it
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

#import "FRBBase65816.h"
#import "FRB65xxHelpers.h"
#import "FRBBase.h"
#import "FRBDefinition.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

typedef struct {
  uintptr_t opcode : 7;
  uintptr_t haltsExecution : 1;
  uintptr_t mode : 5;
} InstructionUserData;

@interface ItFrobHopper65816Base65816 ()

- (void)updateShifts:(DisasmStruct *_Nonnull)disasm
           forOpcode:(const struct FRBOpcode *_Nonnull)opcode;

- (void)setMemoryFlags:(DisasmStruct *_Nonnull)disasm
        forInstruction:(const struct FRBInstruction *_Nonnull)instruction;

- (void)handleNonBranchOpcode:(const struct FRBOpcode *_Nonnull)opcode
                    forDisasm:(DisasmStruct *_Nonnull)disasm
                    usingFile:(NSObject<HPDisassembledFile> *_Nonnull)file;

- (void)handleBranchOpcode:(const struct FRBOpcode *_Nonnull)opcode
                 forDisasm:(DisasmStruct *_Nonnull)disasm
                 usingFile:(NSObject<HPDisassembledFile> *_Nonnull)file;

- (NSString *_Nonnull)formatHexadecimalValue:(int64_t)value
                                    isSigned:(BOOL)isSigned
                            hasLeadingZeroes:(BOOL)hasLeadingZeroes
                                     andSize:(uint32_t)size;

- (NSObject<HPASMLine> *_Nonnull)
formatHexadecimal:(const DisasmOperand *_Nonnull)operand
           inLine:(NSObject<HPASMLine> *_Nonnull)line
         isSigned:(BOOL)isSigned
 hasLeadingZeroes:(BOOL)hasLeadingZeroes;

- (NSObject<HPASMLine> *_Nonnull)formatAddress:(Address)address
                                        inLine:
                                            (NSObject<HPASMLine> *_Nonnull)line;
@end

@implementation ItFrobHopper65816Base65816

+ (NSString *_Nonnull)family {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (NSString *_Nonnull)model {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (BOOL)exported {
  return NO;
}

+ (int)addressSpaceWidth {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (int)processStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  InstructionUserData userData;

  InitialiseDisasmStruct(structure);
  structure->instruction.pcRegisterValue = structure->virtualAddr;
  uint8_t opcodeByte = [file readUInt8AtVirtualAddress:structure->virtualAddr];
  const struct FRBOpcode *opcode = [self opcodeForByte:opcodeByte];
  userData.opcode = opcode->type;
  userData.haltsExecution =
      (userData.opcode == OpcodeSTP || userData.opcode == OpcodeBRK) ? 1 : 0;
  userData.mode = opcode->addressMode;

  if (opcode->addressMode == ModeUnknown) {
    return DISASM_UNKNOWN_OPCODE;
  }

  struct FRBInstruction instruction = FRBInstructions[opcode->type];
  structure->instruction.branchType = instruction.branchType;
  strcpy(structure->instruction.mnemonic, instruction.name);
  strcpy(structure->instruction.unconditionalMnemonic, instruction.name);

  if (instruction.category == CategoryStatusFlagChanges) {
    switch (opcode->type) {
    case OpcodeCLC:
      structure->instruction.eflags.CF_flag = DISASM_EFLAGS_RESET;
      break;

    case OpcodeCLD:
      structure->instruction.eflags.DF_flag = DISASM_EFLAGS_RESET;
      break;

    case OpcodeCLI:
      structure->instruction.eflags.IF_flag = DISASM_EFLAGS_RESET;
      break;

    case OpcodeCLV:
      structure->instruction.eflags.OF_flag = DISASM_EFLAGS_RESET;
      break;

    case OpcodeSEC:
      structure->instruction.eflags.CF_flag = DISASM_EFLAGS_SET;
      break;

    case OpcodeSED:
      structure->instruction.eflags.DF_flag = DISASM_EFLAGS_SET;
      break;

    case OpcodeSEI:
      structure->instruction.eflags.IF_flag = DISASM_EFLAGS_SET;
      break;

    default:
      break;
    }
  } else {
    if (opcode->type == OpcodeCOP) {
      structure->instruction.eflags.DF_flag = DISASM_EFLAGS_RESET;
    }
  }

  structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      opcode->readRegisters;
  structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      opcode->writtenRegisters;
  structure->instruction.length = (uint8_t)FRBOpcodeLength[opcode->addressMode];

  if (opcode->addressMode == ModeImmediate) {
    FRBCPUOperationMode mode = (FRBCPUOperationMode)
        [file cpuModeAtVirtualAddress:structure->virtualAddr];
    NSUInteger registersMask = opcode->readRegisters | opcode->writtenRegisters;

    if (registersMask & (RegisterIndexX | RegisterIndexY)) {
      if ((mode == FRBCPUModeAccumulator8Index16) ||
          (mode == FRBCPUModeAccumulator16Index16)) {
        structure->instruction.length += 1;
      }
    } else {
      if ((mode == FRBCPUModeAccumulator16Index8) ||
          (mode == FRBCPUModeAccumulator16Index16)) {
        structure->instruction.length += 1;
      }
    }
  }

  if (instruction.branchType == DISASM_BRANCH_NONE) {
    [self handleNonBranchOpcode:opcode forDisasm:structure usingFile:file];
  } else {
    [self handleBranchOpcode:opcode forDisasm:structure usingFile:file];
  }

  [self updateShifts:structure forOpcode:opcode];

  structure->instruction.userData = *((uintptr_t *)&userData);

  return structure->instruction.length;
}

- (BOOL)haltsExecutionFlow:(const DisasmStruct *_Nonnull)structure {
  return ((InstructionUserData *)&structure->instruction.userData)
             ->haltsExecution != 0;
}

- (NSObject<HPASMLine> *_Nonnull)
buildMnemonicString:(DisasmStruct *_Nonnull)disasm
             inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
       withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  NSObject<HPASMLine> *line = [services blankASMLine];
  [line appendMnemonic:@(disasm->instruction.mnemonic)];
  return line;
}

- (NSObject<HPASMLine> *_Nullable)
buildOperandString:(DisasmStruct *_Nonnull)disasm
   forOperandIndex:(NSUInteger)operandIndex
            inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               raw:(BOOL)raw
      withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  if ((operandIndex >= DISASM_MAX_OPERANDS) ||
      (disasm->operand[operandIndex].type == DISASM_OPERAND_NO_OPERAND)) {
    return nil;
  }

  NSObject<HPASMLine> *line = [services blankASMLine];
  ArgFormat format = [file formatForArgument:operandIndex
                            atVirtualAddress:disasm->virtualAddr];

  if (disasm->operand[operandIndex].type & DISASM_OPERAND_CONSTANT_TYPE) {
    uint64_t value;

    if (disasm->operand[operandIndex].isBranchDestination) {
      value = disasm->instruction.addressValue;
      format = (format == Format_Default) ? Format_Address : format;
    } else {
      value = (uint64_t)disasm->operand[operandIndex].immediateValue;
      [line appendRawString:@"#"];
    }

    switch (RAW_FORMAT(format)) {
    case Format_Address:
      if (ResolveNameForAddress(file, disasm->instruction.addressValue)) {
        [line append:[file formatNumber:value
                                     at:disasm->virtualAddr
                            usingFormat:format
                             andBitSize:disasm->operand[operandIndex].size]];
      } else {
        [line append:[self formatAddress:value inLine:[services blankASMLine]]];
      }
      break;

    case Format_Hexadecimal:
    case Format_Default:
      [line append:[self formatHexadecimal:&disasm->operand[operandIndex]
                                    inLine:[services blankASMLine]
                                  isSigned:FORMAT_IS_SIGNED(format)
                          hasLeadingZeroes:FORMAT_HAS_LEADING_ZEROES(format)]];
      break;

    default:
      [line append:[file formatNumber:value
                                   at:disasm->virtualAddr
                          usingFormat:format
                           andBitSize:disasm->operand[operandIndex].size]];
    }

    [line setIsOperand:operandIndex startingAtIndex:0];

    return line;
  }

  if (disasm->operand[operandIndex].type & DISASM_OPERAND_MEMORY_TYPE) {
    uint64_t value;

    if (disasm->operand[operandIndex].isBranchDestination) {
      value = disasm->instruction.addressValue;
      format = (format == Format_Default) ? Format_Address : format;
    } else {
      value = (uint64_t)disasm->operand[operandIndex].immediateValue;
    }

    switch (RAW_FORMAT(format)) {
    case Format_Address:
      if (ResolveNameForAddress(file, disasm->instruction.addressValue)) {
        [line append:[file formatNumber:value
                                     at:disasm->virtualAddr
                            usingFormat:format
                             andBitSize:disasm->operand[operandIndex].size]];
      } else {
        [line append:[self formatAddress:value inLine:[services blankASMLine]]];
      }
      break;

    case Format_Hexadecimal:
    case Format_Default:
      [line append:[self formatHexadecimal:&disasm->operand[operandIndex]
                                    inLine:[services blankASMLine]
                                  isSigned:FORMAT_IS_SIGNED(format)
                          hasLeadingZeroes:FORMAT_HAS_LEADING_ZEROES(format)]];
      break;

    default:
      [line append:[file formatNumber:value
                                   at:disasm->virtualAddr
                          usingFormat:format
                           andBitSize:disasm->operand[operandIndex].size]];
    }

    [line setIsOperand:operandIndex startingAtIndex:0];

    return line;
  }

  NSLog(@"Unhandled operand type 0x%llu at virtual address 0x%llu",
        disasm->operand[operandIndex].type, disasm->virtualAddr);
  return nil;
}

- (NSObject<HPASMLine> *_Nullable)
buildCompleteOperandString:(DisasmStruct *_Nonnull)disasm
                    inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                       raw:(BOOL)raw
              withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  NSObject<HPASMLine> *line = [services blankASMLine];

  switch ((Mode)((InstructionUserData *)&disasm->instruction.userData)->mode) {

  case ModeAccumulator:
  case ModeImplied:
  case ModeStack:
    return [services blankASMLine];

  case ModeAbsolute:
  case ModeAbsoluteLong:
  case ModeDirect:
  case ModeProgramCounterRelative:
  case ModeProgramCounterRelativeLong:
  case ModeImmediate: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line append:first];

    return line;
  }

  case ModeAbsoluteIndexedX:
  case ModeAbsoluteLongIndexed:
  case ModeDirectIndexedX: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line append:first];
    [line appendRawString:@",X"];

    return line;
  }

  case ModeAbsoluteIndexedY:
  case ModeDirectIndexedY: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line append:first];
    [line appendRawString:@",Y"];

    return line;
  }

  case ModeAbsoluteIndirect:
  case ModeDirectIndirect: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line appendRawString:@"("];
    [line append:first];
    [line appendRawString:@")"];

    return line;
  }

  case ModeDirectIndexedIndirect:
  case ModeAbsoluteIndexedIndirect: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line appendRawString:@"("];
    [line append:first];
    [line appendRawString:@",X)"];

    return line;
  }

  case ModeDirectIndirectIndexedY: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line appendRawString:@"("];
    [line append:first];
    [line appendRawString:@",Y)"];

    return line;
  }

  case ModeDirectIndirectLong: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line appendRawString:@"["];
    [line append:first];
    [line appendRawString:@"]"];

    return line;
  }

  case ModeDirectIndirectLongIndexed: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line appendRawString:@"["];
    [line append:first];
    [line appendRawString:@"],Y"];

    return line;
  }

  case ModeStackRelative: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line append:first];
    [line appendRawString:@",S"];

    return line;
  }

  case ModeStackRelativeIndirectIndexed: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    if (!first) {
      return nil;
    }

    [line appendRawString:@"("];
    [line append:first];
    [line appendRawString:@",S),Y"];

    return line;
  }

  case ModeBlockMove: {
    NSObject<HPASMLine> *first = [self buildOperandString:disasm
                                          forOperandIndex:0
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];
    NSObject<HPASMLine> *second = [self buildOperandString:disasm
                                           forOperandIndex:1
                                                    inFile:file
                                                       raw:raw
                                              withServices:services];

    if (!first || !second) {
      return nil;
    }

    [line append:first];
    [line appendRawString:@","];
    [line append:second];

    return line;
  }

  default:
    break;
  }

  return nil;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"

- (const struct FRBOpcode *)opcodeForByte:(uint8_t)byte {
  @throw [NSException
      exceptionWithName:FRBHopperExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

#pragma clang diagnostic pop

#pragma mark - Private methods

- (void)updateShifts:(DisasmStruct *_Nonnull)disasm
           forOpcode:(const struct FRBOpcode *_Nonnull)opcode {

  switch (opcode->type) {
  case OpcodeASL:
    disasm->operand[0].shiftMode = DISASM_SHIFT_LSL;
    disasm->operand[0].shiftAmount = 1;
    break;

  case OpcodeLSR:
    disasm->operand[0].shiftMode = DISASM_SHIFT_LSR;
    disasm->operand[0].shiftAmount = 1;
    break;

  case OpcodeROL:
    disasm->operand[0].shiftMode = DISASM_SHIFT_ROR;
    disasm->operand[0].shiftAmount = -1;
    break;

  case OpcodeROR:
    disasm->operand[0].shiftMode = DISASM_SHIFT_ROR;
    disasm->operand[0].shiftAmount = 1;
    break;

  default:
    break;
  }
}

- (void)setMemoryFlags:(DisasmStruct *_Nonnull)disasm
        forInstruction:(const struct FRBInstruction *_Nonnull)instruction {

  switch (instruction->category) {
  case CategoryLoad:
  case CategoryComparison:
  case CategoryLogical:
  case CategoryArithmetic:
    disasm->operand[0].accessMode = DISASM_ACCESS_READ;
    break;

  case CategoryStore:
  case CategoryIncrementDecrement:
  case CategoryShifts:
    disasm->operand[0].accessMode = DISASM_ACCESS_WRITE;
    break;

  case CategoryBlockTransfer:
  case CategoryJumps:
  case CategoryStack:
  case CategorySystem:
  case CategoryBranches:
  case CategoryRegisterTransfers:
  case CategoryStatusFlagChanges:
  case CategoryUnknown:
    break;
  }
}

- (void)handleNonBranchOpcode:(const struct FRBOpcode *_Nonnull)opcode
                    forDisasm:(DisasmStruct *_Nonnull)disasm
                    usingFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  switch (opcode->addressMode) {
  case ModeAbsolute:
  case ModeAbsoluteIndirect:
    SetAddressOperand(file, disasm, 0, 16, 24, 1, 0);
    break;

  case ModeProgramCounterRelativeLong: {
    Address address = (Address)SignedValue(
        @([file readUInt16AtVirtualAddress:disasm->virtualAddr + 1]), 16);
    address += disasm->instruction.pcRegisterValue + disasm->instruction.length;

    disasm->operand[0].memory.baseRegistersMask = 0;
    disasm->operand[0].memory.indexRegistersMask = 0;
    disasm->operand[0].memory.scale = 1;
    disasm->operand[0].memory.displacement = 0;
    disasm->operand[0].type =
        DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
    disasm->operand[0].size = 24;
    disasm->operand[0].immediateValue = address;
    SetDefaultFormatForArgument(file, disasm->virtualAddr, 0, Format_Address);
    break;
  }

  case ModeAbsoluteLong:
  case ModeAbsoluteLongIndexed:
    SetAddressOperand(file, disasm, 0, 24, 24, 1, 0);
    break;

  case ModeAbsoluteIndexedX:
    SetAddressOperand(file, disasm, 0, 16, 24, 1, RegisterX);
    break;

  case ModeAbsoluteIndexedY:
    SetAddressOperand(file, disasm, 0, 16, 24, 1, RegisterY);
    break;

  case ModeImmediate: {
    NSUInteger registersMask = opcode->readRegisters | opcode->writtenRegisters;
    FRBCPUOperationMode mode =
        (FRBCPUOperationMode)[file cpuModeAtVirtualAddress:disasm->virtualAddr];

    if (registersMask & (RegisterIndexX | RegisterIndexY)) {
      if ((mode == FRBCPUModeAccumulator8Index16) ||
          (mode == FRBCPUModeAccumulator16Index16)) {
        SetConstantOperand(file, disasm, 0, 16, 1);
      } else {
        SetConstantOperand(file, disasm, 0, 8, 1);
      }
    } else {
      if ((mode == FRBCPUModeAccumulator16Index8) ||
          (mode == FRBCPUModeAccumulator16Index16)) {
        SetConstantOperand(file, disasm, 0, 16, 1);
      } else {
        SetConstantOperand(file, disasm, 0, 8, 1);
      }
    }

    break;
  }

  case ModeDirectIndexedX:
  case ModeDirectIndexedIndirect:
    SetAddressOperand(file, disasm, 0, 8, 24, 1, RegisterX);
    break;

  case ModeDirect:
  case ModeDirectIndirect:
  case ModeStackRelative:
  case ModeStackRelativeIndirectIndexed:
  case ModeDirectIndirectLong:
  case ModeDirectIndirectLongIndexed:
    SetAddressOperand(file, disasm, 0, 8, 24, 1, 0);
    break;

  case ModeDirectIndexedY:
  case ModeDirectIndirectIndexedY:
    SetAddressOperand(file, disasm, 0, 8, 24, 1, RegisterY);
    break;

  case ModeBlockMove:
    SetConstantOperand(file, disasm, 0, 8, 1);
    SetConstantOperand(file, disasm, 1, 8, 1 + sizeof(uint8_t));
    break;

  case ModeAccumulator:
  case ModeImplied:
  case ModeStack:
    break;

  default: {
    NSString *exceptionFormat =
        @"Internal error: non-branch opcode with address mode %lu found";

    @throw [NSException
        exceptionWithName:FRBHopperExceptionName
                   reason:[NSString stringWithFormat:exceptionFormat,
                                                     (unsigned long)opcode->
                                                     addressMode]
                 userInfo:nil];
  }
  }

  disasm->operand[0].accessMode = DISASM_ACCESS_NONE;
  const struct FRBInstruction instruction = FRBInstructions[opcode->type];

  switch (opcode->addressMode) {
  case ModeImmediate:
  case ModeProgramCounterRelative:
  case ModeAccumulator:
  case ModeImplied:
  case ModeStack:
    break;

  default: {
    [self setMemoryFlags:disasm forInstruction:&instruction];
    break;
  }
  }
}

- (void)handleBranchOpcode:(const struct FRBOpcode *_Nonnull)opcode
                 forDisasm:(DisasmStruct *_Nonnull)disasm
                 usingFile:(NSObject<HPDisassembledFile> *_Nonnull)file {
  switch (opcode->addressMode) {

  case ModeAbsoluteLong:
    SetConstantOperand(file, disasm, 0, 24, 1);
    disasm->instruction.addressValue =
        (Address)disasm->operand[0].immediateValue;
    disasm->operand[0].isBranchDestination = YES;
    break;

  case ModeDirectIndirect:
    disasm->instruction.addressValue =
        SetAddressOperand(file, disasm, 0, 8, 24, 1, 0);
    disasm->operand[0].isBranchDestination = YES;
    break;

  case ModeAbsolute:
  case ModeAbsoluteIndirect:
  case ModeAbsoluteIndexedIndirect:
    SetConstantOperand(file, disasm, 0, 16, 1);
    disasm->instruction.addressValue =
        (Address)disasm->operand[0].immediateValue;
    disasm->operand[0].isBranchDestination = YES;
    break;

  case ModeProgramCounterRelative:
    disasm->instruction.addressValue =
        SetRelativeAddressOperand(file, disasm, 0, 8, 24, 1);
    disasm->operand[0].isBranchDestination = YES;
    break;

  case ModeProgramCounterRelativeLong: {
    Address address =
        SignedValue(
            @([file readUInt16AtVirtualAddress:disasm->virtualAddr + 1]), 16) +
        disasm->instruction.pcRegisterValue + disasm->instruction.length;

    disasm->operand[0].memory.baseRegistersMask = 0;
    disasm->operand[0].memory.indexRegistersMask = 0;
    disasm->operand[0].memory.scale = 1;
    disasm->operand[0].memory.displacement = 0;
    disasm->operand[0].type =
        DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
    disasm->operand[0].size = 24;
    disasm->operand[0].immediateValue = address;
    disasm->operand[0].isBranchDestination = YES;
    break;
  }

  case ModeImplied:
  case ModeStack:
    break;

  default: {
    NSString *exceptionFormat =
        @"Internal error: branch opcode with address mode %lu found";
    @throw [NSException
        exceptionWithName:FRBHopperExceptionName
                   reason:[NSString stringWithFormat:exceptionFormat,
                                                     (unsigned long)opcode->
                                                     addressMode]
                 userInfo:nil];
  }
  }
}

#pragma mark - Custom hexadecimal formatting methods

static NSString *_Nonnull const kValueTooLarge = @"Invalid bits count (%d)";

- (NSString *_Nonnull)formatHexadecimalValue:(int64_t)value
                                    isSigned:(BOOL)isSigned
                            hasLeadingZeroes:(BOOL)hasLeadingZeroes
                                     andSize:(uint32_t)size {

  NSString *formattedValue =
      FormatHexadecimalValue(value, isSigned, hasLeadingZeroes, size);

  if (!formattedValue) {
    @throw [NSException
        exceptionWithName:FRBHopperExceptionName
                   reason:[NSString stringWithFormat:kValueTooLarge, size]
                 userInfo:nil];
  }

  return formattedValue;
}

- (NSObject<HPASMLine> *_Nonnull)
formatHexadecimal:(const DisasmOperand *_Nonnull)operand
           inLine:(NSObject<HPASMLine> *_Nonnull)line
         isSigned:(BOOL)isSigned
 hasLeadingZeroes:(BOOL)hasLeadingZeroes {

  [line
      appendFormattedNumber:[self formatHexadecimalValue:operand->immediateValue
                                                isSigned:isSigned
                                        hasLeadingZeroes:hasLeadingZeroes
                                                 andSize:operand->size]
                  withValue:@(operand->immediateValue)];
  return line;
}

- (NSObject<HPASMLine> *_Nonnull)formatAddress:(Address)address
                                        inLine:(NSObject<HPASMLine> *_Nonnull)
                                                   line {

  [line appendFormattedAddress:[self formatHexadecimalValue:address
                                                   isSigned:NO
                                           hasLeadingZeroes:NO
                                                    andSize:24]
                     withValue:address];
  return line;
}

@end

#pragma clang diagnostic pop