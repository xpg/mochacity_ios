//
//  AMIPadPurchaseController.h
//  AppMocha
//
//  Created by Jason Wang on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMProductCell;

@interface AMIPadPurchaseController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    IBOutlet AMProductCell *productCell;
    
    IBOutlet UITableView *productsTableView;
}

@end
