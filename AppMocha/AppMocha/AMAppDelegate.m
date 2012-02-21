//
//  AMAppDelegate.m
//  AppMocha
//
//  Created by Jason Wang on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#define AppMocha_Demo_App @"amd"

#define AM_Demo_Logout @"AM_Demo_Logout"

//#define kKeyChainLoginForAppMochaDemo @"_AppMochaDemo"
#define kKeyChainEmailForAppMochaDemo @"kKeyChainEmailForAppMochaDemo"
#define kKeyChainPasswordForAppMochaDemo @"kKeyChainPasswordForAppMochaDemo"

#define AppMocha_Demo_Device_Token @"AppMocha_Demo_Device_Token"

#import "AMAppDelegate.h"

#import "AMIPadMainController.h"
#import "AMIPhoneMainController.h"
#import "AMIPadPushController.h"
#import "AMIPadPurchaseController.h"
#import "AMIPadIntroController.h"
#import "AMIPadSettingController.h"

#import "AMIPhonePushController.h"
#import "AMIPhonePurchaseController.h"
#import "AMIPhoneIntroController.h"
#import "AMIPhoneSettingController.h"

#import "AppBandKit.h"
#import "xRestKit.h"

#import "SFHFKeychainUtils.h"

#import "CoreDataManager.h"

#import "I18NController.h"

@interface AMAppDelegate()

@property(nonatomic,copy) NSString *userEmail;
@property(nonatomic,copy) NSString *userPassword;
@property(nonatomic,copy) NSString *token;

- (void)setDeviceToken:(NSData *)tokenData;

- (NSString *)urlScheme;

- (void)didReceiveNotification:(ABNotification *)notification;

- (void)autoLogin;

- (UIViewController *)getFunctionController;

- (UIViewController *)getUnLoginController;

- (void)cleanAll;

- (void)handlePushWhenLauching:(NSDictionary *)launchOptions;

@end

@implementation AMAppDelegate

@synthesize userEmail = _userEmail;
@synthesize userPassword = _userPassword;
@synthesize token = _token;

@synthesize window = _window;
@synthesize rootController = _rootController;

#pragma mark - Public

- (NSString *)deviceToken {
    return self.token;
}

- (void)setEmail:(NSString *)email password:(NSString *)password {
    self.userEmail = email;
    self.userPassword = password;
    
    if ([self availableString:self.userEmail] && [self availableString:self.userPassword]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.userEmail forKey:kKeyChainEmailForAppMochaDemo];
        [[NSUserDefaults standardUserDefaults] setObject:self.userPassword forKey:kKeyChainPasswordForAppMochaDemo];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (BOOL)availableString:(NSString *)target {
    if (!target || [target isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)switchToFunctionController {
    UIViewController *controller = [self getFunctionController];
    [UIView transitionFromView:self.rootController.view toView:controller.view duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        [self.rootController.view removeFromSuperview];
        self.rootController = nil;
        self.rootController = controller;
    }];
}

- (void)switchToUnLoginController {
    [self cleanAll];
    UIViewController *controller = [self getUnLoginController];
    [UIView transitionFromView:self.rootController.view toView:controller.view duration:.5 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        [self.rootController.view removeFromSuperview];
        [_rootController release];
        _rootController = nil;
        self.rootController = controller;
    }];
}

#pragma mark - Private

- (void)setDeviceToken:(NSData *)tokenData {
    NSString *tokenStr = [[[[tokenData description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString:@" " withString:@""];;
    
    if (!tokenStr || [self.token isEqualToString:tokenStr]) return;
    
    self.token = tokenStr;
    [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:AppMocha_Demo_Device_Token];
}

- (NSString *)urlScheme {
    return [NSString stringWithFormat:@"%@%@",AppMocha_Demo_App,[[AppBand shared] appKey]];
}

- (void)didReceiveNotification:(ABNotification *)notification {
    if ([self availableString:notification.notificationId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AppMocha_Demo_Notificaion_Receive_Key object:notification userInfo:nil];
    }
}

- (void)autoLogin {
    NSString *appKey = [[AppBand shared] appKey];
    NSString *appSecret = [[AppBand shared] appSecret];
    NSString *udid = [[AppBand shared] udid];
    NSString *token = [(AMAppDelegate *)[UIApplication sharedApplication].delegate deviceToken];
    NSString *bundleId = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    
    
    NSDictionary *parameters = nil;
    if (!token || [token isEqualToString:@""]) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:udid, AppBand_App_UDID, appKey, AppBand_App_Key, appSecret, AppBand_App_Secret, bundleId, AppBand_App_BundleId, self.userEmail, AppBand_App_Email, self.userPassword, AppBand_App_Password, nil];
    } else {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:udid, AppBand_App_UDID, appKey, AppBand_App_Key, appSecret, AppBand_App_Secret, bundleId, AppBand_App_BundleId, self.token, AppBand_App_token, self.userEmail, AppBand_App_Email, self.userPassword, AppBand_App_Password, nil];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",[[AppBand shared] server] ,@"users/sign_in"];
    [[xRestManager defaultManager] sendRequestTo:url parameter:parameters timeout:30. completion:^(xRestCompletionType type, NSString *response) {
        
    }];
}

- (UIViewController *)getFunctionController {
    UIViewController *pushController = nil;
    UIViewController *purchaseController = nil;
    UIViewController *introController = nil;
    UIViewController *settingController = nil;
    UIImage *logon = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        logon = [UIImage imageNamed:@"AppMocha_Logo"];
        pushController = [[AMIPhonePushController alloc] initWithNibName:@"AMIPhonePushController" bundle:nil];
        pushController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[[I18NController shareController] getLocalizedString:AM_Demo_Logout comment:@"" locale:nil] style:UIBarButtonItemStylePlain target:self action:@selector(switchToUnLoginController)] autorelease];
        
        //        UITabBarItem *pushBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:0];
        UITabBarItem *pushBarItem = [[UITabBarItem alloc] initWithTitle:@"推送通知" image:[UIImage imageNamed:@"iPad_AM_Tab_Notification"] tag:0];
        [pushController setTabBarItem:pushBarItem];
        [pushBarItem release];
        
        purchaseController = [[AMIPhonePurchaseController alloc] initWithNibName:@"AMIPhonePurchaseController" bundle:nil];
        purchaseController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[[I18NController shareController] getLocalizedString:AM_Demo_Logout comment:@"" locale:nil] style:UIBarButtonItemStylePlain target:self action:@selector(switchToUnLoginController)] autorelease];
        
        //        UITabBarItem *purchaseBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];
        UITabBarItem *purchaseBarItem = [[UITabBarItem alloc] initWithTitle:@"应用内购买" image:[UIImage imageNamed:@"iPad_AM_Tab_Purchase"] tag:1];
        [purchaseController setTabBarItem:purchaseBarItem];
        [purchaseBarItem release];
        
        introController = [[AMIPhoneIntroController alloc] initWithNibName:@"AMIPhoneIntroController" bundle:nil];
        introController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[[I18NController shareController] getLocalizedString:AM_Demo_Logout comment:@"" locale:nil] style:UIBarButtonItemStylePlain target:self action:@selector(switchToUnLoginController)] autorelease];
        
        //        UITabBarItem *introBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:2];
        UITabBarItem *introBarItem = [[UITabBarItem alloc] initWithTitle:@"关于我们" image:[UIImage imageNamed:@"iPad_AM_Tab_Intro"] tag:2];
        [introController setTabBarItem:introBarItem];
        [introBarItem release];
        
        settingController = [[AMIPhoneSettingController alloc] initWithNibName:@"AMIPhoneSettingController" bundle:nil];
        settingController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[[I18NController shareController] getLocalizedString:AM_Demo_Logout comment:@"" locale:nil] style:UIBarButtonItemStylePlain target:self action:@selector(switchToUnLoginController)] autorelease];

        UITabBarItem *settingBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:3];
        [settingController setTabBarItem:settingBarItem];
        [settingBarItem release];
    } else {
        logon = [UIImage imageNamed:@"AppMocha_Logo@2x.png"];
        pushController = [[AMIPadPushController alloc] initWithNibName:@"AMIPadPushController" bundle:nil];
        pushController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[[I18NController shareController] getLocalizedString:AM_Demo_Logout comment:@"" locale:nil] style:UIBarButtonItemStylePlain target:self action:@selector(switchToUnLoginController)] autorelease];
        
//        UITabBarItem *pushBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:0];
        UITabBarItem *pushBarItem = [[UITabBarItem alloc] initWithTitle:@"推送通知" image:[UIImage imageNamed:@"iPad_AM_Tab_Notification"] tag:0];
        [pushController setTabBarItem:pushBarItem];
        [pushBarItem release];
        
        purchaseController = [[AMIPadPurchaseController alloc] initWithNibName:@"AMIPadPurchaseController" bundle:nil];
        purchaseController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[[I18NController shareController] getLocalizedString:AM_Demo_Logout comment:@"" locale:nil] style:UIBarButtonItemStylePlain target:self action:@selector(switchToUnLoginController)] autorelease];
        
//        UITabBarItem *purchaseBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];
        UITabBarItem *purchaseBarItem = [[UITabBarItem alloc] initWithTitle:@"应用内购买" image:[UIImage imageNamed:@"iPad_AM_Tab_Purchase"] tag:1];
        [purchaseController setTabBarItem:purchaseBarItem];
        [purchaseBarItem release];
        
        introController = [[AMIPadIntroController alloc] initWithNibName:@"AMIPadIntroController" bundle:nil];
        introController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[[I18NController shareController] getLocalizedString:AM_Demo_Logout comment:@"" locale:nil] style:UIBarButtonItemStylePlain target:self action:@selector(switchToUnLoginController)] autorelease];
        
        UITabBarItem *introBarItem = [[UITabBarItem alloc] initWithTitle:@"关于我们" image:[UIImage imageNamed:@"iPad_AM_Tab_Intro"] tag:2];
        [introController setTabBarItem:introBarItem];
        [introBarItem release];
        
        settingController = [[AMIPadSettingController alloc] initWithNibName:@"AMIPadSettingController" bundle:nil];
        settingController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[[I18NController shareController] getLocalizedString:AM_Demo_Logout comment:@"" locale:nil] style:UIBarButtonItemStylePlain target:self action:@selector(switchToUnLoginController)] autorelease];
        
        //        UITabBarItem *introBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:2];
        UITabBarItem *settingBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:3];
        [settingController setTabBarItem:settingBarItem];
        [settingBarItem release];
    }
    
    UINavigationController *naviPushController = [[UINavigationController alloc] initWithRootViewController:pushController];
    [pushController release];
    [naviPushController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:logon]];
    
    UINavigationController *naviPurchaseController = [[UINavigationController alloc] initWithRootViewController:purchaseController];
    [purchaseController release];
    [naviPurchaseController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:logon]];
    
    UINavigationController *naviIntroController = [[UINavigationController alloc] initWithRootViewController:introController];
    [introController release];
    [naviIntroController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:logon]];
    
    UINavigationController *naviSettingController = [[UINavigationController alloc] initWithRootViewController:settingController];
    [settingController release];
    [naviSettingController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:logon]];
    
    UITabBarController *barController = [[[UITabBarController alloc] init] autorelease];
    [barController setViewControllers:[NSArray arrayWithObjects:naviPushController, naviPurchaseController, naviIntroController, naviSettingController, nil]];
    
    [naviPushController release];
    [naviPurchaseController release];
    [naviIntroController release];
    
    return barController;
}

- (UIViewController *)getUnLoginController {
    UIViewController *viewController = nil;
    UIImage *logon = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController = [[[AMIPhoneMainController alloc] initWithNibName:@"AMIPhoneMainController" bundle:nil] autorelease];
        logon = [UIImage imageNamed:@"AppMocha_Logo"];
    } else {
        viewController = [[[AMIPadMainController alloc] initWithNibName:@"AMIPadMainController" bundle:nil] autorelease];
        logon = [UIImage imageNamed:@"AppMocha_Logo@2x.png"];
    }
    
    UINavigationController *naviController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    [naviController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:logon]];
    
    return naviController;
}

- (void)cleanAll {
    self.userEmail = nil;
    self.userPassword = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKeyChainEmailForAppMochaDemo];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKeyChainPasswordForAppMochaDemo];
}

- (void)handlePushWhenLauching:(NSDictionary *)launchOptions {
    [[ABPush shared] handleNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] applicationState:UIApplicationStateInactive target:self pushSelector:@selector(didReceiveNotification:) richSelector:@selector(didReceiveNotification:)];
}

#pragma mark - Register For Remote Notification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)]) {
        appState = application.applicationState;
    }
    [[ABPush shared] handleNotification:userInfo applicationState:appState target:self pushSelector:@selector(didReceiveNotification:) richSelector:@selector(didReceiveNotification:)];
}

// one of these will be called after calling -registerForRemoteNotifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self setDeviceToken:deviceToken];
    [[AppBand shared] setPushToken:deviceToken];
    [[AppBand shared] updateSettingsWithTarget:nil finishSelector:nil];
}

#pragma mark - UIApplication lifecycle

- (void)dealloc {
    [_window release];
    [_rootController release];
    [self setToken:nil];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor colorWithRed:223. / 255 green:230. / 255 blue:235. / 255 alpha:1.];
    
    self.token = [[NSUserDefaults standardUserDefaults] objectForKey:AppMocha_Demo_Device_Token];
    self.userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyChainEmailForAppMochaDemo];
    self.userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyChainPasswordForAppMochaDemo];
    
    // init AppBand 
    NSMutableDictionary *configOptions = [NSMutableDictionary dictionary];
    [configOptions setValue:[NSNumber numberWithBool:NO] forKey:AppBandKickOfOptionsAppBandConfigRunEnvironment];
    
    [configOptions setValue:@"3" forKey:AppBandKickOfOptionsAppBandConfigSandboxKey];
    [configOptions setValue:@"50b8644c-1e7c-11e1-80e7-001ec9b6dcfc" forKey:AppBandKickOfOptionsAppBandConfigSandboxSecret];
    [configOptions setValue:[NSNumber numberWithBool:NO] forKey:AppBandKickOfOptionsAppBandConfigHandlePushAuto];
    [configOptions setValue:[NSNumber numberWithBool:NO] forKey:AppBandKickOfOptionsAppBandConfigHandleRichAuto];
    
    NSMutableDictionary *kickOffOptions = [NSMutableDictionary dictionary];
    [kickOffOptions setValue:launchOptions forKey:AppBandKickOfOptionsLaunchOptionsKey];
    [kickOffOptions setValue:configOptions forKey:AppBandKickOfOptionsAppBandConfigKey];
    
    [AppBand kickoff:kickOffOptions];
    
    if (![[AppBand shared] getTags]) 
        [[AppBand shared] setTags:[NSDictionary dictionaryWithObjectsAndKeys:@"zh", AppBandTagPreferKeyCountry, nil]];
    
    [[ABPush shared] registerRemoteNotificationWithTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    
    if ([self availableString:self.userEmail] && [self availableString:self.userPassword]) {
         self.rootController = [self getFunctionController];
        [self performSelector:@selector(autoLogin) withObject:nil afterDelay:.5];
    } else {
        self.rootController = [self getUnLoginController];
    }
    
    [self.window addSubview:self.rootController.view];
    [self.window makeKeyAndVisible];
    
    [self performSelector:@selector(handlePushWhenLauching:) withObject:launchOptions afterDelay:.5];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[ABPush shared] resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [AppBand end];
}

@end
