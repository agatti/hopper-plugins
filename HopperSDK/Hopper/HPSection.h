//
// Hopper Disassembler SDK
//
// (c) Cryptic Apps SARL. All Rights Reserved.
// https://www.hopperapp.com
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//

#import "CommonTypes.h"

@protocol HPSegment;

@protocol HPSection

@property (nonatomic, nullable, copy) NSString *sectionName;

@property (nonatomic, assign) uint64_t fileOffset;
@property (nonatomic, assign) uint64_t fileLength;

@property (nonatomic, assign) BOOL pureCodeSection;
@property (nonatomic, assign) BOOL pureDataSection;
@property (nonatomic, assign) BOOL containsCode;
@property (nonatomic, assign) BOOL pureCStringSection;
@property (nonatomic, assign) BOOL zeroFillSection;

@property (nonatomic, assign) uint64_t  flags;

- (NSInteger)sectionIndex;

- (Address)startAddress;
- (size_t)length;

- (Address)endAddress;

- (BOOL)hasDataOnDisk;

- (nonnull NSObject<HPSegment> *)segment;
- (nullable NSObject<HPSection> *)previousSection;
- (nullable NSObject<HPSection> *)nextSection;

- (BOOL)sectionContainsAddress:(Address)address;

@end
