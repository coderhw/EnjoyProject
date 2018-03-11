//
//  TTContactViewController.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/8.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HHTimeTool : NSObject
//时间戳
+(NSString *)timeStr:(long long)timestamp;


/**
 设置一个时间间隔，返回是否大于该间隔

 @param beginTime 间隔
 @return 是否大于该间隔
 */
+(BOOL)isShowMsgTime:(NSString *)beginTime endTime:(NSString *)endTime;

+(BOOL)isShowMsgTime:(NSString *)StartTimeStamp endTimeStamp:(NSString *)endTimeStamp;

+(NSDate*)dateFromLongLong:(long long)msSince1970;
@end
