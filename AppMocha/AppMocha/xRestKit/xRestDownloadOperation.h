/*
 File: xRestDownloadOperation.h
 Abstract: Used for File Download.
 
 Created by Jason Wang on 9/29/11.
 
 Version: 1.0
 
 Copyright 2011 __MyCompanyName__. All rights reserved.
*/

#import <Foundation/Foundation.h>


@interface xRestDownloadOperation : NSOperation {
    @private
        NSString *_key;
        
        NSURLConnection *_urlConnection;
        
        NSURL *_url;
        NSString *_path;
        NSFileHandle *_handle;
    
        NSMutableData *_responseData;
        
        float _bytesReceived;
        long long _expectedBytes;
        float _completePercent;
        
        BOOL _isCompleted;
}

@property(nonatomic,copy) NSString *key;

#pragma mark - lifecycle

- (id)initWithURL:(NSString *)url path:(NSString *)path key:(NSString *)key;

@end
