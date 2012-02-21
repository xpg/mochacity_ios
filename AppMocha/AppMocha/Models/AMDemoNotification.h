//
//  AMDemoNotification.h
//  AppMocha
//
//  Created by Jason Wang on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABNotification.h"

@interface AMDemoNotification : NSObject {
    ABNotification *notification;
    NSString *title;
    NSString *content;
}

@property(nonatomic, retain) ABNotification *notification;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;

@end
