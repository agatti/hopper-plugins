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

typedef void (^FileLoadingCallbackInfo)(NSString *desc, float progress);

@protocol HPDisassembledFile

@property (copy) HopperUUID *fileUUID;

@property (copy) NSString *cpuFamily;
@property (copy) NSString *cpuSubFamily;
@property (strong) NSObject<CPUDefinition> *cpuDefinition;
@property (readonly) NSUInteger userRequestedSyntaxIndex;

- (NSString *)originalFilePath;

// Methods essentially used by Loader plugin
- (NSUInteger)addressSpaceWidthInBits;
- (void)setAddressSpaceWidthInBits:(NSUInteger)bits;

- (BOOL)is32Bits;
- (BOOL)is64Bits;

- (Address)fileBaseAddress;

- (void)addEntryPoint:(Address)address;
- (void)addPotentialProcedure:(Address)address;
- (Address)firstEntryPoint;
- (NSArray<NSNumber *> *)entryPointAddresses;

// Get access to segments and sections
- (NSArray<NSObject<HPSegment> *> *)segments;
- (NSUInteger)segmentCount;

- (NSObject<HPSegment> *)segmentForVirtualAddress:(Address)virtualAddress;
- (NSObject<HPSection> *)sectionForVirtualAddress:(Address)virtualAddress;

- (NSObject<HPSegment> *)segmentNamed:(NSString *)name;
- (NSObject<HPSection> *)sectionNamed:(NSString *)name;

- (NSObject<HPSegment> *)addSegmentAt:(Address)address size:(size_t)length;
- (NSObject<HPSegment> *)addSegmentAt:(Address)address toExcludedAddress:(Address)endAddress;

- (NSObject<HPSegment> *)firstSegment;
- (NSObject<HPSegment> *)lastSegment;
- (NSObject<HPSection> *)firstSection;
- (NSObject<HPSection> *)lastSection;

- (NSObject<HPSegment> *)previousSegment:(NSObject<HPSegment> *)segment;
- (NSObject<HPSegment> *)nextSegment:(NSObject<HPSegment> *)segment;

// CPUContext factory
- (NSObject<CPUContext> *)buildCPUContext;

// Access to the labels
/// An array of NSString objects, containing all labels.
- (NSArray<NSString *> *)allNames;
/// An array of NSNumber objects, representing the address of memory locations that was named.
- (NSArray<NSNumber *> *)allNamedAddresses;
- (NSString *)nameForVirtualAddress:(Address)virtualAddress;
- (NSString *)nearestNameBeforeVirtualAddress:(Address)virtualAddress;
- (void)setName:(NSString *)name forVirtualAddress:(Address)virtualAddress reason:(NameCreationReason)reason;
- (Address)findVirtualAddressNamed:(NSString *)name;

// Comments
- (void)removeCommentAtVirtualAddress:(Address)virtualAddress;
- (void)removeInlineCommentAtVirtualAddress:(Address)virtualAddress;
- (NSString *)commentAtVirtualAddress:(Address)virtualAddress;
- (NSString *)inlineCommentAtVirtualAddress:(Address)virtualAddress;
- (void)setComment:(NSString *)comment atVirtualAddress:(Address)virtualAddress reason:(CommentCreationReason)reason;
- (void)setInlineComment:(NSString *)comment atVirtualAddress:(Address)virtualAddress reason:(CommentCreationReason)reason;

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
- (NSObject<HPASMLine> *)formatNumber:(uint64_t)immediate at:(Address)address usingFormat:(ArgFormat)format andBitSize:(uint64_t)bitSize;

// Procedures
- (BOOL)hasProcedureAt:(Address)address;
- (NSObject<HPProcedure> *)procedureAt:(Address)address;
- (void)removeProcedure:(NSObject<HPProcedure> *)procedure;
- (void)removeProcedureAt:(Address)address;
- (NSObject<HPProcedure> *)makeProcedureAt:(Address)address;
- (void)makeProceduresRecursivelyStartingAt:(Address)address;

// Colors
- (BOOL)hasColorAt:(Address)address;
- (Color)colorAt:(Address)address;
- (void)setColor:(Color)color at:(Address)address;
- (void)setColor:(Color)color atRange:(AddressRange)range;
- (void)clearColorAt:(Address)address;
- (void)clearColorAtRange:(AddressRange)range;

// Tags
- (NSObject<HPTag> *)tagWithName:(NSString *)tagName;
- (NSObject<HPTag> *)buildTag:(NSString *)tagName;
- (void)deleteTag:(NSObject<HPTag> *)tag;
- (void)deleteTagName:(NSString *)tagName;

- (void)addTag:(NSObject<HPTag> *)tag at:(Address)address;
- (void)removeTag:(NSObject<HPTag> *)tag at:(Address)address;
- (NSArray<NSObject<HPTag> *> *)tagsAt:(Address)virtualAddress;
- (BOOL)hasTag:(NSObject<HPTag> *)tag at:(Address)virtualAddress;

// Problem list
- (void)addProblemAt:(Address)address withString:(NSString *)message;

// Assembler
- (NSData *)assembleInstruction:(NSString *)instr atAddress:(Address)address withCPUMode:(uint8_t)cpuMode usingSyntaxVariant:(NSUInteger)syntax isRawData:(BOOL *)isRawData error:(NSError **)error;
- (NSData *)nopDataForRegion:(AddressRange)range;

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

- (int64_t)readSignedLEB128AtVirtualAddress:(Address)virtualAddress length:(size_t *)numberLength;
- (uint64_t)readUnsignedLEB128AtVirtualAddress:(Address)virtualAddress length:(size_t *)numberLength;

- (NSString *)readCStringAt:(Address)address;

// Misc
- (BOOL)hasMappedDataAt:(Address)address;
- (Address)parseAddressString:(NSString *)addressString;

// Undo/Redo Stack Management
- (BOOL)undoRedoLoggingEnabled;

- (void)beginUndoRedoTransactionWithName:(NSString *)name;
- (void)endUndoRedoTransaction;
- (void)discardUndoRedoTransaction;

// Types
- (NSObject<HPTypeDesc> *)voidType;
- (NSObject<HPTypeDesc> *)int8Type;
- (NSObject<HPTypeDesc> *)uint8Type;
- (NSObject<HPTypeDesc> *)int16Type;
- (NSObject<HPTypeDesc> *)uint16Type;
- (NSObject<HPTypeDesc> *)int32Type;
- (NSObject<HPTypeDesc> *)uint32Type;
- (NSObject<HPTypeDesc> *)int64Type;
- (NSObject<HPTypeDesc> *)uint64Type;
- (NSObject<HPTypeDesc> *)floatType;
- (NSObject<HPTypeDesc> *)doubleType;
- (NSObject<HPTypeDesc> *)intType;
- (NSObject<HPTypeDesc> *)uintType;
- (NSObject<HPTypeDesc> *)longType;
- (NSObject<HPTypeDesc> *)ulongType;
- (NSObject<HPTypeDesc> *)longlongType;
- (NSObject<HPTypeDesc> *)ulonglongType;
- (NSObject<HPTypeDesc> *)charType;
- (NSObject<HPTypeDesc> *)ucharType;
- (NSObject<HPTypeDesc> *)shortType;
- (NSObject<HPTypeDesc> *)ushortType;
- (NSObject<HPTypeDesc> *)boolType;

- (NSObject<HPTypeDesc> *)voidPtrType;
- (NSObject<HPTypeDesc> *)int8PtrType;
- (NSObject<HPTypeDesc> *)uint8PtrType;
- (NSObject<HPTypeDesc> *)int16PtrType;
- (NSObject<HPTypeDesc> *)uint16PtrType;
- (NSObject<HPTypeDesc> *)int32PtrType;
- (NSObject<HPTypeDesc> *)uint32PtrType;
- (NSObject<HPTypeDesc> *)int64PtrType;
- (NSObject<HPTypeDesc> *)uint64PtrType;
- (NSObject<HPTypeDesc> *)floatPtrType;
- (NSObject<HPTypeDesc> *)doublePtrType;
- (NSObject<HPTypeDesc> *)intPtrType;
- (NSObject<HPTypeDesc> *)uintPtrType;
- (NSObject<HPTypeDesc> *)longPtrType;
- (NSObject<HPTypeDesc> *)ulongPtrType;
- (NSObject<HPTypeDesc> *)longlongPtrType;
- (NSObject<HPTypeDesc> *)ulonglongPtrType;
- (NSObject<HPTypeDesc> *)charPtrType;
- (NSObject<HPTypeDesc> *)ucharPtrType;
- (NSObject<HPTypeDesc> *)shortPtrType;
- (NSObject<HPTypeDesc> *)ushortPtrType;
- (NSObject<HPTypeDesc> *)boolPtrType;

- (NSObject<HPTypeDesc> *)structureType; /// Build a new empty struct
- (NSObject<HPTypeDesc> *)unionType;     /// Build a new empty union
- (NSObject<HPTypeDesc> *)enumType;      /// Build a new empty enum

- (NSObject<HPTypeDesc> *)pointerTypeOn:(NSObject<HPTypeDesc> *)base;   /// Find the type, or build a new one.
- (NSObject<HPTypeDesc> *)arrayTypeOf:(NSObject<HPTypeDesc> *)base withCount:(NSUInteger)count;

- (BOOL)hasStructureDefinedAt:(Address)address;
- (void)defineStructure:(NSObject<HPTypeDesc> *)type at:(Address)address;
- (NSObject<HPTypeDesc> *)structureTypeAt:(Address)address;

- (NSArray<NSObject<HPTypeDesc> *> *)typeDatabase;
- (NSObject<HPTypeDesc> *)typeWithName:(NSString *)name;
- (NSArray<NSObject<HPTypeDesc> *> *)allStructuredTypes;
- (NSArray<NSObject<HPTypeDesc> *> *)allEnumTypes;

- (BOOL)importTypesFromData:(NSData *)data;
- (NSData *)exportTypes;

@end
