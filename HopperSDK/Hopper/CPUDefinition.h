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

#import <Foundation/Foundation.h>
#import "CPUContext.h"
#import "HopperPlugin.h"
#import "CommonTypes.h"

@protocol CPUDefinition <NSObject,HopperPlugin>

/// Build a context for disassembling.
/// This method should be fast, because it'll be called very often.
- (nonnull Class)cpuContextClass;
- (nonnull NSObject<CPUContext> *)buildCPUContextForFile:(nonnull NSObject<HPDisassembledFile> *)file;

/// Returns an array of NSString of CPU families handled by the plugin.
- (nonnull NSArray<NSString *> *)cpuFamilies;
/// Returns an array of NSString of CPU subfamilies handled by the plugin for a given CPU family.
- (nonnull NSArray<NSString *> *)cpuSubFamiliesForFamily:(nullable NSString *)family;
/// Returns 32 or 64, according to the family and subFamily arguments.
- (int)addressSpaceWidthInBitsForCPUFamily:(nullable NSString *)family andSubFamily:(nullable NSString *)subFamily;
- (int)integerWidthInBitsForCPUFamily:(nullable NSString *)family andSubFamily:(nullable NSString *)subFamily;

/// Default endianess of the CPU.
- (CPUEndianess)endianess;
/// Usually, returns 1, but for the Intel processor, it'll return 2 because we have the Intel and the AT&T syntaxes.
- (NSUInteger)syntaxVariantCount;
/// The number of CPU modes. For instance, 2 for the ARM CPU family: ARM and Thumb modes.
- (NSUInteger)cpuModeCount;

- (nonnull NSArray<NSString *> *)syntaxVariantNames;
- (nonnull NSArray<NSString *> *)cpuModeNames;

- (NSUInteger)registerClassCount;
- (NSUInteger)registerCountForClass:(RegClass)reg_class;
- (nonnull NSString *)registerIndexToString:(NSUInteger)reg ofClass:(RegClass)reg_class withBitSize:(NSUInteger)size position:(DisasmPosition)position andSyntaxIndex:(NSUInteger)syntaxIndex;
- (nonnull NSString *)cpuRegisterStateMaskToString:(uint32_t)cpuState;
- (BOOL)registerIndexIsStackPointer:(NSUInteger)reg ofClass:(RegClass)reg_class cpuMode:(uint8_t)cpuMode file:(nonnull NSObject<HPDisassembledFile> *)file;
- (BOOL)registerIndexIsFrameBasePointer:(NSUInteger)reg ofClass:(RegClass)reg_class cpuMode:(uint8_t)cpuMode file:(nonnull NSObject<HPDisassembledFile> *)file;
- (BOOL)registerIndexIsProgramCounter:(NSUInteger)reg cpuMode:(uint8_t)cpuMode file:(nonnull NSObject<HPDisassembledFile> *)file;
/// Returns true for each special registers, like "CRx" or "DRx" X86 registers for instance
- (BOOL)registerHasSideEffectForIndex:(NSUInteger)reg andClass:(RegClass)reg_class;

// Returns the name of the frame pointer register, ie, "bp" for x86, or "r7" for ARM.
- (nullable NSString *)framePointerRegisterNameForFile:(nonnull NSObject<HPDisassembledFile>*)file cpuMode:(uint8_t)cpuMode;

/// Returns a array of bytes that represents a NOP instruction of a given size.
- (nonnull NSData *)nopWithSize:(NSUInteger)size andMode:(NSUInteger)cpuMode forFile:(nonnull NSObject<HPDisassembledFile> *)file;

/// Return YES if the plugin embed an assembler.
- (BOOL)canAssembleInstructionsForCPUFamily:(nullable NSString *)family andSubFamily:(nullable NSString *)subFamily;

/// Return YES if the plugin embed a decompiler.
/// Note: you cannot create a decompiler yet, because the main class (ASTNode) is not
/// publicly exposed yet.
- (BOOL)canDecompileProceduresForCPUFamily:(nullable NSString *)family andSubFamily:(nullable NSString *)subFamily;

@end
