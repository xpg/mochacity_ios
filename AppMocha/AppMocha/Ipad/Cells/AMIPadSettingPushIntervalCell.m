//
//  AMIPadSettingPushIntervalCell.m
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMIPadSettingPushIntervalCell.h"

@implementation AMIPadSettingPushIntervalCell

- (void)setStartTime:(NSString *)sTime endTime:(NSString *)eTime {
    [startTime setText:sTime];
    [endTime setText:eTime];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
