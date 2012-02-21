//
//  AMPushCell.h
//  AppMocha
//
//  Created by Jason Wang on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMDemoNotification.h"

@interface AMPushCell : UITableViewCell {
    IBOutlet UIImageView *iconView;
    IBOutlet UILabel *messageLabel;
    IBOutlet UILabel *timeLabel;
}

@property(nonatomic,retain) IBOutlet UIImageView *iconView;
@property(nonatomic,retain) IBOutlet UILabel *messageLabel;
@property(nonatomic,retain) IBOutlet UILabel *timeLabel;

- (void)setNotification:(AMDemoNotification *)notification;

@end
