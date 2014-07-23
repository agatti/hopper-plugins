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
#import "FRBGeneric65c02.h"
#import "FRBGeneric65c02Table.h"
#import "FRBModelHandler.h"

@implementation FRBGeneric65C02

static NSString * const FRBProviderName = @"it.frob.hopper.generic65c02";

@synthesize name;
@synthesize usesTFlag;

- (instancetype)init {
    if (self = [super init]) {
        name = FRBProviderName;
        usesTFlag = NO;
    }

    return self;
}

+ (void)load {
    [[FRBModelHandler sharedModelHandler] registerProvider:[FRBGeneric65C02 class]
                                                   forName:FRBProviderName];
}

- (const struct FRBOpcode *)opcodeForByte:(uint8_t)byte {
    return &FRBGeneric65C02OpcodeTable[byte];
}

- (BOOL)haltsExecutionFlow:(const struct FRBOpcode *)opcode {
    return opcode->type == FRBOpcodeTypeBRK;
}

@end


