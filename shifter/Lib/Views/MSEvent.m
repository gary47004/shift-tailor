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

+(MSEvent*)make:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location key:(NSString *)key coding:(NSNumber*)coding dancing:(NSNumber*)dancing cleaning:(NSNumber*)cleaning{
    MSEvent* event = [MSEvent new];
    event.StartDate = start;
    event.EndDate   = end;
    event.title     = title;
    event.location  = location;
    event.key = key;
    event.coding = coding;
    event.dancing = dancing;
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

+(MSEvent*)make:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location key:(NSString*)key codingList:(NSArray*)codinList cleaningList:(NSArray *)cleaningList dancingList:(NSArray *)dancingList shiftType:(NSString *)shiftType{
    MSEvent* event = [MSEvent new];
    event.StartDate = start;
    event.EndDate = end;
    event.title = title;
    event.location = location;
    event.codingList = codinList;
    event.cleaningList = cleaningList;
    event.dancingList = dancingList;
    event.shiftType = shiftType;
    event.key = key;
    
    return event;
}

+(MSEvent*)makeEmployeeShiftEvent:(NSDate *)start end:(NSDate *)end title:(NSString *)title location:(NSString *)location key:(NSString *)key{
    MSEvent* event = [MSEvent new];
    
    event.StartDate = start;
    event.EndDate   = end;
    event.title     = title;
    event.location  = location;
    event.key = key;
    
    return event;

    
}


- (NSDate *)day{
    return [[NSCalendar currentCalendar] startOfDayForDate:self.StartDate];
}
@end