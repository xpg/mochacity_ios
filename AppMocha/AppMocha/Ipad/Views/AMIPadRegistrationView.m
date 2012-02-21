//
//  AMIPadRegistrationView.m
//  AppMocha
//
//  Created by Jason Wang on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#define AM_Registration_View_Email @"AM_Registration_View_Email"
#define AM_Registration_View_Password @"AM_Registration_View_Password"
#define AM_Registration_View_Check @"AM_Registration_View_Check"
#define AM_Registration_View_Code @"AM_Registration_View_Code"

#define AM_Message_Registration_Email_Null @"AM_Message_Registration_Email_Null"
#define AM_Message_Registration_Password_Null @"AM_Message_Registration_Password_Null"
#define AM_Message_Registration_Not_Match @"AM_Message_Registration_Not_Match"
#define AM_Message_Registration_Code_Null @"AM_Message_Registration_Code_Null"
#define AM_Message_Registration_Error @"AM_Message_Registration_Error"

#import "AMIPadRegistrationView.h"

#import "AppBandKit.h"
#import "xRestKit.h"

#import "AMAppDelegate.h"

#import "I18NController.h"

@interface AMIPadRegistrationView()

@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *check;
@property(nonatomic,copy) NSString *code;

- (void)registration;

- (void)hiddenIndicatorAndShowMessage:(NSNumber *)type;

@end

@implementation AMIPadRegistrationView

@synthesize email = _email;
@synthesize password = _password;
@synthesize check = _check;
@synthesize code = _code;

@synthesize delegate;
@synthesize registerView;

#pragma mark - IBAction

- (IBAction)cancel:(id)sender {
    if (self.delegate) {
        [self.delegate cancelledRegistrationView:self];
    }
}

- (IBAction)registration:(id)sender {
    self.email = emailField.text;
    self.password = passwordField.text;
    self.check = checkField.text;
    self.code = codeField.text;
    if (![(AMAppDelegate *)[UIApplication sharedApplication].delegate availableString:self.email]) {
        [messageLabel setText:[[I18NController shareController] getLocalizedString:AM_Message_Registration_Email_Null comment:@"" locale:nil]];
        return;
    } 
    
    if (![(AMAppDelegate *)[UIApplication sharedApplication].delegate availableString:self.password] || [self.password length] < 6) {
        [messageLabel setText:[[I18NController shareController] getLocalizedString:AM_Message_Registration_Password_Null comment:@"" locale:nil]];
        return;
    }
    
    if (![self.password isEqualToString:self.check]) {
        [messageLabel setText:[[I18NController shareController] getLocalizedString:AM_Message_Registration_Not_Match comment:@"" locale:nil]];
        return;
    }
    
    if (![(AMAppDelegate *)[UIApplication sharedApplication].delegate availableString:self.code]) {
        [messageLabel setText:[[I18NController shareController] getLocalizedString:AM_Message_Registration_Code_Null comment:@"" locale:nil]];
        return;
    }
    
    [self registration];
}

- (void)setBecomeFirstResponser {
    [emailField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == emailField) {
        self.email = textField.text;
    } else if (textField == passwordField) {
        self.password = textField.text;
    } else if (textField == checkField) {
        self.check = textField.text;
    } else {
        self.code = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *EmailCellIdentifier = @"EmailCellIdentifier";
    static NSString *PasswordCellIdentifier = @"PasswordCellIdentifier";
    static NSString *CheckCellIdentifier = @"CheckCellIdentifier";
    static NSString *CodeCellIdentifier = @"CodeCellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0: {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:EmailCellIdentifier] autorelease];
            [cell.textLabel setText:[[I18NController shareController] getLocalizedString:AM_Registration_View_Email comment:@"" locale:nil]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UITextField *field = [[[UITextField alloc] initWithFrame:CGRectMake(cell.frame.size.width * .4, cell.frame.size.height * .3, cell.frame.size.width * .58, cell.frame.size.height * .5)] autorelease];
            [field setBorderStyle:UITextBorderStyleNone];
            [field setTextAlignment:UITextAlignmentLeft];
            [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [field setKeyboardType:UIKeyboardTypeEmailAddress];
            [field setReturnKeyType:UIReturnKeyDone];
            [field setBackgroundColor:[UIColor clearColor]];
            [field setTextColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1]];
            [field setDelegate:self];
            
            [cell insertSubview:field aboveSubview:cell.textLabel];
            emailField = field;
            
            break;
        }
        case 1:
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:PasswordCellIdentifier] autorelease];
            [cell.textLabel setText:[[I18NController shareController] getLocalizedString:AM_Registration_View_Password comment:@"" locale:nil]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UITextField *field = [[[UITextField alloc] initWithFrame:CGRectMake(cell.frame.size.width * .4, cell.frame.size.height * .3, cell.frame.size.width * .58, cell.frame.size.height * .5)] autorelease];
            [field setBorderStyle:UITextBorderStyleNone];
            [field setTextAlignment:UITextAlignmentLeft];
            [field setSecureTextEntry:YES];
            [field setReturnKeyType:UIReturnKeyDone];
            [field setBackgroundColor:[UIColor clearColor]];
            [field setTextColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1]];
            [field setDelegate:self];
            
            [cell insertSubview:field aboveSubview:cell.textLabel];
            passwordField = field;
            break;
        case 2: {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CheckCellIdentifier] autorelease];
            [cell.textLabel setText:[[I18NController shareController] getLocalizedString:AM_Registration_View_Check comment:@"" locale:nil]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UITextField *field = [[[UITextField alloc] initWithFrame:CGRectMake(cell.frame.size.width * .4, cell.frame.size.height * .3, cell.frame.size.width * .58, cell.frame.size.height * .5)] autorelease];
            [field setBorderStyle:UITextBorderStyleNone];
            [field setTextAlignment:UITextAlignmentLeft];
            [field setSecureTextEntry:YES];
            [field setReturnKeyType:UIReturnKeyDone];
            [field setBackgroundColor:[UIColor clearColor]];
            [field setTextColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1]];
            [field setDelegate:self];
            
            [cell insertSubview:field aboveSubview:cell.textLabel];
            checkField = field;
            break;
        }
        case 3: {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CodeCellIdentifier] autorelease];
            [cell.textLabel setText:[[I18NController shareController] getLocalizedString:AM_Registration_View_Code comment:@"" locale:nil]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UITextField *field = [[[UITextField alloc] initWithFrame:CGRectMake(cell.frame.size.width * .4, cell.frame.size.height * .3, cell.frame.size.width * .58, cell.frame.size.height * .5)] autorelease];
            [field setBorderStyle:UITextBorderStyleNone];
            [field setTextAlignment:UITextAlignmentLeft];
            [field setReturnKeyType:UIReturnKeyDone];
            [field setBackgroundColor:[UIColor clearColor]];
            [field setTextColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1]];
            [field setDelegate:self];
            
            [cell insertSubview:field aboveSubview:cell.textLabel];
            codeField = field;
            
            break;
        }
    }
    
    return cell;
}

#pragma mark - Private

- (void)registration {
    [registerButton setEnabled:NO];
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
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:udid, AppBand_App_UDID, appKey, AppBand_App_Key, appSecret, AppBand_App_Secret, bundleId, AppBand_App_BundleId, @"", AppBand_App_token, self.email, AppBand_App_Email, self.password, AppBand_App_Password, self.code, AppBand_App_Invite, nil];
    } else {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:udid, AppBand_App_UDID, appKey, AppBand_App_Key, appSecret, AppBand_App_Secret, bundleId, AppBand_App_BundleId, token, AppBand_App_token, self.email, AppBand_App_Email, self.password, AppBand_App_Password,self.code, AppBand_App_Invite, nil];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", [[AppBand shared] server] ,@"users"];
    
    [[xRestManager defaultManager] sendRequestTo:url parameter:parameters timeout:30. completion:^(xRestCompletionType type, NSString *response) {
        [self performSelectorOnMainThread:@selector(hiddenIndicatorAndShowMessage:) withObject:[NSNumber numberWithInt:type] waitUntilDone:YES];
        
        if (type == xRestCompletionTypeSuccess) {
            if (self.delegate) {
                [self.delegate registrationSuccess:self email:self.email password:self.password];
            }
        }
    }];
}

- (void)hiddenIndicatorAndShowMessage:(NSNumber *)type {
    [registerButton setEnabled:YES];
    [cancelButton setEnabled:YES];
    xRestCompletionType t = [type intValue];
    [indicatorView setHidden:YES];
    [indicatorView stopAnimating];
    if (t == xRestCompletionTypeSuccess) {
        [messageLabel setText:@""];
    } else {
        [messageLabel setText:[[I18NController shareController] getLocalizedString:AM_Message_Registration_Error comment:@"" locale:nil]];
    }
    
}

- (void)awakeFromNib {
    registerTableView.backgroundView = nil;
    registerTableView.backgroundView = [[[UIView alloc] init] autorelease];
    registerTableView.backgroundColor = [UIColor clearColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
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
    [self setRegisterView:nil];
    [self setEmail:nil];
    [self setPassword:nil];
    [self setCheck:nil];
    [self setCode:nil];
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
