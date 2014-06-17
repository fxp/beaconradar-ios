//
//  HAMLogTool.h
//  BeaconReceiver
//
//  Created by Dai Yue on 14-2-19.
//  Copyright (c) 2014年 Beacon Test Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAMLogTool : NSObject

//记录影响系统正常运行，可能导致系统崩溃的事件
+(void)fatal:(NSString*)log;
//记录影响业务流程正常进行，导致业务流程提前终止的事件
+(void)error:(NSString*)log;
//记录未预料到，可能导致业务流程无法进行的事件
+(void)warn:(NSString*)log;
//记录系统启动/停止，模块加载/卸载之类事件
+(void)info:(NSString*)log;
//记录业务详细流程，用户鉴权/业务流程选择/数据存取事件
+(void)debug:(NSString*)log;
//记录系统进出消息，码流信息
+(void)trace:(NSString*)log;

@end
