//
//  ZonePickerViewController.m
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

#import "ZonePickerViewController.h"
#import "WorkoutViewController.h"

@interface ZonePickerViewController ()

@end

@implementation ZonePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadTable:(NSString*)zone
{
    WorkoutViewController* wvc = [[WorkoutViewController alloc] initWithNibName:@"WorkoutViewController_iPhone" bundle:nil];
    wvc.zone = zone;
    [self.navigationController pushViewController:wvc animated:YES];
}

- (IBAction)chooseLegs:(id)sender {
    [self loadTable:@"legs"];
}
- (IBAction)chooseArms:(id)sender {
    [self loadTable:@"arms"];
}
- (IBAction)chooseCore:(id)sender {
    [self loadTable:@"core"];
}
- (IBAction)chooseChest:(id)sender {
    [self loadTable:@"chest" ];
}
- (IBAction)chooseBack:(id)sender {
    [self loadTable:@"back"];
}
@end
