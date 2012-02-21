//
//  AMProductCell.h
//  AppMocha
//
//  Created by Jason Wang on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMDemoProduct.h"

@interface AMProductCell : UITableViewCell {
    IBOutlet UIImageView *iconView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *descriptionLabel;
    
    IBOutlet UIProgressView *progressView;
    IBOutlet UILabel *stateLabel;

}

- (void)setDemoProduct:(AMDemoProduct *)p;

@end
