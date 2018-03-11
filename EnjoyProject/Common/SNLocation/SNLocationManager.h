//
//  SNLocationManager.h
//  Enjoy
//
//  Created by  user on 2017/6/11.
//  Copyright © 2017年 高佳冰. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



typedef void(^UpdateLocationSuccessBlock) (CLLocation * location, CLPlacemark * placemark);
typedef void(^UpdateLocationErrorBlock) (CLRegion * region, NSError * error);

@interface SNLocationManager : NSObject

+ (instancetype)shareLocationManager;

/*
 * isAlwaysUse  是否后台定位 持续定位（NSLocationAlwaysUsageDescription）
 */
@property (nonatomic, assign) BOOL isAlwaysUse;
/*
 * isRealTime 是否实时定位
 */
@property (nonatomic, assign) BOOL isRealTime;
/*
 * 精度 默认 kCLLocationAccuracyKilometer
 */
@property (nonatomic, assign) CGFloat desiredAccuracy;
/*
 * 更新距离 默认1000米
 */
@property (nonatomic, assign) CGFloat distanceFilter;

//开始定位
- (void)startUpdatingLocationWithSuccess:(UpdateLocationSuccessBlock)success andFailure:(UpdateLocationErrorBlock)error;

@end
