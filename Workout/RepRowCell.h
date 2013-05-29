//
//  RepRowCell.h
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
#import <UIKit/UIKit.h>

@class WorkoutViewController;

@interface RepRowCell : UITableViewCell
- (void) setCount:(NSNumber*)count andWeight:(NSNumber*)weight at:(NSInteger)index;
- (void) setDate:(NSDate*)date;

@property (nonatomic, weak) WorkoutViewController* delegate;
@end
