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
#import "CommonTypes.h"

#define HOPPER_CURRENT_SDK_VERSION  4

@protocol HPHopperUUID;
@protocol HPHopperServices;

@protocol HopperPlugin <NSObject>

- (nonnull instancetype)initWithHopperServices:(nonnull NSObject<HPHopperServices> *)services;

/// Should return the HOPPER_CURRENT_SDK_VERSION constant.
/// This is used by Hopper to know the SDK version which was used when the plugin was compiled.
+ (int)sdkVersion;

- (nonnull NSObject<HPHopperUUID> *)pluginUUID;
- (HopperPluginType)pluginType;

- (nonnull NSString *)pluginName;
- (nonnull NSString *)pluginDescription;
- (nonnull NSString *)pluginAuthor;
- (nonnull NSString *)pluginCopyright;
- (nonnull NSString *)pluginVersion;

/// Returns a string identifying the plugin for the command line tool.
/// For instance, the Mach-O loader returns "Mach-O".
/// You should avoid spaces in order to avoid quotes in the command line.
- (nonnull NSArray<NSString *> *)commandLineIdentifiers;

@end
