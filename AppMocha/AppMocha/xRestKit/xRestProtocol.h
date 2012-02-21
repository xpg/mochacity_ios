//
//  xRestProtocol.h
//  xRestKitDemo
//
//  Created by Jason Wang on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "xRestConstants.h"

@protocol xRestProtocol <NSObject>

@optional

//called when the request end.
- (void)finishedReuqest:(NSString *)url withEndType:(xRestCompletionType)type content:(NSString *)content;

@end
