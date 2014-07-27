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
#import "FRBContext.h"
#import "FRBDefinition.h"
#import "FRBFormatter.h"
#import "FRBModelHandler.h"
#import "FRBProvider.h"

@interface FRBContext ()

@property (strong, nonatomic) FRBDefinition *cpu;
@property (strong, nonatomic) NSObject<HPDisassembledFile> *file;
@property (strong, nonatomic) NSObject<FRBProvider> *provider;
@property (strong, nonatomic) FRBModelHandler *handler;

- (void)handleNonBranchOpcode:(const struct FRBOpcode *)opcode
                    forDisasm:(DisasmStruct *)disasm;
- (void)handleBranchOpcode:(const struct FRBOpcode *)opcode
                 forDisasm:(DisasmStruct *)disasm;
- (NSString *)formatInstruction:(DisasmStruct *)source;
- (void)setMemoryFlags:(DisasmStruct *)disasm
        forInstruction:(const struct FRBInstruction *)instruction;
- (void)updateRegistersMask:(DisasmStruct *)disasm
                  forOpcode:(const struct FRBOpcode *)opcode;

@end

static NSString * const FRBNMIVectorName = @"NMI_Vector";
static NSString * const FRBRESETVectorName = @"RESET_Vector";
static NSString * const FRBIRQVectorName = @"IRQ_Vector";
static const NSUInteger FRBNMIVectorAddress = 0xFFFA;
static const NSUInteger FRBRESETVectorAddress = 0xFFFC;
static const NSUInteger FRBIRQVectorAddress = 0xFFFE;

@implementation FRBContext

- (instancetype)initWithCPU:(FRBDefinition *)cpu
                    andFile:(NSObject<HPDisassembledFile> *)file {
    if (self = [super init]) {
        _cpu = cpu;
        _file = file;
        _handler = [FRBModelHandler sharedModelHandler];
        NSString *providerName = [_handler providerNameForFamily:file.cpuFamily
                                                    andSubFamily:file.cpuSubFamily];
        _provider = [[FRBModelHandler sharedModelHandler] providerForName:providerName];

        if (!_provider) {
            return nil;
        }

        [file setName:FRBNMIVectorName
    forVirtualAddress:FRBNMIVectorAddress
               reason:NCReason_Script]; // :(
        [file setType:Type_Int16
     atVirtualAddress:FRBNMIVectorAddress
            forLength:sizeof(uint16_t)];

        [file setName:FRBRESETVectorName
    forVirtualAddress:FRBRESETVectorAddress
               reason:NCReason_Script]; // :(
        [file setType:Type_Int16
     atVirtualAddress:FRBRESETVectorAddress
            forLength:sizeof(uint16_t)];

        [file setName:FRBIRQVectorName
    forVirtualAddress:FRBIRQVectorAddress
               reason:NCReason_Script]; // :(
        [file setType:Type_Int16
     atVirtualAddress:FRBIRQVectorAddress
            forLength:sizeof(uint16_t)];
    }
    return self;
}

- (NSObject<CPUContext> *)cloneContext {
    return [[FRBContext alloc] initWithCPU:_cpu
                                   andFile:_file];
}

- (NSObject<CPUDefinition> *)cpuDefinition {
    return _cpu;
}

- (void)initDisasmStructure:(DisasmStruct *)disasm
            withSyntaxIndex:(NSUInteger)syntaxIndex {
    bzero(disasm, sizeof(DisasmStruct));
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

- (Address)nextAddressToTryIfInstructionFailedToDecodeAt:(Address)address
                                              forCPUMode:(uint8_t)mode {
    return address + 1;
}

- (BOOL)haveProcedurePrologAt:(Address)address {
    return NO;
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

- (void)procedureAnalysisEndedForProcedure:(NSObject<HPProcedure> *)procedure
                              atEntryPoint:(Address)entryPoint {
}

- (void)procedureAnalysisContinuesOnBasicBlock:(NSObject<HPBasicBlock> *)basicBlock {
}

- (void)resetDisassembler {
}

- (uint8_t)estimateCPUModeAtVirtualAddress:(Address)address {
    return 0;
}

- (int)disassembleSingleInstruction:(DisasmStruct *)disasm
                 usingProcessorMode:(NSUInteger)mode {

    // Clear all modifiable fields first.

    bzero(disasm->completeInstructionString, sizeof(disasm->completeInstructionString));
    bzero(&disasm->instruction, sizeof(DisasmInstruction));
    for (int index = 0; index < DISASM_MAX_OPERANDS; index++) {
        bzero(&disasm->operand[index], sizeof(DisasmOperand));
    }

    // Perform the disassembling operation.

    disasm->instruction.addressValue = 0;
    disasm->instruction.pcRegisterValue = disasm->virtualAddr;

    uint8_t opcodeByte = [_file readUInt8AtVirtualAddress:disasm->virtualAddr];

    const struct FRBOpcode *opcode = [self.provider opcodeForByte:opcodeByte];
    struct FRBInstruction instruction = FRBInstructions[opcode->type];
    disasm->instruction.userData = opcodeByte;
    if (opcode->addressMode == FRBAddressModeUnknown) {
        return DISASM_UNKNOWN_OPCODE;
    }

    disasm->instruction.branchType = instruction.branchType;

    if (instruction.branchType == DISASM_BRANCH_NONE) {
        [self handleNonBranchOpcode:opcode
                          forDisasm:disasm];
    } else {
        [self handleBranchOpcode:opcode
                       forDisasm:disasm];
    }

    strcpy(disasm->instruction.mnemonic, instruction.name);
    strcpy(disasm->instruction.unconditionalMnemonic, instruction.name);

    if (instruction.category == FRBOpcodeCategoryStatusFlagChanges) {
        switch (opcode->type) {
            case FRBOpcodeTypeCLC:
                disasm->instruction.eflags.CF_flag = DISASM_EFLAGS_RESET;
                break;

            case FRBOpcodeTypeCLD:
                disasm->instruction.eflags.DF_flag = DISASM_EFLAGS_RESET;
                break;

            case FRBOpcodeTypeCLI:
                disasm->instruction.eflags.IF_flag = DISASM_EFLAGS_RESET;
                break;

            case FRBOpcodeTypeCLV:
                disasm->instruction.eflags.OF_flag = DISASM_EFLAGS_RESET;
                break;

            case FRBOpcodeTypeSEC:
                disasm->instruction.eflags.CF_flag = DISASM_EFLAGS_SET;
                break;

            case FRBOpcodeTypeSED:
                disasm->instruction.eflags.DF_flag = DISASM_EFLAGS_SET;
                break;

            case FRBOpcodeTypeSEI:
                disasm->instruction.eflags.IF_flag = DISASM_EFLAGS_SET;
                break;

            case FRBOpcodeTypeSET:
                disasm->instruction.eflags.TF_flag = DISASM_EFLAGS_SET;
                
            default:
                break;
        }
    } else {
        if (self.provider.usesTFlag) {
            disasm->instruction.eflags.TF_flag = DISASM_EFLAGS_RESET;
        }
    }

    [self updateRegistersMask:disasm
                    forOpcode:opcode];

    switch (opcode->addressMode) {
        case FRBAddressModeAbsolute:
        case FRBAddressModeAbsoluteIndexedX:
        case FRBAddressModeAbsoluteIndexedY:
        case FRBAddressModeAbsoluteIndirect:
        case FRBAddressModeAbsoluteIndexedIndirect:
        case FRBAddressModeZeroPageProgramCounterRelative:
        case FRBAddressModeImmediateZeroPage:
        case FRBAddressModeImmediateZeroPageX:
            disasm->instruction.length = 3;
            return 3;

        case FRBAddressModeImmediateAbsolute:
        case FRBAddressModeImmediateAbsoluteX:
            disasm->instruction.length = 4;
            return 4;

        case FRBAddressModeImmediate:
        case FRBAddressModeZeroPageIndexedIndirect:
        case FRBAddressModeZeroPageIndirectIndexedY:
        case FRBAddressModeProgramCounterRelative:
        case FRBAddressModeZeroPage:
        case FRBAddressModeZeroPageIndexedX:
        case FRBAddressModeZeroPageIndexedY:
        case FRBAddressModeZeroPageIndirect:
            disasm->instruction.length = 2;
            return 2;

        case FRBAddressModeBlockTransfer:
            disasm->instruction.length = 7;
            return 7;

        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
        default:
            disasm->instruction.length = 1;
            return 1;
    }
}

- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
    return [self.provider haltsExecutionFlow:[self.provider opcodeForByte:disasm->instruction.userData]];
}

- (void)performBranchesAnalysis:(DisasmStruct *)disasm
           computingNextAddress:(Address *)next
                    andBranches:(NSMutableArray *)branches
                   forProcedure:(NSObject<HPProcedure> *)procedure
                     basicBlock:(NSObject<HPBasicBlock> *)basicBlock
                      ofSegment:(NSObject<HPSegment> *)segment
                      callsites:(NSMutableArray *)callSitesAddresses {
}

- (void)performInstructionSpecificAnalysis:(DisasmStruct *)disasm
                              forProcedure:(NSObject<HPProcedure> *)procedure
                                 inSegment:(NSObject<HPSegment> *)segment {
}

- (void)performProcedureAnalysis:(NSObject<HPProcedure> *)procedure
                      basicBlock:(NSObject<HPBasicBlock> *)basicBlock
                          disasm:(DisasmStruct *)disasm {
}

- (void)updateProcedureAnalysis:(DisasmStruct *)disasm {
}

- (NSString *)formattedVariableNameForDisplacement:(int64_t)displacement
                                       inProcedure:(NSObject<HPProcedure> *)procedure {
    return [NSString stringWithFormat:@"var%lld", displacement];
}

- (void)buildInstructionString:(DisasmStruct *)disasm
                    forSegment:(NSObject<HPSegment> *)segment
                populatingInfo:(NSObject<HPFormattedInstructionInfo> *)formattedInstructionInfo {
    strcat(disasm->completeInstructionString, [self formatInstruction:disasm].UTF8String);
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

- (ASTNode *)rawDecodeArgumentIndex:(int)argIndex
                           ofDisasm:(DisasmStruct *)disasm
                  ignoringWriteMode:(BOOL)ignoreWrite
                    usingDecompiler:(Decompiler *)decompiler {
    return nil;
}

- (ASTNode *)decompileInstructionAtAddress:(Address)a
                                    disasm:(DisasmStruct)d
                                    length:(int)instrLength
                                      arg1:(ASTNode *)arg1
                                      arg2:(ASTNode *)arg2
                                      arg3:(ASTNode *)arg3
                                      dest:(ASTNode *)dest
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

////////////////////////////////////////////////////////////////////////////////

- (void)handleNonBranchOpcode:(const struct FRBOpcode *)opcode
                    forDisasm:(DisasmStruct *)disasm {
    uint16_t operand = 0;

    switch (opcode->addressMode) {
        case FRBAddressModeAbsolute:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 0;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 16;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeAbsoluteIndexedX:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = FRBRegisterIndexX;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 16;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeAbsoluteIndexedY:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = FRBRegisterIndexY;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 16;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeImmediate:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE;
            disasm->operand1.immediateValue = operand;
            disasm->operand1.size = 8;
            break;

        case FRBAddressModeAbsoluteIndirect:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 0;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 16;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeZeroPageIndexedIndirect:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = FRBRegisterIndexX;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeZeroPageIndirectIndexedY:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = FRBRegisterIndexY;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeZeroPage:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 0;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeZeroPageIndexedX:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = FRBRegisterIndexX;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeZeroPageIndexedY:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = FRBRegisterIndexX;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeZeroPageIndirect:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 0;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case FRBAddressModeBlockTransfer: {
            uint16_t start = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            uint16_t end = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 3];
            uint16_t length = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 5];

            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 0;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 16;
            disasm->operand1.immediateValue = start;

            disasm->operand2.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand2.memory.baseRegister = 0;
            disasm->operand2.memory.displacement = 0;
            disasm->operand2.memory.indexRegister = 0;
            disasm->operand2.memory.scale = 1;
            disasm->operand2.size = 16;
            disasm->operand2.immediateValue = end;

            disasm->operand3.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand3.size = 16;
            disasm->operand3.immediateValue = length;

            break;
        }

        case FRBAddressModeImmediateZeroPage: {
            uint8_t value = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            uint8_t zeroPage = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 2];

            disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = value;

            disasm->operand2.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand2.memory.baseRegister = 0;
            disasm->operand2.memory.displacement = 0;
            disasm->operand2.memory.indexRegister = 0;
            disasm->operand2.memory.scale = 1;
            disasm->operand2.size = 8;
            disasm->operand2.immediateValue = zeroPage;
            break;
        }

        case FRBAddressModeImmediateZeroPageX: {
            uint8_t value = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            uint8_t zeroPage = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 2];

            disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = value;

            disasm->operand2.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand2.memory.baseRegister = 0;
            disasm->operand2.memory.displacement = 0;
            disasm->operand2.memory.indexRegister = FRBRegisterIndexX;
            disasm->operand2.memory.scale = 1;
            disasm->operand2.size = 8;
            disasm->operand2.immediateValue = zeroPage;
            break;
        }

        case FRBAddressModeImmediateAbsolute: {
            uint8_t value = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            uint16_t address = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 2];

            disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = value;

            disasm->operand2.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand2.memory.baseRegister = 0;
            disasm->operand2.memory.displacement = 0;
            disasm->operand2.memory.indexRegister = 0;
            disasm->operand2.memory.scale = 1;
            disasm->operand2.size = 16;
            disasm->operand2.immediateValue = address;
            break;
        }

        case FRBAddressModeImmediateAbsoluteX: {
            uint8_t value = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            uint16_t address = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 2];

            disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = value;

            disasm->operand2.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand2.memory.baseRegister = 0;
            disasm->operand2.memory.displacement = 0;
            disasm->operand2.memory.indexRegister = FRBRegisterIndexX;
            disasm->operand2.memory.scale = 1;
            disasm->operand2.size = 16;
            disasm->operand2.immediateValue = address;
            break;
        }

        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;

        default:
            NSLog(@"Internal error: non-branch opcode with address mode %lu found",
                  opcode->addressMode);
            break;
    }

    disasm->operand1.accessMode = DISASM_ACCESS_NONE;
    const struct FRBInstruction instruction = FRBInstructions[opcode->type];

    switch (opcode->addressMode) {
        case FRBAddressModeImmediate:
        case FRBAddressModeProgramCounterRelative:
        case FRBAddressModeAccumulator:
        case FRBAddressModeImplied:
        case FRBAddressModeStack:
            break;

        default: {
            [self setMemoryFlags:disasm
                  forInstruction:&instruction];
            break;
        }
    }
}

- (void)handleBranchOpcode:(const struct FRBOpcode *)opcode
                 forDisasm:(DisasmStruct *)disasm {
    uint16_t operand = 0;

    switch (opcode->addressMode) {
        case FRBAddressModeAbsolute:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->instruction.addressValue = operand;
            disasm->operand1.immediateValue = operand;
            disasm->operand1.size = 16;
            break;

        case FRBAddressModeAbsoluteIndirect:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_RELATIVE;
            disasm->instruction.addressValue = operand;
            disasm->operand1.immediateValue = operand;
            disasm->operand1.size = 16;
            break;

        case FRBAddressModeAbsoluteIndexedIndirect:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->instruction.addressValue = operand;
            disasm->operand1.immediateValue = operand;
            disasm->operand1.size = 16;
            break;

        case FRBAddressModeProgramCounterRelative: {
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            int offset;
            if (operand & (1 << 7)) {
                offset = operand & 0x7F;
                offset = -((~offset + 1) & 0x7F);
            } else {
                offset = operand;
            }

            offset += disasm->instruction.pcRegisterValue + 2;

            disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_RELATIVE;
            disasm->instruction.addressValue = (Address) offset;
            disasm->operand1.immediateValue = offset;
            disasm->operand1.size = 16;
            break;
        }

        case FRBAddressModeZeroPageProgramCounterRelative: {
            uint8_t zeroPage = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE;
            disasm->operand1.memory.baseRegister = 0;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 0;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = zeroPage;

            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 2];

            int offset;
            if (operand & (1 << 7)) {
                offset = operand & 0x7F;
                offset = -((~offset + 1) & 0x7F);
            } else {
                offset = operand;
            }

            offset += disasm->instruction.pcRegisterValue + 2;
            
            disasm->operand2.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_RELATIVE;
            disasm->instruction.addressValue = (Address) offset;
            disasm->operand2.immediateValue = offset;
            disasm->operand2.size = 16;
            break;
        }

        case FRBAddressModeStack:
            break;

        default:
            NSLog(@"Internal error: branch opcode with address mode %lu found",
                  opcode->addressMode);
            break;
    }
}

- (NSString *)formatInstruction:(DisasmStruct *)source {

    NSMutableArray *strings = [NSMutableArray new];

    for (int index = 0; index < DISASM_MAX_OPERANDS; index++) {
        ArgFormat format = [self.file formatForArgument:index
                                       atVirtualAddress:source->virtualAddr];
        [strings addObject:[FRBFormatter format:source
                                        operand:index
                                 argumentFormat:format
                                   withServices:self.cpu.services]];
    }

    const struct FRBOpcode *opcode = [self.provider opcodeForByte:source->instruction.userData];
    struct FRBInstruction instruction = FRBInstructions[opcode->type];
    return [FRBFormatter format:opcode->addressMode
                         opcode:[NSString stringWithUTF8String:instruction.name]
                       operands:strings];
}

- (void)setMemoryFlags:(DisasmStruct *)disasm
        forInstruction:(const struct FRBInstruction *)instruction {

    switch (instruction->category) {
        case FRBOpcodeCategoryLoad:
        case FRBOpcodeCategoryComparison:
        case FRBOpcodeCategoryLogical:
        case FRBOpcodeCategoryArithmetic:
            disasm->operand1.accessMode = DISASM_ACCESS_READ;
            break;

        case FRBOpcodeCategoryStore:
        case FRBOpcodeCategoryIncrementDecrement:
        case FRBOpcodeCategoryShifts:
            disasm->operand1.accessMode = DISASM_ACCESS_WRITE;
            break;

        case FRBOpcodeCategoryBlockTransfer:
            disasm->operand1.accessMode = DISASM_ACCESS_READ;
            disasm->operand2.accessMode = DISASM_ACCESS_WRITE;
            break;

        case FRBOpcodeCategoryJumps:
        case FRBOpcodeCategoryStack:
        case FRBOpcodeCategorySystem:
        case FRBOpcodeCategoryBranches:
        case FRBOpcodeCategoryRegisterTransfers:
        case FRBOpcodeCategoryStatusFlagChanges:
        case FRBOpcodeCategoryUnknown:
            break;
    }
}

- (void)updateRegistersMask:(DisasmStruct *)disasm
                  forOpcode:(const struct FRBOpcode *)opcode {
    if (opcode->readRegisters & FRBRegisterCustom || opcode->writtenRegisters & FRBRegisterCustom) {
        return;
    }

    disasm->implicitlyReadRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = opcode->readRegisters;
    disasm->implicitlyWrittenRegisters[DISASM_OPERAND_GENERAL_REG_INDEX] = opcode->writtenRegisters;
}

@end
