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

@protocol HPTag;
@protocol HPBasicBlock;
@protocol HPSegment;
@protocol HPCallReference;
@protocol HPMethodSignature;
@protocol CPUContext;

@protocol HPProcedure

- (BOOL)bpBasedFrame;
- (int32_t)savedRegistersSize;
- (int32_t)framePointerOffset;
- (int32_t)purgedBytes;
- (int32_t)localsSize;

- (NSUInteger)basicBlockCount;
- (nullable NSObject<HPBasicBlock> *)firstBasicBlock;
- (nullable NSObject<HPBasicBlock> *)basicBlockStartingAt:(Address)address;
- (nullable NSObject<HPBasicBlock> *)basicBlockContainingInstructionAt:(Address)address;
- (nullable NSObject<HPBasicBlock> *)basicBlockAtIndex:(NSUInteger)index;

- (nonnull NSObject<HPSegment> *)segment;

- (Address)entryPoint;
- (nullable NSArray<NSObject<HPBasicBlock> *> *)allExitBlocks;

// Stack
- (int32_t)stackPointerOffsetAt:(Address)address;

// Local Labels
- (BOOL)hasLocalLabelAtAddress:(Address)address;
- (nullable NSString *)localLabelAtAddress:(Address)address;
- (void)setLocalLabel:(nullable NSString *)name atAddress:(Address)address;
- (nonnull NSString *)declareLocalLabelAt:(Address)address;
- (void)removeLocalLabelAtAddress:(Address)address;
- (Address)addressOfLocalLabel:(nonnull NSString *)name;

// Rename register
- (void)renameRegisterOfClass:(RegClass)regCls andIndex:(NSUInteger)regIndex to:(nullable NSString *)name;
- (nullable NSString *)nameOverrideForRegisterOfClass:(RegClass)regCls andIndex:(NSUInteger)regIndex;
- (void)clearNameOverrideForRegisterOfClass:(RegClass)regCls andIndex:(NSUInteger)regIndex;

// Call Graph
- (nullable NSArray<NSObject<HPCallReference> *> *)allCallers;
- (nullable NSArray<NSObject<HPCallReference> *> *)allCallees;

- (nullable NSArray<NSObject<HPProcedure> *> *)allCalleeProcedures;
- (nullable NSArray<NSObject<HPProcedure> *> *)allCallerProcedures;

// Variables
- (nullable NSString *)variableNameForDisplacement:(int64_t)disp;
- (BOOL)setVariableName:(nullable NSString *)name forDisplacement:(int64_t)disp;
- (nullable NSString *)resolvedVariableNameForDisplacement:(int64_t)disp usingCPUContext:(nonnull NSObject<CPUContext> *)cpuContext;

// Signature
- (nullable NSObject<HPMethodSignature> *)signature;
- (void)setSignature:(nullable NSObject<HPMethodSignature> *)signature reason:(SignatureCreationReason)reason;
- (void)setSignature:(nullable NSObject<HPMethodSignature> *)signature propagatingSignature:(BOOL)propagateSignature reason:(SignatureCreationReason)reason;
- (CallingConvention)callingConvention;
- (CallingConvention)resolvedCallingConvention;
- (void)setCallingConvention:(CallingConvention)cc;

// Tags
- (void)addTag:(nonnull NSObject<HPTag> *)tag;
- (void)removeTag:(nonnull NSObject<HPTag> *)tag;
- (BOOL)hasTag:(nonnull NSObject<HPTag> *)tag;

@end
