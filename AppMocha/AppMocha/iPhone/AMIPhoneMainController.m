//
//  AMIPhoneMainController.m
//  AppMocha
//
//  Created by Jason Wang on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMIPhoneMainController.h"
#import "AMIPhoneIntroController.h"

#import "AMAppDelegate.h"

@interface AMIPhoneMainController()

- (void)removeLoginView:(NSNumber *)isLogin;

- (void)removeRegistrationView:(NSNumber *)isRegister;

@end

@implementation AMIPhoneMainController

@synthesize loginView;
@synthesize registrationView;

#pragma mark - Public

- (IBAction)introductionAction:(id)sender {
    AMIPhoneIntroController *introController = [[AMIPhoneIntroController alloc] initWithNibName:@"AMIPhoneIntroController" bundle:nil];
    
    [self.navigationController pushViewController:introController animated:YES];
    [introController release];
}

- (IBAction)loginAction:(id)sender {
    if (self.loginView) {
        [self.loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
        
        [self.view addSubview:self.loginView];
        
        [UIView animateWithDuration:.2 animations:^{
            [self.loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 animations:^{
                [self.loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .9, .9)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [self.loginView.loginView setTransform:CGAffineTransformIdentity];
                } completion:^(BOOL finished) {
                    [self.loginView setBecomeFirstResponser];
                }];
            }];
        }];
    }
}

- (IBAction)registrationAction:(id)sender {
    if (self.registrationView) {
        [self.registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
        
        [self.view addSubview:self.registrationView];
        
        [UIView animateWithDuration:.2 animations:^{
            [self.registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 animations:^{
                [self.registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .9, .9)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [self.registrationView.registerView setTransform:CGAffineTransformIdentity];
                } completion:^(BOOL finished) {
                    [self.registrationView setBecomeFirstResponser];
                }];
            }];
        }];
    }
}

#pragma mark - Private

- (void)removeLoginView:(NSNumber *)isLogin {
    if (self.loginView) {
        [UIView animateWithDuration:.2 animations:^{
            [self.loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 animations:^{
                [self.loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [self.loginView.loginView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
                } completion:^(BOOL finished) {
                    [self.loginView removeFromSuperview];
                    if ([isLogin boolValue]) {
                        [(AMAppDelegate *)[UIApplication sharedApplication].delegate switchToFunctionController];
                    }
                }];
            }];
        }];
    }
}

- (void)removeRegistrationView:(NSNumber *)isRegister {
    if (self.registrationView) {
        [UIView animateWithDuration:.2 animations:^{
            [self.registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 animations:^{
                [self.registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [self.registrationView.registerView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
                } completion:^(BOOL finished) {
                    [self.registrationView removeFromSuperview];
                    if ([isRegister boolValue]) {
                        [(AMAppDelegate *)[UIApplication sharedApplication].delegate switchToFunctionController];
                    }
                }];
            }];
        }];
    }
}

#pragma mark - AMIPadLoginViewDelegate

- (void)loginSuccess:(AMIPhoneLoginView *)loginView 
               email:(NSString *)email 
            password:(NSString *)password {
    [(AMAppDelegate *)[UIApplication sharedApplication].delegate setEmail:email password:password];
    [self performSelectorOnMainThread:@selector(removeLoginView:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    
}

- (void)cancelledLoginView:(AMIPhoneLoginView *)loginView {
    [self removeLoginView:[NSNumber numberWithBool:NO]];
    
}

#pragma mark - AMIPadRegistrationViewDelegate

- (void)registrationSuccess:(AMIPhoneRegistrationView *)reigsterView 
                      email:(NSString *)email 
                   password:(NSString *)password {
    [(AMAppDelegate *)[UIApplication sharedApplication].delegate setEmail:email password:password];
    [self performSelectorOnMainThread:@selector(removeRegistrationView:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
}

- (void)cancelledRegistrationView:(AMIPhoneRegistrationView *)reigsterView {
    [self removeRegistrationView:[NSNumber numberWithBool:NO]];
}

#pragma mark - UIViewController lifecycle

- (void)dealloc {
    [self setLoginView:nil];
    [self setRegistrationView:nil];
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
