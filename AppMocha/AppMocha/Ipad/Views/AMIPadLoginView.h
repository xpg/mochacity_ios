//
//  AMIPadLoginView.h
//  AppMocha
//
//  Created by Jason Wang on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMIPadLoginViewDelegate;

@interface AMIPadLoginView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    IBOutlet id<AMIPadLoginViewDelegate> delegate;
    IBOutlet UITableView *lgoinTableView;
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UILabel *messageLabel;
    
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *loginButton;
    
    UITextField *emailField;
    UITextField *passwordField;
    
    IBOutlet UIView *loginView;
}

@property(nonatomic,assign) IBOutlet id<AMIPadLoginViewDelegate> delegate;
@property(nonatomic,retain) IBOutlet UIView *loginView;

- (IBAction)cancel:(id)sender;

- (IBAction)login:(id)sender;

- (void)setBecomeFirstResponser;

@end

@protocol AMIPadLoginViewDelegate <NSObject>

- (void)loginSuccess:(AMIPadLoginView *)loginView 
               email:(NSString *)email 
            password:(NSString *)password;

- (void)cancelledLoginView:(AMIPadLoginView *)loginView;

@end
