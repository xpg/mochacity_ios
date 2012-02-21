//
//  AMIPhoneRegistrationView.h
//  AppMocha
//
//  Created by Jason Wang on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMIPhoneRegistrationViewDelegate;

@interface AMIPhoneRegistrationView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    IBOutlet id<AMIPhoneRegistrationViewDelegate> delegate;
    IBOutlet UITableView *registerTableView;
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UILabel *messageLabel;
    
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *registerButton;
    
    IBOutlet UIScrollView *registerView;
    
    UITextField *emailField;
    UITextField *passwordField;
    UITextField *checkField;
    UITextField *codeField;
}

@property(nonatomic,assign) IBOutlet id<AMIPhoneRegistrationViewDelegate> delegate;
@property(nonatomic,retain) IBOutlet UIScrollView *registerView;

- (IBAction)cancel:(id)sender;

- (IBAction)registration:(id)sender;

- (void)setBecomeFirstResponser;

@end

@protocol AMIPhoneRegistrationViewDelegate <NSObject>

- (void)registrationSuccess:(AMIPhoneRegistrationView *)reigsterView 
                      email:(NSString *)email 
                   password:(NSString *)password;

- (void)cancelledRegistrationView:(AMIPhoneRegistrationView *)reigsterView;

@end
