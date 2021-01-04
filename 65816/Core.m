/*
 Copyright (c) 2014-2021, Alessandro Gatti - frob.it
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

#import "Core.h"
#import "Definition.h"
#import "HopperCommon.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedClassInspection"

@interface ItFrobHopper65816Base65816 ()

- (void)updateShifts:(DisasmStruct *_Nonnull)disasm
           forOpcode:(const Opcode *_Nonnull)opcode;

- (void)setMemoryFlags:(DisasmStruct *_Nonnull)disasm
        forInstruction:(const Instruction *_Nonnull)instruction;

- (void)handleNonBranchOpcode:(const Opcode *_Nonnull)opcode
                    forDisasm:(DisasmStruct *_Nonnull)disasm
                    usingFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                  andMetadata:(FRBInstructionUserData *_Nonnull)metadata;

- (void)handleBranchOpcode:(const Opcode *_Nonnull)opcode
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
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (NSString *_Nonnull)model {
  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (BOOL)exported {
  return NO;
}

+ (int)addressSpaceWidth {
  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (NSData *_Nonnull)nopOpcodeSignature {
  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (int)processStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  FRBInstructionUserData metadata;

  [HopperUtilities initialiseStructure:structure];
  structure->instruction.pcRegisterValue = structure->virtualAddr;
  const Opcode *opcode = [self opcodeForFile:file
                                   atAddress:structure->virtualAddr
                             andFillMetadata:&metadata];
  metadata.opcode = opcode->type;
  metadata.haltsExecution =
      (metadata.opcode == OpcodeSTP || metadata.opcode == OpcodeBRK) ? 1 : 0;
  metadata.mode = opcode->addressMode;
  metadata.accumulatorType = opcode->accumulatorType;

  if (opcode->addressMode == ModeUnknown) {
    return DISASM_UNKNOWN_OPCODE;
  }

  Instruction instruction = kMnemonics[opcode->type];
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

  if ((opcode->type == OpcodeREP) || (opcode->type == OpcodeSEP)) {
    structure->instruction.specialFlags.changeNextInstrMode = YES;
  }

  structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      (uint32_t) opcode->readRegisters;
  structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      (uint32_t) opcode->writtenRegisters;
  structure->instruction.length = (uint8_t)kOpcodeLength[opcode->addressMode];

  if ((opcode->addressMode == ModeImmediate) && (opcode->type != OpcodeREP) &&
      (opcode->type != OpcodeSEP)) {
    CPUOperationMode mode =
        (CPUOperationMode)[file cpuModeAtVirtualAddress:structure->virtualAddr];
    NSUInteger registersMask = opcode->readRegisters | opcode->writtenRegisters;

    if (registersMask & (RegisterIndexX | RegisterIndexY)) {
      if ((mode == CPUAccumulator8Index16) ||
          (mode == CPUAccumulator16Index16)) {
        structure->instruction.length += 1;
      }
    } else {
      if ((mode == CPUAccumulator16Index8) ||
          (mode == CPUAccumulator16Index16)) {
        structure->instruction.length += 1;
      }
    }
  }

  if (metadata.wideOpcode) {
    structure->instruction.length += 1;
  }

  if (instruction.branchType == DISASM_BRANCH_NONE) {
    [self handleNonBranchOpcode:opcode
                      forDisasm:structure
                      usingFile:file
                    andMetadata:&metadata];
  } else {
    [self handleBranchOpcode:opcode forDisasm:structure usingFile:file];
  }

  [self updateShifts:structure forOpcode:opcode];

  structure->instruction.userData = *((uintptr_t *)&metadata);

  return structure->instruction.length;
}

- (BOOL)haltsExecutionFlow:(const DisasmStruct *_Nonnull)structure {
  return ((FRBInstructionUserData *)&structure->instruction.userData)
             ->haltsExecution != 0;
}

- (NSObject<HPASMLine> *_Nonnull)
    buildMnemonicString:(DisasmStruct *_Nonnull)disasm
                 inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
           withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  NSObject<HPASMLine> *line = [services blankASMLine];
  [line appendMnemonic:@(disasm->instruction.mnemonic)
                isJump:disasm->instruction.branchType != DISASM_BRANCH_NONE];
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
      if ([HopperUtilities
              resolveNameForAddress:disasm->instruction.addressValue
                             inFile:file]) {
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
      if ([HopperUtilities
              resolveNameForAddress:disasm->instruction.addressValue
                             inFile:file]) {
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
  FRBInstructionUserData *metadata =
      (FRBInstructionUserData *)&disasm->instruction.userData;

  switch ((AccumulatorType)metadata->accumulatorType) {
  case AccumulatorA:
    [line
        appendRawString:(Mode)metadata->mode == ModeAccumulator ? @"A" : @"A,"];
    break;

  case AccumulatorB:
    [line
        appendRawString:(Mode)metadata->mode == ModeAccumulator ? @"B" : @"B,"];
    break;

  case AccumulatorDefault:
  default:
    break;
  }

  switch ((Mode)metadata->mode) {

  case ModeAccumulator:
  case ModeImplied:
  case ModeStack:
    return line;

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

  case ModeDirectMemoryAccess:
  case ModeDirectBitAddressing:
  case ModeAbsoluteBitAddressing:
  case ModeAbsoluteMemoryAddress:
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

  case ModeAbsoluteMemoryAddressIndexed:
  case ModeDirectMemoryAccessIndexed: {
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
    [line appendRawString:@",X"];

    return line;
  }

  case ModeDirectBitAddressingAbsolute:
  case ModeDirectBitAddressingProgramCounterRelative: {
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
    NSObject<HPASMLine> *third = [self buildOperandString:disasm
                                          forOperandIndex:2
                                                   inFile:file
                                                      raw:raw
                                             withServices:services];

    if (!first || !second || !third) {
      return nil;
    }

    [line append:first];
    [line appendRawString:@","];
    [line append:second];
    [line appendRawString:@","];
    [line append:third];

    return line;
  }

  default:
    break;
  }

  return nil;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"

- (const Opcode *_Nonnull)
      opcodeForFile:(NSObject<HPDisassembledFile> *_Nonnull)file
          atAddress:(Address)address
    andFillMetadata:(FRBInstructionUserData *_Nonnull)metadata {

  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

#pragma clang diagnostic pop

#pragma mark - Private methods

- (void)updateShifts:(DisasmStruct *_Nonnull)disasm
           forOpcode:(const Opcode *_Nonnull)opcode {

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
  case OpcodeRLA:
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
        forInstruction:(const Instruction *_Nonnull)instruction {

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

- (void)handleNonBranchOpcode:(const Opcode *_Nonnull)opcode
                    forDisasm:(DisasmStruct *_Nonnull)disasm
                    usingFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                  andMetadata:(FRBInstructionUserData *_Nonnull)metadata {

  uint32_t baseOffset = metadata->wideOpcode ? 1 : 0;

  switch (opcode->addressMode) {
  case ModeAbsolute:
  case ModeAbsoluteIndirect:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:disasm
                                   withSize:16
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:0];
    break;

  case ModeProgramCounterRelativeLong: {
    Address address = (Address)SignedValue(
        @([file
            readUInt16AtVirtualAddress:disasm->virtualAddr + baseOffset + 1]),
        16);
    address += disasm->instruction.pcRegisterValue + disasm->instruction.length;

    disasm->operand[0].memory.baseRegistersMask = 0;
    disasm->operand[0].memory.indexRegistersMask = 0;
    disasm->operand[0].memory.scale = 1;
    disasm->operand[0].memory.displacement = 0;
    disasm->operand[0].type =
        DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
    disasm->operand[0].size = 24;
    disasm->operand[0].immediateValue = address;
    disasm->operand[0].userData[0] = (uint8_t)Format_Address;
    break;
  }

  case ModeAbsoluteLong:
  case ModeAbsoluteLongIndexed:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:disasm
                                   withSize:24
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:0];
    break;

  case ModeAbsoluteIndexedX:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:disasm
                                   withSize:16
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:RegisterX];
    break;

  case ModeAbsoluteIndexedY:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:disasm
                                   withSize:16
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:RegisterY];
    break;

  case ModeImmediate: {
    NSUInteger registersMask = opcode->readRegisters | opcode->writtenRegisters;
    CPUOperationMode mode =
        (CPUOperationMode)[file cpuModeAtVirtualAddress:disasm->virtualAddr];
    if ((opcode->type == OpcodeSEP) || (opcode->type == OpcodeREP)) {
      mode = CPUAccumulator8Index8;
    }

    if (registersMask & (RegisterIndexX | RegisterIndexY)) {
      if ((mode == CPUAccumulator8Index16) ||
          (mode == CPUAccumulator16Index16)) {
        [Hopper65xxUtilities fillConstantOperand:0
                                          inFile:file
                                       forStruct:disasm
                                        withSize:16
                                       andOffset:baseOffset + 1];
      } else {
        [Hopper65xxUtilities fillConstantOperand:0
                                          inFile:file
                                       forStruct:disasm
                                        withSize:8
                                       andOffset:baseOffset + 1];
      }
    } else {
      if ((mode == CPUAccumulator16Index8) ||
          (mode == CPUAccumulator16Index16)) {
        [Hopper65xxUtilities fillConstantOperand:0
                                          inFile:file
                                       forStruct:disasm
                                        withSize:16
                                       andOffset:baseOffset + 1];
      } else {
        [Hopper65xxUtilities fillConstantOperand:0
                                          inFile:file
                                       forStruct:disasm
                                        withSize:8
                                       andOffset:baseOffset + 1];
      }
    }

    break;
  }

  case ModeDirectIndexedX:
  case ModeDirectIndexedIndirect:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:disasm
                                   withSize:8
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:RegisterX];
    break;

  case ModeDirect:
  case ModeDirectIndirect:
  case ModeStackRelative:
  case ModeStackRelativeIndirectIndexed:
  case ModeDirectIndirectLong:
  case ModeDirectIndirectLongIndexed:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:disasm
                                   withSize:8
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:0];
    break;

  case ModeDirectIndexedY:
  case ModeDirectIndirectIndexedY:
    [Hopper65xxUtilities fillAddressOperand:0
                                     inFile:file
                                  forStruct:disasm
                                   withSize:8
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:RegisterY];
    break;

  case ModeBlockMove:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:8
                                   andOffset:baseOffset + 1];
    [Hopper65xxUtilities fillConstantOperand:1
                                      inFile:file
                                   forStruct:disasm
                                    withSize:8
                                   andOffset:baseOffset + 2];
    break;

  case ModeDirectMemoryAccess:
  case ModeDirectBitAddressing:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:8
                                   andOffset:baseOffset + 2];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:disasm
                                   withSize:8
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:0];
    break;

  case ModeDirectMemoryAccessIndexed:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:8
                                   andOffset:baseOffset + 2];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:disasm
                                   withSize:8
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:RegisterX];
    break;

  case ModeAbsoluteBitAddressing:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:8
                                   andOffset:baseOffset + 3];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:disasm
                                   withSize:16
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:0];
    break;

  case ModeAbsoluteMemoryAddress:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:8
                                   andOffset:baseOffset + 3];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:disasm
                                   withSize:16
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:0];
    break;

  case ModeAbsoluteMemoryAddressIndexed:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:8
                                   andOffset:baseOffset + 3];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:disasm
                                   withSize:16
                           andEffectiveSize:24
                                 withOffset:baseOffset + 1
                    usingIndexRegistersMask:RegisterX];
    break;

  case ModeAccumulator:
  case ModeImplied:
  case ModeStack:
    break;

  default: {
    NSString *exceptionFormat =
        @"Internal error: non-branch opcode with address mode %lu found";

    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
                   reason:[NSString stringWithFormat:exceptionFormat,
                                                     (unsigned long)opcode->
                                                     addressMode]
                 userInfo:nil];
  }
  }

  disasm->operand[0].accessMode = DISASM_ACCESS_NONE;
  const Instruction instruction = kMnemonics[opcode->type];

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

- (void)handleBranchOpcode:(const Opcode *_Nonnull)opcode
                 forDisasm:(DisasmStruct *_Nonnull)disasm
                 usingFile:(NSObject<HPDisassembledFile> *_Nonnull)file {
  switch (opcode->addressMode) {

  case ModeAbsoluteLong:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:24
                                   andOffset:1];
    disasm->instruction.addressValue =
        (Address)disasm->operand[0].immediateValue;
    disasm->operand[0].isBranchDestination = YES;
    break;

  case ModeDirectIndirect:
    disasm->instruction.addressValue =
        [Hopper65xxUtilities fillAddressOperand:0
                                         inFile:file
                                      forStruct:disasm
                                       withSize:8
                               andEffectiveSize:24
                                     withOffset:1
                        usingIndexRegistersMask:0];
    disasm->operand[0].isBranchDestination = YES;
    break;

  case ModeAbsolute:
  case ModeAbsoluteIndirect:
  case ModeAbsoluteIndexedIndirect:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:16
                                   andOffset:1];
    disasm->instruction.addressValue =
        (Address)disasm->operand[0].immediateValue;
    disasm->operand[0].isBranchDestination = YES;
    break;

  case ModeProgramCounterRelative:
    disasm->instruction.addressValue =
        [Hopper65xxUtilities fillRelativeAddressOperand:0
                                                 inFile:file
                                              forStruct:disasm
                                               withSize:8
                                       andEffectiveSize:24
                                             withOffset:1];
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
    disasm->instruction.addressValue = address;
    break;
  }

  case ModeDirectBitAddressingProgramCounterRelative:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:8
                                   andOffset:2];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:disasm
                                   withSize:8
                           andEffectiveSize:24
                                 withOffset:1
                    usingIndexRegistersMask:0];
    disasm->instruction.addressValue =
        [Hopper65xxUtilities fillRelativeAddressOperand:2
                                                 inFile:file
                                              forStruct:disasm
                                               withSize:8
                                       andEffectiveSize:24
                                             withOffset:3];
    disasm->operand[2].isBranchDestination = YES;
    break;

  case ModeDirectBitAddressingAbsolute:
    [Hopper65xxUtilities fillConstantOperand:0
                                      inFile:file
                                   forStruct:disasm
                                    withSize:8
                                   andOffset:3];
    [Hopper65xxUtilities fillAddressOperand:1
                                     inFile:file
                                  forStruct:disasm
                                   withSize:16
                           andEffectiveSize:24
                                 withOffset:1
                    usingIndexRegistersMask:0];
    disasm->instruction.addressValue =
        [Hopper65xxUtilities fillRelativeAddressOperand:2
                                                 inFile:file
                                              forStruct:disasm
                                               withSize:8
                                       andEffectiveSize:24
                                             withOffset:4];
    disasm->operand[2].isBranchDestination = YES;
    break;

  case ModeImplied:
  case ModeStack:
    break;

  default: {
    NSString *exceptionFormat =
        @"Internal error: branch opcode with address mode %lu found";
    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
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

  NSString *_Nullable formattedValue =
      [Hopper65xxUtilities formatHexadecimalValue:value
                                    displaySigned:isSigned
                                showLeadingZeroes:hasLeadingZeroes
                                       usingWidth:size];

  if (!formattedValue) {
    @throw [NSException
        exceptionWithName:HopperPluginExceptionName
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
