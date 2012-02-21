//
//  AMIPadSettingAliasCell.h
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMIPadSettingAliasCellDelegate;

@interface AMIPadSettingAliasCell : UITableViewCell <UITextFieldDelegate> {
    IBOutlet id<AMIPadSettingAliasCellDelegate> delegate;
    IBOutlet UITextField *aliasField;
}

- (void)setAlias:(NSString *)alias;

@end

@protocol AMIPadSettingAliasCellDelegate <NSObject>

@optional

- (void)aliasCell:(AMIPadSettingAliasCell *)aliasCell alias:(NSString *)alias;

@end
