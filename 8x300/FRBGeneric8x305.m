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
#import "FRBGeneric8x305.h"
#import "FRBModelHandler.h"

@interface ItFrobHopper8x300Generic8x305 ()

- (BOOL)isValidALUOpcode:(uint16_t)opcode;

@end

@implementation ItFrobHopper8x300Generic8x305

static NSString * const kProviderName = @"it.frob.hopper.generic8x305";

@synthesize name;

- (instancetype)init {
    if (self = [super init]) {
        name = kProviderName;
    }

    return self;
}

+ (void)load {
    [[ItFrobHopper8x300ModelHandler sharedModelHandler] registerProvider:[ItFrobHopper8x300Generic8x305 class]
                                                                 forName:kProviderName];
}

#pragma mark - Private methods

- (BOOL)isValidALUOpcode:(uint16_t)opcode {
    int destinationRegister = opcode & 0x001F;

    switch (opcode & 0x1010) {
        case 0x0000:

            // Register to Register

            if (destinationRegister == FRB8x300RegisterOVF) {
                return NO;
            }
            break;

        case 0x1000:

            // I/O bus to register

            if (destinationRegister == FRB8x300RegisterOVF) {
                return NO;
            }
            break;
            
        default:
            break;
    }
    
    return YES;

}

#pragma mark - Opcode handlers

- (BOOL)handleMOVEOpcode:(uint16_t)opcode
            forStructure:(DisasmStruct *)structure
                  onFile:(id<HPDisassembledFile>)file {
    if (![self isValidALUOpcode:opcode]) {
        return NO;
    }

    return [super handleMOVEOpcode:opcode
                      forStructure:structure
                            onFile:file];
}

- (BOOL)handleADDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    if (![self isValidALUOpcode:opcode]) {
        return NO;
    }

    return [super handleADDOpcode:opcode
                     forStructure:structure
                           onFile:file];
}

- (BOOL)handleANDOpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    if (![self isValidALUOpcode:opcode]) {
        return NO;
    }

    return [super handleANDOpcode:opcode
                     forStructure:structure
                           onFile:file];
}

- (BOOL)handleXOROpcode:(uint16_t)opcode
           forStructure:(DisasmStruct *)structure
                 onFile:(id<HPDisassembledFile>)file {
    if (![self isValidALUOpcode:opcode]) {
        return NO;
    }

    return [super handleXOROpcode:opcode
                     forStructure:structure
                           onFile:file];
}

@end
