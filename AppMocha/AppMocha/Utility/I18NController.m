//
//  I18NController.m
//  I18NController
//
//  Created by danny on 6/14/11.
//  Copyright 2011 XPG. All rights reserved.
//


#import "I18NController.h"

static I18NController *shareController = nil;

@implementation I18NController

#pragma mark - Public

- (NSString *)getLocalizedString:(NSString *)_key comment:(NSString *)_comment locale:(NSLocale *)_locale {
    if (_locale) {
        NSString *tableName = [NSString stringWithFormat:@"%@.lproj/Localizable",[_locale localeIdentifier]];
        return NSLocalizedStringFromTable(_key,tableName,_comment);
    }
    
    return NSLocalizedString(_key,_comment);
}

#pragma mark - Singleton

+(I18NController*)shareController {
	@synchronized(self) {
        if (!shareController) {
            shareController = [[I18NController alloc] init];
        }
    }
    return shareController;
}

- (oneway void)release {

}

#pragma mark - lifecycle

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)delloc {
    if (shareController) {
        [shareController release];
    }
    [super dealloc];
}

@end
