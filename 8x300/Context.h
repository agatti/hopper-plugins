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

@import Foundation;

#import <Hopper/Hopper.h>

#import "BaseContext.h"
#import "CPUProvider.h"

/**
 * CPU Context class for the 8x300 disassembler plugin.
 */
@interface ItFrobHopper8x300Context
    : ItFrobHopperBaseContext <CPUContext>

/**
 * Creates an instance of the 8x300 CPU disassembler context.
 *
 * @param[in] definition the CPU definition instance.
 * @param[in] file       the file to disassemble data from.
 * @param[in] provider   the CPU disassembly provider instance.
 * @param[in] services   the Hopper Services instance.
 *
 * @return an instance of ItFrobHopper8x300Context.
 */
- (instancetype _Nonnull)
  initWithCPU:(NSObject<CPUDefinition> *_Nonnull)definition
      andFile:(NSObject<HPDisassembledFile> *_Nonnull)file
 withProvider:(NSObject<ItFrobHopperCPUProvider> *_Nonnull)provider
usingServices:(NSObject<HPHopperServices> *_Nonnull)services;

@end
