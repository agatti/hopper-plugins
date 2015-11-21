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

#import "FRBAddressSpace.h"

static NSString *kUnmappedSectionName = @"BSS";

@interface NAMESPACE(AddressSpace) () {
    /*!
     * Hopper Services instance.
     */
    id<HPHopperServices> _services;
}

/*!
 * Adds extra segments to cover the whole address space.
 *
 * @param sender the selector sender, ignored.
 */
- (void)mapWholeAddressSpace:(id)sender;

@end

@implementation NAMESPACE(AddressSpace)

- (id<HopperPlugin>)initWithHopperServices:(id<HPHopperServices>)services {
    if (self = [super init]) {
        _services = services;
    }

    return self;
}

- (NSArray *)toolMenuDescription {
    return @[
        @{
            HPM_TITLE : @"Map whole address space",
            HPM_SELECTOR : NSStringFromSelector(@selector(mapWholeAddressSpace:))
        }
    ];
}

- (HopperUUID *)pluginUUID {
    return [_services UUIDWithString:@"FD1B7A50-7264-11E4-82F8-0800200C9A66"];
}

- (HopperPluginType)pluginType {
    return Plugin_Tool;
}

- (NSString *)pluginName {
    return @"Address Space";
}

- (NSString *)pluginDescription {
    return @"Address space manipulation tools";
}

- (NSString *)pluginAuthor {
    return @"Alessandro Gatti";
}

- (NSString *)pluginCopyright {
    return @"©2014-2015 Alessandro Gatti";
}

- (NSString *)pluginVersion {
    return @"0.0.1";
}

- (void)mapWholeAddressSpace:(id)sender {
    NSObject<HPDocument> *document = [_services currentDocument];

    // Tool plugins can still be invoked with no file being loaded.

    if (!document) {
        return;
    }

    NSObject<HPDisassembledFile> *file = document.disassembledFile;
    NSUInteger addressSpaceEnd = 1 << file.addressSpaceWidthInBits;
    [document beginToWait:[NSString stringWithFormat:@"Mapping address space (%ld bytes)...", addressSpaceEnd]];

    NSUInteger currentAddress = 0;

    NSArray *existingSegments = [file.segments copy];

    for (NSObject<HPSegment> *segment in existingSegments) {
        if (segment.startAddress > currentAddress) {
            [file addSegmentAt:currentAddress
             toExcludedAddress:segment.startAddress].segmentName = kUnmappedSectionName;
        }

        currentAddress = segment.endAddress;
    }

    if (currentAddress < addressSpaceEnd) {
        [file addSegmentAt:currentAddress
         toExcludedAddress:addressSpaceEnd].segmentName = kUnmappedSectionName;
    }

    [document endWaiting];
}

@end
