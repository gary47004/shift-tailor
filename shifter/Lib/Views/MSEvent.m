//
//  AKEvent.m
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import "MSEvent.h"
#import "NSDate+Easy.h"

@implementation MSEvent

+(MSEvent*)make:(NSDate*)start title:(NSString*)title location:(NSString*)location{
    return [self.class make:start duration:60 title:title location:location];
}

+(MSEvent*)makeManagerEventEvent:(NSDate *)start end:(NSDate *)end title:(NSString *)title location:(NSString *)location key:(NSString *)key beverage:(NSNumber *)beverage cashier:(NSNumber *)cashier cleaning:(NSNumber *)cleaning{
    MSEvent* event = [MSEvent new];
    event.StartDate = start;
    event.EndDate   = end;
    event.title     = title;
    event.location  = location;
    event.key = key;
    event.beverage = beverage;
    event.cashier = cashier;
    event.cleaning = cleaning;
    return event;
}

+(MSEvent*)make:(NSDate*)start duration:(int)minutes title:(NSString*)title location:(NSString*)location{
    MSEvent* event  = [MSEvent new];
    event.StartDate = start;
    event.EndDate   = [start addMinutes:minutes];
    event.title     = title;
    event.location  = location;
    return event;
}

+(MSEvent*)makeManagerShiftEvent:(NSDate *)start end:(NSDate *)end title:(NSString *)title location:(NSString *)location key:(NSString *)key beverageList:(NSArray *)beverageList cleaningList:(NSArray *)cleaningList cashierList:(NSArray *)cashierList shiftType:(NSString *)shiftType{
    MSEvent* event = [MSEvent new];
    event.StartDate = start;
    event.EndDate = end;
    event.title = title;
    event.location = location;
    event.beverageList = beverageList;
    event.cleaningList = cleaningList;
    event.cashierList = cashierList;
    event.shiftType = shiftType;
    event.key = key;
    
    return event;
}

+(MSEvent*)makeEmployeeShiftEvent:(NSDate *)start end:(NSDate *)end title:(NSString *)title location:(NSString *)location key:(NSString *)key late:(NSString *)late{
    MSEvent* event = [MSEvent new];
    
    event.StartDate = start;
    event.EndDate   = end;
    event.title     = title;
    event.location  = location;
    event.key = key;
    event.late = late;
    
    return event;

    
}

+(MSEvent*)makeEmployeeEventEvent:(NSDate *)start end:(NSDate *)end title:(NSString *)title location:(NSString *)location key:(NSString *)key preference:(NSNumber *)preference{
    MSEvent* event = [MSEvent new];
    
    event.StartDate = start;
    event.EndDate = end;
    event.title = title;
    event.location = location;
    event.key = key;
    event.preference = preference;
    
    
    return event;
}


- (NSDate *)day{
    return [[NSCalendar currentCalendar] startOfDayForDate:self.StartDate];
}
@end