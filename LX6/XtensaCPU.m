#import "XtensaCPU.h"
#import "XtensaCtx.h"

#ifdef LINUX
#include <endian.h>

void OSWriteBigInt16(void *address, uintptr_t offset, int16_t data) {
	*(int16_t *) ((uintptr_t) address + offset) = htobe16(data);
}

#endif

NSString *specialRegisters[] = {
#define SPECIAL_REGISTER(a,b) @#a ,
#include "Xtensa_specreg.h"
#undef SPECIAL_REGISTER
};

@implementation XtensaCPU {
	NSObject<HPHopperServices> *_services;
}

- (Class)cpuContextClass {
	return [XtensaCtx class];
}

+ (int)sdkVersion {
	return HOPPER_CURRENT_SDK_VERSION;
}

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
	if (self = [super init]) {
		_services = services;
	}
	return self;
}

- (NSObject<HPHopperServices> *)hopperServices {
	return _services;
}

- (NSObject<CPUContext> *)buildCPUContextForFile:(NSObject<HPDisassembledFile> *)file {
	return [[XtensaCtx alloc] initWithCPU:self andFile:file];
}

- (HopperUUID *)pluginUUID {
	return (HopperUUID *)[_services UUIDWithString:@"7a4d7c28-5fde-48f1-b9fe-6b7ae6a3cd40"];
}

- (HopperPluginType)pluginType {
	return Plugin_CPU;
}

- (NSString *)pluginName {
	return @"Xtensa";
}

- (NSString *)pluginDescription {
	return @"Xtensa-based CPU support";
}

- (NSString *)pluginAuthor {
	return @"Andrzej Szombierski";
}

- (NSString *)pluginCopyright {
	return @"© Andrzej Szombierski";
}

- (NSArray *)cpuFamilies {
	return @[@"xtensa"];
}

- (NSString *)commandLineIdentifier {
	return @"xtensa";
}

- (NSString *)pluginVersion {
	return @"0.0.1";
}

- (NSArray *)cpuSubFamiliesForFamily:(NSString *)family {
	if ([family isEqualToString:@"xtensa"]) return @[@"lx106", @"lx6"];
	return @[];
}

- (int)addressSpaceWidthInBitsForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
	if ([family isEqualToString:@"xtensa"]) return 32;
	return 0;
}

- (CPUEndianess)endianess {
	return CPUEndianess_Little;
}

- (NSUInteger)cpuModeCount {
	return 1;
}

- (NSArray<NSString *> *)cpuModeNames {
	return @[@"generic"];
}

- (NSUInteger)syntaxVariantCount {
	return 1;
}

- (NSArray<NSString *> *)syntaxVariantNames {
	return @[@"lowercase"];
}

- (NSString *)framePointerRegisterNameForFile:(NSObject<HPDisassembledFile> *)file cpuMode:(uint8_t)cpuMode {
  return @"fp";
}

- (NSString *)framePointerRegisterNameForFile:(NSObject<HPDisassembledFile> *)file {
  return @"fp";
}

- (NSUInteger)registerClassCount {
	return RegClass_Xtensa_Cnt;
}

#define SPECREG_COUNT (sizeof(specialRegisters) / sizeof(specialRegisters[0]))

- (NSUInteger)registerCountForClass:(RegClass)reg_class {
	switch (reg_class) {
		case RegClass_CPUState: return 1; 		// pc?
		case RegClass_PseudoRegisterSTACK: return 32;
		case RegClass_GeneralPurposeRegister: return 16;
		case RegClass_SpecialRegister0:
		case RegClass_SpecialRegister1:
		case RegClass_SpecialRegister2:
		case RegClass_SpecialRegister3:
		{
			int rv = SPECREG_COUNT;
			rv -= (reg_class - RegClass_SpecialRegister0) * DISASM_MAX_REG_INDEX;
			if(rv < 0) rv = 0;
			if(rv >= DISASM_MAX_REG_INDEX)
				rv = DISASM_MAX_REG_INDEX-1;
			return rv;
		}
		default: break;
	}
	return 0;
}

- (BOOL)registerIndexIsStackPointer:(NSUInteger)reg ofClass:(RegClass)reg_class cpuMode:(uint8_t)cpuMode file:(NSObject<HPDisassembledFile> *)file {
	return reg_class == RegClass_GeneralPurposeRegister && reg == 1;
}

- (BOOL)registerIndexIsFrameBasePointer:(NSUInteger)reg ofClass:(RegClass)reg_class cpuMode:(uint8_t)cpuMode file:(NSObject<HPDisassembledFile> *)file {
	return NO;
}

- (BOOL)registerIndexIsProgramCounter:(NSUInteger)reg cpuMode:(uint8_t)cpuMode file:(NSObject<HPDisassembledFile> *)file {
	return NO; // FIXME
}

- (BOOL)registerHasSideEffectForIndex:(NSUInteger)reg andClass:(RegClass)reg_class {
	return reg_class == RegClass_CPUState;
}

- (NSString *)lowercaseStringForRegister:(NSUInteger)reg ofClass:(RegClass)reg_class {
	switch (reg_class) {
		case RegClass_CPUState:
			if (reg == 0)
				return @"pc";
			return [NSString stringWithFormat:@"UNKNOWN_CPUSTATE_REG<%lld>", (long long) reg];
		case RegClass_PseudoRegisterSTACK: return [NSString stringWithFormat:@"stk%d", (int) reg];
		case RegClass_GeneralPurposeRegister: return [NSString stringWithFormat:@"a%d", (int) reg];
		case RegClass_SpecialRegister0: 
		case RegClass_SpecialRegister1: 
		case RegClass_SpecialRegister2: 
		case RegClass_SpecialRegister3: 
			return specialRegisters[reg + ((reg_class) - RegClass_SpecialRegister0) * DISASM_MAX_REG_INDEX];
		default: break;
	}
	return nil;
}

- (NSString *)registerIndexToString:(NSUInteger)reg ofClass:(RegClass)reg_class withBitSize:(NSUInteger)size position:(DisasmPosition)position andSyntaxIndex:(NSUInteger)syntaxIndex {
	return [self lowercaseStringForRegister:reg ofClass:reg_class];
}

- (NSString *)cpuRegisterStateMaskToString:(uint32_t)cpuState {
	return @"";
}

- (NSUInteger)translateOperandIndex:(NSUInteger)index operandCount:(NSUInteger)count accordingToSyntax:(uint8_t)syntaxIndex {
	return index;
}

- (NSData *)nopWithSize:(NSUInteger)size andMode:(NSUInteger)cpuMode forFile:(NSObject<HPDisassembledFile> *)file {
	return [NSData new];
}

- (BOOL)canAssembleInstructionsForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
	return NO;
}

- (BOOL)canDecompileProceduresForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
	return NO;
}

- (int)integerWidthInBitsForCPUFamily:(nullable NSString *)family andSubFamily:(nullable NSString *)subFamily {
  return 16;
}


@end
