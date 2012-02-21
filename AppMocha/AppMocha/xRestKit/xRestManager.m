/*
 File: xRestManager.m
 Abstract: Singleton Class to perform webservice request.
 
 Created by Jason Wang on 9/29/11.
 
 Version: 1.0
 
 Copyright 2011 __MyCompanyName__. All rights reserved.
*/

#import "xRestManager.h"

#import "xRestOperation.h"
#import "xRestDownloadOperation.h"

#import "SBJson.h"

@interface xRestManager()

//check whether need set http body
- (BOOL)request:(NSMutableURLRequest *)request setParameter:(NSDictionary *)parameter;

@end

static xRestManager *_defaultManager;

@implementation xRestManager

#pragma mark - Public

- (void)simulateRequestTo:(NSString *)url parameter:(NSDictionary *)parameter response:(NSString *)response delegate:(id<xRestProtocol>)delegate {
    if (url) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240]; //new mutableURLRequest with url and timeout, if the request is POST, then the timeout is invalid.
        
        if (request) {
            xRestOperation *operation = [[xRestOperation alloc] initWithRequest:request simulateResult:response delegate:delegate];
            [_operationQueue addOperation:operation];   //add operation to operation queue. 
            [operation release];
            return;
        } 
    }
    
    if ([delegate respondsToSelector:@selector(finishedReuqest:withEndType:content:)]) {
        [delegate finishedReuqest:url withEndType:xRestCompletionTypeInvalidURL content:nil];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)simulateRequestTo:(NSString *)url parameter:(NSDictionary *)parameter response:(NSString *)response completion:(void (^)(xRestCompletionType type, NSString *response))comletion {
    if (url) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240.];   //new mutableURLRequest with url and timeout, if the request is POST, then the timeout is invalid.
        
        if (request) {
            xRestOperation *operation = [[xRestOperation alloc] initWithRequest:request simulateResult:response completion:comletion];
            [_operationQueue addOperation:operation];   //add operation to operation queue. 
            [operation release];
            return;
        }
    } 
    
    comletion(xRestCompletionTypeInvalidURL,nil);
}
#endif

// send request with delegate
- (NSString *)sendSynchronousTo:(NSString *)url parameter:(NSDictionary *)parameter timeout:(NSTimeInterval)timeout returningResponse:(NSURLResponse **)response error:(NSError **)error {
    NSString *result = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    if (url && request) {
        [self request:request setParameter:parameter];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
        result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    } else {
        NSError *er = [NSError errorWithDomain:@"Invalid URL" code:0 userInfo:nil];
        error = &er;
    }
    
    return result;
}

// send request with delegate
//    url - webservice url
//    parameter - used for POST method
//    timeout - request time out time
//    delegate - xRestProtocol. only need when it is a asynchronous request
- (void)sendRequestTo:(NSString *)url parameter:(NSDictionary *)parameter timeout:(NSTimeInterval)timeout delegate:(id<xRestProtocol>)delegate {
    if (url) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout]; //new mutableURLRequest with url and timeout, if the request is POST, then the timeout is invalid.
        
        if (request) {
            BOOL enableTimeout = [self request:request setParameter:parameter]; //check whether need set http body. if yes, need check timeout by operation.
            xRestOperation *operation = [[xRestOperation alloc] initWithRequest:request timeoutEnable:enableTimeout timeout:timeout delegate:delegate];
            [_operationQueue addOperation:operation];   //add operation to operation queue. 
            [operation release];
            return;
        } 
    }
    
    if ([delegate respondsToSelector:@selector(finishedReuqest:withEndType:content:)]) {
        [delegate finishedReuqest:url withEndType:xRestCompletionTypeInvalidURL content:nil];
    }
    
    return;
}

#if NS_BLOCKS_AVAILABLE
// send request with block.  notice: the request target will be retain.
//    url - webservice url
//    parameter - used for POST method
//    timeout - request time out time
//    completion - completion block. 
- (void)sendRequestTo:(NSString *)url parameter:(NSDictionary *)parameter timeout:(NSTimeInterval)timeout completion:(void (^)(xRestCompletionType type, NSString *response))comletion {
    if (url) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];   //new mutableURLRequest with url and timeout, if the request is POST, then the timeout is invalid.
        
        if (request) {
            BOOL enableTimeout = [self request:request setParameter:parameter]; //check whether need set http body. if yes, need check 
            
            xRestOperation *operation = [[xRestOperation alloc] initWithRequest:request timeoutEnable:enableTimeout timeout:timeout completion:comletion];
            [_operationQueue addOperation:operation];   //add operation to operation queue. 
            [operation release];
            return;
        }
    } 
    
    comletion(xRestCompletionTypeInvalidURL,nil); 
}
#endif

// download file
//    url - file url
//    path - file save location. if nil, the file will be cached in memory, and published out by notification
//    key - the notification name.
- (void)downloadFileWithURL:(NSString *)url path:(NSString *)path key:(NSString *)key {
    xRestDownloadOperation *operation = [[xRestDownloadOperation alloc] initWithURL:url path:path key:key];
    [_downloadQueue addOperation:operation];
    [operation release];
}

// cancel download
- (void)cancelDownloadWithKey:(NSString *)key {
    for (xRestDownloadOperation *operation in [_downloadQueue operations]) {
        if ([operation.key isEqualToString:key]) {
            [operation cancel];
        }
    }
}

#pragma mark - Private

//check whether need set http body
- (BOOL)request:(NSMutableURLRequest *)request setParameter:(NSDictionary *)parameter {
    BOOL enableTimeout = NO;    // default no. no need to open if parameter is nil or empty.
    if(parameter && [[parameter allKeys] count] > 0){
        enableTimeout = YES;
        [request setHTTPMethod:@"POST"];    //set request method to POST.
        
//        NSString * postString = @"";
//        NSArray * keys = [parameter allKeys];
//        for(NSString * key in keys){
//            NSString * _data = (NSString *)[parameter objectForKey:key];
//            postString = [postString stringByAppendingFormat:@"&%@=%@",key,_data]; 
//        }
//        
//        NSMutableData *postBody = [NSMutableData data];
//        [postBody appendData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [request setHTTPBody:postBody]; //set http body.
        
        SBJsonWriter *sbJson = [[SBJsonWriter alloc] init];
        NSString *postString = [sbJson stringWithObject:parameter error:nil];
        
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:postBody]; //set http body.
        [sbJson release];
    }
    
//    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:contentType forHTTPHeaderField:@"Accept"];
    
    return enableTimeout;
}

#pragma mark - Singleton Method

+ (xRestManager *)defaultManager {
	@synchronized([xRestManager class]) {
		if (!_defaultManager) {
			[[self alloc] init];
		}
		return _defaultManager;
	}
	return nil;
}

/* 
 The Methods should not changed. 
 */

+ (id)alloc {
	@synchronized([xRestManager class]) {
		_defaultManager = [super alloc];
		return _defaultManager;
	}
	
	return nil;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized([xRestManager class]) {
		_defaultManager= [super allocWithZone:zone];
		return _defaultManager;
	}
	return nil;
}

- (id)init {
	self = [super init];
	if (self != nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:xRest_Operation_Max_Concurrent];
        
        _downloadQueue = [[NSOperationQueue alloc] init];
        [_downloadQueue setMaxConcurrentOperationCount:xRest_Download_Operation_Max_Concurrent];
        
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;
}

- (oneway void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}

- (void)dealloc {
    [_operationQueue release];
    [_downloadQueue release];
	[super dealloc];
}

@end
