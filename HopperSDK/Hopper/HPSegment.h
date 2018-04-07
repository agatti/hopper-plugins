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

@protocol HPSection;
@protocol HPProcedure;

@protocol HPSegment

@property (nonatomic, copy) NSString *segmentName;

@property (nonatomic, assign) uint64_t fileOffset;
@property (nonatomic, assign) uint64_t fileLength;
@property (nonatomic, assign) uint64_t flags;

@property (nonatomic, assign) BOOL readable, writable, executable;

- (NSUInteger)segmentIndex;

- (BOOL)hasMappedData;
- (NSData *)mappedData;
- (void)setMappedData:(NSData *)data;

- (Address)startAddress;
- (Address)endAddress;
- (Address)endMappedDataAddress;
- (size_t)length;

- (BOOL)containsVirtualAddress:(Address)virtualAddress;

- (NSArray<NSObject<HPSection> *> *)sections;
- (NSUInteger)sectionCount;

- (NSObject<HPSegment> *)nextSegment;
- (NSObject<HPSegment> *)previousSegment;

- (NSObject<HPSection> *)addSectionAt:(Address)address size:(size_t)length;
- (NSObject<HPSection> *)addSectionAt:(Address)address toExcludedAddress:(Address)endAddress;

- (NSObject<HPSection> *)firstSection;
- (NSObject<HPSection> *)lastSection;
- (NSObject<HPSection> *)sectionNamed:(NSString *)name;

- (NSUInteger)procedureCount;
- (BOOL)hasProcedureAt:(Address)virtualAddress;
- (NSObject<HPProcedure> *)procedureAt:(Address)virtualAddress;
- (NSObject<HPProcedure> *)procedureAtIndex:(NSUInteger)index;
- (NSInteger)procedureIndex:(NSObject<HPProcedure> *)procedure;
- (NSArray<NSObject<HPProcedure> *> *)procedures;

// XREFs
- (NSArray<NSNumber *> *)referencesToAddress:(Address)virtualAddress;
- (NSArray<NSNumber *> *)referencesFromAddress:(Address)virtualAddress;
- (void)removeReferencesOfAddress:(Address)referenced fromAddress:(Address)origin;
- (void)addReferencesToAddress:(Address)referenced fromAddress:(Address)origin;

@end
