//
//  AMIPhoneSystemSettingCell.h
//  AppMocha
//
//  Created by Danny Deng on 12-2-24.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMIPhoneSystemSettingCell : UITableViewCell {
    IBOutlet UILabel *lblStartTimeString;
    IBOutlet UILabel *lblEndTimeString;
    IBOutlet UILabel *lblTimeFlag;
}

- (void)setStartEndTimeString:(NSString *)startString EndTime:(NSString *)endString TimeFlag:(NSString *)flagString;

@end
