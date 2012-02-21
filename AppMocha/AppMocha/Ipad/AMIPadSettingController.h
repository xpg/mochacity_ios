//
//  AMIPadSettingController.h
//  AppMocha
//
//  Created by Jason Wang on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMIPadSettingAliasCell.h"
#import "AMIPadSettingPushEnableCell.h"
#import "AMIPadSettingPushIntervalCell.h"

@interface AMIPadSettingController : UIViewController <UITableViewDelegate,UITableViewDataSource,AMIPadSettingAliasCellDelegate,AMIPadSettingPushEnableCellDelegate> {
    IBOutlet AMIPadSettingAliasCell *aliasCell;
    IBOutlet AMIPadSettingPushEnableCell *pushEnableCell;
    IBOutlet AMIPadSettingPushIntervalCell *pushIntervalCell;
    
    IBOutlet UITableView *settingView;
    
    UIBarButtonItem *leftBarButton;
    
    @private
        BOOL _pushEnable;
        NSArray *_pushIntervals;
}

- (void)newIntervalWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime index:(NSNumber *)index;

- (void)deleteIntervalAtIndex:(NSNumber *)index;

@end
