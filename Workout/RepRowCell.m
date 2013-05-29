//
//  RepRowCell.m
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

#import "RepRowCell.h"
#import "WorkoutViewController.h"
#import "NSDate+KinveyWidgets.h"

@interface RepRowCell ()
@property (nonatomic, retain) UIButton* button1;
@property (nonatomic, retain) UIButton* button2;
@property (nonatomic, retain) UIButton* button3;
@property (nonatomic, retain) UIButton* button4;
@property (nonatomic, retain) UILabel* dateLabel;
@end


@implementation RepRowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        CGRect frame = CGRectMake(0, 22., 80., 22.);
        
        _button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button1.frame = frame;
        _button1.tag = 1;
        [_button1 setTitle:@"Set 1" forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button1];
        
        frame.origin.x = CGRectGetMaxX(frame);
        _button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button2.frame = frame;
        _button2.tag = 2;
        [_button2 setTitle:@"Set 2" forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button2];
      
        frame.origin.x = CGRectGetMaxX(frame);
        _button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button3.frame = frame;
        _button3.tag = 3;
        [_button3 setTitle:@"Set 3" forState:UIControlStateNormal];
        [_button3 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button3];
        
        frame.origin.x = CGRectGetMaxX(frame);
        _button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button4.frame = frame;
        _button4.tag = 4;
        [_button4 setTitle:@"Set 4" forState:UIControlStateNormal];
        [_button4 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button4];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, 100, 22)];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(4., 4., 300, 18);
    [self.textLabel sizeToFit];
    
    CGRect f = _dateLabel.frame;
    f.origin.x = CGRectGetMaxX(self.textLabel.frame) + 4.;
    _dateLabel.frame = f;
}

- (void) setCount:(NSNumber*)count andWeight:(NSNumber*)weight at:(NSInteger)index
{
    UIButton* button;
    switch (index) {
        case 0:
            button = _button1;
            break;
        case 1:
            button = _button2;
            break;
        case 2:
            button = _button3;
            break;
        case 3:
            button = _button4;
            break;
        default:
            break;
    }
    NSString* title = [NSString stringWithFormat:@"%@lb (%@)",weight, count];
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)setDate:(NSDate *)date
{
    _dateLabel.text = [date stringWithFormat:@"MM/dd hh:mm"];
}

- (void) buttonTapped:(UIButton*)button
{
    [_delegate tapped:self button:button.tag];
}

@end
