//
//  HAMBeaconManager.m
//  BeaconDemo
//
//  Created by Dai Yue on 14-6-16.
//  Copyright (c) 2014年 MayLight Corp. All rights reserved.
//

#import "HAMBeaconManager.h"

#import "HAMAVOSManager.h"

#import "HAMConstants.h"

#import "HAMTools.h"
#import "HAMLogTool.h"

@interface HAMBeaconManager(){
}

@property NSArray* uuidArray;

@property CLLocationManager* locationManager;
@property NSMutableArray* regionsArray;

@property NSMutableDictionary* beaconDictionary;

@end

static HAMBeaconManager* beaconManager = nil;

@implementation HAMBeaconManager

+ (HAMBeaconManager*)beaconManager{
    @synchronized(self) {
        if (beaconManager == nil) {
            beaconManager = [[HAMBeaconManager alloc] init];
        }
    }
    return beaconManager;
}

-(id)init{
    if (self = [super init]) {
        self.uuidArray = [NSArray array];
        self.beaconDictionary = [NSMutableDictionary dictionary];
        
        [self setupLocationManager];
    }
    return self;
}

- (void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

#pragma mark - Start/Stop Ranging

- (void)startRanging {
    if (![HAMTools isWebAvailable]) {
        [HAMLogTool error:@"currently offline."];
        return;
    }
    
    NSArray* beaconUUIDArray = [HAMAVOSManager beaconUUIDArray];
    self.uuidArray = beaconUUIDArray;
    if (self.uuidArray == nil) {
        [HAMLogTool error:@"failed to fetch BeaconUUID dictionary"];
        return;
    }
    
    self.regionsArray = [NSMutableArray array];
    for (int i = 0; i < beaconUUIDArray.count; i++)
    {
        NSString* uuidString = beaconUUIDArray[i];
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        if (uuid == nil) {
            [HAMLogTool warn:[NSString stringWithFormat:@"invalid UUID: %@",uuidString]];
            continue;
        }
        
        CLBeaconRegion *region = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:uuidString];
        region.notifyEntryStateOnDisplay = YES;
        if (region != nil) {
            [self.regionsArray addObject:region];
        }
    }
    
    for (CLBeaconRegion* beaconRegion in self.regionsArray)
    {
        [self.locationManager startMonitoringForRegion:beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

#pragma mark - LocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    //update beaconDictionary
    CLBeaconRegion* beaconRegion = (CLBeaconRegion*)region;
    NSString* uuid = beaconRegion.proximityUUID.UUIDString;
    [self.beaconDictionary removeObjectForKey:uuid];
    
    [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beaconArray inRegion:(CLBeaconRegion *)region {
    //update beaconDictionary
    NSString* uuid = region.proximityUUID.UUIDString;
    [self.beaconDictionary setObject:beaconArray forKey:uuid];
}


#pragma mark - Service API

- (NSArray*)beaconArray {
    NSMutableArray* beaconArray = [NSMutableArray array];
    
    //add all valid beacons to array
    NSDictionary* beaconDictionary = [NSDictionary dictionaryWithDictionary:self.beaconDictionary];
    NSArray* keyArray = [beaconDictionary allKeys];
    for (int i = 0; i < keyArray.count; i++) {
        NSString* key = keyArray[i];
        NSArray* beacons = [beaconDictionary objectForKey:key];
        for (int j = 0; j < beacons.count; j++) {
            CLBeacon* beacon = beacons[j];
            if (beacon == nil /*|| beacon.accuracy < 0 || beacon.proximity == CLProximityUnknown*/) {
                continue;
            }
            [beaconArray addObject:beacon];
        }
    }
    
    //sort beacons by accuracy
    NSArray *sortedBeaconArray = [beaconArray sortedArrayUsingComparator:^NSComparisonResult(CLBeacon* beacon1, CLBeacon* beacon2) {
        
        if (beacon1.accuracy < 0 && beacon2.accuracy < 0) {
            return NSOrderedSame;
        }
        
        if (beacon1.accuracy < 0) {
            return NSOrderedDescending;
        }
        
        if (beacon2.accuracy < 0) {
            return NSOrderedAscending;
        }
        
        if (beacon1.accuracy < beacon2.accuracy) {
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
    }];
    
    return [NSArray arrayWithArray:sortedBeaconArray];
}

#pragma mark - Static Methods

+ (void)startRanging{
    HAMBeaconManager* beaconManager = [self beaconManager];
    [beaconManager startRanging];
}

+ (NSArray*)beaconArray{
    HAMBeaconManager* beaconManager = [self beaconManager];
    return [beaconManager beaconArray];
}

@end
