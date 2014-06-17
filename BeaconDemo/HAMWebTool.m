//
//  HAMWebTool.m
//  iosapp
//
//  Created by daiyue on 13-8-9.
//  Copyright (c) 2013年 Droplings. All rights reserved.
//

#import "HAMWebTool.h"
#import "HAMLogTool.h"

@implementation HAMWebTool

-(id)init
{
    if (self = [super init])
    {
    }
    return self;
}

#pragma mark - Get Data Methods

+ (void)fetchDataFromUrl:(NSString*)url_ sel:(SEL)callback_ handle:(id)handle_{
    HAMWebTool* connection = [[HAMWebTool alloc] init];
    [connection fetchDataFromUrl:url_ sel:callback_ handle:handle_];
}

-(void)fetchDataFromUrl:(NSString*)url_ sel:(SEL)callback_ handle:(id)handle_
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    url = url_;
    callback = callback_;
    handle = handle_;
    
    receivedData = [NSMutableData data];
    
    //FIXME: has no @autoreleasepool
    
//    [NSThread detachNewThreadSelector:@selector(startConnection) toTarget:self withObject:nil];
    [self performSelectorOnMainThread:@selector(startConnection) withObject:nil waitUntilDone:NO];
//    [self performSelectorInBackground:@selector(startConnection) withObject:nil];
}

#pragma mark - Connection Methods

-(void)startConnection
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:50];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [HAMLogTool error: [NSString stringWithFormat: @"Get data from URL failed : %@", error]];
	SuppressPerformSelectorLeakWarning(
        [handle performSelector:callback withObject:nil withObject:error];
    );
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([handle respondsToSelector:callback]){
        SuppressPerformSelectorLeakWarning(
            [handle performSelector:callback withObject:receivedData];
        );
    }
	else
        [HAMLogTool error:@"Callback failed after getting data from URL!"];
}

@end
