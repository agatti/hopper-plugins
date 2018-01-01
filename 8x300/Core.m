/*
 Copyright (c) 2014-2018, Alessandro Gatti - frob.it
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
#import "InstructionFormatter.h"

#define OPCODE_FROM_WORD(word) ((Opcode)((word) >> 13))

typedef NS_OPTIONS(NSUInteger, RegisterFlags) {
  RegisterFlagAUX = 1 << RegisterAUX,
  RegisterFlagOVF = 1 << RegisterOVF
};

/**
 * CPU opcode names.
 */
static const char *kOpcodeNames[OpcodesCount] = {"MOVE", "ADD",  "AND",  "XOR",
                                                 "XEC",  "NZT",  "XMIT", "JMP",
                                                 "NOP",  "HALT", "XML",  "XMR"};

@interface ItFrobHopper8x300Base8x300 ()

/**
 * Handle potential ALU instructions.
 *
 * F1 encoding operand assignment:
 *
 * [0] = Source Register
 * [1] = Rotation
 * [2] = Destination Register
 *
 * F2 encoding operand assignment:
 *
 * [0] = Source Register
 * [1] = Length
 * [2] = Destination Register
 *
 * @param[in]  structure the structure to process.
 * @param[in]  file      the file to operate on.
 * @param[in]  opcode    the opcode to process.
 * @param[out] metadata  the structure that will contain the extracted metadata.
 *
 * @return YES if a valid ALU instruction was found, NO otherwise.
 */
- (BOOL)handleALUInstruction:(DisasmStruct *_Nonnull)structure
                  withOpcode:(uint16_t)opcode
                    metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handle potential NZT instructions.
 *
 * F3 encoding operand assignment:
 *
 * [0] = Literal
 * [1] = Source Register
 *
 * F4 encoding operand assignment:
 *
 * [0] = Literal
 * [1] = Source Register
 * [2] = Length
 *
 * @param[in]  structure the structure to process.
 * @param[in]  file      the file to operate on.
 * @param[in]  opcode    the opcode to process.
 * @param[out] metadata  the structure that will contain the extracted metadata.
 *
 * @return YES if a valid NZT instruction was found, NO otherwise.
 */
- (BOOL)handleNZTInstruction:(DisasmStruct *_Nonnull)structure
                  withOpcode:(uint16_t)opcode
                    metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handle potential XEC instructions.
 *
 * @param[in]  structure the structure to process.
 * @param[in]  file      the file to operate on.
 * @param[in]  opcode    the opcode to process.
 * @param[out] metadata  the structure that will contain the extracted metadata.
 *
 * @return YES if a valid XEC instruction was found, NO otherwise.
 */
- (BOOL)handleXECInstruction:(DisasmStruct *_Nonnull)structure
                  withOpcode:(uint16_t)opcode
                    metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handle potential XMIT instructions.
 *
 * F3 encoding operand assignment:
 *
 * [0] = Literal
 * [1] = Destination
 *
 * F4 encoding operand assignment:
 *
 * [0] = Literal
 * [1] = Destination
 * [2] = Length
 *
 * @param[in]  structure the structure to process.
 * @param[in]  file      the file to operate on.
 * @param[in]  opcode    the opcode to process.
 * @param[out] metadata  the structure that will contain the extracted metadata.
 *
 * @return YES if a valid XMIT instruction was found, NO otherwise.
 */
- (BOOL)handleXMITInstruction:(DisasmStruct *_Nonnull)structure
                   withOpcode:(uint16_t)opcode
                     metadata:(InstructionMetadata *_Nonnull)metadata;

/**
 * Handle potential JMP instructions.
 *
 * @param[in]  structure the structure to process.
 * @param[in]  file      the file to operate on.
 * @param[in]  opcode    the opcode to process.
 * @param[out] metadata  the structure that will contain the extracted metadata.
 *
 * @return YES if a valid JMP instruction was found, NO otherwise.
 */
- (BOOL)handleJMPInstruction:(DisasmStruct *_Nonnull)structure
                  withOpcode:(uint16_t)opcode
                    metadata:(InstructionMetadata *_Nonnull)metadata;

@end

@implementation ItFrobHopper8x300Base8x300

+ (NSString *_Nonnull)family {
  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (NSString *_Nonnull)model {
  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

+ (BOOL)exported {
  return NO;
}

+ (int)addressSpaceWidth {
  @throw [NSException
      exceptionWithName:HopperPluginExceptionName
                 reason:[NSString stringWithFormat:@"Forgot to implement %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (int)processStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file {

  [HopperUtilities initialiseStructure:structure];

  BOOL result;
  uint16_t opcodeWord =
      [file readUInt16AtVirtualAddress:structure->virtualAddr];
  InstructionMetadata metadata = {.haltsExecution = NO,
                                  .instruction = opcodeWord};

  switch (OPCODE_FROM_WORD(opcodeWord)) {
  case OpcodeMOVE:
    result = [self handleMOVEOpcode:opcodeWord
                       forStructure:structure
                             onFile:file
                           metadata:&metadata];
    break;

  case OpcodeADD:
    result = [self handleADDOpcode:opcodeWord
                      forStructure:structure
                            onFile:file
                          metadata:&metadata];
    break;

  case OpcodeAND:
    result = [self handleANDOpcode:opcodeWord
                      forStructure:structure
                            onFile:file
                          metadata:&metadata];
    break;

  case OpcodeXOR:
    result = [self handleXOROpcode:opcodeWord
                      forStructure:structure
                            onFile:file
                          metadata:&metadata];
    break;

  case OpcodeXEC:
    result = [self handleXECOpcode:opcodeWord
                      forStructure:structure
                            onFile:file
                          metadata:&metadata];
    break;

  case OpcodeNZT:
    result = [self handleNZTOpcode:opcodeWord
                      forStructure:structure
                            onFile:file
                          metadata:&metadata];
    break;

  case OpcodeXMIT:
    result = [self handleXMITOpcode:opcodeWord
                       forStructure:structure
                             onFile:file
                           metadata:&metadata];
    break;

  case OpcodeJMP:
    result = [self handleJMPOpcode:opcodeWord
                      forStructure:structure
                            onFile:file
                          metadata:&metadata];
    break;

  default:
    result = NO;
    break;
  }

  if (!result) {
    return DISASM_UNKNOWN_OPCODE;
  }

  strcpy(&structure->instruction.mnemonic[0], kOpcodeNames[metadata.opcode]);
  strcpy(&structure->instruction.unconditionalMnemonic[0],
         kOpcodeNames[metadata.opcode]);
  structure->instruction.userData = *((uintptr_t *)&metadata);
  structure->instruction.length = 2;
  return structure->instruction.length;
}

- (BOOL)haltsExecutionFlow:(const DisasmStruct *_Nonnull)structure {
  return ((InstructionMetadata *)&structure->instruction.userData)
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

  NSAssert(
      [file.cpuDefinition isKindOfClass:[ItFrobHopper8x300Definition class]],
      @"Invalid CPU definition class");

  NSObject<ItFrobHopper8x300InstructionFormatter> *formatter =
      [(ItFrobHopper8x300Definition *)file.cpuDefinition
          formatterForSyntax:(SyntaxType)file.userRequestedSyntaxIndex];
  NSAssert(formatter != nil, @"Missing formatter for syntax index");

  return [formatter formatOperand:disasm
                          atIndex:operandIndex
                           inFile:file
                     withServices:services];
}

- (NSObject<HPASMLine> *_Nullable)
buildCompleteOperandString:(DisasmStruct *_Nonnull)disasm
                    inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                       raw:(BOOL)raw
              withServices:(NSObject<HPHopperServices> *_Nonnull)services {

  NSAssert(
      [file.cpuDefinition isKindOfClass:[ItFrobHopper8x300Definition class]],
      @"Invalid CPU definition class");

  NSObject<ItFrobHopper8x300InstructionFormatter> *formatter =
      [(ItFrobHopper8x300Definition *)file.cpuDefinition
          formatterForSyntax:(SyntaxType)file.userRequestedSyntaxIndex];
  NSAssert(formatter != nil, @"Missing formatter for syntax index");

  return
      [formatter formatInstruction:disasm
                            inFile:file
                      withServices:services
                       andEncoding:(EncodingType)((InstructionMetadata *)&disasm
                                                      ->instruction.userData)
                                       ->encoding];
}

#pragma mark - Private methods

- (BOOL)handleALUInstruction:(DisasmStruct *_Nonnull)structure
                  withOpcode:(uint16_t)opcode
                    metadata:(InstructionMetadata *_Nonnull)metadata {

  int sourceRegister = (opcode >> 8) & 0b11111;
  int destinationRegister = opcode & 0b11111;
  int rotationOrLength = (opcode >> 5) & 0b111;

  switch (opcode & 0x1010) {

  // Register to Register
  case 0x0000:
    metadata->encoding = EncodingWithRotation;
    break;

  // Register to I/O bus
  case 0x0010:
    metadata->encoding = EncodingWithLength;
    break;

  // I/O bus to register
  case 0x1000:
    metadata->encoding = EncodingWithLength;
    break;

  // I/O bus to I/O bus
  case 0x1010:
    metadata->encoding = EncodingWithLength;
    break;

  default:
    return NO;
  }

  // Source

  structure->operand[0].type = DISASM_OPERAND_REGISTER_TYPE;
  structure->operand[0].immediateValue = sourceRegister;
  structure->operand[0].size = 5;

  // Rotation/Length

  structure->operand[1].type = DISASM_OPERAND_CONSTANT_TYPE;
  structure->operand[1].immediateValue = rotationOrLength;
  structure->operand[1].size = 3;

  // Destination

  structure->operand[2].type = DISASM_OPERAND_REGISTER_TYPE;
  structure->operand[2].immediateValue = destinationRegister;
  structure->operand[2].size = 5;

  structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      (uint32_t)((1 << sourceRegister) | RegisterFlagAUX);
  structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      (uint32_t)((1 << destinationRegister) | RegisterFlagOVF);

  ((OperandMetadata *)&(
       structure->operand[1].userData[OPERAND_USERDATA_METADATA_INDEX]))
      ->defaultFormat = Format_Decimal;

  metadata->opcode = OPCODE_FROM_WORD(opcode);

  // Handle synthetic NOP opcode.

  if ((metadata->opcode == OpcodeMOVE) &&
      (structure->operand[0].immediateValue == RegisterAUX) &&
      (structure->operand[2].immediateValue == RegisterAUX) &&
      (structure->operand[1].immediateValue == 0)) {
    metadata->opcode = OpcodeNOP;
    metadata->encoding = EncodingImplicit;
    for (NSUInteger index = 0; index < 3; index++) {
      memset((void *)&structure->operand[index], 0x00, sizeof(DisasmOperand));
      structure->operand[index].type = DISASM_OPERAND_NO_OPERAND;
    }
  }

  return YES;
}

- (BOOL)handleNZTInstruction:(DisasmStruct *_Nonnull)structure
                  withOpcode:(uint16_t)opcode
                    metadata:(InstructionMetadata *_Nonnull)metadata {

  uint8_t registerId = (uint8_t)((opcode >> 8) & 0b11111);

  structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      (uint32_t)(1 << registerId);

  structure->instruction.branchType = DISASM_BRANCH_JNE;

  // Literal

  structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
  structure->operand[0].isBranchDestination = YES;
  structure->operand[0].accessMode = DISASM_ACCESS_NONE;

  // Source

  structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
  structure->operand[1].immediateValue = registerId;

  // Length

  structure->operand[2].type = DISASM_OPERAND_CONSTANT_TYPE;

  if ((opcode & 0x1000) == 0x0000) {
    // Register immediate

    Address address =
        (structure->virtualAddr & 0xFFFFFE00) + ((opcode & 0x00FF) * 2);
    structure->operand[0].immediateValue = (opcode & 0xFF) * 2;
    structure->operand[0].size = 9;
    structure->operand[2].immediateValue = 0;
    structure->operand[2].size = 0;
    structure->instruction.addressValue = address;
  } else {
    // I/O bus immediate

    Address address =
        (structure->virtualAddr & 0xFFFFFFD0) + ((opcode & 0b11111) * 2);
    structure->operand[0].immediateValue = (opcode & 0b11111) * 2;
    structure->operand[0].size = 6;
    structure->operand[2].immediateValue = (opcode >> 5) & 0b111;
    structure->operand[2].size = 3;
    structure->instruction.addressValue = address;
  }

  ((OperandMetadata *)&(
       structure->operand[2].userData[OPERAND_USERDATA_METADATA_INDEX]))
      ->defaultFormat = Format_Decimal;

  metadata->encoding = EncodingOffsetWithLength;
  metadata->opcode = OPCODE_FROM_WORD(opcode);

  return YES;
}

- (BOOL)handleXECInstruction:(DisasmStruct *_Nonnull)structure
                  withOpcode:(uint16_t)opcode
                    metadata:(InstructionMetadata *_Nonnull)metadata {

  uint8_t registerId = (uint8_t)((opcode >> 8) & 0x001F);

  structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      (uint32_t)(1 << registerId);
  structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;

  structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
  structure->operand[1].immediateValue = registerId;
  structure->operand[1].size = 5;

  structure->operand[2].type = DISASM_OPERAND_CONSTANT_TYPE;

  Address resolvedAddress = structure->instruction.pcRegisterValue;

  if ((opcode & 0x1000) == 0x0000) {
    // Register immediate

    structure->operand[0].immediateValue = opcode & 0x00FF;
    structure->operand[0].size = 8;
    structure->operand[2].immediateValue = 0;
    structure->operand[2].size = 0;
    metadata->encoding = EncodingOffsetWithLength;

    resolvedAddress = (resolvedAddress & ((1 << 9) - 1)) |
                      (structure->operand[0].immediateValue * 2);
  } else {
    // I/O bus immediate

    structure->operand[0].immediateValue = opcode & 0x001F;
    structure->operand[0].size = 5;

    structure->operand[2].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[2].immediateValue = (opcode >> 5) & 0x0007;
    structure->operand[2].size = 3;

    metadata->encoding = EncodingOffsetWithLength;
    resolvedAddress = (resolvedAddress & ((1 << 5) - 1)) |
                      (structure->operand[0].immediateValue * 2);
  }

  ((OperandMetadata *)&(
       structure->operand[2].userData[OPERAND_USERDATA_METADATA_INDEX]))
      ->defaultFormat = Format_Decimal;

  structure->instruction.addressValue = resolvedAddress;
  structure->operand[0].isBranchDestination = YES;
  structure->instruction.branchType = DISASM_BRANCH_JMP;

  ((OperandMetadata *)&(
       structure->operand[0].userData[OPERAND_USERDATA_METADATA_INDEX]))
      ->defaultFormat = Format_Address;

  metadata->opcode = OPCODE_FROM_WORD(opcode);

  return YES;
}

- (BOOL)handleXMITInstruction:(DisasmStruct *_Nonnull)structure
                   withOpcode:(uint16_t)opcode
                     metadata:(InstructionMetadata *_Nonnull)metadata {

  uint8_t registerId = (uint8_t)((opcode >> 8) & 0b11111);

  structure->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] =
      (uint32_t)(1 << registerId);

  structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;

  structure->operand[1].type = DISASM_OPERAND_REGISTER_TYPE;
  structure->operand[1].immediateValue = registerId;
  structure->operand[1].size = 5;

  if ((opcode & 0x1000) == 0x0000) {
    // Register immediate

    structure->operand[0].immediateValue = opcode & 0x00FF;
    structure->operand[0].size = 8;

    metadata->encoding = EncodingAssignment;
  } else {
    // I/O bus immediate

    structure->operand[0].immediateValue = opcode & 0b11111;
    structure->operand[0].size = 5;

    structure->operand[2].type = DISASM_OPERAND_CONSTANT_TYPE;
    structure->operand[2].immediateValue = (opcode >> 5) & 0b111;
    structure->operand[2].size = 3;

    ((OperandMetadata *)&(
         structure->operand[2].userData[OPERAND_USERDATA_METADATA_INDEX]))
        ->defaultFormat = Format_Decimal;

    metadata->encoding = EncodingAssignmentWithLength;
  }

  metadata->opcode = OPCODE_FROM_WORD(opcode);

  // Handle synthetic XML and XMR opcodes.

  if (metadata->encoding == EncodingAssignment) {
    if ((structure->operand[1].immediateValue == RegisterR12) ||
        (structure->operand[1].immediateValue == RegisterR13)) {
      metadata->encoding = EncodingSingle;
      metadata->opcode = (structure->operand[1].immediateValue == RegisterR12)
                             ? OpcodeXML
                             : OpcodeXMR;
      memset((void *)&structure->operand[1], 0x00, sizeof(DisasmOperand));
      structure->operand[1].type = DISASM_OPERAND_NO_OPERAND;
      structure->operand[2].type = DISASM_OPERAND_NO_OPERAND;
    }
  }

  return YES;
}

- (BOOL)handleJMPInstruction:(DisasmStruct *_Nonnull)structure
                  withOpcode:(uint16_t)opcode
                    metadata:(InstructionMetadata *_Nonnull)metadata {

  Address address = (Address)(opcode & 0x1FFF);

  structure->operand[0].memory.baseRegistersMask = 0;
  structure->operand[0].memory.indexRegistersMask = 0;
  structure->operand[0].memory.scale = 1;
  structure->operand[0].memory.displacement = 0;
  structure->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE;
  structure->operand[0].size = 16;
  structure->operand[0].immediateValue = address;
  structure->operand[0].accessMode = DISASM_ACCESS_NONE;
  structure->instruction.branchType = DISASM_BRANCH_JMP;
  structure->instruction.addressValue = address * 2;
  ((OperandMetadata *)&(
       structure->operand[0].userData[OPERAND_USERDATA_METADATA_INDEX]))
      ->defaultFormat = Format_Address;

  structure->operand[0].isBranchDestination = YES;

  metadata->opcode = OPCODE_FROM_WORD(opcode);
  metadata->encoding = EncodingSingle;

  // Handle synthetic HALT opcode.

  if (structure->instruction.addressValue == structure->virtualAddr) {
    metadata->haltsExecution = YES;
    metadata->opcode = OpcodeHALT;
    metadata->encoding = EncodingImplicit;
    memset((void *)&structure->operand[0], 0x00, sizeof(DisasmOperand));
    structure->operand[0].type = DISASM_OPERAND_NO_OPERAND;
  }

  return YES;
}

#pragma mark - Overridable opcode handling methods

- (BOOL)handleMOVEOpcode:(uint16_t)opcode
            forStructure:(DisasmStruct *_Nonnull)structure
                  onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                metadata:(InstructionMetadata *_Nonnull)metadata {

  return
      [self handleALUInstruction:structure withOpcode:opcode metadata:metadata];
}

- (BOOL)handleADDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  BOOL result =
      [self handleALUInstruction:structure withOpcode:opcode metadata:metadata];

  if (result) {
    structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] |=
        1 << RegisterAUX;
  }

  return result;
}

- (BOOL)handleANDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  BOOL result =
      [self handleALUInstruction:structure withOpcode:opcode metadata:metadata];

  if (result) {
    structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] |=
        1 << RegisterAUX;
  }

  return result;
}

- (BOOL)handleXOROpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  BOOL result =
      [self handleALUInstruction:structure withOpcode:opcode metadata:metadata];

  if (result) {
    structure->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] |=
        1 << RegisterAUX;
  }

  return result;
}

- (BOOL)handleXECOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  return
      [self handleXECInstruction:structure withOpcode:opcode metadata:metadata];
}

- (BOOL)handleNZTOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  return
      [self handleNZTInstruction:structure withOpcode:opcode metadata:metadata];
}

- (BOOL)handleXMITOpcode:(uint16_t)opcode
            forStructure:(DisasmStruct *_Nonnull)structure
                  onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                metadata:(InstructionMetadata *_Nonnull)metadata {

  return [self handleXMITInstruction:structure
                          withOpcode:opcode
                            metadata:metadata];
}

- (BOOL)handleJMPOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               metadata:(InstructionMetadata *_Nonnull)metadata {

  return
      [self handleJMPInstruction:structure withOpcode:opcode metadata:metadata];
}

@end
