//
//  AMIPadMainController.m
//  AppMocha
//
//  Created by Jason Wang on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMIPadMainController.h"
#import "AMIPadIntroController.h"

#import "AMAppDelegate.h"

@interface AMIPadMainController()

- (void)removeLoginView:(NSNumber *)isLogin;

- (void)removeRegistrationView:(NSNumber *)isRegister;

@end

@implementation AMIPadMainController

#pragma mark - Public

- (IBAction)introductionAction:(id)sender {
    AMIPadIntroController *introController = [[AMIPadIntroController alloc] initWithNibName:@"AMIPadIntroController" bundle:nil];
    
    [self.navigationController pushViewController:introController animated:YES];
    [introController release];
}

- (IBAction)loginAction:(id)sender {
    if (loginView) {
        [loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
        
        [self.view addSubview:loginView];
        
        [UIView animateWithDuration:.2 animations:^{
            [loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 animations:^{
                [loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .9, .9)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [loginView.loginView setTransform:CGAffineTransformIdentity];
                } completion:^(BOOL finished) {
                    [loginView setBecomeFirstResponser];
                }];
            }];
        }];
    }
}

- (IBAction)registrationAction:(id)sender {
    if (registrationView) {
        [registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
        
        [self.view addSubview:registrationView];
        
        [UIView animateWithDuration:.2 animations:^{
            [registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 animations:^{
                [registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .9, .9)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [registrationView.registerView setTransform:CGAffineTransformIdentity];
                } completion:^(BOOL finished) {
                    [registrationView setBecomeFirstResponser];
                }];
            }];
        }];
    }
}

#pragma mark - Private

- (void)removeLoginView:(NSNumber *)isLogin {
    if (loginView) {
        [UIView animateWithDuration:.2 animations:^{
            [loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 animations:^{
                [loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
                } completion:^(BOOL finished) {
                    [loginView removeFromSuperview];
                    if ([isLogin boolValue]) {
                        [(AMAppDelegate *)[UIApplication sharedApplication].delegate switchToFunctionController];
                    }
                }];
            }];
        }];
    }
}

- (void)removeRegistrationView:(NSNumber *)isRegister {
    if (registrationView) {
        [UIView animateWithDuration:.2 animations:^{
            [registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 animations:^{
                [registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
                } completion:^(BOOL finished) {
                    [registrationView removeFromSuperview];
                    if ([isRegister boolValue]) {
                        [(AMAppDelegate *)[UIApplication sharedApplication].delegate switchToFunctionController];
                    }
                }];
            }];
        }];
    }
}

#pragma mark - AMIPadLoginViewDelegate

- (void)loginSuccess:(AMIPadLoginView *)loginView 
               email:(NSString *)email 
            password:(NSString *)password {
    [(AMAppDelegate *)[UIApplication sharedApplication].delegate setEmail:email password:password];
    [self performSelectorOnMainThread:@selector(removeLoginView:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    
}

- (void)cancelledLoginView:(AMIPadLoginView *)loginView {
    [self removeLoginView:[NSNumber numberWithBool:NO]];
    
}

#pragma mark - AMIPadRegistrationViewDelegate

- (void)registrationSuccess:(AMIPadRegistrationView *)reigsterView 
                      email:(NSString *)email 
                   password:(NSString *)password {
    [(AMAppDelegate *)[UIApplication sharedApplication].delegate setEmail:email password:password];
    [self performSelectorOnMainThread:@selector(removeRegistrationView:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
}

- (void)cancelledRegistrationView:(AMIPadRegistrationView *)reigsterView {
    [self removeRegistrationView:[NSNumber numberWithBool:NO]];
}

#pragma mark - UIViewController lifecycle

- (void)dealloc {
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor clearColor]];

}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown);
}
@end
