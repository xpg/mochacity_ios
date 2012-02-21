/*
 File: xRestManager.h
 Abstract: Singleton Class to perform webservice request.
 
 Created by Jason Wang on 9/29/11.
 
 Version: 1.0
 
 Copyright 2011 __MyCompanyName__. All rights reserved.
*/

#import <Foundation/Foundation.h>

#import "xRestConstants.h"
#import "xRestProtocol.h"

@protocol xRestProtocol;

@interface xRestManager : NSObject {
    @private
        NSOperationQueue *_operationQueue;
        NSOperationQueue *_downloadQueue;
}

#pragma mark - Public

- (void)simulateRequestTo:(NSString *)url parameter:(NSDictionary *)parameter response:(NSString *)response delegate:(id<xRestProtocol>)delegate;

#if NS_BLOCKS_AVAILABLE
- (void)simulateRequestTo:(NSString *)url parameter:(NSDictionary *)parameter response:(NSString *)response completion:(void (^)(xRestCompletionType type, NSString *response))comletion;
#endif

// send request with delegate
- (NSString *)sendSynchronousTo:(NSString *)url parameter:(NSDictionary *)parameter timeout:(NSTimeInterval)timeout returningResponse:(NSURLResponse **)response error:(NSError **)error;

// send request with delegate
//    url - webservice url
//    parameter - used for POST method
//    timeout - request time out time
//    delegate - xRestProtocol. only need when it is a asynchronous request
- (void)sendRequestTo:(NSString *)url parameter:(NSDictionary *)parameter timeout:(NSTimeInterval)timeout delegate:(id<xRestProtocol>)delegate;

#if NS_BLOCKS_AVAILABLE
// send request with block.  notice: the request target will be retain.
//    url - webservice url
//    parameter - used for POST method
//    timeout - request time out time
//    completion - completion block. 
- (void)sendRequestTo:(NSString *)url parameter:(NSDictionary *)parameter timeout:(NSTimeInterval)timeout completion:(void (^)(xRestCompletionType type, NSString *response))comletion;
#endif

// download file
//    url - file url
//    path - file save location. if nil, the file will be cached in memory, and published out by notification
//    key - the notification name.
- (void)downloadFileWithURL:(NSString *)url path:(NSString *)path key:(NSString *)key;

// cancel download
- (void)cancelDownloadWithKey:(NSString *)key;

#pragma mark - Singleton Method

+ (xRestManager *)defaultManager;

@end
