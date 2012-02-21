//
//  AMIPadSettingController.h
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMIPadSettingPushEnableCellDelegate;

@interface AMIPadSettingPushEnableCell : UITableViewCell {
    IBOutlet id<AMIPadSettingPushEnableCellDelegate> delegate;
    IBOutlet UISwitch *enableSwitch;
}

- (void)setIsOn:(BOOL)isOn;

- (IBAction)enableChange:(id)sender;

@end

@protocol AMIPadSettingPushEnableCellDelegate <NSObject>

@optional

- (void)pushEnableCell:(AMIPadSettingPushEnableCell *)aliasCell isOn:(BOOL)isOn;

@end
