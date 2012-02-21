//
//  AMIPadMainController.h
//  AppMocha
//
//  Created by Jason Wang on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMIPadLoginView.h"
#import "AMIPadRegistrationView.h"

@interface AMIPadMainController : UIViewController <AMIPadLoginViewDelegate, AMIPadRegistrationViewDelegate> {
    IBOutlet AMIPadLoginView *loginView;
    IBOutlet AMIPadRegistrationView *registrationView;
}

- (IBAction)introductionAction:(id)sender;

- (IBAction)loginAction:(id)sender;

- (IBAction)registrationAction:(id)sender;

@end
