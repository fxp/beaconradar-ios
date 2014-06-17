//
//  HAMBeaconViewViewController.m
//  BeaconDemo
//
//  Created by Dai Yue on 14-6-16.
//  Copyright (c) 2014年 MayLight Corp. All rights reserved.
//

#import "HAMBeaconViewViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "HAMConstants.h"

@interface HAMBeaconViewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) NSString *urlForBeacon;

@end

static const double kHAMBeaconAreaHeight = 398;

@implementation HAMBeaconViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showBeacon:(CLBeacon*)beacon urlForBeacon:(NSString*)urlForBeacon{
    self.view.hidden = NO;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1lf", beacon.accuracy];
    self.urlForBeacon = urlForBeacon;
    
    CGRect frame = self.view.frame;
    if (beacon.accuracy < 0 || beacon.accuracy > 10) {
        frame.origin.y = 0;
    }
    else{
        frame.origin.y = 0.1 * kHAMBeaconAreaHeight + 0.7 * kHAMBeaconAreaHeight * (10 - beacon.accuracy) / 10;
    }
    self.view.frame = frame;
}

- (void)hide{
    self.view.hidden = YES;
}

@end
