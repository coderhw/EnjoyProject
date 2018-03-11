//
//  HHVerityCodeViewController.m
//  EnjoyProject
//
//  Created by vanke on 2018/3/7.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import "HHVerityCodeViewController.h"
#import <AFNetworking.h>
#import "HHTabBarController.h"
#import "NSString+MD5Addition.h"


#define kMax 60

@interface HHVerityCodeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *verityButton;
@property (weak, nonatomic) IBOutlet UITextField *verityCodeTF;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int seconds;

//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
@end

@implementation HHVerityCodeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.titleStr = @"验证码校验";
    self.navigationController.navigationBarHidden = NO;
    self.navColor = [UIColor whiteColor];
    
    self.verityButton.layer.cornerRadius = 5.0f;
    self.verityButton.layer.masksToBounds = YES;
    
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    self.seconds = 60;
    [self.verityButton addTarget:self
                          action:@selector(verityButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                            selector:@selector(countDown)
                                            userInfo:nil repeats:YES];
    
    [self fetchVerityCode];
    
    [self.verityCodeTF becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)backButtonPressed:(UIButton *)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}


//获取验证码
- (void)fetchVerityCode {
    
    NSDictionary *params = @{@"weixinid":APPContext.weixinid};
    NSString *urlStr = [NSString stringWithFormat:@"%@fansfront_sendMacMsgApp.action",kHost];
    [self startCodeRequestWithParams:params url:urlStr complete:^(BOOL success, NSError *error, NSDictionary *result) {
        if(success){
            NSLog(@"获取验证码成功");
        }
    }];
    
}

//
- (void)verityButtonPressed:(UIButton *)sender {
    
    self.seconds = 60;

    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                            selector:@selector(countDown)
                                            userInfo:nil repeats:YES];
    
}

- (void)countDown {
    
    self.seconds --;
    NSString *title = [NSString stringWithFormat:@"%ds", self.seconds];
    [self.verityButton setTitle:title forState:UIControlStateNormal];
    self.verityButton.backgroundColor = [UIColor lightGrayColor];
    self.verityButton.enabled = NO;
    
    if(self.seconds <=0){
        self.verityButton.enabled = YES;
        self.verityButton.backgroundColor = [UIColor colorWithHex:@"#0095FF"];
        [self.verityButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    }
}

//提交
- (IBAction)submitButtonPressed:(id)sender {
    
    NSDictionary *params = @{@"verifyCode":self.verityCodeTF.text?self.verityCodeTF.text:@"",
                             @"weixinid":APPContext.weixinid};
    NSString *urlStr = [NSString stringWithFormat:@"%@fansfront_validatePartnerApp.action",kHost];
    [self startCodeRequestWithParams:params url:urlStr complete:^(BOOL success, NSError *error, NSDictionary *info) {
        
        if(success == YES){
            NSLog(@"验证码校验成功");
            [self bindDeviceUUIDwithWeixinStr:APPContext.weixinid];
        }else{
            //登录失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"验证码错误,请重试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                             }];
            [alert addAction:okaction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
}

//绑定设备
- (void)bindDeviceUUIDwithWeixinStr:(NSString *)weixin {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"请稍后";
    NSDictionary *parmas = @{@"deviceId":[self.accountNum stringFromMD5],@"weixinid":weixin};
    NSString *urlStr = [NSString stringWithFormat:@"%@login/login!bindAppMac.action",kHost];
    
    [self startRequestWithParams:parmas url:urlStr complete:^(BOOL success, NSError *error, NSDictionary *info) {
        [hud hide:YES];
        if(success == YES){
            NSLog(@"绑定成功");
            //这里请求成功才绑定
            [[NSUserDefaults standardUserDefaults] setObject:APPContext.weixinid forKey:@"LocalFlag"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                HHTabBarController  *rootVC = [[HHTabBarController alloc] init];
                [[[[UIApplication sharedApplication] delegate] window] setRootViewController:rootVC];
                APPContext.tabBar = rootVC;
            });
        }else{
            //登录失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"系统错误, 请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                             }];
            [alert addAction:okaction];
            [self presentViewController:alert animated:YES completion:nil];
        }
       
    }];
    
}

#pragma mark - Request
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


//只用来获取验证码和校验验证码
- (void)startCodeRequestWithParams:(NSDictionary *)params url:(NSString *)url
                      complete:(void (^)(BOOL success, NSError *error, NSDictionary *result))completeBlock {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject%@",responseObject);
        if([responseObject[@"status"] isEqualToString:@"success"]){
            completeBlock(YES, nil, responseObject);
        }else{
            completeBlock(NO, nil, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error){
            completeBlock(NO, error, nil);
            NSLog(@"error%@",error);
        }
    }];
}

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //这是一张“<”的图片，可以让美工给切一张
        UIImage *image = [UIImage imageNamed:@"返回按钮"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //字体的多少为btn的大小
        [btn sizeToFit];
        //左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //让返回按钮内容继续向左边偏移15，如果不设置的话，就会发现返回按钮离屏幕的左边的距离有点儿大，不美观
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}


@end
