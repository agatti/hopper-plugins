#import <Foundation/Foundation.h>
#import <Hopper/Hopper.h>

@class XtensaCPU;

@interface XtensaCtx : NSObject<CPUContext>

- (instancetype)initWithCPU:(XtensaCPU *)cpu andFile:(NSObject<HPDisassembledFile> *)file;

@end
