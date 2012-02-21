//
//  AMIPhoneMainController.h
//  AppMocha
//
//  Created by Jason Wang on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMIPhoneLoginView.h"
#import "AMIPhoneRegistrationView.h"

@interface AMIPhoneMainController : UIViewController <AMIPhoneLoginViewDelegate, AMIPhoneRegistrationViewDelegate> {
    IBOutlet AMIPhoneLoginView *loginView;
    IBOutlet AMIPhoneRegistrationView *registrationView;
}

@property(nonatomic,retain) IBOutlet AMIPhoneLoginView *loginView;
@property(nonatomic,retain) IBOutlet AMIPhoneRegistrationView *registrationView;

- (IBAction)introductionAction:(id)sender;

- (IBAction)loginAction:(id)sender;

- (IBAction)registrationAction:(id)sender;

@end
