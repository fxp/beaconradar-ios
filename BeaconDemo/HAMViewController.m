//
//  HAMViewController.m
//  BeaconDemo
//
//  Created by Dai Yue on 14-6-16.
//  Copyright (c) 2014年 MayLight Corp. All rights reserved.
//

#import "HAMViewController.h"

#import "HAMBeaconViewViewController.h"
#import "HAMWebViewController.h"
#import "UserDataTapGestureRecognizer.h"

#import "HAMBeaconManager.h"
#import "HAMAVOSManager.h"

#import "HAMConstants.h"
#import "HAMTools.h"

@interface HAMViewController () {
    Class popoverClass;
}

@property(weak, nonatomic) IBOutlet UIView *beaconAreaView;
@property NSArray *beaconViewControllerArray;

@property CLBeacon *currentBeacon;

@property(weak, nonatomic) IBOutlet UIView *modelBackgroundView;
@property(weak, nonatomic) IBOutlet UIWebView *modelView;

@property NSTimer *refreshTimer;
@end

static NSArray *beaconViewFrameXArray;


@implementation HAMViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    beaconViewFrameXArray = @[@127, @27, @227];

    //init beacon views
    NSMutableArray *beaconViewControllerMutableArray = [NSMutableArray array];
    for (int i = 0; i < kHAMMaxBeaconViewNum; i++) {
        //init view controller
        HAMBeaconViewViewController *viewController = [[HAMBeaconViewViewController alloc] initWithNibName:@"HAMBeaconViewViewController" bundle:nil];
        [beaconViewControllerMutableArray addObject:viewController];

        //position view
        UIView *beaconView = viewController.view;
        CGRect frame = beaconView.frame;
        frame.origin.x = [beaconViewFrameXArray[i] doubleValue];
        frame.origin.y = 0.0f;
        beaconView.frame = frame;

        [self.beaconAreaView addSubview:beaconView];
        beaconView.hidden = YES;

    }
    self.beaconViewControllerArray = [NSArray arrayWithArray:beaconViewControllerMutableArray];

    //init model
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModalView)];
    [self.modelBackgroundView addGestureRecognizer:tapGesture];
    self.modelBackgroundView.alpha = 0.0f;
    self.modelBackgroundView.hidden = YES;
    self.modelView.hidden = YES;

    //init refresh timer
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:kHAMRefreshViewTimeInteval target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
    [self.refreshTimer fire];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.refreshTimer setFireDate:[NSDate date]];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (bool)isPresenting:(CLBeacon *)beacon {
    if (self.currentBeacon == nil) {
        return false;
    }
    if (beacon) {
        if ([beacon.proximityUUID isEqual:self.currentBeacon.proximityUUID] &&
                [beacon.major isEqual:self.currentBeacon.major] &&
                [beacon.minor isEqual:self.currentBeacon.minor]) {
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}

#pragma mark - View

- (void)refreshView {
    NSArray *beaconArray = [HAMBeaconManager beaconArray];
    if (beaconArray == nil || beaconArray.count == 0) {
        return;
    }


    int i;
    for (i = 0; i < kHAMMaxBeaconViewNum && i < beaconArray.count; i++) {
        CLBeacon *beacon = beaconArray[i];

        //show beacon view
        HAMBeaconViewViewController *beaconViewVC = self.beaconViewControllerArray[i];
        NSString *urlForBeacon = [HAMAVOSManager urlOfBeacon:beacon];
        NSString *nameForBeacon = [HAMAVOSManager nameOfBeacon:beacon];
        double rangeIn = [HAMAVOSManager rangeOfBeacon:beacon];
        double rangeOut = [HAMAVOSManager rangeOutOfBeacon:beacon];
        [beaconViewVC showBeacon:beacon urlForBeacon:urlForBeacon nameForBeacon:nameForBeacon];

        NSLog(@"Beacon %@,%@,%@,%f,%f", beacon.proximityUUID, beacon.major, beacon.minor, rangeIn, rangeOut);

        UserDataTapGestureRecognizer *singleTap = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        singleTap.numberOfTapsRequired = 2;
        beaconViewVC.view.userInteractionEnabled = YES;
        [beaconViewVC.view addGestureRecognizer:singleTap];
        singleTap.userData = urlForBeacon;

        //alert
        if (beacon.accuracy < rangeIn && beacon.accuracy != -1) {
//            [HAMTools showAlert:@"Beacon在范围内" title:@"Look out！" delegate:self];
//            [self.refreshTimer setFireDate:[NSDate distantFuture]];
            self.currentBeacon = beacon;
            [self presentWebViewWithURL:[HAMAVOSManager urlOfBeacon:beacon]];
        }
        if (beacon.accuracy != -1 && beacon.accuracy > rangeOut && rangeOut != -1 && [self isPresenting:beacon]) {
            NSLog(@"dismissModalView");
            [self dismissModalView];
        }
    }

    for (; i < kHAMMaxBeaconViewNum; i++) {
        HAMBeaconViewViewController *beaconViewVC = self.beaconViewControllerArray[i];
        [beaconViewVC hide];
    }
}

- (void)tapDetected:(id)sender {
    UserDataTapGestureRecognizer *tap = (UserDataTapGestureRecognizer *) sender;
//    [self.refreshTimer setFireDate:[NSDate distantFuture]];
    [self presentWebViewWithURL:tap.userData];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.refreshTimer setFireDate:[NSDate date]];
}

#pragma mark - Present Web View

- (void)presentWebViewWithURL:(NSString *)urlString {
    if (self.modelView.hidden == NO) {
        return;
    }
    self.modelView.hidden = NO;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.modelView loadRequest:request];

    [self showModelView];
}

- (void)showModelView {
    self.modelBackgroundView.hidden = NO;

    [UIView beginAnimations:@"presentModel" context:nil];
    [UIView setAnimationDuration:kHAMModelAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    //background
    self.modelBackgroundView.alpha = kHAMModelDimBackgroundAlpha;

    //model view
    CGRect frame = self.modelView.frame;
    frame.origin.y = 100;
    self.modelView.frame = frame;

    [UIView commitAnimations];
}

- (void)dismissModalView {
    [UIView animateWithDuration:kHAMModelAnimationDuration animations:^(void) {
        //background
        self.modelBackgroundView.alpha = 0.0f;

        //model view
        CGRect frame = self.modelView.frame;
        frame.origin.y = 568;
        self.modelView.frame = frame;
    }                completion:^(BOOL finished) {
        self.modelBackgroundView.hidden = YES;
        self.modelView.hidden = YES;
        [self.refreshTimer setFireDate:[NSDate date]];
        self.currentBeacon = nil;
    }];
}

@end
