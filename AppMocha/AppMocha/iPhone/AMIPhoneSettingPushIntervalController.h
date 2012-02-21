//
//  AMIPhoneSettingPushIntervalController.h
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMIPhoneSettingController.h"

@interface AMIPhoneSettingPushIntervalController : UIViewController {
    IBOutlet UISegmentedControl *timeSegment;
    IBOutlet UIDatePicker *timePicker;
    
    IBOutlet UIButton *deleteButton;
    
    AMIPhoneSettingController *previousController;
}

@property(nonatomic,assign) AMIPhoneSettingController *previousController;

- (void)setStartTime:(NSDate *)startTime endTime:(NSDate *)endTime index:(NSNumber *)index;

@end
