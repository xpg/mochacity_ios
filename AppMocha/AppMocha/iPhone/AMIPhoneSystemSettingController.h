//
//  AMIPhoneSystemSettingController.h
//  AppMocha
//
//  Created by Danny Deng on 12-2-24.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMIPhoneStartEndTimeController.h"
#import "AMIPhoneSystemSettingCell.h"

@interface AMIPhoneSystemSettingController : UIViewController <UITableViewDelegate, UITableViewDataSource, AMIPhoneStartEndTimeControllerDelegate>{
    UIBarButtonItem *_addBarButton, *_editBarButton;
    NSInteger editingItem;
    IBOutlet AMIPhoneSystemSettingCell *systemSettingCell;
}

@property (nonatomic, assign) NSMutableArray *timeDataArray;
@property (nonatomic, assign) IBOutlet UITableView *timeTableView;

@end
