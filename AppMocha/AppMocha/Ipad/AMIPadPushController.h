//
//  AMIPadPushController.h
//  AppMocha
//
//  Created by Jason Wang on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreDataManager.h"
#import "AMIPadRichView.h"

@class AMPushCell;

@interface AMIPadPushController : UIViewController <UITableViewDelegate,UITableViewDataSource,AMIPadRichViewDelegate> {
    CoreDataController *dataController;
    
    IBOutlet UITableView *pushTableView;
    
    IBOutlet AMPushCell *pushCell;
    
    IBOutlet AMIPadRichView *richView;
    
    NSString *reloadStr;
    NSString *pullStr;
    NSString *loadingStr;
    
    BOOL isDragging;
    BOOL dragToReload;
    
    BOOL hasNextPage;
    BOOL isLoading;
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIActivityIndicatorView *refreshSpinner;
    
    NSInteger sum;
}

@property(nonatomic,retain) IBOutlet UITableView *pushTableView;

@end
