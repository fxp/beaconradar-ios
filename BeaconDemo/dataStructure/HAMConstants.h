//
//  HAMConstants.h
//  BeaconDemo
//
//  Created by Dai Yue on 14-6-16.
//  Copyright (c) 2014年 MayLight Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

//the time inteval for view to fetch beacon data from beaconManager. In seconds
static const double kHAMRefreshViewTimeInteval = 1.0f;
//max number of beaconView. Currently must <= 3
static const int kHAMMaxBeaconViewNum = 3;

//model view's present and dismiss animation duration time. In seconds
static const double kHAMModelAnimationDuration = 0.8f;
//model view's dimmed background alpha. Must be >=0 and <=1, 0 being completely transparent and 1 being non-transparent black.
static const double kHAMModelDimBackgroundAlpha = 0.5f;

@interface HAMConstants : NSObject

@end
