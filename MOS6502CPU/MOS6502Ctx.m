/*!
 Copyright (c) 2014, Alessandro Gatti
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

#import "MOS6502Ctx.h"
#import "MOS6502Opcodes.h"

@interface MOS6502Ctx()

- (void)handleNonBranchOpcode:(const struct MOS6502Opcode *)opcode
                    forDisasm:(DisasmStruct *)disasm;
- (void)handleBranchOpcode:(const struct MOS6502Opcode *)opcode
                 forDisasm:(DisasmStruct *)disasm;
+ (NSString *)valueAsHexadecimal:(DisasmStruct *)disasm
                 forOperandIndex:(size_t)operand
                        isSigned:(BOOL)isSigned;
+ (NSString *)valueAsDecimal:(DisasmStruct *)disasm
             forOperandIndex:(size_t)operand
                    isSigned:(BOOL)isSigned;
+ (NSString *)valueAsOctal:(DisasmStruct *)disasm
           forOperandIndex:(size_t)operand;
+ (NSString *)valueAsBinary:(DisasmStruct *)disasm
            forOperandIndex:(size_t)operand;
+ (NSString *)convertToBinary:(uint64_t)value
                   sizeInBits:(size_t)bits;

@end

@implementation MOS6502Ctx {
    MOS6502CPU *_cpu;
    NSObject<HPDisassembledFile> *_file;
}

- (instancetype)initWithCPU:(MOS6502CPU *)cpu
                    andFile:(NSObject<HPDisassembledFile> *)file {
    if (self = [super init]) {
        _cpu = cpu;
        _file = file;
    }
    return self;
}

- (NSObject<CPUContext> *)cloneContext {
    return [[MOS6502Ctx alloc] initWithCPU:_cpu
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

    struct MOS6502Opcode opcode = kOpcodes[opcodeByte];
    disasm->instruction.userData = opcodeByte;
    if (opcode.addressMode == MOS6502AddressModeUnknown) {
        return DISASM_UNKNOWN_OPCODE;
    }

    disasm->instruction.branchType = opcode.branchType;

    if (opcode.branchType == DISASM_BRANCH_NONE) {
        [self handleNonBranchOpcode:&opcode
                          forDisasm:disasm];
    } else {
        [self handleBranchOpcode:&opcode
                       forDisasm:disasm];
    }

    const char *name = kOpcodeNames[opcode.type];
    strcpy(disasm->instruction.mnemonic, name);
    strcpy(disasm->instruction.unconditionalMnemonic, name);

    if (opcode.opcodeCategory == MOS6502OpcodeCategoryStatusFlagChanges) {
        switch (opcode.type) {
            case MOS6502OpcodeTypeCLC:
                disasm->instruction.eflags.CF_flag = DISASM_EFLAGS_RESET;
                break;

            case MOS6502OpcodeTypeCLD:
                disasm->instruction.eflags.DF_flag = DISASM_EFLAGS_RESET;
                break;

            case MOS6502OpcodeTypeCLI:
                disasm->instruction.eflags.IF_flag = DISASM_EFLAGS_RESET;
                break;

            case MOS6502OpcodeTypeCLV:
                disasm->instruction.eflags.OF_flag = DISASM_EFLAGS_RESET;
                break;

            case MOS6502OpcodeTypeSEC:
                disasm->instruction.eflags.CF_flag = DISASM_EFLAGS_SET;
                break;

            case MOS6502OpcodeTypeSED:
                disasm->instruction.eflags.DF_flag = DISASM_EFLAGS_SET;
                break;

            case MOS6502OpcodeTypeSEI:
                disasm->instruction.eflags.IF_flag = DISASM_EFLAGS_SET;
                break;
                
            default:
                break;
        }
    }

    switch (opcode.addressMode) {
        case MOS6502AddressModeAbsolute:
        case MOS6502AddressModeAbsoluteXIndexed:
        case MOS6502AddressModeAbsoluteYIndexed:
        case MOS6502AddressModeIndirect:
            disasm->instruction.length = 3;
            return 3;

        case MOS6502AddressModeImmediate:
        case MOS6502AddressModeIndirectXIndexed:
        case MOS6502AddressModeIndirectYIndexed:
        case MOS6502AddressModeRelative:
        case MOS6502AddressModeZeropage:
        case MOS6502AddressModeZeropageXIndexed:
        case MOS6502AddressModeZeropageYIndexed:
            disasm->instruction.length = 2;
            return 2;

        default:
            disasm->instruction.length = 1;
            return 1;
    }
}

- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
    return kOpcodes[disasm->instruction.userData].type == MOS6502OpcodeTypeBRK;
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
    const char *spaces = "    ";
    strcpy(disasm->completeInstructionString, disasm->instruction.mnemonic);
    strcat(disasm->completeInstructionString, spaces + strlen(disasm->instruction.mnemonic));
    ArgFormat format = [_file formatForArgument:0
                               atVirtualAddress:disasm->virtualAddr];
    NSString *formatted = [MOS6502Ctx formatInstruction:disasm
                                       withOperandIndex:0
                                             withFormat:format];
    strcpy(disasm->operand1.mnemonic, formatted.UTF8String);
    strcat(disasm->completeInstructionString, formatted.UTF8String);
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

- (void) handleNonBranchOpcode:(const struct MOS6502Opcode *)opcode
                     forDisasm:(DisasmStruct *)disasm {
    uint16_t operand = 0;

    switch (opcode->addressMode) {
        case MOS6502AddressModeAbsolute:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = operand;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 0;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 16;
            disasm->operand1.immediateValue = operand;
            break;

        case MOS6502AddressModeAbsoluteXIndexed:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = operand;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 1;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 16;
            disasm->operand1.immediateValue = operand;
            break;

        case MOS6502AddressModeAbsoluteYIndexed:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = operand;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 2;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 16;
            disasm->operand1.immediateValue = operand;
            break;

        case MOS6502AddressModeImmediate:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE;
            disasm->operand1.immediateValue = operand;
            disasm->operand1.size = 8;
            break;

        case MOS6502AddressModeIndirect:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = operand;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 0;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 16;
            disasm->operand1.immediateValue = operand;
            break;

        case MOS6502AddressModeIndirectXIndexed:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = operand;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 1;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case MOS6502AddressModeIndirectYIndexed:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->operand1.memory.baseRegister = operand;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 2;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case MOS6502AddressModeZeropage:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE;
            disasm->operand1.memory.baseRegister = operand;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 0;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case MOS6502AddressModeZeropageXIndexed:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE;
            disasm->operand1.memory.baseRegister = operand;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 1;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case MOS6502AddressModeZeropageYIndexed:
            operand = [_file readUInt8AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE;
            disasm->operand1.memory.baseRegister = operand;
            disasm->operand1.memory.displacement = 0;
            disasm->operand1.memory.indexRegister = 2;
            disasm->operand1.memory.scale = 1;
            disasm->operand1.size = 8;
            disasm->operand1.immediateValue = operand;
            break;

        case MOS6502AddressModeImplied:
            break;

        default:
            NSLog(@"Internal error: non-branch opcode with address mode %lu found",
                  opcode->addressMode);
            break;
    }

    disasm->operand1.accessMode = DISASM_ACCESS_NONE;

    if (opcode->addressMode != MOS6502AddressModeImmediate &&
        opcode->addressMode != MOS6502AddressModeRelative &&
        opcode->addressMode != MOS6502AddressModeImplied) {

        switch (opcode->opcodeCategory) {
            case MOS6502OpcodeCategoryLoad:
            case MOS6502OpcodeCategoryComparison:
            case MOS6502OpcodeCategoryLogical:
            case MOS6502OpcodeCategoryArithmetic:
                disasm->operand1.accessMode = DISASM_ACCESS_READ;
                break;

            case MOS6502OpcodeCategoryStore:
            case MOS6502OpcodeCategoryIncrementDecrement:
            case MOS6502OpcodeCategoryShifts:
                disasm->operand1.accessMode = DISASM_ACCESS_WRITE;
                break;

            case MOS6502OpcodeCategoryJumps:
            case MOS6502OpcodeCategoryStack:
            case MOS6502OpcodeCategorySystem:
            case MOS6502OpcodeCategoryBranches:
            case MOS6502OpcodeCategoryRegisterTransfers:
            case MOS6502OpcodeCategoryStatusFlagChanges:
            case MOS6502OpcodeCategoryUnknown:
                break;
        }
    }
}

- (void) handleBranchOpcode:(const struct MOS6502Opcode *)opcode
                  forDisasm:(DisasmStruct *)disasm {
    uint16_t operand = 0;

    switch (opcode->addressMode) {
        case MOS6502AddressModeAbsolute:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_ABSOLUTE;
            disasm->instruction.addressValue = operand;
            disasm->operand1.immediateValue = operand;
            disasm->operand1.size = 16;
            break;

        case MOS6502AddressModeIndirect:
            operand = [_file readUInt16AtVirtualAddress:disasm->virtualAddr + 1];
            disasm->operand1.type = DISASM_OPERAND_MEMORY_TYPE | DISASM_OPERAND_RELATIVE;
            disasm->instruction.addressValue = operand;
            disasm->operand1.immediateValue = operand;
            disasm->operand1.size = 16;
            break;

        case MOS6502AddressModeRelative:
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

        case MOS6502AddressModeImplied:
            break;

        default:
            NSLog(@"Internal error: branch opcode with address mode %lu found",
                  opcode->addressMode);
            break;
    }
}

+ (NSString *)formatInstruction:(DisasmStruct *)disasm
               withOperandIndex:(size_t)operand
                     withFormat:(ArgFormat)format {

    switch ((int) format) {
        case Format_Hexadecimal | Format_Signed:
            return [MOS6502Ctx valueAsHexadecimal:disasm
                                  forOperandIndex:operand
                                         isSigned:YES];

        case Format_Hexadecimal:
            return [MOS6502Ctx valueAsHexadecimal:disasm
                                  forOperandIndex:operand
                                         isSigned:NO];

        case Format_Decimal | Format_Signed:
            return [MOS6502Ctx valueAsDecimal:disasm
                              forOperandIndex:operand
                                     isSigned:YES];

        case Format_Decimal:
            return [MOS6502Ctx valueAsDecimal:disasm
                              forOperandIndex:operand
                                     isSigned:NO];

        case Format_Octal:
            return [MOS6502Ctx valueAsOctal:disasm
                            forOperandIndex:operand];

        case Format_Binary:
            return [MOS6502Ctx valueAsBinary:disasm
                             forOperandIndex:operand];

        default:
            return [MOS6502Ctx valueAsHexadecimal:disasm
                                  forOperandIndex:operand
                                         isSigned:NO];
    }
}

+ (NSString *)valueAsHexadecimal:(DisasmStruct *)disasm
                 forOperandIndex:(size_t)operand
                        isSigned:(BOOL)isSigned {
    if (disasm->operand[operand].type == DISASM_OPERAND_NO_OPERAND) {
        return @"";
    }

    int64_t operandValue = disasm->operand[operand].immediateValue;
    int64_t value;
    BOOL negative;
    if (operandValue & (1 << (disasm->operand[operand].size - 1)) && isSigned) {
        value = ~operandValue + 1;
        negative = YES;
    } else {
        value = operandValue;
        negative = NO;
    }

    switch (kOpcodes[disasm->instruction.userData].addressMode) {
        case MOS6502AddressModeAbsolute:
        case MOS6502AddressModeRelative:
            return [NSString stringWithFormat:@"%@$%04X",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeAbsoluteXIndexed:
            return [NSString stringWithFormat:@"%@$%04X,X",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeAbsoluteYIndexed:
            return [NSString stringWithFormat:@"%@$%04X,Y",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeImmediate:
        case MOS6502AddressModeZeropage:
            return [NSString stringWithFormat:@"#%@$%02X",
                    negative ? @"-" : @"", (uint8_t) (value & 0xFF)];

        case MOS6502AddressModeIndirect:
            return [NSString stringWithFormat:@"(%@$%04X)",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeIndirectXIndexed:
            return [NSString stringWithFormat:@"(%@$%02X,X)",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFF)];

        case MOS6502AddressModeIndirectYIndexed:
            return [NSString stringWithFormat:@"(%@$%02X),Y",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFF)];

        case MOS6502AddressModeZeropageXIndexed:
            return [NSString stringWithFormat:@"#%@$%02X,X",
                    negative ? @"-" : @"", (uint8_t) (value & 0xFF)];

        case MOS6502AddressModeZeropageYIndexed:
            return [NSString stringWithFormat:@"#%@$%02X,Y",
                    negative ? @"-" : @"", (uint8_t) (value & 0xFF)];

        case MOS6502AddressModeUnknown:
        case MOS6502AddressModeImplied:
        default:
            return @"";
    }
}

+ (NSString *)valueAsDecimal:(DisasmStruct *)disasm
             forOperandIndex:(size_t)operand
                    isSigned:(BOOL)isSigned {
    if (disasm->operand[operand].type == DISASM_OPERAND_NO_OPERAND) {
        return @"";
    }

    int64_t operandValue = disasm->operand[operand].immediateValue;
    int64_t value;
    BOOL negative;
    if (operandValue & (1 << (disasm->operand[operand].size - 1)) && isSigned) {
        value = ~operandValue + 1;
        negative = YES;
    } else {
        value = operandValue;
        negative = NO;
    }

    switch (kOpcodes[disasm->instruction.userData].addressMode) {
        case MOS6502AddressModeAbsolute:
        case MOS6502AddressModeRelative:
            return [NSString stringWithFormat:@"%@%d",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeAbsoluteXIndexed:
            return [NSString stringWithFormat:@"%@%d,X",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeAbsoluteYIndexed:
            return [NSString stringWithFormat:@"%@%d,Y",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeImmediate:
        case MOS6502AddressModeZeropage:
            return [NSString stringWithFormat:@"#%@%d",
                    negative ? @"-" : @"", (uint8_t) (value & 0xFF)];

        case MOS6502AddressModeIndirect:
            return [NSString stringWithFormat:@"(%@%d)",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeIndirectXIndexed:
            return [NSString stringWithFormat:@"(%@%d,X)",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFF)];

        case MOS6502AddressModeIndirectYIndexed:
            return [NSString stringWithFormat:@"(%@%d),Y",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFF)];

        case MOS6502AddressModeZeropageXIndexed:
            return [NSString stringWithFormat:@"#%@%d,X",
                    negative ? @"-" : @"", (uint8_t) (value & 0xFF)];

        case MOS6502AddressModeZeropageYIndexed:
            return [NSString stringWithFormat:@"#%@%d,Y",
                    negative ? @"-" : @"", (uint8_t) (value & 0xFF)];

        case MOS6502AddressModeUnknown:
        case MOS6502AddressModeImplied:
        default:
            return @"";
    }
}

+ (NSString *)valueAsOctal:(DisasmStruct *)disasm
           forOperandIndex:(size_t)operand {
    if (disasm->operand[operand].type == DISASM_OPERAND_NO_OPERAND) {
        return @"";
    }

    int64_t operandValue = disasm->operand[operand].immediateValue;
    int64_t value;
    BOOL negative;
    if (operandValue & (1 << (disasm->operand[operand].size - 1))) {
        value = ~operandValue + 1;
        negative = YES;
    } else {
        value = operandValue;
        negative = NO;
    }

    switch (kOpcodes[disasm->instruction.userData].addressMode) {
        case MOS6502AddressModeAbsolute:
        case MOS6502AddressModeRelative:
            return [NSString stringWithFormat:@"%@%oo",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeAbsoluteXIndexed:
            return [NSString stringWithFormat:@"%@%oo,X",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeAbsoluteYIndexed:
            return [NSString stringWithFormat:@"%@%oo,Y",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeImmediate:
        case MOS6502AddressModeZeropage:
            return [NSString stringWithFormat:@"#%@%oo",
                    negative ? @"-" : @"", (uint8_t) (value & 0xFF)];

        case MOS6502AddressModeIndirect:
            return [NSString stringWithFormat:@"(%@%oo)",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFFFF)];

        case MOS6502AddressModeIndirectXIndexed:
            return [NSString stringWithFormat:@"(%@%oo,X)",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFF)];

        case MOS6502AddressModeIndirectYIndexed:
            return [NSString stringWithFormat:@"(%@%oo),Y",
                    negative ? @"-" : @"", (uint16_t) (value & 0xFF)];

        case MOS6502AddressModeZeropageXIndexed:
            return [NSString stringWithFormat:@"#%@%oo,X",
                    negative ? @"-" : @"", (uint8_t) (value & 0xFF)];

        case MOS6502AddressModeZeropageYIndexed:
            return [NSString stringWithFormat:@"#%@%oo,Y",
                    negative ? @"-" : @"", (uint8_t) (value & 0xFF)];

        case MOS6502AddressModeUnknown:
        case MOS6502AddressModeImplied:
        default:
            return @"";
    }
}

+ (NSString *)valueAsBinary:(DisasmStruct *)disasm
            forOperandIndex:(size_t)operand {
    if (disasm->operand[operand].type == DISASM_OPERAND_NO_OPERAND) {
        return @"";
    }

    int64_t operandValue = disasm->operand[operand].immediateValue &
        ((1 << disasm->operand[operand].size) - 1);
    NSString *binaryValue = [MOS6502Ctx convertToBinary:operandValue
                                             sizeInBits:disasm->operand[operand].size];

    switch (kOpcodes[disasm->instruction.userData].addressMode) {
        case MOS6502AddressModeAbsolute:
        case MOS6502AddressModeRelative:
            return [NSString stringWithFormat:@"%%%@", binaryValue];

        case MOS6502AddressModeAbsoluteXIndexed:
            return [NSString stringWithFormat:@"%%%@,X", binaryValue];

        case MOS6502AddressModeAbsoluteYIndexed:
            return [NSString stringWithFormat:@"%%%@,Y", binaryValue];

        case MOS6502AddressModeImmediate:
        case MOS6502AddressModeZeropage:
            return [NSString stringWithFormat:@"#%%%@", binaryValue];

        case MOS6502AddressModeIndirect:
            return [NSString stringWithFormat:@"(%%%@)", binaryValue];

        case MOS6502AddressModeIndirectXIndexed:
            return [NSString stringWithFormat:@"(%%%@,X)", binaryValue];

        case MOS6502AddressModeIndirectYIndexed:
            return [NSString stringWithFormat:@"(%%%@),Y", binaryValue];

        case MOS6502AddressModeZeropageXIndexed:
            return [NSString stringWithFormat:@"#%%%@,X", binaryValue];

        case MOS6502AddressModeZeropageYIndexed:
            return [NSString stringWithFormat:@"#%%%@,Y", binaryValue];

        case MOS6502AddressModeUnknown:
        case MOS6502AddressModeImplied:
        default:
            return @"";
    }
}

+ (NSString *)convertToBinary:(uint64_t)value
                   sizeInBits:(size_t)bits {
    NSMutableString *output = [NSMutableString new];
    long startBit = bits - 1;
    BOOL firstBitSet = NO;
    while (startBit >= 0) {
        BOOL bitSet = (value & (1 << startBit)) == (1 << startBit);
        startBit--;
        if (bitSet) {
            firstBitSet = YES;
        } else {
            if (!firstBitSet) {
                continue;
            }
        }

        [output appendFormat:@"%c", bitSet ? '1' : '0' ];
    }

    if (output.length == 0) {
        [output appendFormat:@"0"];
    }

    return output;
}

@end
