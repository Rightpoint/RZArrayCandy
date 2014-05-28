//
//  NSArray+RZFunctionalContainers.m
//  RZFunctionalContainerTests
//
//  Created by Nick Donaldson on 5/28/14.

#import "NSArray+RZFunctionalContainers.h"

@implementation NSArray (RZFunctionalContainers)

- (NSArray *)rz_map:(RZFCArrayObjBlock)block
{
    NSParameterAssert(block);
    NSMutableArray *mapped = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id result = block(obj, idx, self);
        if ( result ) {
            [mapped addObject:result];
        }
    }];
    return [NSArray arrayWithArray:mapped];
}

- (NSArray *)rz_filter:(RZFCArrayBooleanBlock)block
{
    NSParameterAssert(block);
    NSMutableArray *filtered = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( block(obj, idx, self) ) {
            [filtered addObject:obj];
        }
    }];
    return [NSArray arrayWithArray:filtered];
}

- (NSArray *)rz_reversed
{
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)rz_deduped
{
    return [[[NSOrderedSet alloc] initWithArray:self] array];
}

@end
