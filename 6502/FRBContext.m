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
#import "FRBModelHandler.h"
#import "FRBCPUProvider.h"

/*!
 *	CPU type and subtype model handler.
 */
static const ItFrobHopper6502ModelHandler *kModelHandler;

@interface ItFrobHopper6502Context () {
    id<CPUDefinition> _cpu;
    id<HPDisassembledFile> _file;
    id<FRBCPUProvider> _provider;
    id<HPHopperServices> _services;
}
@end

@implementation ItFrobHopper6502Context

- (instancetype)initWithCPU:(id<CPUDefinition>)cpu
                    andFile:(id<HPDisassembledFile>)file
               withServices:(id<HPHopperServices>)services {
    if (self = [super init]) {
        _cpu = cpu;
        _file = file;
        _services = services;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kModelHandler = [ItFrobHopper6502ModelHandler sharedModelHandler];
        });

        _provider = [kModelHandler providerForName:[kModelHandler providerNameForFamily:file.cpuFamily
                                                                           andSubFamily:file.cpuSubFamily]];

        if (!_provider) {
            return nil;
        }
    }
    return self;
}

#pragma mark - CPUContext methods

- (id<CPUDefinition>)cpuDefinition {
    return _cpu;
}

- (int)disassembleSingleInstruction:(DisasmStruct *)disasm
                 usingProcessorMode:(NSUInteger)mode {
    return [_provider processStructure:disasm
                                onFile:_file];
}

- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
    return [_provider haltsExecutionFlow:disasm];
}

- (void)buildInstructionString:(DisasmStruct *)disasm
                    forSegment:(id<HPSegment>)segment
                populatingInfo:(id<HPFormattedInstructionInfo>)formattedInstructionInfo {
    [_provider formatInstruction:disasm
                          onFile:_file
                    withServices:_services];
}

@end