//
//  HAMWebTool.h
//  iosapp
//
//  Created by daiyue on 13-8-9.
//  Copyright (c) 2013年 Droplings. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff; \
        _Pragma("clang diagnostic pop") \
    } while (0)

@interface HAMWebTool : NSObject <NSURLConnectionDelegate>
{
    NSString* url;
    NSMutableData* receivedData;
    id handle;
    SEL callback;
}

+ (void)fetchDataFromUrl:(NSString*)url sel:(SEL)callback handle:(id)handle;

@end
