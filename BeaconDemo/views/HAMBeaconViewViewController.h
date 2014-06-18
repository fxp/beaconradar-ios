//
//  HAMBeaconViewViewController.h
//  BeaconDemo
//
//  Created by Dai Yue on 14-6-16.
//  Copyright (c) 2014年 MayLight Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLBeacon;

@interface HAMBeaconViewViewController : UIViewController
{}

- (NSString*)urlForBeacon;
- (void)showBeacon:(CLBeacon*)beacon urlForBeacon:(NSString*)urlForBeacon nameForBeacon:(NSString*)nameForBeacon;
- (void)hide;

@end
