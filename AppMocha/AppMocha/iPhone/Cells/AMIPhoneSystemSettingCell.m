//
//  AMIPhoneSystemSettingCell.m
//  AppMocha
//
//  Created by Danny Deng on 12-2-24.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "AMIPhoneSystemSettingCell.h"

@implementation AMIPhoneSystemSettingCell

- (void)dealloc {
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setStartEndTimeString:(NSString *)startString EndTime:(NSString *)endString TimeFlag:(NSString *)flagString{
    [lblStartTimeString setText:startString];
    [lblEndTimeString setText:endString];
    [lblTimeFlag setText:flagString];
}

@end