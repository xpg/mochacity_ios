//
//  AMIPhoneSettingPushEnableCell.h
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMIPhoneSettingPushEnableCellDelegate;

@interface AMIPhoneSettingPushEnableCell : UITableViewCell {
    IBOutlet id<AMIPhoneSettingPushEnableCellDelegate> delegate;
    IBOutlet UISwitch *enableSwitch;
}

- (void)setIsOn:(BOOL)isOn;

- (IBAction)enableChange:(id)sender;

@end

@protocol AMIPhoneSettingPushEnableCellDelegate <NSObject>

@optional

- (void)pushEnableCell:(AMIPhoneSettingPushEnableCell *)aliasCell isOn:(BOOL)isOn;

@end
