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
 *  The instruction colouriser shared amongst all 65xx plugins.
 */
@interface ItFrobHopper65xxCommonInstructionColouriser : NSObject

/*!
 *	Initialises an instance of the instruction colouriser with the given data.
 *
 *	@param validOpcodes a list of valid opcodes for the CPU in use.
 *	@param services     a reference to HPHopperService to fetch theme colours.
 *
 *	@return an initialised instance of the instruction colouriser.
 */
- (instancetype)initWithOpcodesSet:(const NSSet *)validOpcodes
                       andServices:(id<HPHopperServices>)services;

/*!
 *	Colourises the given string.
 *
 *	@param source an attributed string containing the text to colourise.
 *
 *	@return the colourised string, or the original string in case of problems.
 */
- (NSAttributedString *)colouriseInstruction:(NSAttributedString *)source;

@end
