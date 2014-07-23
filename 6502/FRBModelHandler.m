/*
 Copyright (c) 2014, Alessandro Gatti - frob.it
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "FRBProvider.h"
#import "FRBModelHandler.h"

@interface FRBModelHandler()

- (BOOL)loadModelsFromPlist:(NSString *)fileName;

@property (strong, nonatomic, readonly) NSMutableDictionary *providers;

@end

@implementation FRBModelHandler

static NSString * const FRBModelsFileName = @"models.plist";
static NSString * const FRBPluginBundleName = @"it.frob.hopper.-502"; // :(

+ (instancetype)sharedModelHandler {
    static FRBModelHandler *sharedModelHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModelHandler = [[FRBModelHandler alloc] initWithModels:FRBModelsFileName];
    });
    return sharedModelHandler;
}

- (instancetype)initWithModels:(NSString *)fileName {
    if (self = [super init]) {
        NSLog(@"loading");
        if (![self loadModelsFromPlist:FRBModelsFileName]) {
            return nil;
        }

        _providers = [NSMutableDictionary new];
    }

    return self;
}

- (BOOL)loadModelsFromPlist:(NSString *)fileName {
    NSBundle *bundle = [NSBundle bundleWithIdentifier:FRBPluginBundleName];
    NSArray *items = [fileName componentsSeparatedByString:@"."];
    NSString *plistPath = [bundle pathForResource:items[0]
                                           ofType:items.count > 1 ? items[1] : nil];
    if (!plistPath) {
        return NO;
    }

    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:plistPath];
    if (!stream) {
        return NO;
    }
    [stream open];

    NSError *error = nil;
    id propertyList = [NSPropertyListSerialization propertyListWithStream:stream
                                                                  options:NSPropertyListImmutable
                                                                   format:nil
                                                                    error:&error];
    [stream close];
    if (error != nil) {
        return NO;
    }

    if (![propertyList isKindOfClass:[NSDictionary class]]) {
        return NO;
    }

    _models = (NSDictionary *) propertyList;

    return YES;
}

- (void)registerProvider:(Class)provider
                 forName:(NSString *)name {
    if ([provider conformsToProtocol:@protocol(FRBProvider)]) {
        self.providers[name] = provider;
    }
}

- (NSString *)providerNameForFamily:(NSString *)family
                       andSubFamily:(NSString *)subFamily {
    NSDictionary *subFamilies = self.models[family];
    if (subFamilies) {
        return subFamilies[subFamily];
    }
    
    return nil;
}

- (NSObject<FRBProvider> *)providerForName:(NSString *)name {
    Class providerClass = self.providers[name];
    if (!providerClass) {
        return nil;
    }

    return [[providerClass alloc] init];
}

@end
