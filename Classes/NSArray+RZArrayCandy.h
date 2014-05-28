//
//  NSArray+RZArrayCandy.h
//  RZFunctionalContainerTests
//
//  Created by Nick Donaldson on 5/28/14.


#import <Foundation/Foundation.h>

typedef id   (^RZFCArrayObjBlock)(id obj, NSUInteger idx, NSArray *array);
typedef id   (^RZFCArrayReduceBlock)(id prev, id current, NSUInteger idx, NSArray *array);
typedef BOOL (^RZFCArrayBooleanBlock)(id obj, NSUInteger idx, NSArray *array);

@interface NSArray (RZArrayCandy)

/**
 *  Perform a block on each object in the target array and return the results in a new array.
 *
 *  @param block Block to perform on each object. Receives the current object, 
 *               its index, and the original array. The block should return an
 *               object or nil. If nil, the corresponding object will be omitted from
 *               the resulting array.
 *
 *  @return A new array contining the result of performing the block on each object.
 */
- (NSArray *)rz_map:(RZFCArrayObjBlock)block;

/**
 *  Reduce the objects in the target array to a single value.
 *
 *  @param block   Block that performs the reduction operation.
 *                     @c prev
 *                     The result from the previous invocation of the block, or the initial
 *                     value if this is the first invocation.
 *                     @c current
 *                     The object at the current index of the array.
 *                     @c idx
 *                     The current index of the array.
 *                     @c array
 *                     The original array.
 *
 *  @return Result from performing the reduce operation on all objects in the array.
 */
- (id)rz_reduce:(RZFCArrayReduceBlock)block;

/**
 *  Reduce the objects in the target array to a single value.
 *
 *  @param block   Block that performs the reduction operation.
 *                     @c prev
 *                     The result from the previous invocation of the block, or the initial
 *                     value if this is the first invocation.
 *                     @c current
 *                     The object at the current index of the array.
 *                     @c idx
 *                     The current index of the array.
 *                     @c array
 *                     The original array.
 *
 *  @param initial Optional initial value for the reduce operation.
 *
 *  @return Result from performing the reduce operation on all objects in the array.
 */
- (id)rz_reduce:(RZFCArrayReduceBlock)block initial:(id)initial;

/**
 *  Filter the target array and return the result.
 *
 *  @param block Block that is passed the object, its index, and the original array.
 *               If the block returns NO for an object, it is omitted from the result.
 *
 *  @return A new array that is a filtered version of the target.
 */
- (NSArray *)rz_filter:(RZFCArrayBooleanBlock)block;

/**
 *  Get the value for a keypath on each object in the target array.
 *  Syntatic shortcut for @p valueForKeyPath: on an array.
 *
 *  @param keypath The keypath for which to get the value on each object.
 *
 *  @return A new array consisting of the values for the provided keypath.
 */
- (NSArray *)rz_pick:(NSString *)keypath;


/**
 *  Returns whether all the objects in the array pass a test.
 *
 *  @param block Block that tests a condition and returns whether the object passes.
 *
 *  @return YES if all objects pass the test, NO otherwise.
 */
- (BOOL)rz_all:(RZFCArrayBooleanBlock)block;

/**
 *  Returns whether none of the objects in the array pass a test.
 *
 *  @param block Block that tests a condition and returns whether the object passes.
 *
 *  @return YES if none of the objects pass the test, NO otherwise.
 */
- (BOOL)rz_none:(RZFCArrayBooleanBlock)block;

/**
 *  Remove all instances of NSNull in the target array
 *
 *  @return A new array without any NSNull instances.
 */
- (NSArray *)rz_compacted;

/**
 *  Reverse the array and return the result.
 *
 *  @return A new array that is a reversed version of the target.
 */
- (NSArray *)rz_reversed;

/**
 *  Remove duplicate entries in the array while maintaining current relative ordering.
 *
 *  @return An array with duplicate entires removed
 */
- (NSArray *)rz_deduped;

/**
 *  Return the sum of the numbers in the array.
 *  Objects in array must respond to @p decimalValue. 
 *  @p NSNumber and @p NSString representing a number are both valid.
 *  Syntactic shortcut for @p valueForKeyPath:@"@sum.self"
 *
 *  @return The sum of all the numbers in the array.
 */
- (NSNumber *)rz_sum;

/**
 *  Return the average of the numbers in the array.
 *  Objects in array must respond to @p decimalValue.
 *  @p NSNumber and @p NSString representing a number are both valid.
 *  Syntactic shortcut for @p valueForKeyPath:@"@avg.self"
 *
 *  @return The average of all the numbers in the array.
 */
- (NSNumber *)rz_average;

/**
 *  Return the maximum of the numbers in the array.
 *  Objects in array must all be numeric types.
 *  Syntactic shortcut for @p valueForKeyPath:@"@max.self"
 *
 *  @return The maximum of all the numbers in the array.
 */
- (NSNumber *)rz_max;

/**
 *  Return the minimum of the numbers in the array.
 *  Objects in array must all be numeric types.
 *  Syntactic shortcut for @p valueForKeyPath:@"@min.self"
 *
 *  @return The minimum of all the numbers in the array.
 */
- (NSNumber *)rz_min;

@end
