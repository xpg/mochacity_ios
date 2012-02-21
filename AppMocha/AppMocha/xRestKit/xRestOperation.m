/*
 File: xRestOperation.m
 Abstract: Used for asynchronous Request.
 
 Created by Jason Wang on 9/29/11.
 
 Version: 1.0
 
 Copyright 2011 __MyCompanyName__. All rights reserved.
*/

#import "xRestOperation.h"

@interface xRestOperation()

@property(nonatomic,assign) id<xRestProtocol> delegate;

@property(nonatomic,copy) NSURLRequest *request;
@property(nonatomic,assign) NSTimeInterval timeout;
@property(nonatomic,copy) NSString *simulateResult;

@property(assign) BOOL isTest;
@property(assign) BOOL isCompleted;
@property(assign) BOOL enableTimeout;
@property(nonatomic,retain) NSMutableData *responseData;
@property(nonatomic,assign) xRestCompletionType type;

//timeout method.
- (void)requestTimeOut;

- (void)operationCompleted;

- (void)simulateReturn;

@end

@implementation xRestOperation

@synthesize delegate = _delegate;

@synthesize request = _request;
@synthesize timeout = _timeout;
@synthesize simulateResult = _simulateResult;

@synthesize isTest = _isTest;
@synthesize isCompleted = _isCompleted;
@synthesize enableTimeout = _enableTimeout;
@synthesize responseData = _responseData;
@synthesize type = _type;

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError :%@",[error localizedDescription]);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTimeOut) object:nil];
	self.responseData = nil;    //set the data to nil.
    self.type = xRestCompletionTypeError;   //set tgpe to xRestCompletionTypeError.
	self.isCompleted = YES;  //set isCompleted to YES.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTimeOut) object:nil];
    
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    if ((httpResponse.statusCode / 100) != 2) { // is the statuCode is not 2**, then there is error.
        
        if (_urlConnection) {
            [_urlConnection release];
            _urlConnection = nil;
        }
        self.responseData = nil;    //set the data to nil.
        self.type = xRestCompletionTypeError;   //set tgpe to xRestCompletionTypeError.
        self.isCompleted = YES;  //set isCompleted to YES.
    }
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.isCompleted || !self.responseData) return;
    
	[self.responseData appendData:data]; //append Data
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.isCompleted || !self.responseData) return;
    
    self.type = xRestCompletionTypeSuccess; //set tgpe to xRestCompletionTypeSuccess.
	self.isCompleted = YES;
}

#pragma mark -
#pragma mark Private

- (void)requestTimeOut {
    
    //release NSURLConnection
    if (_urlConnection) {
        [_urlConnection cancel];
		[_urlConnection release];
		_urlConnection = nil;
	}
    
    //set tgpe to xRestCompletionTypeTimeout.
    self.type = xRestCompletionTypeTimeout;
	self.isCompleted = YES;
}

- (void)operationCompleted {
    NSString *returnStr = nil;
    
    //check whether the operation is be cancelled.
    if ([self isCancelled]) {
        //if YES, set type to xRestCompletionTypeCancel.
        self.type = xRestCompletionTypeCancel;
    } else {
        if (self.responseData) {
            //Convert NSData to NSString.
            NSString *tempStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
            returnStr= [NSString stringWithString:tempStr];
            [tempStr release];
        }
    }
    
    if (_completion) {
        //if block is not nil. then call block.
        _completion(self.type, returnStr);
    } else if ([self.delegate respondsToSelector:@selector(finishedReuqest:withEndType:content:)]) {
        [self.delegate finishedReuqest:[[self.request URL] absoluteString] withEndType:self.type content:returnStr];
    }
}

- (void)simulateReturn {
    NSData *data = [self.simulateResult dataUsingEncoding:NSUTF8StringEncoding];
    [self.responseData appendData:data];
    self.type = xRestCompletionTypeSuccess;
    self.isCompleted = YES;
}

#pragma mark - lifecycle

- (id)initWithRequest:(NSURLRequest *)request simulateResult:(NSString *)simulateResult delegate:(id<xRestProtocol>)delegate {
    self = [super init];
    if (self) {
        self.request = request;
        self.enableTimeout = NO;
        self.timeout = 0.;
        self.delegate = delegate;
        self.isTest = YES;
        self.simulateResult = simulateResult;
        _completion = nil;
        
        self.isCompleted = YES;
        self.type = xRestCompletionTypeUnknown;
    }
    
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request simulateResult:(NSString *)simulateResult completion:(void (^)(xRestCompletionType type, NSString *response))comletion {
    self = [super init];
    if (self) {
        self.request = request;
        self.enableTimeout = NO;
        self.timeout = 0.;
        self.delegate = nil;
        self.isTest = YES;
        self.simulateResult = simulateResult;
        _completion = Block_copy(comletion);
        
        self.isCompleted = YES;
        self.type = xRestCompletionTypeUnknown;
    }
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request timeoutEnable:(BOOL)enable timeout:(NSTimeInterval)timeout delegate:(id<xRestProtocol>)delegate {
    self = [super init];
    if (self) {
        self.request = request;
        self.enableTimeout = enable;
        self.timeout = timeout;
        self.delegate = delegate;
        self.isTest = NO;
        self.simulateResult = nil;
        _completion = nil;
        
        self.isCompleted = YES;
        self.type = xRestCompletionTypeUnknown;
    }
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request timeoutEnable:(BOOL)enable timeout:(NSTimeInterval)timeout completion:(void (^)(xRestCompletionType type, NSString *response))comletion {
    self = [super init];
    if (self) {
        self.request = request;
        self.enableTimeout = enable;
        self.timeout = timeout;
        self.delegate = nil;
        self.isTest = NO;
        self.simulateResult = nil;
        _completion = Block_copy(comletion);
        
        self.isCompleted = YES;
        self.type = xRestCompletionTypeUnknown;
    }
    return self;
}

- (void)main {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    self.type = xRestCompletionTypeNoConnection;  //set type to xRestCompletionTypeNoConnection, default.
    
    if (hasConnection()) { //Check connection 
        self.responseData = [NSMutableData data];
        
        if (!self.isTest) {
            _urlConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
            self.type = xRestCompletionTypeInvalidURL;
            
            if (_urlConnection) {
                self.isCompleted = NO; //set isCompleted to NO.
                if (self.enableTimeout) {   //if YES, need to perform timeout selector after self.timeout time.
                    [self performSelector:@selector(requestTimeOut) withObject:nil afterDelay:self.timeout];
                }
            }
        } else {
            self.isCompleted = NO;
            [self performSelector:@selector(simulateReturn) withObject:nil afterDelay:2.];
        }
        
        while(!self.isCompleted && ![self isCancelled]) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    
    [self operationCompleted];
    
	[pool release];
}

- (void)dealloc {
    NSLog(@"operation dealloc");
    Block_release(_completion); //release block.
    if (_urlConnection) {
        [_urlConnection release];
    }
    self.simulateResult = nil;
    self.request = nil;
    self.responseData = nil;
	[super dealloc];
}

@end
