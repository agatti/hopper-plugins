/*
 Copyright (c) 2014-2015, Alessandro Gatti - frob.it
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

/*
 According to Apple documentation ("Code Loading Programming Topics"):

 <quote>
 Categories

 Plug-ins should avoid using Objective-C categories to override methods of
 classes in public frameworks. If multiple plug-ins attempt to override the
 same method of the same class, only one override takes effect, leading to
 unpredictable behavior.
 </quote>

 Therefore, the functions located here are not in a NSData/NSMutableData
 category of their own.
 */

/*!
 * Returns a NSData object with the given size and filled with the chosen
 * filler byte.
 *
 * @param filler the filler byte.
 * @param length the length.
 *
 * @return a NSData instance using the given filler or nil if there is no
 *         memory.
 */
NSData *NSDataWithFiller(const uint8_t filler, NSUInteger length);

/*!
 * Returns a NSMutableData object with the given size and filled with the
 * chosen filler byte.
 *
 * @param filler the filler byte.
 * @param length the length.
 *
 * @return a NSMutableData instance using the given filler or nil if there is
 *         no memory.
 */
NSMutableData *NSMutableDataWithFiller(const uint8_t filler, NSUInteger length);
