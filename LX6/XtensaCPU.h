#import <Foundation/Foundation.h>
#import <Hopper/Hopper.h>

typedef NS_ENUM(NSUInteger, XtensaRegClass) {
	RegClass_SpecialRegister0 = RegClass_FirstUserClass,
	RegClass_SpecialRegister1,
	RegClass_SpecialRegister2,
	RegClass_SpecialRegister3,
	// not sure if special registers should be exposed here
	// Hopper limits us to 32 regs per class, so we have to split into multiple classes
	RegClass_FPRegister,
	RegClass_Xtensa_Cnt
};


@interface XtensaCPU : NSObject<CPUDefinition>

- (NSObject<HPHopperServices> *)hopperServices;

@end
