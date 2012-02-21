/*
 File: xRestOperation.h
 Abstract: Used for asynchronous Request.
 
 Created by Jason Wang on 9/29/11.
 
 Version: 1.0
 
 Copyright 2011 __MyCompanyName__. All rights reserved.
*/

#import <Foundation/Foundation.h>

#import "xRestConstants.h"
#import "xRestProtocol.h"

@protocol xRestProtocol;

@interface xRestOperation : NSOperation {
    @private
        id<xRestProtocol> _delegate;
        
        BOOL _isTest;
        BOOL _isCompleted;
        BOOL _enableTimeout;
    
        NSString *_simulateResult;
        
        NSURLRequest *_request;
        NSTimeInterval _timeout;
        void (^_completion)(xRestCompletionType type, NSString *response);
    
        NSURLConnection *_urlConnection;
    
        NSMutableData *_responseData;
    
        xRestCompletionType _type;
}

#pragma mark - lifecycle

- (id)initWithRequest:(NSURLRequest *)request simulateResult:(NSString *)simulateResult delegate:(id<xRestProtocol>)delegate;

- (id)initWithRequest:(NSURLRequest *)request simulateResult:(NSString *)simulateResult completion:(void (^)(xRestCompletionType type, NSString *response))comletion;

//init method. for delegate
- (id)initWithRequest:(NSURLRequest *)request timeoutEnable:(BOOL)enable timeout:(NSTimeInterval)timeout delegate:(id<xRestProtocol>)delegate;

//init method. for block
- (id)initWithRequest:(NSURLRequest *)request timeoutEnable:(BOOL)enable timeout:(NSTimeInterval)timeout completion:(void (^)(xRestCompletionType type, NSString *response))comletion;

@end
