/*
 Copyright (c) 2014-2017, Alessandro Gatti - frob.it
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

@import ObjectiveC.objc_class;

#import "ModelManager.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

@interface ItFrobHopperModelManager ()

typedef NSDictionary<NSString *, Class<ItFrobHopperCPUProvider>> FRBModelItem;
typedef NSDictionary<NSString *, FRBModelItem *> FRBModelsDictionary;

@property(strong, nonatomic, readonly, nonnull) FRBModelsDictionary *providers;

- (FRBModelsDictionary *)enumerateProviders:(NSBundle *)bundle;

@end

@implementation ItFrobHopperModelManager

#pragma mark - Public API

+ (instancetype _Nullable)modelManagerWithBundle:(NSBundle *_Nonnull)bundle {
  return [[ItFrobHopperModelManager alloc] initWithBundle:bundle];
}

- (NSArray<NSString *> *_Nonnull)families {
  return self.providers.allKeys;
}

- (NSArray<NSString *> *_Nonnull)modelsForFamily:(NSString *_Nonnull)family {
  return self.providers[family].allKeys;
}

- (NSObject<ItFrobHopperCPUProvider> *_Nonnull)
providerForFamily:(NSString *_Nonnull)family
         andModel:(NSString *_Nonnull)model {
  Class providerClass = [self classForFamily:family andModel:model];
  return (NSObject<ItFrobHopperCPUProvider> *)[[providerClass alloc] init];
}

- (Class<ItFrobHopperCPUProvider> _Nonnull)
classForFamily:(NSString *_Nonnull)family
      andModel:(NSString *_Nonnull)model {
  return self.providers[family][model];
}

#pragma mark - Private methods

- (instancetype _Nullable)initWithBundle:(NSBundle *_Nonnull)bundle {
  if (self = [super init]) {
    NSDictionary *providersFound = [self enumerateProviders:bundle];
    if (!providersFound) {
      return nil;
    }

    _providers = providersFound;
  }

  return self;
}

- (FRBModelsDictionary *)enumerateProviders:(NSBundle *)bundle {
  unsigned int classCount;
  NSMutableDictionary *providers = [NSMutableDictionary new];
  Protocol *protocol = @protocol(ItFrobHopperCPUProvider);
  const char **classNames = objc_copyClassNamesForImage(
      bundle.executablePath.UTF8String, &classCount);

  for (unsigned int index = 0; index < classCount; index++) {
    Class class = NSClassFromString(@(classNames[index]));

    if (!class_conformsToProtocol(class, protocol)) {
      continue;
    }

    Class<ItFrobHopperCPUProvider> provider =
        (Class<ItFrobHopperCPUProvider>)class;

    if (![provider exported]) {
      continue;
    }

    NSString *family = [provider family];
    NSString *model = [provider model];

    NSMutableDictionary *familyDictionary = [providers valueForKey:family];
    if (!familyDictionary) {
      familyDictionary = [NSMutableDictionary new];
      [providers setValue:familyDictionary forKey:family];
    }

    if ([familyDictionary doesContain:model]) {
      return nil;
    }

    [familyDictionary setValue:class forKey:model];
  }

  return providers.allKeys.count > 0 ? providers : nil;
}

@end

#pragma clang diagnostic pop