//
//  xRestConstants.h
//  xRestKitDemo
//
//  Created by Jason Wang on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Reachability.h"

#define xRest_Operation_Max_Concurrent 5
#define xRest_Download_Operation_Max_Concurrent 3

/************** Notification object NSDictionary Key *************/
#define xREST_PROCESS_STATUS @"xREST_PROCESS_STATUS"

#define xREST_FILE_PROCESS_PERCENT @"xREST_FILE_PROCESS_PERCENT"
#define xREST_PROCESS_STATUS_DONE_ERROR @"xREST_PROCESS_STATUS_DONE_ERROR"
#define xREST_PROCESS_STATUS_DONE_IMAGE_TARGET @"xREST_PROCESS_STATUS_DONE_IMAGE_TARGET"
/************** Notification object NSDictionary Key *************/


//Check whether the web connection is valid.
CG_INLINE BOOL hasConnection() {
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
	return (status == ReachableViaWiFi || status == ReachableViaWWAN) ? YES : NO;
}

//Create file at path
CG_INLINE  BOOL createFileAtLocation(NSString * filePath, BOOL overwirte) {
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO]) {
		if (overwirte) {
			if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL])
				return NO;
		}
	}
	return [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
}

typedef enum {
    xRestCompletionTypeUnknown, //unknown type
    xRestCompletionTypeNoConnection,    //no Connection
    xRestCompletionTypeInvalidURL,  //the url is invalid.
    xRestCompletionTypeCancel, //the request is cancelled
    xRestCompletionTypeTimeout, //the request is timeou.
    xRestCompletionTypeError,   //error happened when requesting.
    xRestCompletionTypeSuccess, //success.
}xRestCompletionType; //xRest Request Return Type

typedef enum {
    xRestProccessStatusFail,
	xRestProccessStatusProccessing,
    xRestProccessStatusCancel,
	xRestProccessStatusSuccess,
}xRestProccessStatus;  //xRest Download Proccess Type


