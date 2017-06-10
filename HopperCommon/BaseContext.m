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

#import "BaseContext.h"

#import "FRBHopperCommon.h"

@implementation ItFrobHopperHopperCommonBaseContext

- (NSObject<CPUDefinition> *)cpuDefinition {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (void)initDisasmStructure:(DisasmStruct *)disasm
            withSyntaxIndex:(NSUInteger)syntaxIndex {
  InitialiseDisasmStruct(disasm);
}

- (Address)adjustCodeAddress:(Address)address {
  return address;
}

- (uint8_t)cpuModeFromAddress:(Address)address {
  return 0;
}

- (BOOL)addressForcesACPUMode:(Address)address {
  return NO;
}

- (uint8_t)estimateCPUModeAtVirtualAddress:(Address)address {
  return 0;
}

- (Address)nextAddressToTryIfInstructionFailedToDecodeAt:(Address)address
                                              forCPUMode:(uint8_t)mode {
  return address + 1;
}

- (int)isNopAt:(Address)address {
  return 0;
}

- (BOOL)hasProcedurePrologAt:(Address)address {
  return NO;
}

- (NSUInteger)detectedPaddingLengthAt:(Address)address {
  return 0;
}

- (void)analysisBeginsAt:(Address)entryPoint {
}

- (void)analysisEnded {
}

- (void)procedureAnalysisBeginsForProcedure:(NSObject<HPProcedure> *)procedure
                               atEntryPoint:(Address)entryPoint {
}

- (void)procedureAnalysisOfPrologForProcedure:(NSObject<HPProcedure> *)procedure
                                 atEntryPoint:(Address)entryPoint {
}

- (void)procedureAnalysisOfEpilogForProcedure:(NSObject<HPProcedure> *)procedure
                                 atEntryPoint:(Address)entryPoint {
}

- (void)procedureAnalysisEndedForProcedure:(NSObject<HPProcedure> *)procedure
                              atEntryPoint:(Address)entryPoint {
}

- (void)procedureAnalysisContinuesOnBasicBlock:
    (NSObject<HPBasicBlock> *)basicBlock {
}

- (void)resetDisassembler {
}

- (int)disassembleSingleInstruction:(DisasmStruct *)disasm
                 usingProcessorMode:(NSUInteger)mode {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (void)updateProcedureAnalysis:(DisasmStruct *)disasm {
}

- (BOOL)instructionCanBeUsedToExtractDirectMemoryReferences:
    (DisasmStruct *)disasmStruct {
  return YES;
}

- (BOOL)instructionOnlyLoadsAddress:(DisasmStruct *)disasmStruct {
  return NO;
}

- (BOOL)instructionMayBeASwitchStatement:(DisasmStruct *)disasmStruct {
  return NO;
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
}

- (void)performInstructionSpecificAnalysis:(DisasmStruct *)disasm
                              forProcedure:(NSObject<HPProcedure> *)procedure
                                 inSegment:(NSObject<HPSegment> *)segment {
}

- (Address)getThunkDestinationForInstructionAt:(Address)address {
  return BAD_ADDRESS;
}

- (void)performProcedureAnalysis:(id<HPProcedure>)procedure
                      basicBlock:(id<HPBasicBlock>)basicBlock
                          disasm:(DisasmStruct *)disasm {
}

- (NSObject<HPASMLine> *)buildMnemonicString:(DisasmStruct *)disasm
                                      inFile:
                                          (NSObject<HPDisassembledFile> *)file {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (NSObject<HPASMLine> *)buildOperandString:(DisasmStruct *)disasm
                            forOperandIndex:(NSUInteger)operandIndex
                                     inFile:(NSObject<HPDisassembledFile> *)file
                                        raw:(BOOL)raw {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (NSObject<HPASMLine> *)
buildCompleteOperandString:(DisasmStruct *)disasm
                    inFile:(NSObject<HPDisassembledFile> *)file
                       raw:(BOOL)raw {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"Forgot to override %s",
                                                   __PRETTY_FUNCTION__]
               userInfo:nil];
}

- (BOOL)canDecompileProcedure:(NSObject<HPProcedure> *)procedure {
  return NO;
}

- (Address)skipHeader:(NSObject<HPBasicBlock> *)basicBlock
          ofProcedure:(NSObject<HPProcedure> *)procedure {
  return basicBlock.from;
}

- (Address)skipFooter:(NSObject<HPBasicBlock> *)basicBlock
          ofProcedure:(NSObject<HPProcedure> *)procedure {
  return basicBlock.to;
}

- (ASTNode *)decompileInstructionAtAddress:(Address)a
                                    disasm:(DisasmStruct *)d
                                 addNode_p:(BOOL *)addNode_p
                           usingDecompiler:(Decompiler *)decompiler {
  return nil;
}

- (NSData *)assembleRawInstruction:(NSString *)instr
                         atAddress:(Address)addr
                           forFile:(NSObject<HPDisassembledFile> *)file
                       withCPUMode:(uint8_t)cpuMode
                usingSyntaxVariant:(NSUInteger)syntax
                             error:(NSError **)error {
  return nil;
}

@end
