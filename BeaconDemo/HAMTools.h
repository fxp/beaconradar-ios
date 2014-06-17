//
//  HAMTools.h
//  iosapp
//
//  Created by daiyue on 13-7-30.
//  Copyright (c) 2013年 Droplings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAMTools : NSObject
{}

+(void)setObject:(id)object toMutableArray:(NSMutableArray*)array atIndex:(int)pos;

+(NSDictionary*)dictionaryFromJsonData:(NSData*)data;
+(NSArray*)arrayFromJsonData:(NSData*)data;

+(NSNumber*)intNumberFromString:(NSString*)string;

+(NSString*)stringFromDate:(NSDate*)date;
+(NSDate*)dateFromString:(NSString*)dateString;
+(NSDate*)dateFromLongLong:(long long)msSince1970;
+(long long)longLongFromDate:(NSDate*)date;
+(Boolean)ifDateIsToday:(NSDate*)date;

+(Boolean)isWebAvailable;
+(UIImage*)imageFromURL:(NSString*)urlString;
+(UIImage*)image:(UIImage*)originalImage changeToSize:(CGSize)size;
+(UIImage*)image:(UIImage*)originalImage changeToMaxSize:(CGSize)size;
+(UIImage*)image:(UIImage*)originalImage changeToMinSize:(CGSize)size;
+(UIImage*)image:(UIImage*)originalImage staysShapeChangeToSize:(CGSize)size;

+(void)showAlert:(NSString*)text title:(NSString*)title delegate:(id)target;
+(void)showAlert:(NSString*)text title:(NSString*)title buttonTitle:(NSString*)buttonTitle delegate:(id)target;

@end
