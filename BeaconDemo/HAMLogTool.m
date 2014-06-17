//
//  HAMLogTool.m
//  BeaconReceiver
//
//  Created by Dai Yue on 14-2-19.
//  Copyright (c) 2014年 Beacon Test Group. All rights reserved.
//

#import "HAMLogTool.h"

@implementation HAMLogTool

+(void)fatal:(NSString*)log{
    NSLog(@"FATAL - %@",log);
}

+(void)error:(NSString*)log{
    NSLog(@"ERROR - %@",log);
}

+(void)warn:(NSString*)log{
    NSLog(@"WARN - %@",log);
}

+(void)info:(NSString*)log{
    NSLog(@"INFO - %@",log);
}

+(void)debug:(NSString*)log{
    NSLog(@"DEBUG - %@",log);
}

+(void)trace:(NSString*)log{
    NSLog(@"TRACE - %@",log);
}

@end
