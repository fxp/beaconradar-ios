//
//  HAMBeaconManager.h
//  BeaconDemo
//
//  Created by Dai Yue on 14-6-16.
//  Copyright (c) 2014年 MayLight Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface HAMBeaconManager : NSObject <CLLocationManagerDelegate>
{
}

+ (HAMBeaconManager*)beaconManager;

+ (void)startRanging;

+ (NSArray*)beaconArray;

@end
