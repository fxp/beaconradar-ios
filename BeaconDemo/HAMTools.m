//
//  HAMTools.m
//  iosapp
//
//  Created by daiyue on 13-7-30.
//  Copyright (c) 2013年 Droplings. All rights reserved.
//

#import "HAMTools.h"
#import "HAMLogTool.h"
#import "Reachability.h"

#define COMMON_DATEFORMAT @"yyyy-MM-dd HH:mm:ss zzz"
#define JSON_DATEFORMAT @""

@implementation HAMTools

#pragma mark - Json Data Methods

+(void)setObject:(id)object toMutableArray:(NSMutableArray*)array atIndex:(int)pos
{
    long i;
    for (i = [array count]; i < pos; i++)
        [array addObject:[NSNull null]];
    [array setObject:object atIndexedSubscript:pos];
}

+(NSDictionary*)dictionaryFromJsonData:(NSData*)data
{
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    if (error)
        [HAMLogTool error:[NSString stringWithFormat:@"Json parse failed : %@", error]];
    
    return dic;
}

+(NSArray*)arrayFromJsonData:(NSData*)data
{
    NSError* error;
    NSArray* array = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:kNilOptions
                         error:&error];
    
    if (error)
        [HAMLogTool error:[NSString stringWithFormat:@"Json parse failed : %@", error]];
    
    return array;
}

+(NSNumber*)intNumberFromString:(NSString*)string{
    return [NSNumber numberWithInt:[string intValue]];
};

# pragma mark - NSDate Methods

+(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:COMMON_DATEFORMAT];
    
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)dateFromString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:COMMON_DATEFORMAT];
    
    return [dateFormatter dateFromString:dateString];
}

+(NSDate*)dateFromLongLong:(long long)msSince1970{
    return [NSDate dateWithTimeIntervalSince1970:msSince1970 / 1000];
}

+(long long)longLongFromDate:(NSDate*)date{
    return [date timeIntervalSince1970] * 1000;
}

+(Boolean)ifDateIsToday:(NSDate*)date{
    if (date == nil) {
        return false;
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    return [today isEqualToDate:otherDate];
}

#pragma mark - other Methods

+(Boolean) isWebAvailable {
    return ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] != NotReachable);
}

+(UIImage*)imageFromURL:(NSString *)urlString {
    if ([HAMTools isWebAvailable] == NO) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

+(UIImage*)image:(UIImage*)originalImage changeToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    originalImage = nil;
    return reSizeImage;
}

+(UIImage*)image:(UIImage*)originalImage changeToMaxSize:(CGSize)size {
    CGSize realSize;
    if (originalImage.size.height < size.height && originalImage.size.width < size.width) {
        return originalImage;
    }
    if (size.height / originalImage.size.height < size.width / originalImage.size.width) {
        realSize = CGSizeMake(originalImage.size.width * size.height / originalImage.size.height, size.height);
    } else {
        realSize = CGSizeMake(size.width, originalImage.size.height * size.width / originalImage.size.width);
    }
    UIGraphicsBeginImageContext(realSize);
    [originalImage drawInRect:CGRectMake(0, 0, realSize.width, realSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    originalImage = nil;
    return reSizeImage;
}

+(UIImage*)image:(UIImage*)originalImage changeToMinSize:(CGSize)size {
    CGSize realSize;
    if (size.height / originalImage.size.height > size.width / originalImage.size.width) {
        realSize = CGSizeMake(originalImage.size.width * size.height / originalImage.size.height, size.height);
    } else {
        realSize = CGSizeMake(size.width, originalImage.size.height * size.width / originalImage.size.width);
    }
    UIGraphicsBeginImageContext(realSize);
    [originalImage drawInRect:CGRectMake(0, 0, realSize.width, realSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    originalImage = nil;
    return reSizeImage;
}

+(UIImage*)image:(UIImage*)originalImage staysShapeChangeToSize:(CGSize)size {
    UIImage *resizedImage = [HAMTools image:originalImage changeToMinSize:size];
    CGRect newImageRect;
    if (resizedImage.size.width == size.width) {
        newImageRect = CGRectMake(0.0f, (resizedImage.size.height - size.height) / 2.0f, size.width, size.height);
    } else {
        newImageRect = CGRectMake((resizedImage.size.width - size.width) / 2.0f, 0.0f, size.width, size.height);
    }
    CGImageRef subImageRef = CGImageCreateWithImageInRect(resizedImage.CGImage, newImageRect);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, newImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    originalImage = nil;
    resizedImage = nil;
    
    return smallImage;
}

#pragma mark - View

+(void)showAlert:(NSString*)text title:(NSString*)title delegate:(id)target{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:text
                          delegate:target
                          cancelButtonTitle:@"返回"
                          otherButtonTitles:nil];
    [alert show];
}

+(void)showAlert:(NSString*)text title:(NSString*)title buttonTitle:(NSString*)buttonTitle delegate:(id)target{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:text
                          delegate:target
                          cancelButtonTitle:@"返回"
                          otherButtonTitles:buttonTitle,nil];
    [alert show];
}


@end