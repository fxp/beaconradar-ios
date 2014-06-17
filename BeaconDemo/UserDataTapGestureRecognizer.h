//
//  UserDataTapGestureRecognizer.h
//  BeaconDemo
//
//  Created by FengXiaoping on 6/17/14.
//  Copyright (c) 2014 MayLight Corp. All rights reserved.
//

#ifndef BeaconDemo_UserDataTapGestureRecognizer_h
#define BeaconDemo_UserDataTapGestureRecognizer_h

#import <Foundation/Foundation.h>

@interface UserDataTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, strong) NSString* userData;
@end

@implementation UserDataTapGestureRecognizer
@end

#endif
