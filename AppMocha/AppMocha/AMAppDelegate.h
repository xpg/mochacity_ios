//
//  AMAppDelegate.h
//  AppMocha
//
//  Created by Jason Wang on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UIViewController *rootController;

- (NSString *)deviceToken;

- (void)setEmail:(NSString *)email password:(NSString *)password;

- (BOOL)availableString:(NSString *)target;

- (void)switchToFunctionController;

- (void)switchToUnLoginController;

@end
