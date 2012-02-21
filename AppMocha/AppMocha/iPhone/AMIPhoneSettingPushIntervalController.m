//
//  AMIPhoneSettingPushIntervalController.m
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMIPhoneSettingPushIntervalController.h"

@interface AMIPhoneSettingPushIntervalController()

@property(nonatomic,copy) NSDate *sTime;
@property(nonatomic,copy) NSDate *eTime;
@property(nonatomic,copy) NSNumber *indexOfArray;

@end

@implementation AMIPhoneSettingPushIntervalController

@synthesize previousController;

@synthesize sTime = _sTime;
@synthesize eTime = _eTime;
@synthesize indexOfArray = _indexOfArray;

- (void)setStartTime:(NSDate *)startTime endTime:(NSDate *)endTime index:(NSNumber *)index {
    self.sTime = startTime;
    self.eTime = endTime;
    self.indexOfArray = index;
}

- (IBAction)deleteInterval:(id)sender {
    [previousController deleteIntervalAtIndex:self.indexOfArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segementChanged:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    switch (seg.selectedSegmentIndex) {
        case 1:
            [timePicker setDate:self.eTime];
            break;
        default:
            [timePicker setDate:self.sTime];
            break;
    }
}

- (IBAction)timeChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    switch (timeSegment.selectedSegmentIndex) {
        case 1:
            self.eTime = datePicker.date;
            break;
        default:
            self.sTime = datePicker.date;
            break;
    }
}

- (void)saveInterval {
    [previousController newIntervalWithStartTime:self.sTime endTime:self.eTime index:self.indexOfArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInterval)];
    self.navigationItem.rightBarButtonItem = saveItem;
    [saveItem release];
    
    if (!self.sTime) self.sTime = [NSDate date];
    if (!self.eTime) self.eTime = [NSDate dateWithTimeInterval:60. * 60 * 2 sinceDate:self.sTime]; 
    [timeSegment setSelectedSegmentIndex:0];
    [timePicker setDate:self.sTime];
    
    if (self.indexOfArray) {
        [deleteButton setHidden:NO];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [self setSTime:nil];
    [self setETime:nil];
    [self setIndexOfArray:nil];
    [super dealloc];
}

@end
