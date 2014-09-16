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

#import "FRBContext.h"
#import "FRBDefinition.h"
#import "FRBModelHandler.h"
#import "FRBProvider.h"

// HopperCommon library imports

#import "FRBHopperCommon.h"

static const ItFrobHopper8x300ModelHandler *kModelHandler;

@interface ItFrobHopper8x300Context () {
    id<CPUDefinition> _cpu;
    id<HPDisassembledFile> _file;
    id<HPHopperServices> _services;
    id<FRBProvider> _provider;
}
@end

@implementation ItFrobHopper8x300Context

- (instancetype)initWithCPU:(id<CPUDefinition>)cpu
                    andFile:(id<HPDisassembledFile>)file
               withServices:(id<HPHopperServices>)services {
    if (self = [super init]) {
        _cpu = cpu;
        _file = file;
        _services = services;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kModelHandler = [ItFrobHopper8x300ModelHandler sharedModelHandler];
        });

        NSString *providerName = [kModelHandler providerNameForFamily:file.cpuFamily
                                                         andSubFamily:file.cpuSubFamily];
        _provider = [kModelHandler providerForName:providerName];

        if (!_provider) {
            return nil;
        }
    }
    return self;
}

- (id<CPUDefinition>)cpuDefinition {
    return _cpu;
}

- (Address)adjustCodeAddress:(Address)address {
    return address & ~1;
}

- (Address)nextAddressToTryIfInstructionFailedToDecodeAt:(Address)address
                                              forCPUMode:(uint8_t)mode {
    return (address & ~1) + 2;
}

- (int)disassembleSingleInstruction:(DisasmStruct *)disasm
                 usingProcessorMode:(NSUInteger)mode {
    disasm->instruction.pcRegisterValue = disasm->virtualAddr;
    return [_provider processStructure:disasm
                                onFile:_file];
}

- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
    return [_provider haltsExecutionFlow:disasm];
}

- (void)buildInstructionString:(DisasmStruct *)disasm
                    forSegment:(NSObject<HPSegment> *)segment
                populatingInfo:(NSObject<HPFormattedInstructionInfo> *)formattedInstructionInfo {
    strcat(disasm->completeInstructionString, [_provider formatInstruction:disasm
                                                                    onFile:_file
                                                              withServices:_services]);
}

@end
