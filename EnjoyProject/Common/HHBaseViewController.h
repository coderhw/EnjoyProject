//
//  VKBaseViewController.h
//  VKProject
//
//  Created by Evan on 16/8/29.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>


typedef void(^BackButtonClickBlock)(void);

@interface HHBaseViewController : UIViewController

@property (nonatomic, assign) BOOL hideNavBar;//是否隐藏导航栏
@property (nonatomic, assign) BOOL hideBackButton; //是否隐藏返回按钮
@property (nonatomic, copy) BackButtonClickBlock backButtonClickBlock; //返回按钮回调
@property (nonatomic, copy) NSString *titleStr; //导航栏标题
@property (nonatomic, strong) UIColor *navColor; //导航栏颜色
@property (nonatomic, strong) UIColor *titleColor; //导航栏字体颜色
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, copy) NSString *url; //H5地址

@end

