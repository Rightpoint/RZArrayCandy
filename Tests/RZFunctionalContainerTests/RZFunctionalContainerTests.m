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

- (void)test_ArrayMap
{
    // test basic map function
    NSArray *result = [@[@1, @2, @3, @4] rz_map:^id(NSNumber *n, NSUInteger idx, NSArray *array) {
        return @([n integerValue] * 2);
    }];
    XCTAssertEqualObjects(result, ({@[@2, @4, @6, @8];}), @"Map did not correctly execute");
    
    // test nil result from map block
    result = [@[@"1", @2, @3, @4] rz_map:^id(id obj, NSUInteger idx, NSArray *array) {
        return [obj isKindOfClass:[NSNumber class]] ? obj : nil;
    }];
    XCTAssertEqualObjects(result, ({@[@2, @3, @4];}), @"Map did not correctly exclude nil result");
    
    // test index argument
    result = [@[@1, @2, @3, @4] rz_map:^id(NSNumber *n, NSUInteger idx, NSArray *array) {
        return @([n integerValue] + idx);
    }];
    XCTAssertEqualObjects(result, ({@[@1, @3, @5, @7];}), @"Map did not receive correct indexes");
    
    // test array argument
    result = [@[@1, @2, @3, @4] rz_map:^id(NSNumber *n, NSUInteger idx, NSArray *array) {
        return [array objectAtIndex:array.count - idx - 1];
    }];
    XCTAssertEqualObjects(result, ({@[@4, @3, @2, @1];}), @"Map did not receive the original array");
}

- (void)test_ArrayFilter
{
    NSMutableArray *numbers = [NSMutableArray array];
    for ( NSUInteger i = 0; i < 1000; i++ ) {
        [numbers addObject:@(i)];
    }
    
    NSArray *result = [numbers rz_filter:^BOOL(NSNumber *n, NSUInteger idx, NSArray *array) {
        return [n compare:@3] != NSOrderedDescending;
    }];
    XCTAssertEqualObjects(result, ({@[@0, @1, @2, @3];}), @"Filter did not work");
    
    NSArray *peeps = @[
        @{
            @"name" : @"Bob",
            @"age" : @40
        },
        @{
            @"name" : @"Steve",
            @"age" : @19
        },
        @{
            @"name" : @"Tiffany",
            @"age"  : @25
        }
    ];
    
    result = [peeps rz_filter:^BOOL(NSDictionary *person, NSUInteger idx, NSArray *array) {
        return [person[@"age"] compare:@21] != NSOrderedAscending;
    }];
    
    XCTAssertTrue(result.count == 2, @"Should only be two matches");
    if ( result.count == 2 ) {
        XCTAssertEqualObjects(result[0][@"name"], @"Bob", @"Wrong name in results");
        XCTAssertEqualObjects(result[1][@"name"], @"Tiffany", @"Wrong name in results");
    }
}

- (void)test_ArrayReverse
{
    NSArray *numbers = @[@0, @1, @2, @3];
    XCTAssertEqualObjects([numbers rz_reversed], ({@[@3, @2, @1, @0];}), @"Did not reverse array correctly");
}

- (void)test_ArrayDedupe
{
    NSArray *dupes = @[@"I", @"sometimes", @"sometimes", @"might", @"stutter", @"stutter"];
    XCTAssertEqualObjects([dupes rz_deduped], ({@[@"I", @"sometimes", @"might", @"stutter"];}), @"Did not dedupe array correctly");
}

@end
