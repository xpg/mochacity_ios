//
//  AMIPadSettingPersonalInfoController.h
//  AppMocha
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMIPadSettingPersonalInfoController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    UILabel *_lblsex, *_lblage, *_lblEarn;
    UITextField *_textFieldJob;
    UIPickerView *_agePickerView;
    UIPickerView *_earnPickerView;
    NSInteger wan,qian,bai;
}

@property (nonatomic, assign) IBOutlet UITableView *personalSettingTableView;

@end
