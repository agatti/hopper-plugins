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

#import <Foundation/Foundation.h>

/*!
 *	Protocol for CPU providers.
 */
@protocol FRBCPUProvider <NSObject>

/*!
 * Provider name.
 */
@property (strong, nonatomic, readonly) NSString *name;

/*!
 *	Processes the given disassembly structure.
 *
 *	@param structure the structure with the current opcode data, if any.
 *  @param file      the currently disassembled file.
 *
 *	@return how many bytes have been processed, or DISASM_UNKNOWN_OPCODE.
 */
- (int)processStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file;

/*!
 *	Checks if the given disassembly structure content halts execution flow
 *  or not.
 *
 *	@param structure the structure to check.
 *
 *	@return YES if the structure content halts execution flow, NO otherwise.
 */
- (BOOL)haltsExecutionFlow:(const DisasmStruct *)structure;

/*!
 *	Creates an assemblable representation of the given disassembly structure.
 *
 *	@param structure the structure with the current opcode data, if any.
 *  @param file      the currently disassembled file.
 *	@param services  the shared Hopper services instance.
 */
- (void)formatInstruction:(DisasmStruct *)structure
                   onFile:(id<HPDisassembledFile>)file
             withServices:(id<HPHopperServices>)services;
@end
