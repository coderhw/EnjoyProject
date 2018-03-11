//
//  VKTabBarController.m
//  VKTabBarDemo
//
//  Created by Evan on 2017/2/7.
//  Copyright © 2017年 Vanke.com All rights reserved.
//

#import "HHTabBarController.h"
#import "HHMessageController.h"
#import "HHQRCodetController.h"
#import "HHWorkViewController.h"
#import "HHMeViewController.h"


@interface HHTabBarController ()

@property (nonatomic, strong) UILabel *redDotLabel;

@end

@implementation HHTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self authenticatedControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.translucent = NO;
    
    //UI
    CGRect rect = CGRectMake(0, 0, APP_WIDH, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[UIColor lightGrayColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundColor:[UIColor redColor]];
    [[UITabBar appearance] setShadowImage:img];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],
                                                        NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],
                                                        NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
}


- (void)authenticatedControllers {
    
    //消息
    HHMessageController *msgVC = [[HHMessageController alloc] initWithNibName:@"HHMessageController" bundle:nil];
    UINavigationController *msgNav = [[UINavigationController alloc] initWithRootViewController:msgVC];
    msgNav.tabBarItem = [self itemWithNormal:NSLocalizedString(@"消息", @"")
                                       nomalImage:@"msg"
                                         selected:@"msg_selected"];
    
    
    //工作台
    HHWorkViewController *workVC = [[HHWorkViewController alloc] initWithNibName:@"HHWorkViewController" bundle:nil];
    UINavigationController *workNav = [[UINavigationController alloc] initWithRootViewController:workVC];
    workNav.tabBarItem = [self itemWithNormal:NSLocalizedString(@"工作台", @"")
                                  nomalImage:@"work"
                                    selected:@"work_selected"];
    
    
    //二维码
    HHQRCodetController *qrCodeVC = [[HHQRCodetController alloc] initWithNibName:@"HHQRCodetController" bundle:nil];
    UINavigationController *qrNav = [[UINavigationController alloc] initWithRootViewController:qrCodeVC];
    qrNav.tabBarItem = [self itemWithNormal:NSLocalizedString(@"二维码", @"")
                                  nomalImage:@"code"
                                    selected:@"code_selected"];
    
    //我的
    HHMeViewController *meVC = [[HHMeViewController alloc] initWithNibName:@"HHMeViewController" bundle:nil];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meVC];
    meNav.tabBarItem = [self itemWithNormal:NSLocalizedString(@"我的", @"")
                                  nomalImage:@"me"
                                    selected:@"me_selected"];
    
    self.viewControllers = @[msgNav,workNav,qrNav,meNav];
    self.selectedIndex = 0;
    
    [self.tabBar addSubview:self.redDotLabel];
}

- (UILabel *)redDotLabel {
   
    if(!_redDotLabel){
        
        _redDotLabel = [[UILabel alloc] initWithFrame:CGRectMake(APP_WIDH/4*0.5+5, 0, 25, 25)];
        _redDotLabel.layer.cornerRadius =  12.5;
        _redDotLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _redDotLabel.layer.borderWidth = 2.0f;
        _redDotLabel.font = FONT(12);
        _redDotLabel.layer.masksToBounds = YES;
        _redDotLabel.backgroundColor = [UIColor redColor];
        _redDotLabel.textColor = [UIColor whiteColor];
        _redDotLabel.textAlignment = NSTextAlignmentCenter;
        _redDotLabel.hidden = YES;
    }
    return _redDotLabel;
}


- (UITabBarItem *)itemWithNormal:(NSString *)title nomalImage:(NSString *)normalName selected:(NSString *)selectedName {
    
    UIImage *normal = [[UIImage imageNamed:normalName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selected = [[UIImage imageNamed:selectedName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(title, @"") image:normal selectedImage:selected];
    NSDictionary *normalTitleAttributs = @{NSForegroundColorAttributeName:[UIColor grayColor]};
    NSDictionary *selectTitleAttribute = @{NSForegroundColorAttributeName:RGB(245, 180, 63)};
    [item setTitleTextAttributes:normalTitleAttributs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectTitleAttribute forState:UIControlStateSelected];
    return item;
}

- (void)setBage:(NSString *)bageCount {
    self.redDotLabel.text = bageCount;
    if([bageCount intValue] <= 0){
        self.redDotLabel.hidden = YES;
    }else{
        self.redDotLabel.hidden = NO;

    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //暂时不作处理，后面可用来埋点
}


@end
