//
// Hopper Disassembler SDK
//
// (c)2014 - Cryptic Apps SARL. All Rights Reserved.
// http://www.hopperapp.com
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//

#import <Foundation/Foundation.h>
#import "CommonTypes.h"

@class HopperUUID;
@protocol HPHopperServices;

@protocol HopperPlugin <NSObject>

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services;

- (HopperUUID *)pluginUUID;
- (HopperPluginType)pluginType;

- (NSString *)pluginName;
- (NSString *)pluginDescription;
- (NSString *)pluginAuthor;
- (NSString *)pluginCopyright;
- (NSString *)pluginVersion;

@end
