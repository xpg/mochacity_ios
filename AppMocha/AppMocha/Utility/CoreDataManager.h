//
//  CoreDataManager.h
//  iFamily
//
//  Created by Jason Wang on 5/21/11.
//  Copyright 2011 Jason Wang. All rights reserved.
//

#import "CoreDataController.h"
#import "CoreDataProtocol.h"

@interface CoreDataManager : NSObject {
    NSMutableDictionary *cdControllers;
}

#pragma mark - Singleton Method

+ (CoreDataManager *)defaultManager;

#pragma mark -  Public

- (CoreDataController *)fetchCDController:(NSString *)_persistentStore;

- (void)releaseCDController:(NSString *)_persistentStore;

- (void)cleanAll;

@end
