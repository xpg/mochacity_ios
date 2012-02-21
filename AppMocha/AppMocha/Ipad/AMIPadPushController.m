//
//  AMIPadPushController.m
//  AppMocha
//
//  Created by Jason Wang on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#define REFRESH_HEADER_HEIGHT 104.0f

#define App_Receive_Push @"App_Receive_Push"

#import "AMIPadPushController.h"

#import "I18NController.h"

#import "AMPushCell.h"
#import "AppBandKit.h"
#import "AMDemoNotification.h"

@interface AMIPadPushController()

@property(nonatomic,copy) NSArray *pushArray;

- (void)controllerPadDidReceiveNotification:(NSNotification *)notification;

- (void)showRichView:(AMDemoNotification *)notification;

- (void)addPullToRefreshHeader;

- (void)startLoading:(AMDemoNotification *)notification number:(NSInteger)number;

- (void)startReloading:(NSInteger)number;

- (void)stopReloading;

- (void)getNotificationsEnd:(ABNotificationsResponse *)response;

- (void)reloadPushTable;

@end

@implementation AMIPadPushController

@synthesize pushArray = _pushArray;

@synthesize pushTableView;

#pragma mark - Deferred image loading (UIScrollViewDelegate)

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isDragging && scrollView.contentOffset.y < 0) {
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            refreshLabel.text = reloadStr;
        } else { 
            refreshLabel.text = pullStr;
            
        }
        [UIView commitAnimations];
    }
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        [self startReloading:40];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - Private

- (void)controllerPadDidReceiveNotification:(NSNotification *)notification {
    ABNotification *abNoti = notification.object;
    AMDemoNotification *amNoti = [[[AMDemoNotification alloc] init] autorelease];
    [amNoti setNotification:abNoti];
    
    UIApplicationState state = abNoti.state;
    
    NSInteger number = [self.pushArray count] > 40 ? [self.pushArray count] : 40;
    if (state == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[I18NController shareController] getLocalizedString:App_Receive_Push comment:@"" locale:nil] message:abNoti.alert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        [self startReloading:number];
    } else {
        if (abNoti.type == ABNotificationTypeRich) {
            [self showRichView:amNoti];
        }
        
        if (state == UIApplicationStateBackground) {
            [self startReloading:number];
        }
    }
}

- (void)showRichView:(AMDemoNotification *)notification {
    if (richView) {
        if (richView.notification) {
            [richView setTarget:notification];
        } else {
            [richView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
            
            [self.view addSubview:richView];
            
            [UIView animateWithDuration:.2 animations:^{
                [richView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [richView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .9, .9)];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.15 animations:^{
                        [richView setTransform:CGAffineTransformIdentity];
                    } completion:^(BOOL finished) {
                        [richView setTarget:notification];
                    }];
                }];
            }];
        }
    }
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, pushTableView.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pushTableView.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshSpinner];
    [pushTableView addSubview:refreshHeaderView];
    
    [refreshLabel release];
    [refreshSpinner release];
    [refreshHeaderView release];
}

- (void)startLoading:(AMDemoNotification *)notification number:(NSInteger)number {
    if (isLoading) return;
    
    isLoading = YES;
    NSString *abni = @"";
    if (notification) {
        abni = notification.notification.notificationId;
    }
    [[ABPush shared] getNotificationsByType:ABNotificationTypeAll startAt:abni status:ABNotificationStatusAll pageCapacity:[NSNumber numberWithInt:number] target:self finishSelector:@selector(getNotificationsEnd:)];
}

- (void)startReloading:(NSInteger)number {
    dragToReload = YES;
    self.pushArray = nil;
    [pushTableView setScrollEnabled:NO];
    refreshLabel.text = loadingStr;
    
    [UIView animateWithDuration:.3 animations:^{
        pushTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        [refreshSpinner startAnimating];
    }];
    
    [self startLoading:nil number:number];
}

- (void)stopReloading {
    dragToReload = NO;
    [pushTableView setScrollEnabled:YES];
    refreshLabel.text = pullStr;
    [UIView animateWithDuration:.3 animations:^{
        pushTableView.contentInset = UIEdgeInsetsZero;
    } completion:^(BOOL finished) {
        [refreshSpinner stopAnimating];
    }];
}

- (void)getNotificationsEnd:(ABNotificationsResponse *)response {
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.pushArray];
    if (response && [response.notificationArray count] > 0) {
        for (ABNotification *noti in response.notificationArray) {
            AMDemoNotification *amNoti = [[[AMDemoNotification alloc] init] autorelease];
            [amNoti setNotification:noti];
            [tmp addObject:amNoti];
        }
    }
    
    self.pushArray = tmp;
    isLoading = NO;
    hasNextPage = ([response.notificationArray count] >= 40);
    [self performSelectorOnMainThread:@selector(reloadPushTable) withObject:nil waitUntilDone:NO];
}

- (void)reloadPushTable {
    [pushTableView reloadData];
    if (dragToReload) {
        [self stopReloading];
    }
}

#pragma mark - AMIPadRichViewDelegate

- (void)richViewClosed:(AMIPadRichView *)rView {
    if (richView) {
        [UIView animateWithDuration:.2 animations:^{
            [richView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.15 animations:^{
                [richView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    [richView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, .000001, .000001)];
                } completion:^(BOOL finished) {
                    [richView removeFromSuperview];
                }];
            }];
        }];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.pushArray count]) {
        return 55;
    }
    return 104;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.pushArray count]) return;
    
    AMDemoNotification *notification = [self.pushArray objectAtIndex:indexPath.row];
    
    if (notification.notification.type == ABNotificationTypePush) return;
    
    [self showRichView:notification];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (hasNextPage && [self.pushArray count] >= 40) {
        return [self.pushArray count] + 1;
    }
    return [self.pushArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AMPushCell";
    static NSString *MoreCellIdentifier = @"MoreCellIdentifier";
    
    if (indexPath.row == [self.pushArray count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreCellIdentifier] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setText:@"正在获取更多数据..."];
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicatorView setCenter:CGPointMake(260, 28)];
            [cell addSubview:indicatorView];
            [indicatorView startAnimating];
            
            [indicatorView release];
        }
        
        [self startLoading:[self.pushArray lastObject] number:40];
        return cell;
    }
    
    AMPushCell *cell = (AMPushCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"AMPushCell" owner:self options:NULL];
        cell = pushCell;
    }
    
    AMDemoNotification *notification = [self.pushArray objectAtIndex:indexPath.row];
    
    [cell setNotification:notification];
    
    return cell;
}

#pragma mark - UIViewController lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AppMocha_Demo_Notificaion_Receive_Key object:nil];
    [reloadStr release];
    [pullStr release];
    [loadingStr release];
    [self setPushArray:nil];
    [self setPushTableView:nil];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pushArray = [NSArray array];
        
        reloadStr = [[NSString alloc] initWithString:@"放开刷新数据"];
        pullStr = [[NSString alloc] initWithString:@"下拉表格重新刷新数据"];
        loadingStr = [[NSString alloc] initWithString:@"正在刷新数据"];
        
        dragToReload = hasNextPage = isLoading = NO;
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
    
    [self addPullToRefreshHeader];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AppMocha_Demo_Notificaion_Receive_Key object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controllerPadDidReceiveNotification:) name:AppMocha_Demo_Notificaion_Receive_Key object:nil];
    
    [self startLoading:nil number:40];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

@end
