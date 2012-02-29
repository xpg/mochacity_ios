//
//  AMIPhoneStartEndTimeController.h
//  AppMocha
//
//  Created by Danny Deng on 12-2-24.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AMIPhoneStartEndTimeControllerDelegate;


@interface AMIPhoneStartEndTimeController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) id<AMIPhoneStartEndTimeControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIPickerView *startPickerView, *endPickerView;

- (void)setStartEndTime:(NSInteger)startTime EndTime:(NSInteger)endTime;

@end

@protocol AMIPhoneStartEndTimeControllerDelegate <NSObject>

@optional
- (void)StartEndTime:(NSInteger)startTime EndTime:(NSInteger)endTime;

@end
