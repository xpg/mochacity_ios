//
//  AMIPhonePurchaseController.h
//  AppMocha
//
//  Created by Jason Wang on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMIPhoneProductCell;

@interface AMIPhonePurchaseController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    IBOutlet AMIPhoneProductCell *productCell;
    
    IBOutlet UITableView *productsTableView;
}

@end
