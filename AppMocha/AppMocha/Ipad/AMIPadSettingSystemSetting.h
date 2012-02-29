//
//  AMIPadSettingSystemSetting.h
//  AppMocha
//
//  Created by Danny Deng on 12-2-24.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMIPadSystemStartEndTimeController.h"
#import "AMIPadSystemSettingCell.h"

@interface AMIPadSettingSystemSetting :  UIViewController <UITableViewDelegate, UITableViewDataSource, AMIPadSystemStartEndTimeControllerDelegate>{
    UIBarButtonItem *_addBarButton, *_editBarButton;
    NSInteger editingItem;
    IBOutlet AMIPadSystemSettingCell *systemSettingCell;
}

@property (nonatomic, assign) NSMutableArray *timeDataArray;
@property (nonatomic, assign) IBOutlet UITableView *timeTableView;

@end
