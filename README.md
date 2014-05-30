RZArrayCandy
============

[![Build Status](https://travis-ci.org/Raizlabs/RZArrayCandy.svg)](https://travis-ci.org/Raizlabs/RZArrayCandy)

A collection of delicious, safely-prefixed functional sugar for `NSArray`.

#### `rz_map:`

Map a block over each object in an array to produce a transformed array.

```objective-c
NSArray *result = [@[@1, @2, @3, @4] rz_map:^id(NSNumber *n, NSUInteger idx, NSArray *array) {
	return @([n integerValue] * 2);
}];
// result == @[@2, @4, @6, @8]
```

Returning nil omits that entry from the resulting array.

```objective-c
NSArray *result = [@[@"1", @2, @3, @4] rz_map:^id(id obj, NSUInteger idx, NSArray *array) {
   return [obj isKindOfClass:[NSNumber class]] ? obj : nil;
}];
// result == @[@2, @3, @4]
```

#### `rz_reduce:`

Reduce the objects in an array to a single value.

```objective-c
    NSArray *result = [@[@1, @2, @3, @10] rz_reduce:^id(NSNumber *prev, NSNumber *current, NSUInteger idx, NSArray *array) {
    return @([prev integerValue] + [current integerValue]);
}];
// result == @16
```

#### `rz_filter:`

```objective-c
NSArray *result = [@[@1, @2, @3, @4, @5] rz_filter:^BOOL(NSNumber *n, NSUInteger idx, NSArray *array) {
    return ([n integerValue] >= 3);
}];
// result == @[@3, @4, @5]
```
