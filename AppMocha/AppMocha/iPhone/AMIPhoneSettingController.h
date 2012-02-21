//
//  AMIPhoneSettingController.h
//  AppMocha
//
//  Created by Jason Wang on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMIPhoneSettingAliasCell.h"
#import "AMIPhoneSettingPushEnableCell.h"
#import "AMIPhoneSettingPushIntervalCell.h"

@interface AMIPhoneSettingController : UIViewController <UITableViewDelegate,UITableViewDataSource,AMIPhoneSettingAliasCellDelegate,AMIPhoneSettingPushEnableCellDelegate> {
    IBOutlet AMIPhoneSettingAliasCell *aliasCell;
    IBOutlet AMIPhoneSettingPushEnableCell *pushEnableCell;
    IBOutlet AMIPhoneSettingPushIntervalCell *pushIntervalCell;
    
    IBOutlet UITableView *settingView;
    
    UIBarButtonItem *leftBarButton;
    
    @private
        BOOL _pushEnable;
        NSArray *_pushIntervals;
}

- (void)newIntervalWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime index:(NSNumber *)index;

- (void)deleteIntervalAtIndex:(NSNumber *)index;

@end
