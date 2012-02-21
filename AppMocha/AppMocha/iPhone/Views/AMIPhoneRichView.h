//
//  AMIPhoneRichView.h
//  AppMocha
//
//  Created by Jason Wang on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMDemoNotification.h"

@protocol AMIPhoneRichViewDelegate;

@interface AMIPhoneRichView : UIView {
    IBOutlet id<AMIPhoneRichViewDelegate> delegate;
    IBOutlet UIWebView *webView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIActivityIndicatorView *indicatorView;
}

@property(nonatomic,assign) IBOutlet id<AMIPhoneRichViewDelegate> delegate;
@property(nonatomic,retain) AMDemoNotification *notification;

- (void)setTarget:(AMDemoNotification *)notification;

- (IBAction)close:(id)sender;

@end

@protocol AMIPhoneRichViewDelegate <NSObject>

- (void)richViewClosed:(AMIPhoneRichView *)richView;

@end
