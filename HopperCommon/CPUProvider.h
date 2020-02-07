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

@import Foundation;

#import <Hopper/Hopper.h>

/**
 * Protocol for CPU providers.
 */
@protocol ItFrobHopperCPUProvider <NSObject>

/**
 * Returns the family name for the CPU.
 *
 * @return the family name for the CPU.
 */
+ (NSString *_Nonnull)family;

/**
 * Returns the model name for the CPU.
 *
 * @return the model name for the CPU.
 */
+ (NSString *_Nonnull)model;

/**
 * Returns a flag indicating whether the CPU provider must be enumerated or not.
 *
 * @return YES if the CPU provider should be enumerated, NO otherwise.
 */
+ (BOOL)exported;

/**
 * Returns the address space width, in bits, for the CPU.
 *
 * @return the address space width, in bits, for the CPU.
 */
+ (int)addressSpaceWidth;

@optional

/**
 * Returns a NSData container for the sequence of bytes that are interpreted as
 * a no-operation (NOP) opcode by the CPU.
 *
 * @return the NSData container with the NOP opcode.
 */
+ (NSData *_Nonnull)nopOpcodeSignature;

@required

/**
 * Processes the given disassembly structure.
 *
 * @param[in] structure the structure with the current opcode data, if any.
 * @param[in] file      the currently disassembled file.
 *
 * @return how many bytes have been processed, or DISASM_UNKNOWN_OPCODE.
 */
- (int)processStructure:(DisasmStruct *_Nonnull)structure
                 onFile:(NSObject<HPDisassembledFile> *_Nonnull)file;

/**
 * Checks if the given disassembly structure content halts execution flow
 * or not.
 *
 * @param[in] structure the structure to check.
 *
 * @return YES if the structure content halts execution flow, NO otherwise.
 */
- (BOOL)haltsExecutionFlow:(const DisasmStruct *_Nonnull)structure;

- (NSObject<HPASMLine> *_Nonnull)
    buildMnemonicString:(DisasmStruct *_Nonnull)disasm
                 inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
           withServices:(NSObject<HPHopperServices> *_Nonnull)services;

- (NSObject<HPASMLine> *_Nullable)
    buildOperandString:(DisasmStruct *_Nonnull)disasm
       forOperandIndex:(NSUInteger)operandIndex
                inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                   raw:(BOOL)raw
          withServices:(NSObject<HPHopperServices> *_Nonnull)services;

- (NSObject<HPASMLine> *_Nullable)
    buildCompleteOperandString:(DisasmStruct *_Nonnull)disasm
                        inFile:(NSObject<HPDisassembledFile> *_Nonnull)file
                           raw:(BOOL)raw
                  withServices:(NSObject<HPHopperServices> *_Nonnull)services;

@end
