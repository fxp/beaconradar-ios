//
//  HAMAVOSManager.h
//  BeaconDemo
//
//  Created by Dai Yue on 14-6-16.
//  Copyright (c) 2014年 MayLight Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@class CLBeacon;

@interface HAMAVOSManager : NSObject
{}

#pragma mark - BeaconUUID

#pragma mark - BeaconUUID Query

+ (NSArray*)beaconUUIDArray;

#pragma mark - Beacon Query

+ (double)rangeOfBeacon:(CLBeacon*)beacon;

+ (NSString*)urlOfBeacon:(CLBeacon*)beacon;

@end
