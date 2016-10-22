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
@property (nonatomic, strong) NSNumber  *coding;
@property (nonatomic, strong) NSNumber  *dancing;
@property (nonatomic, strong) NSNumber  *cleaning;
@property (nonatomic, strong) NSArray   *codingList;
@property (nonatomic, strong) NSArray   *cleaningList;
@property (nonatomic, strong) NSArray   *dancingList;
@property (nonatomic, strong) NSString  *shiftType;




+(MSEvent*)make:(NSDate*)start title:(NSString*)title location:(NSString*)location;
+(MSEvent*)make:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location key:(NSString*)key coding:(NSNumber*)coding dancing:(NSNumber*)dancing cleaning:(NSNumber*)cleaning ;

+(MSEvent*)make:(NSDate*)start duration:(int)minutes title:(NSString*)title location:(NSString*)location;

+(MSEvent*)make:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location key:(NSString*)key codingList:(NSArray*)codinList cleaningList:(NSArray*)cleaningList dancingList:(NSArray*)dancingList shiftType:(NSString*)shiftType;

- (NSDate *)day;

@end