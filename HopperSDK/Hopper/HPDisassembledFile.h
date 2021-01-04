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

@class HopperUUID;

@protocol CPUDefinition;
@protocol CPUContext;
@protocol HPSegment;
@protocol HPSection;
@protocol HPProcedure;
@protocol HPTag;
@protocol HPASMLine;
@protocol HPTypeDesc;

typedef void (^FileLoadingCallbackInfo)(NSString * _Nonnull desc, float progress);

@protocol HPDisassembledFile

@property (nullable, copy) HopperUUID *fileUUID;

@property (nullable, copy) NSString *cpuFamily;
@property (nullable, copy) NSString *cpuSubFamily;
@property (nonnull, strong) NSObject<CPUDefinition> *cpuDefinition;
@property (readonly) NSUInteger userRequestedSyntaxIndex;

- (nullable NSString *)originalFilePath;

// Methods essentially used by Loader plugin
- (NSUInteger)addressSpaceWidthInBits;
- (void)setAddressSpaceWidthInBits:(NSUInteger)bits;
- (NSUInteger)integerWidthInBits;
- (void)setIntegerWidthInBits:(NSUInteger)bits;

- (BOOL)is32Bits;
- (BOOL)is64Bits;

- (Address)fileBaseAddress;

- (void)addEntryPoint:(Address)address;
- (void)addEntryPoint:(Address)address withCPUMode:(uint8_t)cpuMode;
- (void)addPotentialProcedure:(Address)address;
- (void)addPotentialProcedure:(Address)address withCPUMode:(uint8_t)cpuMode;
- (Address)firstEntryPoint;
- (nonnull NSArray<NSNumber *> *)entryPointAddresses;

// Get access to segments and sections
- (nonnull NSArray<NSObject<HPSegment> *> *)segments;
- (NSUInteger)segmentCount;

- (nullable NSObject<HPSegment> *)segmentForVirtualAddress:(Address)virtualAddress;
- (nullable NSObject<HPSection> *)sectionForVirtualAddress:(Address)virtualAddress;

- (nullable NSObject<HPSegment> *)segmentNamed:(nonnull NSString *)name;
- (nullable NSObject<HPSection> *)sectionNamed:(nonnull NSString *)name;

- (nonnull NSObject<HPSegment> *)addSegmentAt:(Address)address size:(size_t)length;
- (nonnull NSObject<HPSegment> *)addSegmentAt:(Address)address toExcludedAddress:(Address)endAddress;
- (void)removeSegment:(nonnull NSObject<HPSegment> *)segment;

- (nullable NSObject<HPSegment> *)firstSegment;
- (nullable NSObject<HPSegment> *)lastSegment;
- (nullable NSObject<HPSection> *)firstSection;
- (nullable NSObject<HPSection> *)lastSection;

- (nullable NSObject<HPSegment> *)previousSegment:(nonnull NSObject<HPSegment> *)segment;
- (nullable NSObject<HPSegment> *)nextSegment:(nonnull NSObject<HPSegment> *)segment;

// CPUContext factory
- (nonnull NSObject<CPUContext> *)buildCPUContext;

// Access to the labels
/// An array of NSString objects, containing all labels.
- (nonnull NSArray<NSString *> *)allNames;
/// An array of NSNumber objects, representing the address of memory locations that was named.
- (nonnull NSArray<NSNumber *> *)allNamedAddresses;
- (nullable NSString *)nameForVirtualAddress:(Address)virtualAddress;
- (nullable NSString *)nearestNameBeforeVirtualAddress:(Address)virtualAddress;
- (void)setName:(nullable NSString *)name forVirtualAddress:(Address)virtualAddress reason:(NameCreationReason)reason;
- (Address)findVirtualAddressNamed:(nonnull NSString *)name;

// Comments
- (void)removeCommentAtVirtualAddress:(Address)virtualAddress;
- (void)removeInlineCommentAtVirtualAddress:(Address)virtualAddress;
- (nullable NSString *)commentAtVirtualAddress:(Address)virtualAddress;
- (nullable NSString *)inlineCommentAtVirtualAddress:(Address)virtualAddress;
- (void)setComment:(nullable NSString *)comment atVirtualAddress:(Address)virtualAddress reason:(CommentCreationReason)reason;
- (void)setInlineComment:(nullable NSString *)comment atVirtualAddress:(Address)virtualAddress reason:(CommentCreationReason)reason;

// Types
- (BOOL)typeCanBeModifiedAtAddress:(Address)va;
- (ByteType)typeForVirtualAddress:(Address)virtualAddress;
- (void)setType:(ByteType)type atVirtualAddress:(Address)virtualAddress forLength:(size_t)length;
- (BOOL)hasCodeAt:(Address)virtualAddress;
- (uint8_t)cpuModeAtVirtualAddress:(Address)virtualAddress;

// Searching
- (Address)findNextAddress:(Address)address ofTypeOrMetaType:(ByteType)typeOrMetaType wrapping:(BOOL)wrapping;

// Instruction Operand Format
- (ArgFormat)formatForArgument:(NSUInteger)argIndex atVirtualAddress:(Address)virtualAddress;
- (Address)formatRelativeToForArgument:(NSUInteger)argIndex atVirtualAddress:(Address)virtualAddress;
- (void)setFormat:(ArgFormat)format forArgument:(NSUInteger)argIndex atVirtualAddress:(Address)virtualAddress;
- (void)setFormat:(ArgFormat)format relativeTo:(Address)relTo forArgument:(NSUInteger)argIndex atVirtualAddress:(Address)virtualAddress;

// Format a number
- (nonnull NSObject<HPASMLine> *)formatNumber:(uint64_t)immediate at:(Address)address operandIndex:(NSUInteger)operandIndex andBitSize:(uint64_t)bitSize;
- (nonnull NSObject<HPASMLine> *)formatNumber:(uint64_t)immediate at:(Address)address usingFormat:(ArgFormat)format andBitSize:(uint64_t)bitSize;

// Procedures
- (BOOL)hasProcedureAt:(Address)address;
- (nullable NSObject<HPProcedure> *)procedureAt:(Address)address;
- (void)removeProcedure:(nonnull NSObject<HPProcedure> *)procedure;
- (void)removeProcedureAt:(Address)address;
- (nullable NSObject<HPProcedure> *)makeProcedureAt:(Address)address;
- (void)makeProceduresRecursivelyStartingAt:(Address)address;

// Colors
- (BOOL)hasColorAt:(Address)address;
- (Color)colorAt:(Address)address;
- (void)setColor:(Color)color at:(Address)address;
- (void)setColor:(Color)color atRange:(AddressRange)range;
- (void)clearColorAt:(Address)address;
- (void)clearColorAtRange:(AddressRange)range;

// Tags
- (nullable NSObject<HPTag> *)tagWithName:(nonnull NSString *)tagName;
- (nonnull NSObject<HPTag> *)buildTag:(nonnull NSString *)tagName;
- (void)deleteTag:(nonnull NSObject<HPTag> *)tag;
- (void)deleteTagName:(nonnull NSString *)tagName;

- (void)addTag:(nonnull NSObject<HPTag> *)tag at:(Address)address;
- (void)removeTag:(nonnull NSObject<HPTag> *)tag at:(Address)address;
- (nullable NSArray<NSObject<HPTag> *> *)tagsAt:(Address)virtualAddress;
- (BOOL)hasTag:(nonnull NSObject<HPTag> *)tag at:(Address)virtualAddress;

// Problem list
- (void)addProblemAt:(Address)address withString:(nonnull NSString *)message;

// Assembler
- (nullable NSData *)assembleInstruction:(nonnull NSString *)instr atAddress:(Address)address withCPUMode:(uint8_t)cpuMode usingSyntaxVariant:(NSUInteger)syntax isRawData:(nonnull BOOL *)isRawData error:(NSError * _Nonnull * _Nonnull)error;
- (nullable NSData *)nopDataForRegion:(AddressRange)range;

// Reading file
// Warning: don't use these methods in a Loader plugin, because no CPU plugin
// is attached to the file at this stage!
// Note: writing operations are defined in the HPDocument protocol.
- (int8_t)readInt8AtVirtualAddress:(Address)virtualAddress;
- (int16_t)readInt16AtVirtualAddress:(Address)virtualAddress;
- (int32_t)readInt32AtVirtualAddress:(Address)virtualAddress;
- (int64_t)readInt64AtVirtualAddress:(Address)virtualAddress;
- (uint8_t)readUInt8AtVirtualAddress:(Address)virtualAddress;
- (uint16_t)readUInt16AtVirtualAddress:(Address)virtualAddress;
- (uint32_t)readUInt32AtVirtualAddress:(Address)virtualAddress;
- (uint64_t)readUInt64AtVirtualAddress:(Address)virtualAddress;

- (Address)readAddressAtVirtualAddress:(Address)virtualAddress;

- (int64_t)readSignedLEB128AtVirtualAddress:(Address)virtualAddress length:(nonnull size_t *)numberLength;
- (uint64_t)readUnsignedLEB128AtVirtualAddress:(Address)virtualAddress length:(nonnull size_t *)numberLength;

- (nullable NSString *)readCStringAt:(Address)address;

// Misc
- (BOOL)hasMappedDataAt:(Address)address;
- (Address)parseAddressString:(nonnull NSString *)addressString;

// Undo/Redo Stack Management
- (BOOL)undoRedoLoggingEnabled;

- (void)beginUndoRedoTransactionWithName:(nonnull NSString *)name;
- (void)endUndoRedoTransaction;
- (void)discardUndoRedoTransaction;

// Types
- (nonnull NSObject<HPTypeDesc> *)voidType;
- (nonnull NSObject<HPTypeDesc> *)int8Type;
- (nonnull NSObject<HPTypeDesc> *)uint8Type;
- (nonnull NSObject<HPTypeDesc> *)int16Type;
- (nonnull NSObject<HPTypeDesc> *)uint16Type;
- (nonnull NSObject<HPTypeDesc> *)int32Type;
- (nonnull NSObject<HPTypeDesc> *)uint32Type;
- (nonnull NSObject<HPTypeDesc> *)int64Type;
- (nonnull NSObject<HPTypeDesc> *)uint64Type;
- (nonnull NSObject<HPTypeDesc> *)floatType;
- (nonnull NSObject<HPTypeDesc> *)doubleType;
- (nonnull NSObject<HPTypeDesc> *)intType;
- (nonnull NSObject<HPTypeDesc> *)uintType;
- (nonnull NSObject<HPTypeDesc> *)longType;
- (nonnull NSObject<HPTypeDesc> *)ulongType;
- (nonnull NSObject<HPTypeDesc> *)longlongType;
- (nonnull NSObject<HPTypeDesc> *)ulonglongType;
- (nonnull NSObject<HPTypeDesc> *)charType;
- (nonnull NSObject<HPTypeDesc> *)ucharType;
- (nonnull NSObject<HPTypeDesc> *)shortType;
- (nonnull NSObject<HPTypeDesc> *)ushortType;
- (nonnull NSObject<HPTypeDesc> *)boolType;

- (nonnull NSObject<HPTypeDesc> *)voidPtrType;
- (nonnull NSObject<HPTypeDesc> *)int8PtrType;
- (nonnull NSObject<HPTypeDesc> *)uint8PtrType;
- (nonnull NSObject<HPTypeDesc> *)int16PtrType;
- (nonnull NSObject<HPTypeDesc> *)uint16PtrType;
- (nonnull NSObject<HPTypeDesc> *)int32PtrType;
- (nonnull NSObject<HPTypeDesc> *)uint32PtrType;
- (nonnull NSObject<HPTypeDesc> *)int64PtrType;
- (nonnull NSObject<HPTypeDesc> *)uint64PtrType;
- (nonnull NSObject<HPTypeDesc> *)floatPtrType;
- (nonnull NSObject<HPTypeDesc> *)doublePtrType;
- (nonnull NSObject<HPTypeDesc> *)intPtrType;
- (nonnull NSObject<HPTypeDesc> *)uintPtrType;
- (nonnull NSObject<HPTypeDesc> *)longPtrType;
- (nonnull NSObject<HPTypeDesc> *)ulongPtrType;
- (nonnull NSObject<HPTypeDesc> *)longlongPtrType;
- (nonnull NSObject<HPTypeDesc> *)ulonglongPtrType;
- (nonnull NSObject<HPTypeDesc> *)charPtrType;
- (nonnull NSObject<HPTypeDesc> *)ucharPtrType;
- (nonnull NSObject<HPTypeDesc> *)shortPtrType;
- (nonnull NSObject<HPTypeDesc> *)ushortPtrType;
- (nonnull NSObject<HPTypeDesc> *)boolPtrType;

- (nonnull NSObject<HPTypeDesc> *)structureType; /// Build a new empty struct
- (nonnull NSObject<HPTypeDesc> *)unionType;     /// Build a new empty union
- (nonnull NSObject<HPTypeDesc> *)enumType;      /// Build a new empty enum

- (nonnull NSObject<HPTypeDesc> *)pointerTypeOn:(nonnull NSObject<HPTypeDesc> *)base;   /// Find the type, or build a new one.
- (nonnull NSObject<HPTypeDesc> *)arrayTypeOf:(nonnull NSObject<HPTypeDesc> *)base withCount:(NSUInteger)count;

- (BOOL)hasStructureDefinedAt:(Address)address;
- (void)defineStructure:(nonnull NSObject<HPTypeDesc> *)type at:(Address)address;
- (nonnull NSObject<HPTypeDesc> *)structureTypeAt:(Address)address;

- (nonnull NSArray<NSObject<HPTypeDesc> *> *)typeDatabase;
- (nullable NSObject<HPTypeDesc> *)typeWithName:(nonnull NSString *)name;
- (nonnull NSArray<NSObject<HPTypeDesc> *> *)allStructuredTypes;
- (nonnull NSArray<NSObject<HPTypeDesc> *> *)allEnumTypes;

- (BOOL)importTypesFromData:(nonnull NSData *)data;
- (nonnull NSData *)exportTypes;

@end
