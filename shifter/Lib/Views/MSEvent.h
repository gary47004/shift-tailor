//
//  AKEvent.h
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTTimePeriod.h"

@interface MSEvent : DTTimePeriod

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *location;
@property (nonatomic, strong) NSString  *key;
@property (nonatomic, strong) NSNumber  *beverage;
@property (nonatomic, strong) NSNumber  *cashier;
@property (nonatomic, strong) NSNumber  *cleaning;
@property (nonatomic, strong) NSArray   *beverageList;
@property (nonatomic, strong) NSArray   *cleaningList;
@property (nonatomic, strong) NSArray   *cashierList;
@property (nonatomic, strong) NSString  *shiftType;
@property (nonatomic, strong) NSString  *late;
@property (nonatomic, strong) NSNumber  *preference;




+(MSEvent*)make:(NSDate*)start title:(NSString*)title location:(NSString*)location;

+(MSEvent*)makeManagerEventEvent:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location key:(NSString*)key beverage:(NSNumber*)beverage cashier:(NSNumber*)cashier cleaning:(NSNumber*)cleaning;

+(MSEvent*)make:(NSDate*)start duration:(int)minutes title:(NSString*)title location:(NSString*)location;

+(MSEvent*)makeManagerShiftEvent:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location key:(NSString*)key beverageList:(NSArray*)beverageList cleaningList:(NSArray*)cleaningList cashierList:(NSArray*)cashierList shiftType:(NSString*)shiftType;

+(MSEvent*)makeEmployeeShiftEvent:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location key:(NSString*)key late:(NSString*)late;

+(MSEvent*)makeEmployeeEventEvent:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location key:(NSString*)key preference:(NSNumber*)preference;

- (NSDate *)day;

@end