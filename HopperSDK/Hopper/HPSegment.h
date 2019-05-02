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

@property (nonatomic, nullable, copy) NSString *segmentName;

@property (nonatomic, assign) uint64_t fileOffset;
@property (nonatomic, assign) uint64_t fileLength;
@property (nonatomic, assign) uint64_t flags;

@property (nonatomic, assign) BOOL readable, writable, executable;

- (NSUInteger)segmentIndex;

- (BOOL)hasMappedData;
- (nullable NSData *)mappedData;
- (void)setMappedData:(nullable NSData *)data;

- (Address)startAddress;
- (Address)endAddress;
- (Address)endMappedDataAddress;
- (size_t)length;

- (BOOL)containsVirtualAddress:(Address)virtualAddress;

- (nonnull NSArray<NSObject<HPSection> *> *)sections;
- (NSUInteger)sectionCount;

- (nullable NSObject<HPSegment> *)nextSegment;
- (nullable NSObject<HPSegment> *)previousSegment;

- (nonnull NSObject<HPSection> *)addSectionAt:(Address)address size:(size_t)length;
- (nonnull NSObject<HPSection> *)addSectionAt:(Address)address toExcludedAddress:(Address)endAddress;

- (nullable NSObject<HPSection> *)firstSection;
- (nullable NSObject<HPSection> *)lastSection;
- (nullable NSObject<HPSection> *)sectionNamed:(nonnull NSString *)name;

- (NSUInteger)procedureCount;
- (BOOL)hasProcedureAt:(Address)virtualAddress;
- (nullable NSObject<HPProcedure> *)procedureAt:(Address)virtualAddress;
- (nullable NSObject<HPProcedure> *)procedureAtIndex:(NSUInteger)index;
- (NSInteger)procedureIndex:(nonnull NSObject<HPProcedure> *)procedure;
- (nonnull NSArray<NSObject<HPProcedure> *> *)procedures;

// XREFs
- (nullable NSArray<NSNumber *> *)referencesToAddress:(Address)virtualAddress;
- (nullable NSArray<NSNumber *> *)referencesFromAddress:(Address)virtualAddress;
- (void)removeReferencesOfAddress:(Address)referenced fromAddress:(Address)origin;
- (void)addReferencesToAddress:(Address)referenced fromAddress:(Address)origin;

@end
