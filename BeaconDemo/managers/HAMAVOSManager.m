//
//  HAMAVOSManager.m
//  BeaconDemo
//
//  Created by Dai Yue on 14-6-16.
//  Copyright (c) 2014年 MayLight Corp. All rights reserved.
//

#import "HAMAVOSManager.h"
#import <CoreLocation/CoreLocation.h>

#import "HAMLogTool.h"

@implementation HAMAVOSManager

#pragma mark - Cache

#pragma mark - Query Methods

+ (void)setCachePolicyOfQuery:(AVQuery*)query{
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 600;
}

#pragma mark - Clear Cache

+ (void)clearCache{
    [AVQuery clearAllCachedResults];
}

#pragma mark - BeaconUUID

#pragma mark - BeaconUUID Query

+ (NSArray*)beaconUUIDArray{
    [AVQuery clearAllCachedResults];
    AVQuery *query = [AVQuery queryWithClassName:@"BeaconUUID"];
    [self setCachePolicyOfQuery:query];
    
    NSArray* uuidObjectsArray = [query findObjects];
    if (uuidObjectsArray == nil) {
        return nil;
    }
    
    NSMutableArray* uuidArray = [NSMutableArray array];
    for (int i = 0; i < uuidObjectsArray.count; i++) {
        AVObject* uuidObject = uuidObjectsArray[i];
        NSString* uuid = [uuidObject objectForKey:@"proximityUUID"];
        if (uuid == nil) {
            continue;
        }
        [uuidArray addObject:uuid];
    }
    
    return uuidArray;
}

#pragma mark - Beacon Query

+ (AVObject*)queryBeaconAVObjectWithCLBeacon:(CLBeacon*)beacon{
    if (beacon == nil) {
        return nil;
    }
    
    AVQuery *query = [AVQuery queryWithClassName:@"Beacon"];
    [self setCachePolicyOfQuery:query];
    
    [query whereKey:@"proximityUUID" equalTo:beacon.proximityUUID.UUIDString];
    [query whereKey:@"major" equalTo:beacon.major];
    [query whereKey:@"minor" equalTo:beacon.minor];
    
    AVObject* beaconObject = [query getFirstObject];
    return beaconObject;
}

+ (double)rangeOfBeacon:(CLBeacon*)beacon{
    if (beacon == nil) {
        [HAMLogTool warn:@"query range of beacon nil"];
        return CLProximityUnknown;
    }
    
    AVObject* beaconObject = [self queryBeaconAVObjectWithCLBeacon:beacon];
    if (beaconObject == nil) {
        return -1;
    }
    
    NSNumber* rangeNumber = [beaconObject objectForKey:@"range"];
    
    if (rangeNumber == nil) {
        return -1;
    }
    
    return [rangeNumber doubleValue];
}

+ (NSString*)urlOfBeacon:(CLBeacon*)beacon{
    if (beacon == nil) {
        [HAMLogTool warn:@"query range of beacon nil"];
        return nil;
    }
    
    AVObject* beaconObject = [self queryBeaconAVObjectWithCLBeacon:beacon];
    return [beaconObject objectForKey:@"url"];
}

@end
