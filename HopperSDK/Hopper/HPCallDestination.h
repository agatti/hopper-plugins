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

@protocol HPCallDestination

- (Address)address;
- (void)setAddress:(Address)address;

- (BOOL)cpuModeIsKnown;
- (void)setCpuModeIsKnown:(BOOL)b;
- (uint8_t)cpuMode;
- (void)setCpuMode:(uint8_t)cpuMode;

@end
