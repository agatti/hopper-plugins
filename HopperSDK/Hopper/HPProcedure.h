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

@protocol HPBasicBlock;
@protocol HPTag;

@protocol HPProcedure

- (NSUInteger)basicBlockCount;
- (NSObject<HPBasicBlock> *)firstBasicBlock;
- (NSObject<HPBasicBlock> *)basicBlockStartingAt:(Address)address;
- (NSObject<HPBasicBlock> *)basicBlockContainingInstructionAt:(Address)address;
- (NSObject<HPBasicBlock> *)basicBlockAtIndex:(NSUInteger)index;

- (Address)entryPoint;

// Variables
- (NSString *)variableNameForDisplacement:(int64_t)disp;
- (void)setVariableName:(NSString *)name forDisplacement:(int64_t)disp;

// Tags
- (void)addTag:(NSObject<HPTag> *)tag;
- (void)removeTag:(NSObject<HPTag> *)tag;
- (BOOL)hasTag:(NSObject<HPTag> *)tag;

@end
