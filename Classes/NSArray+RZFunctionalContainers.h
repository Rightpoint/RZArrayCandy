//
//  NSArray+RZFunctionalContainers.h
//  RZFunctionalContainerTests
//
//  Created by Nick Donaldson on 5/28/14.


#import <Foundation/Foundation.h>

@interface NSArray (RZFunctionalContainers)

- (NSArray *)rz_map:(id(^)(id obj, NSUInteger idx))block;

@end
