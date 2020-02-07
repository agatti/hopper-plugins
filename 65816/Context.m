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

#import "Context.h"
#import "Core.h"
#import "Definition.h"
#import "HopperCommon.h"

static const uint8_t kInvalidCPUMode = 0xFF;

static uint8_t translateCPUModeToPBits(uint8_t mode);
static uint8_t translatePBitsToCPUMode(uint8_t bits);

@interface ItFrobHopper65816Context ()

@property(strong, nonatomic, readonly, nonnull)
    NSObject<CPUDefinition> *definition;
@property(strong, nonatomic, readonly, nonnull)
    NSObject<HPDisassembledFile> *file;
@property(strong, nonatomic, readonly, nonnull)
    NSObject<HPHopperServices> *services;
@property(strong, nonatomic, readonly, nonnull)
    NSObject<ItFrobHopperCPUProvider> *provider;

@end

@implementation ItFrobHopper65816Context

- (instancetype)initWithCPU:(NSObject<CPUDefinition> *_Nonnull)definition
                    andFile:(NSObject<HPDisassembledFile> *_Nonnull)file
               withProvider:
                   (NSObject<ItFrobHopperCPUProvider> *_Nonnull)provider
              usingServices:(NSObject<HPHopperServices> *_Nonnull)services {
  if (self = [super init]) {
    _definition = definition;
    _file = file;
    _provider = provider;
    _services = services;
  }

  return self;
}

#pragma mark - CPUContext protocol implementation

- (NSObject<CPUDefinition> *)cpuDefinition {
  return self.definition;
}

- (Address)adjustCodeAddress:(Address)address {
  return address;
}

- (Address)nextAddressToTryIfInstructionFailedToDecodeAt:(Address)address
                                              forCPUMode:(uint8_t)mode {
  return address + 1;
}

- (int)isNopAt:(Address)address {
  return [self.file readUInt8AtVirtualAddress:address] == 0xEA;
}

- (int)disassembleSingleInstruction:(DisasmStruct *)disasm
                 usingProcessorMode:(NSUInteger)mode {
  disasm->instruction.pcRegisterValue = disasm->virtualAddr;
  return [self.provider processStructure:disasm onFile:self.file];
}

- (BOOL)instructionMayBeASwitchStatement:(DisasmStruct *)disasmStruct {
  return NO;
}

- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
  return [self.provider haltsExecutionFlow:disasm];
}

- (NSObject<HPASMLine> *)buildMnemonicString:(DisasmStruct *)disasm
                                      inFile:
                                          (NSObject<HPDisassembledFile> *)file {

  return [self.provider buildMnemonicString:disasm
                                     inFile:file
                               withServices:self.services];
}

- (NSObject<HPASMLine> *)
    buildCompleteOperandString:(DisasmStruct *)disasm
                        inFile:(NSObject<HPDisassembledFile> *)file
                           raw:(BOOL)raw {

  return [self.provider buildCompleteOperandString:disasm
                                            inFile:file
                                               raw:raw
                                      withServices:self.services];
}

- (NSObject<HPASMLine> *)buildOperandString:(DisasmStruct *)disasm
                            forOperandIndex:(NSUInteger)operandIndex
                                     inFile:(NSObject<HPDisassembledFile> *)file
                                        raw:(BOOL)raw {

  return [self.provider buildOperandString:disasm
                           forOperandIndex:operandIndex
                                    inFile:file
                                       raw:raw
                              withServices:self.services];
}

- (void)performProcedureAnalysis:(NSObject<HPProcedure> *)procedure
                      basicBlock:(NSObject<HPBasicBlock> *)basicBlock
                          disasm:(DisasmStruct *)disasm {

  NSUInteger operandIndex = 0;
  while (operandIndex < DISASM_MAX_OPERANDS) {
    ArgFormat format = (ArgFormat)disasm->operand[operandIndex].userData[0];
    switch (RAW_FORMAT(format)) {
    case Format_Address:
      [self.file setFormat:format
               forArgument:operandIndex
          atVirtualAddress:disasm->virtualAddr];
      break;

    default:
      break;
    }

    operandIndex++;
  }
}

- (uint8_t)cpuModeForNextInstruction:(DisasmStruct *)disasmStruct {
  FRBInstructionUserData metadata =
      *(FRBInstructionUserData *)&disasmStruct->instruction.userData;
  uint8_t bitsValue =
      (([self.file readUInt8AtVirtualAddress:disasmStruct->virtualAddr + 1]) >>
       4) &
      0x03;

  uint8_t currentMode = translateCPUModeToPBits(
      [self.file cpuModeAtVirtualAddress:disasmStruct->virtualAddr]);

  switch (metadata.opcode) {
  case OpcodeSEP:
    currentMode |= bitsValue;
    break;

  case OpcodeREP:
    currentMode &= ~bitsValue;
    break;

  default:
    return CPUAccumulator8Index8;
  }

  return translatePBitsToCPUMode(currentMode);
}

@end

uint8_t translateCPUModeToPBits(uint8_t mode) {
  switch (mode) {
  case CPUAccumulator8Index8:
    return 3;

  case CPUAccumulator8Index16:
    return 2;

  case CPUAccumulator16Index8:
    return 1;

  case CPUAccumulator16Index16:
    return 0;

  default:
    return kInvalidCPUMode;
  }
}

uint8_t translatePBitsToCPUMode(uint8_t bits) {
  switch (bits) {
  case 3:
    return CPUAccumulator8Index8;

  case 2:
    return CPUAccumulator8Index16;

  case 1:
    return CPUAccumulator16Index8;

  case 0:
    return CPUAccumulator16Index16;

  default:
    return kInvalidCPUMode;
  }
}
