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

#import "Context.h"
#import "Common.h"
#import "Core.h"

NSString *_Nonnull ItFrobHopper8x300MissingOperand =
    @"Missing operand fragment for index %d at address %llu";

@interface ItFrobHopper8x300Context ()

@property(strong, nonatomic, readonly, nonnull)
    NSObject<CPUDefinition> *definition;
@property(strong, nonatomic, readonly, nonnull)
    NSObject<HPDisassembledFile> *file;
@property(strong, nonatomic, readonly, nonnull)
    NSObject<HPHopperServices> *services;
@property(strong, nonatomic, readonly, nonnull)
    NSObject<ItFrobHopperCPUProvider> *provider;

@end

@implementation ItFrobHopper8x300Context

- (instancetype _Nonnull)
      initWithCPU:(NSObject<CPUDefinition> *_Nonnull)definition
          andFile:(NSObject<HPDisassembledFile> *_Nonnull)file
     withProvider:(NSObject<ItFrobHopperCPUProvider> *_Nonnull)provider
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
  return address & ~1;
}

- (Address)nextAddressToTryIfInstructionFailedToDecodeAt:(Address)address
                                              forCPUMode:(uint8_t)mode {
  return (address & ~1) + 2;
}

- (int)isNopAt:(Address)address {
  return ([self.file readUInt16AtVirtualAddress:address] == 0x0000) ? 2 : 0;
}

- (int)disassembleSingleInstruction:(DisasmStruct *)disasm
                 usingProcessorMode:(NSUInteger)mode {
  disasm->instruction.pcRegisterValue = disasm->virtualAddr;
  return [self.provider processStructure:disasm onFile:self.file];
}

- (BOOL)instructionMayBeASwitchStatement:(DisasmStruct *)disasmStruct {
  return ((Opcode)(disasmStruct->instruction.userData >> 8)) == OpcodeXEC;
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

- (void)performInstructionSpecificAnalysis:(DisasmStruct *)disasm
                              forProcedure:(NSObject<HPProcedure> *)procedure
                                 inSegment:(NSObject<HPSegment> *)segment {

  NSUInteger operandIndex = 0;
  while (operandIndex < DISASM_MAX_OPERANDS) {
    OperandMetadata *data =
        (OperandMetadata *)&(disasm->operand[operandIndex]
                                 .userData[OPERAND_USERDATA_METADATA_INDEX]);
    ArgFormat format = (ArgFormat)data->defaultFormat;
    switch (RAW_FORMAT(format)) {
    case Format_Decimal:
    case Format_Hexadecimal:
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

- (void)performBranchesAnalysis:(DisasmStruct *)disasm
           computingNextAddress:(Address *)next
                    andBranches:(NSMutableArray<NSNumber *> *)branches
                   forProcedure:(NSObject<HPProcedure> *)procedure
                     basicBlock:(NSObject<HPBasicBlock> *)basicBlock
                      ofSegment:(NSObject<HPSegment> *)segment
                calledAddresses:(NSMutableArray<NSNumber *> *)calledAddresses
                      callsites:
                          (NSMutableArray<NSNumber *> *)callSitesAddresses {

  InstructionMetadata *metadata =
      (InstructionMetadata *)&disasm->instruction.userData;
  BOOL isSwitch = metadata->opcode == OpcodeXEC;

  if ([self.file segmentForVirtualAddress:disasm->instruction.addressValue] ==
      nil) {
    if (isSwitch) {
      static NSString *switchOutOfBounds =
          @"Switch out of mapped memory (0x%lX)";

      [HopperUtilities
          addInlineCommentIfEmpty:[NSString
                                      stringWithFormat:switchOutOfBounds,
                                                       (unsigned long)
                                                           disasm->instruction
                                                               .addressValue]
                        atAddress:disasm->virtualAddr
                           inFile:self.file];
    } else {
      static NSString *jumpOutOfBounds = @"Jump out of mapped memory (0x%lX)";

      [HopperUtilities
          addInlineCommentIfEmpty:[NSString
                                      stringWithFormat:jumpOutOfBounds,
                                                       (unsigned long)
                                                           disasm->instruction
                                                               .addressValue]
                        atAddress:disasm->virtualAddr
                           inFile:self.file];
    }

    return;
  }

  if (isSwitch) {
    [segment addReferencesToAddress:disasm->instruction.addressValue
                        fromAddress:disasm->virtualAddr];
  }
}

@end
