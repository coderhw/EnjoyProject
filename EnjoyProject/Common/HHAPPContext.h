//
//  VKUserInfo.h
//  MeiFang
//
//  Created by Evan on 2017/3/17.
//  Copyright © 2017年 Vanke.com All rights reserved.
//
/*
 * * 放置App信息eg:是否版本更新，是否已经登录......
 */

#import <Foundation/Foundation.h>
#import "HHTabBarController.h"


@interface HHAPPContext : NSObject


@property (nonatomic) BOOL isLogin;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *weixinid;
@property (nonatomic, strong) NSString *headimgurl; //用户头像
@property (nonatomic, copy) NSString *userName; //用户姓名
@property (nonatomic, strong) HHTabBarController *tabBar;
@property (nonatomic, assign) int notReadCount;
+ (instancetype)sharedAppContext;

@end




