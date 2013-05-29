//
//  ViewController.m
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

#import "WorkoutViewController.h"
#import "Workout.h"
#import "RepRowCell.h"
#import "NSError+KinveyWidgets.h"
#import "NSArray+MKHelpers.h"

#import <KinveyKit/KinveyKit.h>

@interface WorkoutViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UITextField* textView;
@property (nonatomic, strong) NSArray* workouts;
@property (nonatomic, strong) KCSAppdataStore* dataStore;
@property (nonatomic, strong) UIPickerView* weightPicker;
@property (nonatomic, weak) Workout* lastWorkout;
@property (nonatomic) int lastRep;
@end

@implementation WorkoutViewController


#pragma mark - Kinvey
- (void) setupStore
{
    KCSCollection* workoutCollection = [KCSCollection collectionFromString:@"workouts" ofClass:[Workout class]];
    _dataStore = [KCSAppdataStore storeWithCollection:workoutCollection options:nil];
}

- (void) refresh
{
    KCSQuery* byZone = [KCSQuery queryOnField:@"zone" withExactMatchForValue:_zone];
    [byZone addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"time" inDirection:kKCSDescending]];
    
// ---- READ ---- 
    [_dataStore queryWithQuery:byZone withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
       
        if (objectsOrNil) {
            
            _workouts = objectsOrNil;
            [_tableView reloadData];
            
        } else {
            
            [errorOrNil kcsAlert];
            
        }
    } withProgressBlock:^(NSArray *objects, double percentComplete) {
        NSLog(@"Refresh progress for '%@', %f", _zone, percentComplete);
    }];
}

#pragma mark - Actions

- (void) add:(id)sender
{
    NSString* name =  _textView.text;
    if (name.length == 0) {
        return;
    }
    [_textView endEditing:YES];
    
    Workout* workout = [[Workout alloc] init];
    workout.workoutTime = [NSDate date];
    workout.workoutName = name;
    workout.zone = _zone;
    _lastWorkout = workout;
    
    _workouts = [_workouts arrayByPrependingObject:workout];
    [_tableView reloadData];
    
// ------ Insert new object in the db ---------------------------
    [_dataStore saveObject:workout withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil) {
            [errorOrNil kcsAlert];
        } else {
            //save always returns an updated object, so reload just in case
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_workouts indexOfObject:workout] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    } withProgressBlock:nil];
}

- (void) doneSettingRep:(id)sender
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
    NSUInteger weightRow = [_weightPicker selectedRowInComponent:0];
    NSUInteger repRow = [_weightPicker selectedRowInComponent:1];
    
    NSNumber* weight = @((weightRow+1)*5);
    NSNumber* count = @(repRow+1);
    
    if (_lastRep < _lastWorkout.repCount.count) {
        [_lastWorkout.repCount replaceObjectAtIndex:_lastRep withObject:count];
        [_lastWorkout.repWeight replaceObjectAtIndex:_lastRep withObject:weight];
    } else {
        [_lastWorkout.repWeight addObject:weight];
        [_lastWorkout.repCount addObject:count];
    }
    
    [_weightPicker removeFromSuperview];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_workouts indexOfObject:_lastWorkout] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
// ------ Saving ---------------------------
    [_dataStore saveObject:_lastWorkout withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil) {
            [errorOrNil kcsAlert];
        } else {
            //save always returns an updated object, so reload just in case
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_workouts indexOfObject:_lastWorkout] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    } withProgressBlock:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) return;
    
    Workout* workout = _workouts[indexPath.row];
// ------- DELETE -------------
    [_dataStore removeObject:workout withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (!errorOrNil) {
            _workouts = [_workouts arrayByRemovingObject:workout];
            [_tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [errorOrNil kcsAlert];
        }
    } withProgressBlock:nil];
}



#pragma mark - App lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
    _textView = [[UITextField alloc] initWithFrame:CGRectMake(0., 0., 200., 28.)];
    _textView.placeholder = @"Enter Workout Name";
    _textView.borderStyle = UITextBorderStyleRoundedRect;
    _textView.delegate = self;
    self.navigationItem.titleView = _textView;
    
    _weightPicker = [[UIPickerView alloc] init];
    _weightPicker.delegate = self;
    _weightPicker.dataSource = self;
    _weightPicker.showsSelectionIndicator = YES;

    
    _workouts = @[];
    
    [self.tableView registerClass:[RepRowCell class] forCellReuseIdentifier:@"cell"];
    
    [self setupStore];
    [self refresh];
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _workouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepRowCell* rc = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    rc.delegate = self;
    
    Workout* workout = _workouts[indexPath.row];
    rc.textLabel.text = workout.workoutName;
    [rc setDate:workout.workoutTime];
    
    NSMutableString* s = [NSMutableString string];
    for (int i = 0; i < workout.repCount.count; i++) {
        [rc setCount:workout.repCount[i] andWeight:workout.repWeight[i] at:i];
    }
    
    rc.detailTextLabel.text = s;
    return rc;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _lastWorkout = _workouts[indexPath.row];

    CGRect f = _weightPicker.frame;
    f.origin.y = self.tableView.frame.size.height - f.size.height;
    _weightPicker.frame = f;
    
    [self.tableView addSubview:_weightPicker];
    [self.view endEditing:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSettingRep:)];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tapped:(UITableViewCell*)cell button:(NSInteger)button
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    _lastWorkout = _workouts[indexPath.row];
    _lastRep = button - 1;
    
    CGRect f = _weightPicker.frame;
    f.origin.y = self.tableView.frame.size.height - f.size.height;
    _weightPicker.frame = f;
    
    if (button <= _lastWorkout.repCount.count) {
        int c = [_lastWorkout.repCount[button-1] intValue];
        int w = [_lastWorkout.repWeight[button-1] intValue];
        [_weightPicker selectRow:(w/5 - 1) inComponent:0 animated:NO];
        [_weightPicker selectRow:(c-1) inComponent:1 animated:NO];
    }
    
    [self.tableView addSubview:_weightPicker];
    [self.view endEditing:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSettingRep:)];
}

#pragma mark - Text Field
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self add:textField];
    [textField endEditing:YES];
    return YES;
}

#pragma mark - Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  20;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* s = nil;
    switch (component) {
        case 0:
            s = [NSString stringWithFormat:@"%d lb", (row+1)*5];
            break;
        case 1:
            s = [NSString stringWithFormat:@"%d", (row+1)];
            break;
        default:
            break;
    }
    return s;
}


@end
