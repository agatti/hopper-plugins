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

@protocol HPProcedure;
@protocol HPTag;

@protocol HPBasicBlock

- (Address)from;
- (Address)to;

- (nonnull NSObject<HPProcedure> *)procedure;
- (NSUInteger)index;

- (BOOL)hasSuccessors;
- (BOOL)hasPredecessors;

- (nullable NSArray<NSObject<HPBasicBlock> *> *)predecessors;
- (nullable NSArray<NSObject<HPBasicBlock> *> *)successors;

// Tags
- (void)addTag:(nonnull NSObject<HPTag> *)tag;
- (void)removeTag:(nonnull NSObject<HPTag> *)tag;
- (BOOL)hasTag:(nonnull NSObject<HPTag> *)tag;

@end
