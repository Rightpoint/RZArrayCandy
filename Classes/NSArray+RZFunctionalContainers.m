//
//  NSArray+RZFunctionalContainers.m
//  RZFunctionalContainerTests
//
//  Created by Nick Donaldson on 5/28/14.

#import "NSArray+RZFunctionalContainers.h"

@implementation NSArray (RZFunctionalContainers)

- (NSArray *)rz_map:(id (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    NSMutableArray *mapped = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id result = block(obj, idx);
        if ( result ) {
            [mapped addObject:result];
        }
    }];
    return [NSArray arrayWithArray:mapped];
}

@end
