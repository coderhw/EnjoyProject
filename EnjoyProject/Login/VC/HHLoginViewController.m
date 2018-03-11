//
//  HHLoginViewController.m
//  EnjoyProject
//
//  Created by vanke on 2018/3/2.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import "HHLoginViewController.h"
#import <AFNetworking.h>
#import "HHTabBarController.h"
#import "HHVerityCodeViewController.h"
#import "NSString+MD5Addition.h"

@interface HHLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIImageView *LogoImage;


@end

@implementation HHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTextfield];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (LocalFlagGET) {

        APPContext.weixinid = LocalFlagGET;
        HHTabBarController *tabbarVC = [[HHTabBarController alloc] init];
        APPContext.tabBar = tabbarVC;
        [self presentViewController:tabbarVC animated:NO completion:nil];
    };
}

#pragma mark - UI

- (void)configTextfield {
    
    
    UIImage *accountLeftImg = [UIImage imageNamed:@"g02"];
    self.accountTF.leftView = [[UIImageView alloc] initWithImage:accountLeftImg];
    self.accountTF.leftViewMode = UITextFieldViewModeAlways;

    UIImage *pwdRightImg = [UIImage imageNamed:@"g03"];
    self.passwordTF.leftView = [[UIImageView alloc] initWithImage:pwdRightImg];
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTF.secureTextEntry = YES;

    
    //test
#ifdef DEBUG
    self.accountTF.text = @"15820437839";
    self.passwordTF.text = @"15820437839";
#endif
}


- (IBAction)loginAction:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"请稍后";

    NSString *account = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    
    NSDictionary *parmas = @{@"loginName":account?account:@"15820437839",
                             @"password":password?password:@"15820437839",
                             @"deviceId":[account stringFromMD5]
                             };
    NSString *urlStr = [NSString stringWithFormat:@"%@login/login!loginApp.action",kHost];
    [self startRequestWithParams:parmas url:urlStr complete:^(BOOL success, NSError *error, NSDictionary *info) {
        
        [hud hide:YES];
        APPContext.weixinid = info[@"weixinid"];
        
        if(success){
           
            if([info[@"needDeviceId"] isEqualToString:@"true"]){
                //调取绑定设备接口
                APPContext.weixinid = info[@"weixinid"];
                HHVerityCodeViewController *verityVC = [[HHVerityCodeViewController alloc] init];
                verityVC.accountNum = self.accountTF.text;
                [self.navigationController pushViewController:verityVC animated:YES];
                
            }else{
                //调到主页
                NSLog(@"//调到主页");
                //这里请求成功才绑定
                [[NSUserDefaults standardUserDefaults] setObject:APPContext.weixinid forKey:@"LocalFlag"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                HHTabBarController *tabbarVC = [[HHTabBarController alloc] init];
                [self presentViewController:tabbarVC animated:NO completion:nil];
            }
        }else{
            
            //登录失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"用户名或密码错误!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:okaction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
}


//稍微封装下，后续都用这个
- (void)startRequestWithParams:(NSDictionary *)params url:(NSString *)url
                      complete:(void (^)(BOOL success, NSError *error, NSDictionary *result))completeBlock {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject%@",responseObject);
        if([responseObject[@"state"] isEqualToString:@"success"]){
            completeBlock(YES, nil, responseObject);
        }else{
            completeBlock(NO, nil, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(NO, error, nil);
        NSLog(@"error%@",error);
    }];
}



@end
