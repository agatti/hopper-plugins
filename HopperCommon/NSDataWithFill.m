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

#import "NSDataWithFill.h"

/**
 * Creates a NSMutableData object filled with the given byte.
 *
 * @param[in] filler the filler byte to use.
 * @param[in] length how many bytes to write.
 *
 * @return a filled NSMutableData object or nil if there is no memory available.
 */
static NSMutableData *_Nullable newDataForFillerByte(const uint8_t filler,
                                                     NSUInteger length);

/**
 * Creates a NSMutableData object filled with the given byte sequence.
 *
 * @param[in] filler the filler object to use.
 * @param[in] length how many bytes to write.
 *
 * @return a filled NSMutableData object or nil if there is no memory available
 * or if the requested length does not match the filler length.
 */
static NSMutableData *_Nullable newDataForFillerData(
    const NSData *_Nonnull data, NSUInteger length);

NSData *_Nullable NSDataWithFiller(const uint8_t filler, NSUInteger length) {
  return newDataForFillerByte(filler, length);
}

NSMutableData *_Nullable NSMutableDataWithFiller(const uint8_t filler,
                                                 NSUInteger length) {
  return newDataForFillerByte(filler, length);
}

NSData *_Nullable NSDataWithFillerData(const NSData *_Nonnull data,
                                       NSUInteger length) {
  return newDataForFillerData(data, length);
}

NSMutableData *_Nullable NSMutableDataWithFillerData(
    const NSData *_Nonnull data, NSUInteger length) {
  return newDataForFillerData(data, length);
}

NSMutableData *_Nullable newDataForFillerByte(const uint8_t filler,
                                              NSUInteger length) {
  NSMutableData *data = [[NSMutableData alloc] initWithCapacity:length];
  if (data) {
    memset(data.mutableBytes, filler, length);
  }
  return data;
}

NSMutableData *_Nullable newDataForFillerData(const NSData *_Nonnull data,
                                              NSUInteger length) {
  NSMutableData *target = [[NSMutableData alloc] initWithCapacity:length];
  if (target && ((length % data.length) == 0)) {
    NSUInteger rounds = length / data.length;
    for (size_t index = 0; index < rounds; index++) {
      [target appendData:(NSData * _Nonnull) data];
    }
  }

  return target;
}
