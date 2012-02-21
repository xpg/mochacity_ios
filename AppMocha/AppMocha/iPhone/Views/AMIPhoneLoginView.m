//
//  AMIPhoneLoginView.m
//  AppMocha
//
//  Created by Jason Wang on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#define AM_Login_View_Email @"AM_Login_View_Email"
#define AM_Login_View_Password @"AM_Login_View_Password"

#define AM_Message_Login_Email_Null @"AM_Message_Login_Email_Null"
#define AM_Message_Login_Password_Null @"AM_Message_Login_Password_Null"
#define AM_Message_Login_Error @"AM_Message_Login_Error"

#import "AMIPhoneLoginView.h"

#import "AppBandKit.h"
#import "xRestKit.h"

#import "AMAppDelegate.h"
#import "I18NController.h"

@interface AMIPhoneLoginView()

@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *password;

- (void)login;

- (void)hiddenIndicatorAndShowMessage:(NSNumber *)type;

@end

@implementation AMIPhoneLoginView

@synthesize email = _email;
@synthesize password = _password;

@synthesize delegate;
@synthesize loginView;

#pragma mark - IBAction

- (IBAction)cancel:(id)sender {
    [loginView setCenter:CGPointMake(160, 170)];
    if (self.delegate) {
        [self.delegate cancelledLoginView:self];
    }
}

- (IBAction)login:(id)sender {
    self.email = emailField.text;
    self.password = passwordField.text;
    if (![(AMAppDelegate *)[UIApplication sharedApplication].delegate availableString:self.email]) {
        [messageLabel setText:[[I18NController shareController] getLocalizedString:AM_Message_Login_Email_Null comment:@"" locale:nil]];
        return;
    } 
    
    if (![(AMAppDelegate *)[UIApplication sharedApplication].delegate availableString:self.password] || [self.password length] < 6) {
        [messageLabel setText:[[I18NController shareController] getLocalizedString:AM_Message_Login_Password_Null comment:@"" locale:nil]];
        return;
    }
    
    
    [self login];
}

- (void)setBecomeFirstResponser {
    [loginView setCenter:CGPointMake(160, 90)];
    [emailField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [loginView setCenter:CGPointMake(160, 90)];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == emailField) {
        self.email = textField.text;
    } else {
        self.password = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [loginView setCenter:CGPointMake(160, 170)];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *EmailCellIdentifier = @"EmailCellIdentifier";
    static NSString *PasswordCellIdentifier = @"PasswordCellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0: {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:EmailCellIdentifier] autorelease];
            [cell.textLabel setText:[[I18NController shareController] getLocalizedString:AM_Login_View_Email comment:@"" locale:nil]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UITextField *field = [[[UITextField alloc] initWithFrame:CGRectMake(cell.frame.size.width * .32, cell.frame.size.height * .3, cell.frame.size.width * .48, cell.frame.size.height * .5)] autorelease];
            [field setBorderStyle:UITextBorderStyleNone];
            [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [field setKeyboardType:UIKeyboardTypeEmailAddress];
            [field setTextAlignment:UITextAlignmentLeft];
            [field setReturnKeyType:UIReturnKeyDone];
            [field setBackgroundColor:[UIColor clearColor]];
            [field setTextColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1]];
            [field setDelegate:self];
            [field setText:self.email];
            
            [cell insertSubview:field aboveSubview:cell.textLabel];
            emailField = field;
            [emailField becomeFirstResponder];
            
            break;
        }
        case 1:
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:PasswordCellIdentifier] autorelease];
            [cell.textLabel setText:[[I18NController shareController] getLocalizedString:AM_Login_View_Password comment:@"" locale:nil]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UITextField *field = [[[UITextField alloc] initWithFrame:CGRectMake(cell.frame.size.width * .32, cell.frame.size.height * .3, cell.frame.size.width * .48, cell.frame.size.height * .5)] autorelease];
            [field setBorderStyle:UITextBorderStyleNone];
            [field setTextAlignment:UITextAlignmentLeft];
            [field setSecureTextEntry:YES];
            [field setReturnKeyType:UIReturnKeyDone];
            [field setBackgroundColor:[UIColor clearColor]];
            [field setTextColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1]];
            [field setDelegate:self];
            [field setText:self.password];
            
            [cell insertSubview:field aboveSubview:cell.textLabel];
            passwordField = field;
            break;
    }
    
    return cell;
}

#pragma mark - Private

- (void)login {
    [loginButton setEnabled:NO];
    [cancelButton setEnabled:NO];
    [messageLabel setText:@""];
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    
    NSString *appKey = [[AppBand shared] appKey];
    NSString *appSecret = [[AppBand shared] appSecret];
    NSString *udid = [[AppBand shared] udid];
    NSString *token = [(AMAppDelegate *)[UIApplication sharedApplication].delegate deviceToken];
    NSString *bundleId = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    NSDictionary *parameters = nil;
    if (!token || [token isEqualToString:@""]) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:udid, AppBand_App_UDID, appKey, AppBand_App_Key, appSecret, AppBand_App_Secret, bundleId, AppBand_App_BundleId, @"", AppBand_App_token, self.email, AppBand_App_Email, self.password, AppBand_App_Password, nil];
    } else {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:udid, AppBand_App_UDID, appKey, AppBand_App_Key, appSecret, AppBand_App_Secret, bundleId, AppBand_App_BundleId, token, AppBand_App_token, self.email, AppBand_App_Email, self.password, AppBand_App_Password, nil];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", [[AppBand shared] server] ,@"users/sign_in"];
    
    [[xRestManager defaultManager] sendRequestTo:url parameter:parameters timeout:30. completion:^(xRestCompletionType type, NSString *response) {
        [self performSelectorOnMainThread:@selector(hiddenIndicatorAndShowMessage:) withObject:[NSNumber numberWithInt:type] waitUntilDone:YES];
        if (type == xRestCompletionTypeSuccess) {
            if (self.delegate) {
                [self.delegate loginSuccess:self email:self.email password:self.password];
            }
        }
    }];
}

- (void)hiddenIndicatorAndShowMessage:(NSNumber *)type {
    [loginButton setEnabled:YES];
    [cancelButton setEnabled:YES];
    xRestCompletionType t = [type intValue];
    [indicatorView setHidden:YES];
    [indicatorView stopAnimating];
    if (t == xRestCompletionTypeSuccess) {
        [messageLabel setText:@""];
    } else {
        [messageLabel setText:[[I18NController shareController] getLocalizedString:AM_Message_Login_Error comment:@"" locale:nil]];
    }
    
}

- (void)awakeFromNib {
    lgoinTableView.backgroundView = nil;
    lgoinTableView.backgroundView = [[[UIView alloc] init] autorelease];
    lgoinTableView.backgroundColor = [UIColor clearColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.email = @"";
        self.password = @"";
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [self setLoginView:nil];
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

