//
//  VKUtilsDefineHeader.h
//  MeiFang
//
//  Created by Evan on 2017/3/14.
//  Copyright © 2017年 Vanke.com All rights reserved.
//
//主要放置一些方便开发的宏

#ifndef VKUtilsDefineHeader_h
#define VKUtilsDefineHeader_h

#define APPContext          [HHAPPContext sharedAppContext]


#define KLOIGN_KEY @"HHEnjoyProject"

#define kDATETIME_FORMATTER     @"yyyy-MM-dd HH:mm:ss"
#define kDATE_FORMATTER         @"yyyy-MM-dd"
#define kTIME_FORMATTER         @"HH:mm:ss"
#define kTime_DayEnd            @"23:59:59"

#define ENV_DEBUG_OLD  1
#define kNEED_ENCRYPT 0
#define kWILL_HOUSE_COUNT   3

//UI
#define iOS_ge_7        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)
#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define APP_WIDH        CGRectGetWidth([[UIScreen mainScreen] bounds])
#define APP_HIGH        CGRectGetHeight([[UIScreen mainScreen] bounds])
#define APP_NAV_HIGH    CGRectGetHeight([[UIScreen mainScreen] bounds])
#define FONT(a)             [UIFont systemFontOfSize:a]
#define BFONT(a)            [UIFont boldSystemFontOfSize:a]
#define kFONT(a,b)          [UIFont fontWithName:a size:b]
#define kView_W(View) (View.frame.origin.x + View.bounds.size.width)
#define kView_H(View) (View.frame.origin.y + View.bounds.size.height)
#define kViewW(View) View.bounds.size.width
#define kViewH(View) View.bounds.size.height
#define kViewOriginY(View) View.frame.origin.y
#define kViewOriginX(View) View.frame.origin.x
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kBaseScreenW 375
#define kBaseScale kScreenWidth*1.0/kBaseScreenW
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kIMAGE(IMAGE_NAME) [UIImage imageNamed:IMAGE_NAME]
#define kSystemFontSize(value) [UIFont systemFontOfSize:value]
#define kBodyFontSize(value) [UIFont boldSystemFontOfSize:value]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define RBG(a,b,c) [[UIColor alloc] initWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]

#define UUID [[UIDevice currentDevice].identifierForVendor UUIDString]
#define LocalFlagSET(weixinid) [[NSUserDefaults standardUserDefaults]setObject:weixin forKey:@"LocalFlag"]
#define LocalFlagGET [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalFlag"]


#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"VKSearchhistories.plist"]
#define VKError(domain,errorMsg) [NSError errorWithDomain:domain code:-1 userInfo:@{@"errorMsg":errorMsg}]
#define SAFE_STRING(str) (![str isKindOfClass: [NSString class]] ? @"" : str)
#define SAFE_ARRAY(value) (![value isKindOfClass: [NSArray class]] ? [NSArray array] : value)
#define SAFE_NUMBER(value) ([value isKindOfClass: [NSNumber class]] ? value : @(-1))

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


#define kBarColor [UIColor colorWithHex:@"32c87d"]

//#define kHost @"http://zxtnet.ittun.com/"

#define kHost @"http://lx.zxtnet.com/"

#endif /* VKUtilsDefineHeader_h */





