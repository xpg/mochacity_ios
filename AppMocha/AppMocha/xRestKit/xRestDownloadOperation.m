/*
 File: xRestDownloadOperation.m
 Abstract: Used for File Download.
 
 Created by Jason Wang on 9/29/11.
 
 Version: 1.0
 
 Copyright 2011 __MyCompanyName__. All rights reserved.
 */
#import "xRestDownloadOperation.h"

#import "xRestConstants.h"

@interface xRestDownloadOperation()

@property(nonatomic,retain) NSURL *url;
@property(nonatomic,copy) NSString *path;
@property(nonatomic,retain) NSFileHandle *handle;

@property(nonatomic,retain) NSMutableData *responseData;

@property(assign) BOOL isCompleted;

- (void)downloadOperationCancelled;

@end

@implementation xRestDownloadOperation

@synthesize key = _key;

@synthesize url = _url;
@synthesize path = _path;
@synthesize handle = _handle;

@synthesize responseData = _responseData;

@synthesize isCompleted = _isCompleted;

#pragma mark - Private

- (void)downloadOperationCancelled {
    self.responseData = nil;
    if (self.path) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:NO]) {
            [[NSFileManager defaultManager] removeItemAtPath:self.path error:NULL];
        }
    }
	
    if (_urlConnection) {
        [_urlConnection release];
        _urlConnection = nil;
    }
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:[NSNumber numberWithInt:xRestProccessStatusCancel] forKey:xREST_PROCESS_STATUS];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:self.key object:dic];
	
	self.isCompleted = YES;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
	NSDictionary *headerDic = [httpResponse allHeaderFields];
	if(headerDic) {
		if ([headerDic objectForKey: @"Content-Range"]) {
			NSString *contentRange = [headerDic objectForKey: @"Content-Range"];
			NSRange range = [contentRange rangeOfString: @"/"];
			NSString *totalBytesCount = [contentRange substringFromIndex: range.location + 1];
			_expectedBytes = [totalBytesCount floatValue];
		} else if ([headerDic objectForKey: @"Content-Length"]) {
			_expectedBytes = [[headerDic objectForKey: @"Content-Length"] floatValue];
		} else {
			_expectedBytes = -1;
		}
		
		if ([@"Identity" isEqualToString: [headerDic objectForKey: @"Transfer-Encoding"]]) {
			_expectedBytes = _bytesReceived;
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	float receivedLen = [data length];
	_bytesReceived = (_bytesReceived + receivedLen);
    
    if (self.handle) {
        [self.handle writeData:data];
    } else {
        [self.responseData appendData:data];
    }
    
	if(_expectedBytes != NSURLResponseUnknownLength) {
		_completePercent = ((_bytesReceived / _expectedBytes) * 100) / 100;
		
		NSMutableDictionary *dic = [NSMutableDictionary dictionary];
		[dic setObject:[NSNumber numberWithInt:xRestProccessStatusProccessing] forKey:xREST_PROCESS_STATUS];
		[dic setObject:[NSNumber numberWithFloat:_completePercent] forKey:xREST_FILE_PROCESS_PERCENT];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:self.key object:dic];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.responseData = nil;
    if (self.path) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:NO]) {
            [[NSFileManager defaultManager] removeItemAtPath:self.path error:NULL];
        }
    }
	
    if (_urlConnection) {
        [_urlConnection release];
        _urlConnection = nil;
    }
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:[NSNumber numberWithInt:xRestProccessStatusFail] forKey:xREST_PROCESS_STATUS];
	[dic setObject:error forKey:xREST_PROCESS_STATUS_DONE_ERROR];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:self.key object:dic];
	
	self.isCompleted = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:[NSNumber numberWithInt:xRestProccessStatusSuccess] forKey:xREST_PROCESS_STATUS];
    if (!self.path) {
        UIImage *image = [UIImage imageWithData:self.responseData];
        if (image) {
            [dic setObject:[UIImage imageWithData:self.responseData] forKey:xREST_PROCESS_STATUS_DONE_IMAGE_TARGET];
        }
    }
	
	[[NSNotificationCenter defaultCenter] postNotificationName:self.key object:dic];
	
	self.isCompleted = YES;
}

#pragma mark - lifecycle

- (id)initWithURL:(NSString *)url path:(NSString *)path key:(NSString *)key {
    self = [super init];
	if (self) { 
		self.url = [NSURL URLWithString:url];
        self.path = path;
        self.key = key;
		
		self.isCompleted = NO;
        
        _bytesReceived = 0.0;
	}
	return self;
}

- (void)main {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    if (self.url && self.key) {
        if (self.path) {
            if (!createFileAtLocation(self.path, YES))
                [self cancel];
            
            self.handle = [NSFileHandle fileHandleForWritingAtPath:self.path];
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:120];
        self.responseData = [NSMutableData data];
        _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (_urlConnection) {
            while(!self.isCompleted && ![self isCancelled]) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            if ([self isCancelled]) {
                [self downloadOperationCancelled];
            }
            
        } else {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSNumber numberWithInt:xRestProccessStatusFail] forKey:xREST_PROCESS_STATUS];
            [dic setObject:[NSError errorWithDomain:@"File URL Error" code:1 userInfo:nil] forKey:xREST_PROCESS_STATUS_DONE_ERROR];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:self.key object:dic];
        }
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSNumber numberWithInt:xRestProccessStatusFail] forKey:xREST_PROCESS_STATUS];
        [dic setObject:[NSError errorWithDomain:@"File Path Error" code:0 userInfo:nil] forKey:xREST_PROCESS_STATUS_DONE_ERROR];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:self.key object:dic];
    }
    
	[pool release];
}

- (void)dealloc {
    NSLog(@"xRestDownloadOperation dealloc");
    if (_urlConnection) {
        [_urlConnection release];
    }
    self.responseData = nil;
	self.key = nil;
	self.url = nil;
    self.path = nil;
    self.key = nil;
    self.handle = nil;
	[super dealloc];
}

@end
