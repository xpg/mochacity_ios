//
//  I18NController.h
//  I18NController
//
//  Created by danny on 6/14/11.
//  Copyright 2011 XPG. All rights reserved.
//

#define Change_Language_Notification_Name @"Change_Language_Notification_Name"

@interface I18NController : NSObject {
    
}

#pragma mark - Singleton

+ (I18NController*)shareController;

#pragma mark - Public

- (NSString *)getLocalizedString:(NSString *)_key comment:(NSString *)_comment locale:(NSLocale *)_locale;

@end
