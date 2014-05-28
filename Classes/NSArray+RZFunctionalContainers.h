//
//  NSArray+RZFunctionalContainers.h
//  RZFunctionalContainerTests
//
//  Created by Nick Donaldson on 5/28/14.


#import <Foundation/Foundation.h>

typedef id   (^RZFCArrayObjBlock)(id obj, NSUInteger idx, NSArray *array);
typedef id   (^RZFCArrayReduceBlock)(id prev, id current, NSUInteger idx, NSArray *array);
typedef BOOL (^RZFCArrayBooleanBlock)(id obj, NSUInteger idx, NSArray *array);

@interface NSArray (RZFunctionalContainers)

/**
 *  Returns the result of perorming a block on each object in the array
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
 *  Reduce the objects in an array to a single value.
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
 *  @param initial Initial value for the reduce operation, or nil.
 *
 *  @return Result from performing the reduce operation on all objects in the array.
 */
- (id)rz_reduce:(RZFCArrayReduceBlock)block initial:(id)initial;

/**
 *  Returns a filtered version of the array as filtered by the block
 *
 *  @param block Block that is passed the object, its index, and the original array.
 *               If the block returns NO for an object, it is omitted from the result.
 *
 *  @return A new array that is a filtered version of the target.
 */
- (NSArray *)rz_filter:(RZFCArrayBooleanBlock)block;

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

@end
