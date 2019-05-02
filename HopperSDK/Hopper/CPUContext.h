//
// Hopper Disassembler SDK
//
// (c) Cryptic Apps SARL. All Rights Reserved.
// https://www.hopperapp.com
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//

#import <Foundation/Foundation.h>
#include "DisasmStruct.h"

@protocol HPSegment;
@protocol HPProcedure;
@protocol HPBasicBlock;
@protocol HPDisassembledFile;
@protocol HPASMLine;
@protocol HPCallDestination;
@protocol CPUDefinition;

@class Decompiler;
@class ASTNode;

@protocol CPUContext

- (nonnull NSObject<CPUDefinition> *)cpuDefinition;

- (void)initDisasmStructure:(nonnull DisasmStruct*)disasm withSyntaxIndex:(NSUInteger)syntaxIndex;

////////////////////////////////////////////////////////////////////////////////
//
// Analysis
//
////////////////////////////////////////////////////////////////////////////////

/// Adjust address to the lowest possible address acceptable by the CPU. Example: M68000 instruction must be word aligned, so this method would clear bit 0.
- (Address)adjustCodeAddress:(Address)address;

/// Returns a guessed CPU mode for a given address. Example, ARM processors knows that an instruction is in Thumb mode if bit 0 is 1.
- (uint8_t)cpuModeFromAddress:(Address)address;

/// Returns YES if we know that a given address forces the CPU to use a specific mode. Thumb mode of comment above.
- (BOOL)addressForcesACPUMode:(Address)address;

/// An heuristic to estimate the CPU mode at a given address, not based on the value of the
/// address itself (this is the purpose of the "cpuModeFromAddress:" method), but rather
/// by trying to disassemble a few instruction and see which mode seems to be the best guess.
- (uint8_t)estimateCPUModeAtVirtualAddress:(Address)address;

- (Address)nextAddressToTryIfInstructionFailedToDecodeAt:(Address)address forCPUMode:(uint8_t)mode;

/// Return 0 if the instruction at this address doesn't represent a NOP instruction (or any padding instruction), or the insturction length if any.
- (int)isNopAt:(Address)address;

/// Returns YES if a procedure prolog has been detected at this address.
- (BOOL)hasProcedurePrologAt:(Address)address;

/// Returns the padding size, if any, detected at this address.
/// For instance, on Windows, somes files contains padding between procedures, made of 0xCC bytes (int 3).
/// This method returns the longuest run of 0xCC in that case.
- (NSUInteger)detectedPaddingLengthAt:(Address)address;

/// Notify the plugin that an analysisbegan from an entry point.
/// This could be either a simple disassembling, or a procedure creation.
/// In the latter case, another method will be called to notify the plugin (see below).
- (void)analysisBeginsAt:(Address)entryPoint;
/// Notify the plugin that analysis has ended.
- (void)analysisEnded;

/// A Procedure object is about to be created.
- (void)procedureAnalysisBeginsForProcedure:(nonnull NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint;
/// The prolog of the created procedure is being analyzed.
/// Warning: this method is not called at the begining of the procedure creation, but once all basic blocks
/// have been created.
- (void)procedureAnalysisOfPrologForProcedure:(nonnull NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint;
- (void)procedureAnalysisOfEpilogForProcedure:(nonnull NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint;
- (void)procedureAnalysisEndedForProcedure:(nonnull NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint;

/// A new basic bloc is created
- (void)procedureAnalysisContinuesOnBasicBlock:(nonnull NSObject<HPBasicBlock> *)basicBlock;

/// This method may be called when the internal state of the disassembler should be reseted.
/// For instance, the ARM plugin maintains a state during the disassembly process to
/// track the state of IT blocks. When this method is called, this state is reseted.
- (void)resetDisassembler;

/// Disassemble a single instruction, filling the DisasmStruct structure.
/// Only a few fields are set by Hopper (mainly, the syntaxIndex, the "bytes" field and the virtualAddress of the instruction).
/// The CPU should fill as much information as possible.
- (int)disassembleSingleInstruction:(nonnull DisasmStruct *)disasm usingProcessorMode:(NSUInteger)mode;

/// Returns whether or not an instruction may halt the processor (like the HLT Intel instruction).
- (BOOL)instructionHaltsExecutionFlow:(nonnull DisasmStruct *)disasm;

/// These methods are called to let you update your internal plugin state during the analysis.
- (void)performProcedureAnalysis:(nonnull NSObject<HPProcedure> *)procedure basicBlock:(nonnull NSObject<HPBasicBlock> *)basicBlock disasm:(nonnull DisasmStruct *)disasm;
- (void)updateProcedureAnalysis:(nonnull DisasmStruct *)disasm;

/// Return YES if the provided DisasmStruct represents an instruction that can directly reference a memory address.
/// Ususally, this methods returns YES. This is used by the ARM plugin to avoid false references on "MOVW" instruction
/// for instance.
- (BOOL)instructionCanBeUsedToExtractDirectMemoryReferences:(nonnull DisasmStruct *)disasmStruct;

/// Return YES if the instruction is used to load an address, but will not read, or write at this address.
/// Example: the "LEA" x86 instruction.
- (BOOL)instructionOnlyLoadsAddress:(nonnull DisasmStruct *)disasmStruct;

/// Return YES if the instruction uses float.
- (BOOL)instructionManipulatesFloat:(nonnull DisasmStruct *)disasmStruct;

/// This method is called on branching instruction (like CALL on x86, or BL on ARM).
/// If the instruction conditions the CPU mode of the target address, the method should return YES, and set the cpuMode given in argument.
/// Otherwise, return NO if you don't know if the CPU mode is altered.
- (BOOL)instructionConditionsCPUModeAtTargetAddress:(nonnull DisasmStruct *)disasmStruct resultCPUMode:(nonnull uint8_t *)cpuMode;

/// This method is called during the analysis when the field disasm.instruction.specialFlags.changeNextInstrMode is set in order
/// to determine the future CPU mode for the next instruction.
- (uint8_t)cpuModeForNextInstruction:(nonnull DisasmStruct *)disasmStruct;

/// Return YES if the instruction may be used to build a switch/case statement.
/// For instance, for the Intel processor, it returns YES for the "JMP reg" and the "JMP [xxx+reg*4]" instructions,
/// and for the Am processor, it returns YES for the "TBB" and "TBH" instructions.
- (BOOL)instructionMayBeASwitchStatement:(nonnull DisasmStruct *)disasmStruct;

/// If a branch instruction is found, Hopper calls this method to compute additional destinations of the instruction.
/// The "*next" value is already set to the address which follows the instruction if the jump does not occurs.
/// The "branches" array is filled by NSNumber objects. The values are the addresses where the instruction can jump. Only the
/// jumps that occur in the same procedure are put here (for instance, CALL instruction targets are not put in this array).
/// The "calledAddresses" array is filled by objects conforming to the HPCallDestination protocol of addresses that are
/// the target of a "CALL like" instruction, ie all the jumps which go outside of the procedure.
/// The "callSiteAddresses" contains NSNumber of the addresses of the "CALL" instructions.
/// The purpose of this method is to compute additional destinations.
/// Most of the time, Hopper already found the destinations, so there is no need to do more.
/// This is used by the Intel CPU plugin to compute the destinations of switch/case constructions when it found a "JMP register" instruction.
- (void)performBranchesAnalysis:(nonnull DisasmStruct *)disasm
           computingNextAddress:(nonnull Address *)next
                    andBranches:(nonnull NSMutableArray<NSNumber *> *)branches
                   forProcedure:(nonnull NSObject<HPProcedure> *)procedure
                     basicBlock:(nonnull NSObject<HPBasicBlock> *)basicBlock
                      ofSegment:(nonnull NSObject<HPSegment> *)segment
                calledAddresses:(nonnull NSMutableArray<NSObject<HPCallDestination> *> *)calledAddresses
                      callsites:(nonnull NSMutableArray<NSNumber *> *)callSitesAddresses;

/// If you need a specific analysis, this method will be called once the previous branch analysis is performed.
/// For instance, this is used by the ARM CPU plugin to set the type of the destination of an LDR instruction to
/// an int of the correct size.
- (void)performInstructionSpecificAnalysis:(nonnull DisasmStruct *)disasm forProcedure:(nonnull NSObject<HPProcedure> *)procedure inSegment:(nonnull NSObject<HPSegment> *)segment;

/// Returns the destination address if the function starting at the given address is a thunk (ie: a direct jump to another method)
/// Returns BAD_ADDRESS is the instruction is not a thunk.
- (Address)getThunkDestinationForInstructionAt:(Address)address;

////////////////////////////////////////////////////////////////////////////////
//
// Printing instruction
//
////////////////////////////////////////////////////////////////////////////////

/// Build the complete instruction string in the DisasmStruct structure.
/// This is the string to be displayed in Hopper.
- (nonnull NSObject<HPASMLine> *)buildMnemonicString:(nonnull DisasmStruct *)disasm inFile:(nonnull NSObject<HPDisassembledFile> *)file;
- (nonnull NSObject<HPASMLine> *)buildOperandString:(nonnull DisasmStruct *)disasm forOperandIndex:(NSUInteger)operandIndex inFile:(nonnull NSObject<HPDisassembledFile> *)file raw:(BOOL)raw;
- (nonnull NSObject<HPASMLine> *)buildCompleteOperandString:(nonnull DisasmStruct *)disasm inFile:(nonnull NSObject<HPDisassembledFile> *)file raw:(BOOL)raw;

////////////////////////////////////////////////////////////////////////////////
//
// Decompiler
//
////////////////////////////////////////////////////////////////////////////////

- (BOOL)canDecompileProcedure:(nonnull NSObject<HPProcedure> *)procedure;

/// Return the address of the first instruction of the procedure, after its prolog.
- (Address)skipHeader:(nonnull NSObject<HPBasicBlock> *)basicBlock ofProcedure:(nonnull NSObject<HPProcedure> *)procedure;

/// Return the address of the last instruction of the procedure, before its epilog.
- (Address)skipFooter:(nonnull NSObject<HPBasicBlock> *)basicBlock ofProcedure:(nonnull NSObject<HPProcedure> *)procedure;

/// Decompile an assembly instruction.
/// Note: ASTNode is not publicly exposed yet. You cannot write a decompiler at the moment.
- (nonnull ASTNode *)decompileInstructionAtAddress:(Address)a
                                            disasm:(nonnull DisasmStruct *)d
                                         addNode_p:(nonnull BOOL *)addNode_p
                                   usingDecompiler:(nonnull Decompiler *)decompiler;

////////////////////////////////////////////////////////////////////////////////
//
// Assembler
//
////////////////////////////////////////////////////////////////////////////////

- (nonnull NSData *)assembleRawInstruction:(nonnull NSString *)instr atAddress:(Address)addr forFile:(nonnull NSObject<HPDisassembledFile> *)file withCPUMode:(uint8_t)cpuMode usingSyntaxVariant:(NSUInteger)syntax error:(NSError * _Nullable * _Nullable)error;

@end
