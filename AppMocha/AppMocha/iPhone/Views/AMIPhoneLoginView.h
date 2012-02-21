//
//  AMIPhoneLoginView.h
//  AppMocha
//
//  Created by Jason Wang on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMIPhoneLoginViewDelegate;

@interface AMIPhoneLoginView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    IBOutlet id<AMIPhoneLoginViewDelegate> delegate;
    IBOutlet UITableView *lgoinTableView;
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UILabel *messageLabel;
    
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *loginButton;
    
    IBOutlet UIView *loginView;
    
    UITextField *emailField;
    UITextField *passwordField;
}

@property(nonatomic,assign) IBOutlet id<AMIPhoneLoginViewDelegate> delegate;
@property(nonatomic,retain) IBOutlet UIView *loginView;

- (IBAction)cancel:(id)sender;

- (IBAction)login:(id)sender;

- (void)setBecomeFirstResponser;

@end

@protocol AMIPhoneLoginViewDelegate <NSObject>

- (void)loginSuccess:(AMIPhoneLoginView *)loginView 
               email:(NSString *)email 
            password:(NSString *)password;

- (void)cancelledLoginView:(AMIPhoneLoginView *)loginView;

@end