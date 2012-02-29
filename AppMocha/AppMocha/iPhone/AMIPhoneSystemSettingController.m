//
//  AMIPhoneSystemSettingController.m
//  AppMocha
//
//  Created by Danny Deng on 12-2-24.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "AMIPhoneSystemSettingController.h"

@implementation AMIPhoneSystemSettingController
@synthesize timeTableView;
@synthesize timeDataArray;

#pragma mark - Private
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
//    [self setSystemSettingCell:nil];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [timeDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMIPhoneSystemSettingCell *cell = nil;
    NSString *cellIdentify = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"AMIPhoneSystemSettingCell" owner:self options:NULL];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell = systemSettingCell;
     }
    NSDictionary *dic = [timeDataArray objectAtIndex:indexPath.section];
    NSInteger startTime = [[dic objectForKey:@"startTime"] intValue];
    NSInteger endTime = [[dic objectForKey:@"endTime"] intValue];
    [cell setStartEndTimeString:[NSString stringWithFormat:@"Start:%i时%i分%i秒",startTime/3600, startTime/60%60, startTime%60] 
                        EndTime:[NSString stringWithFormat:@"End:%i时%i分%i秒",endTime/3600, endTime/60%60, endTime%60] 
                       TimeFlag:[NSString stringWithFormat:@"时间段%i", indexPath.section]];
    return cell;
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    editingItem = indexPath.section;
    NSDictionary *dic = [timeDataArray objectAtIndex:indexPath.section];
    NSInteger startTime = [[dic objectForKey:@"startTime"] intValue];
    NSInteger endTime = [[dic objectForKey:@"endTime"] intValue];
    AMIPhoneStartEndTimeController *startEndTime = [[AMIPhoneStartEndTimeController alloc] initWithNibName:@"AMIPhoneStartEndTimeController" bundle:nil];
    [startEndTime setDelegate:self];
    [self.navigationController pushViewController:startEndTime animated:YES];
    [startEndTime setStartEndTime:startTime EndTime:endTime];
    [startEndTime release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - AMIPhoneStartEndTimeControllerDelegate
- (void)StartEndTime:(NSInteger)startTime EndTime:(NSInteger)endTime {
    NSMutableDictionary *dic = [timeDataArray objectAtIndex:editingItem];
    [dic setObject:[NSNumber numberWithInt:startTime] forKey:@"startTime"];
    [dic setObject:[NSNumber numberWithInt:endTime] forKey:@"endTime"];
    [timeTableView reloadData];
}

@end
