//
//  AMIPhoneSettingController.m
//  AppMocha
//
//  Created by Jason Wang on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMIPhoneSettingController.h"

#import "AMIPhoneSettingPushIntervalController.h"
#import "DateUtility.h"

#import "ABResponse.h"
#import "AppBand+Private.h"
#import "ABPush+Private.h"
#import "AMIPhoneSettingPersonalController.h"


@interface AMIPhoneSettingController() <ABUpdateSettingsProtocol>


@end

@implementation AMIPhoneSettingController

#pragma mark - Private
- (void)switchChange{
    [[ABPush shared] setPushEnabled:[_pushSwitch isOn]];
}

- (void)setSaveEnable {
    [leftBarButton setEnabled:YES];
}

- (void)savePushConfiguration {
    [leftBarButton setEnabled:NO];
    [[AppBand shared] updateSettingsWithTarget:self];
}

#pragma mark - ABUpdateSettingsProtocol

- (void)finishUpdateSettings:(ABResponse *)response {
    [self performSelectorOnMainThread:@selector(setSaveEnable) withObject:nil waitUntilDone:YES];
}

#pragma mark - Public

- (void)newIntervalWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime index:(NSNumber *)index {
//    NSIndexPath *updatePath = nil;
//    NSIndexPath *addPath =  nil;
//    NSIndexPath *deletePath = nil;
//    if (index) {
//        updatePath = [NSIndexPath indexPathForRow:(1 + [index intValue]) inSection:1];
//        NSDictionary *newValue = [NSDictionary dictionaryWithObjectsAndKeys:startTime, AppBandPushIntervalBeginTimeKey, endTime, AppBandPushIntervalEndTimeKey, nil];
//        NSMutableArray *tmp = [NSMutableArray arrayWithArray:_pushIntervals];
//        [tmp replaceObjectAtIndex:[index intValue] withObject:newValue];
//        [_pushIntervals release];
//        _pushIntervals = [[NSArray alloc] initWithArray:tmp];
//        
//    } else {
//        addPath = [NSIndexPath indexPathForRow:(1 + [_pushIntervals count]) inSection:1];
//        if ([_pushIntervals count] >= 2) {
//            deletePath = [NSIndexPath indexPathForRow:3 inSection:1];
//        }
//        
//        if (!_pushIntervals) {
//            _pushIntervals = [[NSArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:startTime, AppBandPushIntervalBeginTimeKey, endTime, AppBandPushIntervalEndTimeKey, nil], nil];
//        } else {
//            NSMutableArray *tmp = [NSMutableArray arrayWithArray:_pushIntervals];
//            [tmp addObject:[NSDictionary dictionaryWithObjectsAndKeys:startTime, AppBandPushIntervalBeginTimeKey, endTime, AppBandPushIntervalEndTimeKey, nil]];
//            [_pushIntervals release];
//            _pushIntervals = [[NSArray alloc] initWithArray:tmp];
//        }
//    }
//    
//    
//    [settingView beginUpdates];
//    
//    if (updatePath) {
//        [settingView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:updatePath, nil] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    if (deletePath) {
//        [settingView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:deletePath, nil] withRowAnimation:UITableViewRowAnimationBottom];
//    }
//    if (addPath) {
//        [settingView insertRowsAtIndexPaths:[NSArray arrayWithObjects:addPath, nil] withRowAnimation:UITableViewRowAnimationTop];
//    }
//    
//    [settingView endUpdates];
}

- (void)deleteIntervalAtIndex:(NSNumber *)index {
    if (index) {
//        NSIndexPath *deletePath = [NSIndexPath indexPathForRow:(1 + [index intValue]) inSection:1];
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:_pushIntervals];
        [tmp removeObjectAtIndex:[index intValue]];
        [_pushIntervals release];
        _pushIntervals = [[NSArray alloc] initWithArray:tmp];
//        [settingView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:deletePath, nil] withRowAnimation:UITableViewRowAnimationBottom];
        [settingView reloadData];
    }
}

#pragma mark - AMIPhoneSettingPushEnableCellDelegate

- (void)pushEnableCell:(AMIPhoneSettingPushEnableCell *)aliasCell isOn:(BOOL)isOn {
    _pushEnable = isOn;
}

#pragma mark - AMIPhoneSettingAliasCellDelegate

- (void)aliasCell:(AMIPhoneSettingAliasCell *)aliasCell alias:(NSString *)alias {
    [[AppBand shared] setAlias:alias];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (!_systemSettingVC) {
            _systemSettingVC = [[AMIPhoneSystemSettingController alloc] initWithNibName:@"AMIPhoneSystemSettingController" bundle:nil];
        }
        [self.navigationController pushViewController:_systemSettingVC animated:YES];
    }
    if (indexPath.section == 2) {
        AMIPhoneSettingPersonalController *personalSetting = [[AMIPhoneSettingPersonalController alloc] initWithNibName:@"AMIPadSettingPersonalInfoController" bundle:nil];
        [self.navigationController pushViewController:personalSetting animated:YES];
        [personalSetting release]; 
    }
    
    
    
    
    
//    if (indexPath.section == 1) {
//        if (indexPath.row == (1 + [_pushIntervals count]) && [_pushIntervals count] < 3) {
//            AMIPhoneSettingPushIntervalController *intervalController = [[AMIPhoneSettingPushIntervalController alloc] initWithNibName:@"AMIPhoneSettingPushIntervalController" bundle:nil];
//            [intervalController setPreviousController:self];
//            [self.navigationController pushViewController:intervalController animated:YES];
//            
//            [intervalController release];
//        } else if (indexPath.row > 0) {
////            NSDictionary *interval = [_pushIntervals objectAtIndex:indexPath.row - 1];
////            NSDate *startTime = [interval objectForKey:AppBandPushIntervalBeginTimeKey];
////            NSDate *endTime = [interval objectForKey:AppBandPushIntervalEndTimeKey];
////            
////            AMIPhoneSettingPushIntervalController *intervalController = [[AMIPhoneSettingPushIntervalController alloc] initWithNibName:@"AMIPhoneSettingPushIntervalController" bundle:nil];
////            [intervalController setStartTime:startTime endTime:endTime index:[NSNumber numberWithInt:indexPath.row - 1]];
////            [intervalController setPreviousController:self];
////            [self.navigationController pushViewController:intervalController animated:YES];
////            
////            [intervalController release];
//        }
//    }
}
 
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1: {
//            NSInteger rowsNum = 1 + [_pushIntervals count];
//            rowsNum = rowsNum > 3 ? rowsNum : rowsNum + 1;
//            return rowsNum;
            return 1;
            break;
        }
        default: 
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    switch (indexPath.section) {
        case 0:
            [cell.textLabel setText:@"系统设置"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case 1:
            [cell.textLabel setText:@"推送设置"];
            [cell setAccessoryView:_pushSwitch];
            break;
        case 2:
            [cell.textLabel setText:@"用户信息"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        default:
            break;
    }
    return cell;
    
    
//    switch (indexPath.section) {
//        case 0: {
//            static NSString *AliasCellIdentifier = @"AliasCellIdentifier";
//            AMIPhoneSettingAliasCell *cell = (AMIPhoneSettingAliasCell *)[tableView dequeueReusableCellWithIdentifier:AliasCellIdentifier];
//            if (!cell) {
//                [[NSBundle mainBundle] loadNibNamed:@"AMIPhoneSettingAliasCell" owner:self options:NULL];
//                cell = aliasCell;
//                
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            }
//            
//            [cell setAlias:[[AppBand shared] getAlias]];
//            
//            return cell;
//            break;
//        }
//        case 1: {
//            if (indexPath.row == 0) {
//                static NSString *PushEnableCellIdentifier = @"PushEnableCellIdentifier";
//                AMIPhoneSettingPushEnableCell *cell = (AMIPhoneSettingPushEnableCell *)[tableView dequeueReusableCellWithIdentifier:PushEnableCellIdentifier];
//                if (!cell) {
//                    [[NSBundle mainBundle] loadNibNamed:@"AMIPhoneSettingPushEnableCell" owner:self options:NULL];
//                    cell = pushEnableCell;
//                    
//                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//                }
//                
//                [cell setIsOn:_pushEnable];
//                
//                return cell;
//            } else if (indexPath.row == (1 + [_pushIntervals count])) {
//                static NSString *DefaultCellIdentifier = @"DefaultCellIdentifier";
//                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
//                if (!cell) {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DefaultCellIdentifier] autorelease];
//                    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
//                    [cell.textLabel setText:@"添加免打扰时间"];
//                }
//                
//                return cell;
//            } else {
////                static NSString *PushIntervalCellIdentifier = @"PushIntervalCellIdentifier";
////                AMIPhoneSettingPushIntervalCell *cell = (AMIPhoneSettingPushIntervalCell *)[tableView dequeueReusableCellWithIdentifier:PushIntervalCellIdentifier];
////                if (!cell) {
////                    [[NSBundle mainBundle] loadNibNamed:@"AMIPhoneSettingPushIntervalCell" owner:self options:NULL];
////                    cell = pushIntervalCell;
////                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
////                }
////                
////                NSDictionary *interval = [_pushIntervals objectAtIndex:indexPath.row - 1];
////                NSDate *startTime = [interval objectForKey:AppBandPushIntervalBeginTimeKey];
////                NSDate *endTime = [interval objectForKey:AppBandPushIntervalEndTimeKey];
////                [cell setStartTime:getStringFromDate(TIME_TEMPLATE_STRING, startTime) endTime:getStringFromDate(TIME_TEMPLATE_STRING, endTime)];
////                
////                return cell;
//                
//            }
//            break;
//        }
//    }
//    return nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 1:
//            return @"推送设置";
//            break;
//            
//        default:
//            return @"系统设置";
//            break;
//    }
//}

#pragma mark - UIViewController lifecycle

- (void)dealloc {
    [_systemSettingVC release];
    [_pushSwitch release];
    [_pushIntervals release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pushEnable = [[ABPush shared] getPushEnabled];
        _pushIntervals = [[ABPush shared] getPushDNDIntervals];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    leftBarButton = [[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePushConfiguration)] autorelease];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    _pushSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_pushSwitch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventTouchUpInside];
    [_pushSwitch setOn:[[ABPush shared] getPushEnabled]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
