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

@class HopperUUID;

@protocol HPLoaderOptionComponents <NSObject>

@property (assign) Address addressValue;

@property (assign) BOOL isChecked;

@property (nullable, strong) HopperUUID *cpuUUID;
@property (nullable, strong) NSString *cpuFamily;
@property (nullable, strong) NSString *cpuSubFamily;

@property (nullable, strong) NSArray *stringList;
@property (assign) NSUInteger selectedStringIndex;

@end
