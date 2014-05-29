//
//  RZArrayCandyTests.m
//  RZArrayCandyTests
//
//  Created by Nick Donaldson on 5/28/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+RZArrayCandy.h"

@interface RZArrayCandyTests : XCTestCase

@property (nonatomic, strong) NSArray *peeps;

@end

@implementation RZArrayCandyTests

- (void)setUp
{
    [super setUp];
    NSArray *peeps = @[
       @{
           @"name" : @"Bob",
           @"age" : @40,
           @"pet" : @{
                   @"name" : @"Rover"
           }
        },
       @{
           @"name" : @"Steve",
           @"age" : @19,
           @"pet" : @{
                   @"name" : @"Dumbledore"
           }
        },
       @{
           @"name" : @"Tiffany",
           @"age"  : @25
        }
    ];
    self.peeps = peeps;
}

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

- (void)test_ArrayReduce
{
    // Simple adder
    NSArray *result = [@[@1, @2, @3, @10] rz_reduce:^id(NSNumber *prev, NSNumber *current, NSUInteger idx, NSArray *array) {
        return @([prev integerValue] + [current integerValue]);
    }];
    XCTAssertEqualObjects(result, @16, @"Result is not correct - reduce did not add correctly");
    
    result = [self.peeps rz_reduce:^id(id prev, id current, NSUInteger idx, NSArray *array) {
        return @( [prev integerValue] + [current[@"age"] integerValue] );
    } initialValue:@16];
    XCTAssertEqualObjects(result, @100, @"Ages did not sum correctly with initial value");
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
    
    result = [self.peeps rz_filter:^BOOL(NSDictionary *person, NSUInteger idx, NSArray *array) {
        return [person[@"age"] compare:@21] != NSOrderedAscending;
    }];
    
    XCTAssertTrue(result.count == 2, @"Should only be two matches");
    if ( result.count == 2 ) {
        XCTAssertEqualObjects(result[0][@"name"], @"Bob", @"Wrong name in results");
        XCTAssertEqualObjects(result[1][@"name"], @"Tiffany", @"Wrong name in results");
    }
}

- (void)test_ArrayPick
{
    NSArray *result = [self.peeps rz_pick:@"name"];
    XCTAssertEqualObjects(result, ({@[@"Bob", @"Steve", @"Tiffany"];}), "Pick failed with single key");
    
    result = [self.peeps rz_pick:@"pet.name"];
    XCTAssertEqualObjects(result, ({@[@"Rover", @"Dumbledore", [NSNull null]];}), @"Pick failed with keypath");
    XCTAssertEqualObjects([result rz_compacted], ({@[@"Rover", @"Dumbledore"];}), @"Compacted failed.");
}

- (void)test_ArrayAllNone
{
    BOOL peepsAllOldEnough = [self.peeps rz_all:^BOOL(id obj, NSUInteger idx, NSArray *array) {
        return [obj[@"age"] integerValue] > 18;
    }];
    XCTAssertTrue(peepsAllOldEnough, @"Everyone should be older than 18.");
    
    BOOL peepsAllYoungEnough = [self.peeps rz_none:^BOOL(id obj, NSUInteger idx, NSArray *array) {
        return [obj[@"age"] integerValue] > 80;
    }];
    XCTAssertTrue(peepsAllYoungEnough, @"Everyone should be younger than 80.");
    
    BOOL peepsAllHavePets = [self.peeps rz_all:^BOOL(id obj, NSUInteger idx, NSArray *array) {
        return obj[@"pet"] != nil;
    }];
    XCTAssertFalse(peepsAllHavePets, @"Not all the peeps have pets");
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

- (void)test_ArrayNumericSugar
{
    NSArray *numbers = @[@1, @3, @7, @10];
    NSArray *numericStrings = @[@1, @"3", @"7", @10];
    NSArray *nonNumericStrings = @[@1, @"Hoover", @"7", @10];
    NSArray *wtfAreYouDoing = @[@1, [NSObject new], @"Marshmallow", [NSNull null]];
    
    XCTAssertEqualObjects([numbers rz_sum], @21, @"Sum didn't work");
    XCTAssertEqualObjects([numericStrings rz_sum], @21, @"Sum didn't work on mixed types");
    XCTAssertEqualObjects([nonNumericStrings rz_sum], @(NAN), @"Sum should produce NaN for invalid strings");
    XCTAssertThrows([wtfAreYouDoing rz_sum], @"That should throw an exception, buddy");

    XCTAssertEqualObjects([numbers rz_average], @(5.25), @"Average didn't work");
    XCTAssertEqualObjects([numericStrings rz_average], @(5.25), @"Average didn't work on mixed types");
    XCTAssertThrows([nonNumericStrings rz_average], @"Average should throw exception for invalid strings");
    XCTAssertThrows([wtfAreYouDoing rz_average], @"That should throw an exception, buddy");
    
    XCTAssertEqualObjects([numbers rz_max], @(10), @"Max didn't work");
    XCTAssertThrows([numericStrings rz_max], @"Max should throw exception on mixed types");
    XCTAssertThrows([nonNumericStrings rz_max], @"Max should throw exception for invalid strings");
    XCTAssertThrows([wtfAreYouDoing rz_max], @"That should throw an exception, buddy");
    
    XCTAssertEqualObjects([numbers rz_min], @(1), @"Min didn't work");
    XCTAssertThrows([numericStrings rz_min], @"Min should throw exception for mixed types");
    XCTAssertThrows([nonNumericStrings rz_min], @"Min should throw exception for invalid strings");
    XCTAssertThrows([wtfAreYouDoing rz_min], @"That should throw an exception, buddy");
}

- (void)test_ArrayCompound
{
    NSMutableArray *numbers = [NSMutableArray array];
    for ( NSUInteger i = 0; i < 10; i++ ) {
        [numbers addObject:@(i+1)];
    }
    
    NSNumber *result =
        [[numbers rz_map:^id(NSNumber *n, NSUInteger idx, NSArray *array) {
            return @([n integerValue] * 10);
        }] rz_reduce:^id(id prev, id current, NSUInteger idx, NSArray *array) {
            return @([prev integerValue] + [current integerValue]);
        }];
    
    XCTAssertEqualObjects(result, @550, @"Compound enumeration failed");
}

@end
