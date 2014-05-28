//
//  RZFunctionalContainersTests.m
//  RZFunctionalContainersTests
//
//  Created by Nick Donaldson on 5/28/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RZFunctionalContainers.h"

@interface RZFunctionalContainersTests : XCTestCase

@end

@implementation RZFunctionalContainersTests

- (void)test_ArrayMapBasic
{
    // test basic map function
    NSArray *result = [@[@1, @2, @3, @4] rz_map:^id(NSNumber *n, NSUInteger idx) {
        return @([n integerValue] * 2);
    }];
    XCTAssertEqualObjects(result, ({@[@2, @4, @6, @8];}), @"Map did not correctly execute");
    
    // test nil result from map block
    result = [@[@"1", @2, @3, @4] rz_map:^id(id obj, NSUInteger idx) {
        return [obj isKindOfClass:[NSNumber class]] ? obj : nil;
    }];
    XCTAssertEqualObjects(result, ({@[@2, @3, @4];}), @"Map did not correctly exclude nil result");
    
    // test index
    result = [@[@1, @2, @3, @4] rz_map:^id(NSNumber *n, NSUInteger idx) {
        return @([n integerValue] + idx);
    }];
    XCTAssertEqualObjects(result, ({@[@1, @3, @5, @7];}), @"Map did not receive correct indexes");
}

@end
