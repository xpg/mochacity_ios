//
//  CoreDataManager.m
//  iFamily
//
//  Created by Jason Wang on 5/21/11.
//  Copyright 2011 Jason Wang. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

static CoreDataManager *_defaultManager;

#pragma mark - Public

- (CoreDataController *)fetchCDController:(NSString *)_persistentStore {
    id controller = [cdControllers objectForKey:_persistentStore];
    
    if (controller && [controller isKindOfClass:[CoreDataController class]]) return controller;
    
    controller = [[CoreDataController alloc] initWithModel:_persistentStore store:_persistentStore];
    
    [cdControllers setObject:controller forKey:_persistentStore];
    
    [controller release];
    
    return controller;
}

- (void)releaseCDController:(NSString *)_persistentStore {
    if ([[cdControllers allKeys] containsObject:_persistentStore]) {
        [cdControllers removeObjectForKey:_persistentStore];
    }
}

- (void)cleanAll {
    if (cdControllers) {
        [cdControllers release];
        cdControllers = nil;
    }
    cdControllers = [[NSMutableDictionary alloc] init];
}

#pragma mark - Singleton Method

+ (CoreDataManager *)defaultManager {
	@synchronized([CoreDataManager class]) {
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
	@synchronized([CoreDataManager class]) {
		_defaultManager = [super alloc];
		return _defaultManager;
	}
	return nil;
} 

- (id)init {
	self = [super init];
	if (self != nil) {
        cdControllers = [[NSMutableDictionary alloc] init];
	}
	return self;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized([CoreDataManager class]) {
		_defaultManager= [super allocWithZone:zone];
		return _defaultManager;
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}

- (void)dealloc {
    [cdControllers release];
	[super dealloc];
}

@end
