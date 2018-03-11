//
//  TTContactViewController.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/8.
//  Copyright © 2016年 Vanke.com All rights reserved.
//

#import "HHTimeTool.h"

@implementation HHTimeTool

+(NSString *)timeStr:(long long)timestamp{
    //返回时间格式
   
    
    //currentDate 2015-09-28 16:28:09 +0000
    //msgDate 2015-09-28 10:36:22 +0000
    NSCalendar   *calendar = [NSCalendar currentCalendar];
    //1.获取当前的时间
    NSDate *currentDate = [NSDate date];

    // 获取年，月，日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
//    NSLog(@"currentYear %ld",components.year);
//    NSLog(@"currentMonth %ld",components.month);
//    NSLog(@"currentDay %ld",components.day);
    
    
    //2.获取消息发送时间
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    // 获取年，月，日
    components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYead = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
//    NSLog(@"msgYear %ld",components.year);
//    NSLog(@"msgMonth %ld",components.month);
//    NSLog(@"msgDay %ld",components.day);
    
    
    //3.判断:
    /*今天：(HH:mm)
     *昨天: (昨天 HH:mm)
     *昨天以前:（2015-09-26 15:27）
     */
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYead
        && currentMonth == msgMonth
        && currentDay == msgDay) {//今天
        dateFmt.dateFormat= @"HH:mm";
    }else if(currentYear == msgYead
             && currentMonth == msgMonth
             && currentDay - 1 == msgDay){//昨天
        dateFmt.dateFormat= @"昨天 HH:mm";
    }else{//昨天以前
        dateFmt.dateFormat= @"MM-dd HH:mm";
    }
    
    
    return [dateFmt stringFromDate:msgDate];
}

+(BOOL)isShowMsgTime:(NSString *)beginTime endTime:(NSString *)endTime{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beginD=[dateFormatter dateFromString:beginTime];
    NSDate *endD=[dateFormatter dateFromString:endTime];
    NSTimeInterval value=[endD timeIntervalSinceDate:beginD];
    //如果时间大于5分钟，5*60秒，则显示时间
    
    if (fabs(value) > 5*60) {
        return YES;
    }else {
        return NO;
    }
}

+(NSDate*)dateFromLongLong:(long long)msSince1970{
    return [NSDate dateWithTimeIntervalSince1970:msSince1970 / 1000];
}

+(BOOL)isShowMsgTime:(NSString *)startTimeStamp endTimeStamp:(NSString *)endTimeStamp {

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    
    NSDate *startDate = [formatter dateFromString:startTimeStamp];
    NSDate *endDate = [formatter dateFromString:endTimeStamp];
    NSTimeInterval value=[startDate timeIntervalSinceDate:endDate];
    if (value>5*60) {
        return true;
        
    }else {
        return NO;
    }
}


@end
