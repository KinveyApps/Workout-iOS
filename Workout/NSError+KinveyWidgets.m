//
//  NSError+KinveyWidgets.m
//  KinveyWidgets
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
//  Created by Michael Katz on 5/29/13.
//

#import "NSError+KinveyWidgets.h"
#import <KinveyKit/KinveyKit.h>

@implementation NSError (KinveyWidgets)

- (void) kcsAlert
{
    [[[UIAlertView alloc] initWithTitle:[self localizedDescription]
                               message:[self localizedFailureReason]
                              delegate:nil
                     cancelButtonTitle:NSLocalizedString(@"OK", @"OK button")
                      otherButtonTitles:nil] show];
    NSLog(@"Kinvey Error: %@ (Request ID: '%@')", [self userInfo][KCSErrorCode], [self userInfo][KCSRequestId]);
}

@end
