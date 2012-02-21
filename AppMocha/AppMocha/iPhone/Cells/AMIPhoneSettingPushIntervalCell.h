//
//  AMIPhoneSettingPushIntervalCell.h
//  AppMocha
//
//  Created by Jason Wang on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMIPhoneSettingPushIntervalCell : UITableViewCell {
    IBOutlet UILabel *startTime;
    IBOutlet UILabel *endTime;
}

- (void)setStartTime:(NSString *)sTime endTime:(NSString *)eTime;

@end
