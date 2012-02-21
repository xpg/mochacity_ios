//
//  AMIPadSettingController.m
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMIPadSettingPushEnableCell.h"

@implementation AMIPadSettingPushEnableCell

- (void)setIsOn:(BOOL)isOn {
    [enableSwitch setOn:isOn];
}

- (IBAction)enableChange:(id)sender {
    UISwitch *s = (UISwitch *)sender;
    [delegate pushEnableCell:self isOn:s.isOn];
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
