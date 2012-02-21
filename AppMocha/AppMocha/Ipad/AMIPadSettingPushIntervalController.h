//
//  AMIPadSettingPushIntervalController.h
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMIPadSettingController.h"

@interface AMIPadSettingPushIntervalController : UIViewController {
    IBOutlet UISegmentedControl *timeSegment;
    IBOutlet UIDatePicker *timePicker;
    
    IBOutlet UIButton *deleteButton;
    
    AMIPadSettingController *previousController;
}

@property(nonatomic,assign) AMIPadSettingController *previousController;

- (void)setStartTime:(NSDate *)startTime endTime:(NSDate *)endTime index:(NSNumber *)index;

@end
