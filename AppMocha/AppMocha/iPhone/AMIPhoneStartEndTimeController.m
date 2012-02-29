//
//  AMIPhoneStartEndTimeController.m
//  AppMocha
//
//  Created by Danny Deng on 12-2-24.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "AMIPhoneStartEndTimeController.h"

@implementation AMIPhoneStartEndTimeController
@synthesize startPickerView, endPickerView;
@synthesize delegate;

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (delegate && [delegate respondsToSelector:@selector(StartEndTime:EndTime:)]) {
        NSInteger startTime, endTime;
        startTime = [startPickerView selectedRowInComponent:0]*60*60;
        startTime += [startPickerView selectedRowInComponent:1]*60;
        startTime += [startPickerView selectedRowInComponent:2];
        endTime = [endPickerView selectedRowInComponent:0]*60*60;
        endTime += [endPickerView selectedRowInComponent:1]*60;
        endTime += [endPickerView selectedRowInComponent:2];
        [delegate StartEndTime:startTime EndTime:endTime];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect startPickFrame, endPickFrame;
    startPickFrame = [startPickerView frame];
    endPickFrame = [endPickerView frame];
    [startPickerView setDelegate:self];
    [startPickerView setDataSource:self];
    [endPickerView setDelegate:self];
    [endPickerView setDataSource:self];
    [startPickerView setFrame:CGRectMake(startPickFrame.origin.x, startPickFrame.origin.y, startPickFrame.size.width, 130)];
    [endPickerView setFrame:CGRectMake(endPickFrame.origin.x, endPickFrame.origin.y, endPickFrame.size.width, 130)];
    [startPickerView selectRow:12 inComponent:0 animated:NO];
    [startPickerView selectRow:30 inComponent:1 animated:NO];
    [startPickerView selectRow:30 inComponent:2 animated:NO];
    [endPickerView selectRow:12 inComponent:0 animated:NO];
    [endPickerView selectRow:30 inComponent:1 animated:NO];
    [endPickerView selectRow:30 inComponent:2 animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PickerViewDelegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 24;
            break;
        case 1:
            return 60;
            break;
        case 2:
            return 60;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%i时", row];
            break;
        case 1:
            return [NSString stringWithFormat:@"%i分", row];
            break;
        case 2:
            return [NSString stringWithFormat:@"%i秒", row];
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - Public
- (void)setStartEndTime:(NSInteger)startTime EndTime:(NSInteger)endTime {
    [startPickerView selectRow:startTime/3600 inComponent:0 animated:NO];
    [startPickerView selectRow:startTime/60%60 inComponent:1 animated:NO];
    [startPickerView selectRow:startTime%60 inComponent:2 animated:NO];
    [endPickerView selectRow:endTime/3600 inComponent:0 animated:NO];
    [endPickerView selectRow:endTime/60%60 inComponent:1 animated:NO];
    [endPickerView selectRow:endTime%60 inComponent:2 animated:NO];
    
}

@end
