//
//  AMIPadRichView.m
//  AppMocha
//
//  Created by Jason Wang on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMIPadRichView.h"

#import "AMAppDelegate.h"

@interface AMIPadRichView()

- (void)finishGetRich:(ABRichResponse *)response;

- (void)showRich:(ABRichResponse *)response;

@end

@implementation AMIPadRichView

@synthesize delegate;
@synthesize notification = _notification;

- (void)finishGetRich:(ABRichResponse *)response {
    [self performSelectorOnMainThread:@selector(showRich:) withObject:response waitUntilDone:YES];
}

- (void)showRich:(ABRichResponse *)response {
    [indicatorView stopAnimating];
    [indicatorView setHidden:YES];
    [webView setHidden:NO];
    
    if (response.code == ABResponseCodeHTTPSuccess && response.richContent) {
        
        [titleLabel setText:response.richTitle];
        [webView loadHTMLString:response.richContent baseURL:nil];
        
        self.notification.title = response.richTitle;
        self.notification.content = response.richContent;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@%@",AppBand_App_Rich_Push_Read_Prefix,self.notification.notification.notificationId] object:nil];
    }
}

#pragma mark - Public

- (void)setTarget:(AMDemoNotification *)notification {
    self.notification = notification;
    [titleLabel setText:nil];
    [webView loadHTMLString:nil baseURL:nil];
    
    if (!notification)
        return;
    
    if ([(AMAppDelegate *)[UIApplication sharedApplication].delegate availableString:notification.title]) {
        [indicatorView stopAnimating];
        [indicatorView setHidden:YES];
        [webView setHidden:NO];
        [titleLabel setText:self.notification.title];
        [webView loadHTMLString:self.notification.content baseURL:nil];
    } else {
        [webView setHidden:NO]; 
        [indicatorView startAnimating];
        [indicatorView setHidden:NO];
        [[ABPush shared] getRichContent:self.notification.notification target:self finishSelector:@selector(finishGetRich:)];
    }
}

- (IBAction)close:(id)sender {
    [titleLabel setText:nil];
    [webView loadHTMLString:nil baseURL:nil];
    [[ABPush shared] cancelGetRichContent:self.notification.notification.notificationId];
    [self setTarget:nil];
    [self.delegate richViewClosed:self];
}

#pragma mark - UIView lifecycle

- (void)dealloc {
    [self setNotification:nil];
    [super dealloc];
}
 
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
