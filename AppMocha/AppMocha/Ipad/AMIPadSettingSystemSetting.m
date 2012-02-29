//
//  AMIPadSettingSystemSetting.m
//  AppMocha
//
//  Created by Danny Deng on 12-2-24.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "AMIPadSettingSystemSetting.h"

@implementation AMIPadSettingSystemSetting
@synthesize timeTableView;
@synthesize timeDataArray;

#pragma mark - Private
- (void)saveStartEndTimeToUserDefault {
    for (int i = 0; i < 3; i++) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"startTime%i",i]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"endTime%i",i]];
    }
    for (int i = 0; i < [timeDataArray count]; i++) {
        NSDictionary *dic = [timeDataArray objectAtIndex:i];
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"startTime"] forKey:[NSString stringWithFormat:@"startTime%i",i]];
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"endTime"] forKey:[NSString stringWithFormat:@"endTime%i",i]];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clickAdd {
    if ([timeDataArray count] >=3) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:[NSNumber numberWithInt:45030] forKey:@"startTime"];
    [dic setObject:[NSNumber numberWithInt:45030] forKey:@"endTime"];
    [timeDataArray addObject:dic];
    [dic release];
    [timeTableView reloadData];
    if ([timeDataArray count] >= 3) {
        [_addBarButton setEnabled:NO];
    }
    [self saveStartEndTimeToUserDefault];
}

- (void)clickEdit {
    if ([timeTableView isEditing]) {
        [timeTableView setEditing:NO animated:YES];
    }
    else {
        [timeTableView setEditing:YES animated:YES];
    }
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [timeTableView indexPathForSelectedRow];
    [timeTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc {
    [timeDataArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAdd)];
    [self.navigationItem setRightBarButtonItem:_addBarButton];
    
//    _editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(clickEdit)];
//    [self.navigationItem setRightBarButtonItem:_editBarButton];
    
    timeDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [timeTableView setDelegate:self];
    [timeTableView setDataSource:self];
    NSNumber *startTime0, *startTime1, *startTime2, *endTime0, *endTime1, *endTime2;
    startTime0 = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime0"];
    startTime1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime1"];
    startTime2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime2"];
    endTime0 = [[NSUserDefaults standardUserDefaults] objectForKey:@"endTime0"];
    endTime1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"endTime1"];
    endTime2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"endTime2"];
    if (startTime0 && endTime0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:startTime0, @"startTime",
                                    endTime0, @"endTime" , nil];
        [timeDataArray addObject:dic];
    }
    
    if (startTime1 && endTime1) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:startTime1, @"startTime",
                                    endTime1, @"endTime" , nil];
        [timeDataArray addObject:dic];
    }
    
    if (startTime2 && endTime2) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:startTime2, @"startTime",
                                    endTime2, @"endTime" , nil];
        [timeDataArray addObject:dic];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [timeDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMIPadSystemSettingCell *cell = nil;
    NSString *cellIdentify = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"AMIPadSystemSettingCell" owner:self options:NULL];
        cell = systemSettingCell;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSDictionary *dic = [timeDataArray objectAtIndex:indexPath.section];
    NSInteger startTime = [[dic objectForKey:@"startTime"] intValue];
    NSInteger endTime = [[dic objectForKey:@"endTime"] intValue];
    [cell setStartEndTimeString:[NSString stringWithFormat:@"Start:%i时%i分%i秒",startTime/3600, startTime/60%60, startTime%60] 
                        EndTime:[NSString stringWithFormat:@"End:%i时%i分%i秒",endTime/3600, endTime/60%60, endTime%60] 
                       TimeFlag:[NSString stringWithFormat:@"时间段%i", indexPath.section]];
    return cell;
    
    
//    UITableViewCell *cell = nil;
//    NSString *cellIdentify = @"cell";
//    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    }
//    NSDictionary *dic = [timeDataArray objectAtIndex:indexPath.section];
//    NSInteger startTime = [[dic objectForKey:@"startTime"] intValue];
//    NSInteger endTime = [[dic objectForKey:@"endTime"] intValue];
//    [cell.textLabel setText:[NSString stringWithFormat:@"时间段%i:",indexPath.section]];
//    [cell.detailTextLabel setText:[NSString stringWithFormat:@"                   Start:%i时%i分%i秒                 End:%i时%i分%i秒",startTime/3600, startTime/60%60, startTime%60, endTime/3600, endTime/60%60, endTime%60]];
//    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
//    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [timeDataArray removeObjectAtIndex:indexPath.section];
    if ([timeDataArray count] < 3) {
        [_addBarButton setEnabled:YES];
    }
    [timeTableView reloadData];
    [self saveStartEndTimeToUserDefault];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    editingItem = indexPath.section;
    NSDictionary *dic = [timeDataArray objectAtIndex:indexPath.section];
    NSInteger startTime = [[dic objectForKey:@"startTime"] intValue];
    NSInteger endTime = [[dic objectForKey:@"endTime"] intValue];
    AMIPadSystemStartEndTimeController *startEndTime = [[AMIPadSystemStartEndTimeController alloc] initWithNibName:@"AMIPadSystemStartEndTimeController" bundle:nil];
    [startEndTime setDelegate:self];
    [self.navigationController pushViewController:startEndTime animated:YES];
    [startEndTime setStartEndTime:startTime EndTime:endTime];
    [startEndTime release];
}

#pragma mark - AMIPhoneStartEndTimeControllerDelegate
- (void)StartEndTime:(NSInteger)startTime EndTime:(NSInteger)endTime {
    NSMutableDictionary *dic = [timeDataArray objectAtIndex:editingItem];
    [dic setObject:[NSNumber numberWithInt:startTime] forKey:@"startTime"];
    [dic setObject:[NSNumber numberWithInt:endTime] forKey:@"endTime"];
    [timeTableView reloadData];
    
    [self saveStartEndTimeToUserDefault];
}

@end
