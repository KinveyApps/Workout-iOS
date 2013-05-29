//
//  NSArray+MKHelpers.h
//  iOS UI Utils
//
//  Copyright 2012-2013 Michael Katz
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>

/* Array utils */
@interface NSArray (MKHelpers)
/** Returns the elements of the start array, reversed.
 @return a new array with the reversed elements 
 */
- (NSArray*) reverseArray;

- (NSArray*) map:(id (^)(id obj, NSUInteger idx)) mapping;
+ (NSArray*) intArrayFrom:(NSInteger)start to:(NSInteger)end;

- (instancetype) arrayByRemovingObject:(id)object;
- (instancetype) arrayByPrependingObject:(id)object;

@end
