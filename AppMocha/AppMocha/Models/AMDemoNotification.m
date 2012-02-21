//
//  AMDemoNotification.m
//  AppMocha
//
//  Created by Jason Wang on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMDemoNotification.h"

@implementation AMDemoNotification

@synthesize notification;
@synthesize title;
@synthesize content;

- (void)dealloc {
    [self setNotification:nil];
    [self setTitle:nil];
    [self setContent:nil];
    [super dealloc];
}

@end
