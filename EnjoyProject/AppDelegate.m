//
//  AppDelegate.m
//  EnjoyProject
//
//  Created by vanke on 2018/3/2.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import "AppDelegate.h"
#import "HHTabBarController.h"
#import "HHLoginViewController.h"
// 引入JPush功能所需头文件
#import <JPUSHService.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

//message model
#import "HHMessageModel.h"
#import "HHTimeTool.h"
#import "SNLocationManager.h"

@interface AppDelegate ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
//    HHTabBarController  *rootVC = [[HHTabBarController alloc] init];
//    self.window.rootViewController = rootVC;
    
    HHLoginViewController *loginVC = [[HHLoginViewController alloc] initWithNibName:@"HHLoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];

    
    self.window.rootViewController = nav;
   
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"31c2b8878d61321d8666385d"
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    
    [[SNLocationManager shareLocationManager] startUpdatingLocationWithSuccess:^(CLLocation *location, CLPlacemark *placemark) {
        
    } andFailure:^(CLRegion *region, NSError *error) {
        NSLog(@"  错误！！！！ %@  ",error);
        
    }];
    
     [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].applicationIconBadgeNumber = APPContext.notReadCount;
    });
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kMessageUpdateNotification" object:nil];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    //服务端传递的Extras附加字段，key是自己定义的
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    UILocalNotification* localNoti = [[UILocalNotification alloc]init];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    localNoti.fireDate = date;
    localNoti.alertBody =   userInfo[@"content"];
    localNoti.userInfo = userInfo;
    localNoti.applicationIconBadgeNumber = 0;
    
    UIApplication* app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:localNoti];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0){
        [JPUSHService handleRemoteNotification:userInfo];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS10以下版本  程序在后台或者关闭都在这个方法处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge++;
        //程序当前正处于前台
        if (application.applicationState == UIApplicationStateActive) {
            [self handlePushInfo:userInfo];
        }else if (application.applicationState == UIApplicationStateInactive) {
            //程序处于后台
            NSLog(@"notifi---userInfo---%@",userInfo);
            [self handlePushInfo:userInfo];
        } else if (application.applicationState == UIApplicationStateBackground){
            [self handlePushInfo:userInfo];

        }
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

//前台收到推送消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
        willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    //Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self handlePushInfo:userInfo];
    NSLog(@"前台收到消息");
    NSLog(@"=======%@",userInfo);
}

// iOS 10 Support
//应用关闭或者后台得到推送信息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
 didReceiveNotificationResponse:(UNNotificationResponse *)response
          withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"=======%@",userInfo);
    [self handlePushInfo:userInfo];
    NSLog(@"后台收到消息");
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"notify---%@",response);
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
    completionHandler();
}




//处理推送消息
- (void)handlePushInfo:(NSDictionary *)info {
    
    //本地化消息
    HHMessageModel *msgModel = [[HHMessageModel alloc] init];
    
    if([info.allKeys containsObject:@"aps"]){
        NSString *type = [NSString stringWithFormat:@"%@", info[@"transType"]];
        msgModel.transType = type;
        msgModel.msgTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000];
        msgModel.content = info[@"aps"][@"alert"];
        if([type intValue] == 0){
            msgModel.headName = info[@"headName"];
            msgModel.headImage = info[@"headImage"];
            
        }
        msgModel.linkUrl = info[@"linkUrl"];
        [msgModel save];
    }

    if([info.allKeys containsObject:@"extras"]){
        NSString *content = info[@"content"];
        NSString *transType = info[@"extras"][@"transType"];
        NSString *headImage = nil;
        NSString *headName = nil;
        NSString *linkUrl = info[@"extras"][@"linkUrl"];
        if([transType intValue] == 0){
            headImage = info[@"extras"][@"headImage"];
            headName = info[@"extras"][@"headName"];
        }
        
        msgModel.content = content;
        msgModel.transType = transType;
        msgModel.headImage = headImage;
        msgModel.headName = headName;
        msgModel.linkUrl = linkUrl;
        msgModel.msgTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000];
        msgModel.isNotRead = @"1";
        [msgModel save];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kMessageUpdateNotification" object:nil];
}


@end
