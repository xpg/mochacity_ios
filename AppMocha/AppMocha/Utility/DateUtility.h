//
//  DateUtility.h
//  iFamily
//
//  Created by Jason Wang on 5/21/11.
//  Copyright 2011 Jason Wang. All rights reserved.
//

#define DAY_OF_SECONDS 24.0*60*60

#define DEFAULT_DATE_TEMPLATE_STRING @"HH:mm:ss dd/MM/yy"
#define SHORT_DATE_TEMPLATE_STRING @"yyyy-MM-dd"
#define TIME_TEMPLATE_STRING @"hh:mm a"

struct JWDate {
    NSUInteger second;
    NSUInteger minute;
    NSUInteger hour;
    NSUInteger weekday;
    NSUInteger day;
    NSUInteger month;
    NSUInteger year;
};
typedef struct JWDate JWDate;

CG_INLINE JWDate JWDateMake(NSDate *date) {
    JWDate jwDate;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    jwDate.second = [components second];
    jwDate.minute = [components minute];
    jwDate.hour = [components hour];
    jwDate.weekday = [components weekday];
    jwDate.day = [components day];
    jwDate.month = [components month];
    jwDate.year = [components year];
    
    return jwDate;
}

CG_INLINE NSArray * getWeekdaySymbols() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *weekdaySymbols = [formatter weekdaySymbols];
    [formatter release];
    
    return weekdaySymbols;
}

CG_INLINE NSArray * getShortWeekdaySymbols() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *weekdaySymbols = [formatter shortWeekdaySymbols];
    [formatter release];
    
    return weekdaySymbols;
}

CG_INLINE NSArray * getMonthSymbols() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *monthSymbols = [formatter monthSymbols];
    [formatter release];
    
    return monthSymbols;
}

CG_INLINE NSArray * getShortMonthSymbols() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *monthSymbols = [formatter shortMonthSymbols];
    [formatter release];
    
    return monthSymbols;
}

CG_INLINE NSDate * getDate(NSDate *fromDate, NSInteger dayGap) {
    return [NSDate dateWithTimeInterval:DAY_OF_SECONDS * dayGap sinceDate:fromDate];
}

CG_INLINE NSDate * getLastDateOfMonth(NSDate *targetMonthDay) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSRange daysRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:targetMonthDay];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:targetMonthDay];
    [components setDay:daysRange.length];
    
    return [calendar dateFromComponents:components];
}

CG_INLINE NSDate * getFirstDateOfMonth(NSDate *targetMonthDay) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:targetMonthDay];
    [components setDay:1];
    
    return [calendar dateFromComponents:components];
}

CG_INLINE NSDate *getFirstDateOfWeek(NSDate *date) {
    JWDate jwDate = JWDateMake(date);
    
    return getDate(date, -1 * (jwDate.weekday - 1));
}

CG_INLINE NSDate *getTomorrowDate() {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [calendar components:kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond fromDate:today];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSTimeInterval timeInterval = DAY_OF_SECONDS - 3600 * hour - 60 * minute - second + 1;
    
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:today];;
}

CG_INLINE NSDate * getDateFromString(NSString *dateStringTemplate, NSString *dateStr) {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (!dateStringTemplate) {
        dateStringTemplate = DEFAULT_DATE_TEMPLATE_STRING;
    }
    
    [dateFormatter setDateFormat:dateStringTemplate];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    [dateFormatter release];
    return date;
}

CG_INLINE NSString *getStringFromDate(NSString *dateStringTemplate, NSDate *date) {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (!dateStringTemplate) {
        dateStringTemplate = DEFAULT_DATE_TEMPLATE_STRING;
    }
    
    [dateFormatter setDateFormat:dateStringTemplate];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    [dateFormatter release];
    return dateStr;
}




