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

#import "AppBandKit.h"

@implementation AMIPhoneSettingController

#pragma mark - Private

- (void)setSaveEnable {
    [leftBarButton setEnabled:YES];
}

- (void)savePushConfigurationEnd:(ABResponse *)response {
    [self performSelectorOnMainThread:@selector(setSaveEnable) withObject:nil waitUntilDone:YES];
}

- (void)savePushConfiguration {
    [leftBarButton setEnabled:NO];
//    [[ABPush shared] setPushEnabled:_pushEnable unavailableIntervals:_pushIntervals];
    [[ABPush shared] setPushEnabled:_pushEnable unavailableIntervals:nil];
    [[AppBand shared] updateSettingsWithTarget:self finishSelector:@selector(savePushConfigurationEnd:)];
}

#pragma mark - Public

- (void)newIntervalWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime index:(NSNumber *)index {
    NSIndexPath *updatePath = nil;
    NSIndexPath *addPath =  nil;
    NSIndexPath *deletePath = nil;
    if (index) {
        updatePath = [NSIndexPath indexPathForRow:(1 + [index intValue]) inSection:1];
        NSDictionary *newValue = [NSDictionary dictionaryWithObjectsAndKeys:startTime, AppBandPushIntervalBeginTimeKey, endTime, AppBandPushIntervalEndTimeKey, nil];
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:_pushIntervals];
        [tmp replaceObjectAtIndex:[index intValue] withObject:newValue];
        [_pushIntervals release];
        _pushIntervals = [[NSArray alloc] initWithArray:tmp];
        
    } else {
        addPath = [NSIndexPath indexPathForRow:(1 + [_pushIntervals count]) inSection:1];
        if ([_pushIntervals count] >= 2) {
            deletePath = [NSIndexPath indexPathForRow:3 inSection:1];
        }
        
        if (!_pushIntervals) {
            _pushIntervals = [[NSArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:startTime, AppBandPushIntervalBeginTimeKey, endTime, AppBandPushIntervalEndTimeKey, nil], nil];
        } else {
            NSMutableArray *tmp = [NSMutableArray arrayWithArray:_pushIntervals];
            [tmp addObject:[NSDictionary dictionaryWithObjectsAndKeys:startTime, AppBandPushIntervalBeginTimeKey, endTime, AppBandPushIntervalEndTimeKey, nil]];
            [_pushIntervals release];
            _pushIntervals = [[NSArray alloc] initWithArray:tmp];
        }
    }
    
    
    [settingView beginUpdates];
    
    if (updatePath) {
        [settingView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:updatePath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (deletePath) {
        [settingView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:deletePath, nil] withRowAnimation:UITableViewRowAnimationBottom];
    }
    if (addPath) {
        [settingView insertRowsAtIndexPaths:[NSArray arrayWithObjects:addPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [settingView endUpdates];
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
    if (indexPath.section == 1) {
        if (indexPath.row == (1 + [_pushIntervals count]) && [_pushIntervals count] < 3) {
            AMIPhoneSettingPushIntervalController *intervalController = [[AMIPhoneSettingPushIntervalController alloc] initWithNibName:@"AMIPhoneSettingPushIntervalController" bundle:nil];
            [intervalController setPreviousController:self];
            [self.navigationController pushViewController:intervalController animated:YES];
            
            [intervalController release];
        } else if (indexPath.row > 0) {
            NSDictionary *interval = [_pushIntervals objectAtIndex:indexPath.row - 1];
            NSDate *startTime = [interval objectForKey:AppBandPushIntervalBeginTimeKey];
            NSDate *endTime = [interval objectForKey:AppBandPushIntervalEndTimeKey];
            
            AMIPhoneSettingPushIntervalController *intervalController = [[AMIPhoneSettingPushIntervalController alloc] initWithNibName:@"AMIPhoneSettingPushIntervalController" bundle:nil];
            [intervalController setStartTime:startTime endTime:endTime index:[NSNumber numberWithInt:indexPath.row - 1]];
            [intervalController setPreviousController:self];
            [self.navigationController pushViewController:intervalController animated:YES];
            
            [intervalController release];
        }
    }
}
 
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
    switch (indexPath.section) {
        case 0: {
            static NSString *AliasCellIdentifier = @"AliasCellIdentifier";
            AMIPhoneSettingAliasCell *cell = (AMIPhoneSettingAliasCell *)[tableView dequeueReusableCellWithIdentifier:AliasCellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"AMIPhoneSettingAliasCell" owner:self options:NULL];
                cell = aliasCell;
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            [cell setAlias:[[AppBand shared] getAlias]];
            
            return cell;
            break;
        }
        case 1: {
            if (indexPath.row == 0) {
                static NSString *PushEnableCellIdentifier = @"PushEnableCellIdentifier";
                AMIPhoneSettingPushEnableCell *cell = (AMIPhoneSettingPushEnableCell *)[tableView dequeueReusableCellWithIdentifier:PushEnableCellIdentifier];
                if (!cell) {
                    [[NSBundle mainBundle] loadNibNamed:@"AMIPhoneSettingPushEnableCell" owner:self options:NULL];
                    cell = pushEnableCell;
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                
                [cell setIsOn:_pushEnable];
                
                return cell;
            } else if (indexPath.row == (1 + [_pushIntervals count])) {
                static NSString *DefaultCellIdentifier = @"DefaultCellIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
                if (!cell) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DefaultCellIdentifier] autorelease];
                    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                    [cell.textLabel setText:@"添加免打扰时间"];
                }
                
                return cell;
            } else {
                static NSString *PushIntervalCellIdentifier = @"PushIntervalCellIdentifier";
                AMIPhoneSettingPushIntervalCell *cell = (AMIPhoneSettingPushIntervalCell *)[tableView dequeueReusableCellWithIdentifier:PushIntervalCellIdentifier];
                if (!cell) {
                    [[NSBundle mainBundle] loadNibNamed:@"AMIPhoneSettingPushIntervalCell" owner:self options:NULL];
                    cell = pushIntervalCell;
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                
                NSDictionary *interval = [_pushIntervals objectAtIndex:indexPath.row - 1];
                NSDate *startTime = [interval objectForKey:AppBandPushIntervalBeginTimeKey];
                NSDate *endTime = [interval objectForKey:AppBandPushIntervalEndTimeKey];
                [cell setStartTime:getStringFromDate(TIME_TEMPLATE_STRING, startTime) endTime:getStringFromDate(TIME_TEMPLATE_STRING, endTime)];
                
                return cell;
                
            }
            break;
        }
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return @"推送设置";
            break;
            
        default:
            return @"系统设置";
            break;
    }
}

#pragma mark - UIViewController lifecycle

- (void)dealloc {
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    leftBarButton = [[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePushConfiguration)] autorelease];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
