//
//  AMIPhonePushController.h
//  AppMocha
//
//  Created by Jason Wang on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreDataManager.h"
#import "AMIPhoneRichView.h"

@class AMIPhonePushCell;

@interface AMIPhonePushController : UIViewController <UITableViewDelegate,UITableViewDataSource,AMIPhoneRichViewDelegate> {
    
    IBOutlet UITableView *pushTableView;
    
    IBOutlet AMIPhonePushCell *pushCell;
    
    IBOutlet AMIPhoneRichView *richView;
    
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
}

@property(nonatomic,retain) IBOutlet UITableView *pushTableView;

@end
