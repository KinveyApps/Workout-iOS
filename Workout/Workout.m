//
//  Workout.m
//  Workout
//
//  Copyright 2013 Kinvey, Inc
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
//  Created by Michael Katz on 5/20/13.
//

#import "Workout.h"

@implementation Workout

- (id)init
{
    self = [super init];
    if (self) {
        _repCount = [NSMutableArray array];
        _repWeight = [NSMutableArray array];
        _workoutTime = [NSDate date];
    }
    return self;
}

- (NSDictionary *)hostToKinveyPropertyMapping
{
    //       client property : backend column
    //       ----------------:----------------
    return @{@"workoutId"    : KCSEntityKeyId,
             @"zone"         : @"zone",
             @"workoutName"  : @"name",
             @"repCount"     : @"repCount",
             @"repWeight"    : @"repWeight",
             @"workoutTime"  : @"time"};
}

@end
