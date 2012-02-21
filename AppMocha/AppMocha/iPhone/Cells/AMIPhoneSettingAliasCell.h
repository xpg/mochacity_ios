//
//  AMIPhoneSettingAliasCell.h
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMIPhoneSettingAliasCellDelegate;

@interface AMIPhoneSettingAliasCell : UITableViewCell <UITextFieldDelegate> {
    IBOutlet id<AMIPhoneSettingAliasCellDelegate> delegate;
    IBOutlet UITextField *aliasField;
}

- (void)setAlias:(NSString *)alias;

@end

@protocol AMIPhoneSettingAliasCellDelegate <NSObject>

@optional

- (void)aliasCell:(AMIPhoneSettingAliasCell *)aliasCell alias:(NSString *)alias;

@end
