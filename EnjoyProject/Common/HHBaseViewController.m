//
//  TTBaseViewController.m
//  TTProject
//
//  Created by Evan on 16/8/29.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "HHBaseViewController.h"
#import "UIColor+Util.h"

#import <AVFoundation/AVFoundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "WKWebViewJavascriptBridge.h"
#import "SNLocationManager.h"
#import <MessageUI/MessageUI.h>
#import "JPUSHService.h"
#import "HHQRCodetController.h"
#import "HHLoginViewController.h"


#define kTextColor_6  @"#666666"    //灰色
#define kTitleName_PingFang_M @"PingFang-SC-Medium"


@interface HHBaseViewController ()<UINavigationControllerDelegate>
{
    NSString* str1;//通讯录
    NSString* latitude;
    NSString* Longitude;
    NSString* SYSStr;
}


@property (nonatomic, strong) UIButton  *backButton;
@property (nonatomic, strong) UIImageView *shadowImage;
@property (nonatomic, strong) UILabel   *titleLabel;
@property WKWebViewJavascriptBridge *webViewBridge;
@property (strong, nonatomic)WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;


//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end

@implementation HHBaseViewController

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(self.navigationController.viewControllers.count == 1) {
        if(_backButton){
            [_backButton removeFromSuperview];
            _backButton = nil;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initBackButton];
}

static NSInteger seq = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self.navigationItem.backBarButtonItem setCustomView:[UIView new]];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    if (self.url) {
        [self loadWebData];
        _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
        [_webViewBridge setWebViewDelegate:self];
        
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
        
        //注册js调用方法
        [self registerNativeFunctions];
        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 2)];
        self.progressView.backgroundColor = [UIColor blueColor];
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:self.progressView];
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)loadWebData
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 0;
    configuration.preferences = preferences;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,20)];
    label.backgroundColor = [UIColor colorWithRed:0.137 green:0.306 blue:0.471 alpha:1.00];
    [self.view addSubview:label];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,64,self.view.frame.size.width, self.view.frame.size.height-64) configuration:configuration];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
}

- (void)initBackButton {
    if([self.navigationController.viewControllers count] == 2){
        [self.navigationController.navigationBar addSubview:self.backButton];
    }
}


- (void)configNavigationBar {
    
    //改变状态栏颜色 导航栏字体 颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:33/255.0 green:77/255.0 blue:122/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:kTextColor_6],
                              NSFontAttributeName:kFONT(kTitleName_PingFang_M, 18)}];
    
    self.titleLabel.text = self.titleStr;
    self.navigationItem.titleView = self.titleLabel;
    
    // 隐藏导航栏下方的线
    [self hideBottomLineOnNavBar];
    
}

- (void)backButtonPressed:(UIButton *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeNative{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter/Setter
- (UIButton *)backButton {
    
    if(!_backButton) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 44, 44);
        [backButton setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        _backButton = backButton;
        _backButton.hidden = _hideBackButton;
    }
    return _backButton;
}

- (void)setTitleStr:(NSString *)titleStr {
    if (titleStr.length > 12) {
        titleStr = [titleStr substringToIndex:12];
        _titleStr = [NSString stringWithFormat:@"%@...",titleStr];
    }else {
        _titleStr = titleStr;
    }
    self.titleLabel.text = _titleStr;
}

#pragma mark -遍历导航栏的所有子视图
NSArray *allSubviews(UIView *aView) {
    NSArray *results = [aView subviews];
    for (UIView *eachView in aView.subviews)
        {
        NSArray *subviews = allSubviews(eachView);
        if (subviews)
            results = [results arrayByAddingObjectsFromArray:subviews];
        }
    return results;
}

// 隐藏导航栏下方的线
- (void)hideBottomLineOnNavBar {
    NSArray *subViews = allSubviews(self.navigationController.navigationBar);
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height<1) {
                //实践后发现系统的横线高度为0.333
            self.shadowImage = (UIImageView *)view;
        }
    }
    self.shadowImage.hidden = YES;
}

- (void)setNavColor:(UIColor *)navColor {
    self.navigationController.navigationBar.barTintColor = navColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor,
                              NSFontAttributeName:BFONT(16)}];

}

- (void)setTitleFont:(UIFont *)titleFont {
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSFontAttributeName:titleFont}];
}


#pragma mark - Getter/Setter Methods
- (UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_WIDH*0.5 - 80, 44)];
        _titleLabel.font = kFONT(kTitleName_PingFang_M, 19);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}


#pragma mark - JS调用方法
- (void)registerNativeFunctions
{
    [self getLocation];

    [self getContact];

    [self sendSMS];

    [self callHandle];

    [self pictureProc];

    [self setAliasAndTag];

    [self getQrCodeInfo];
    
    [self collectLocation];//定位的
    
    [self getVersionCode];
    
    [self hisBack];//返回
    
    [self loginOut];//退出登录
}

-(void)getVersionCode
{
    
    [_webViewBridge registerHandler:@"getVersionCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        //版本号
        NSString* BBH =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        NSString* str = [NSString stringWithFormat:@"{\"system\":%@,\"verson\":\"%@\"}",@"ios",BBH];
        responseCallback(str);
    }];
    
}

-(void)collectLocation
{
    [_webViewBridge registerHandler:@"collectLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        //获取地址
        
        [self initBlock];
    }];
}

-(void)initBlock
{
    //定位地址
    [[SNLocationManager shareLocationManager] startUpdatingLocationWithSuccess:^(CLLocation *location, CLPlacemark *placemark) {
        
        latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];//纬度
        Longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];//精度
        NSLog(@" SNLocationManager lat === %f  long === %f  ",location.coordinate.latitude,location.coordinate.longitude);
        
    } andFailure:^(CLRegion *region, NSError *error) {
        
        NSLog(@"  错误！！！！ %@  ",error);
        
    }];
}

-(void)get2 {
    //定位地址
    [[SNLocationManager shareLocationManager] startUpdatingLocationWithSuccess:^(CLLocation *location, CLPlacemark *placemark) {
        latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];//纬度
        Longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];//精度
        
    } andFailure:^(CLRegion *region, NSError *error) {
        NSLog(@"  错误！！！！ %@  ",error);
        
    }];
}

-(void)getLocation
{
    //定位
    [self get2];
    [_webViewBridge registerHandler:@"getLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 获取位置信息
        NSString* str = [NSString stringWithFormat:@"{\"latitude\":%@,\"longitude\":\"%@\"}",latitude,Longitude];
        NSLog(@"   ===== lat %@  =====  long %@",latitude,Longitude);
        
        responseCallback(str);
    }];
}

-(void)getContact
{
    
    //获取通讯录
    [_webViewBridge registerHandler:@"getContact" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 获取位置信息
        
        ABAddressBookRef tmpAddressBook = nil;
        //根据系统版本不同，调用不同方法获取通讯录
        if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
            
            tmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            
            dispatch_semaphore_t sema=dispatch_semaphore_create(0);
            
            ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
                
                dispatch_semaphore_signal(sema);
                
            });
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
        }
        
        else
            
        {
            
            tmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            
        }
        
        //取得通讯录失败
        //将通讯录中的信息用数组方式读出
        
        NSArray* tmpPeoples = (__bridge NSArray*) ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
        NSLog(@" ======= %@",tmpPeoples);
        NSMutableArray* tab = [[NSMutableArray alloc]init];
        for(NSDictionary* tmpPerson in tmpPeoples){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            //获取的联系人单一属性:First name
            NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
            NSLog(@"First name:%@", tmpFirstName);
            
            //         [dic setValue:tmpFirstName forKey:@"FirstName"];
            
            //获取的联系人单一属性:Last name
            
            NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson),kABPersonLastNameProperty);
            NSLog(@"Last name:%@", tmpLastName);
            //获取的联系人单一属性:Nickname
            NSString* name;
            if (tmpFirstName != nil&&tmpLastName == nil) {
                name = [NSString stringWithFormat:@"%@",tmpFirstName];
            }else if (tmpFirstName == nil&&tmpLastName != nil)
            {
                name = [NSString stringWithFormat:@"%@",tmpLastName];
            }else
            {
                name = [NSString stringWithFormat:@"%@%@",tmpLastName,tmpFirstName];
            }
            
            
            
            [dic setValue:name forKey:@"name"];
            
            
            NSLog(@"  ===  厚礼%@",dic);
            //获取的联系人单一属性:Generic phone number
            
            ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson),kABPersonPhoneProperty);
            
            for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
                
            {
                
                NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
                NSLog(@"tmpPhoneIndex%ld:%@", (long)j, tmpPhoneIndex);
                [dic setValue:tmpPhoneIndex forKey:@"tel"];
                
            }
            
            [tab addObject:dic];
            
        }
        
        
        NSLog(@"      大数据  ==============  %@      " ,tab);
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tab options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"  json = %@   ",jsonString);
        responseCallback(jsonString);
        
    }];
    
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)sendSMS
{
    
    [_webViewBridge registerHandler:@"sendSMS" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 发送短信
        
        NSDictionary* dic = data;
        [self showMessageView:[NSArray arrayWithObjects:dic[@"phone"], nil] title:@"test" body:dic[@"message"]];
        
    }];
}

-(void)callHandle
{
    [_webViewBridge registerHandler:@"callHandle" handler:^(id data, WVJBResponseCallback responseCallback) {
        //打电话
        NSString* str = data;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",str]]];
        
        
        
    }];
    
}

- (void)hisBack{
    [_webViewBridge registerHandler:@"hisBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        //返回
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}

- (void)loginOut{
    [_webViewBridge registerHandler:@"loginOut" handler:^(id data, WVJBResponseCallback responseCallback) {
        //退出登录
        HHLoginViewController *loginVC = [[HHLoginViewController alloc] initWithNibName:@"HHLoginViewController" bundle:nil];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LocalFlag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self presentViewController:loginVC animated:YES completion:nil];
    }];
}

-(void)pictureProc
{
    [_webViewBridge registerHandler:@"pictureProc" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data 的类型与 JS中传的参数有关
        NSDictionary *tempDic = data;
        
        NSArray *array = [tempDic[@"dataobj"] componentsSeparatedByString:@","];
        NSString* imgBase64 = array[1];//图片Base64
        NSString* width = tempDic[@"width"];//图片的宽
        NSString* height = tempDic[@"height"];//图片的高
        NSData *decodedImageData   = [[NSData alloc] initWithBase64Encoding:imgBase64];
        UIImage *decodedImage      = [UIImage imageWithData:decodedImageData];
        [decodedImage drawInRect:CGRectMake(0, 0, [width intValue],[height intValue])];
        UIGraphicsEndImageContext();
        NSData *data1 = UIImageJPEGRepresentation(decodedImage,0.5f);
        NSString *_encodedImageStr = [data1 base64Encoding];
        NSString* str111 = [NSString stringWithFormat:@"{\"status\":%@,\"data\":\"%@\"}",@"true",_encodedImageStr];
        // 将分享的结果返回到JS
        responseCallback(str111);
    }];
}
-(void)setAliasAndTag
{
    [_webViewBridge registerHandler:@"setAliasAndTag" handler:^(id data, WVJBResponseCallback responseCallback) {
        //设置标签
        
        NSDictionary* dic = data;
        NSArray * tagsList = @[dic[@"tag"]];
        NSMutableSet * tags = [[NSMutableSet alloc] init];
        [tags addObjectsFromArray:tagsList];
        if (dic.count ==1) {
            
            if ([dic[@"tag"] isEqualToString:@""]) {
                
            }else
            {
                [JPUSHService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                    
                    if (iResCode == 0) {
                        
                        NSLog(@"tags成功");
                    }
                    
                    
                } seq:[self seq]];
            }
            
            if ([dic[@"alias"] isEqualToString:@""]) {
                
            }else
            {
                [JPUSHService setAlias:dic[@"alias"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    
                    
                    if (iResCode == 0) {
                        
                        NSLog(@"成功alias");
                    }
                    
                    
                } seq:[self seq]];
            }
            
        }else if (dic.count == 2)
        {
            [JPUSHService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                
                if (iResCode == 0) {
                    
                    NSLog(@"tags成功");
                }
                
                
            } seq:[self seq]];
            
            [JPUSHService setAlias:dic[@"alias"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
                
                if (iResCode == 0) {
                    
                    NSLog(@"成功alias");
                }
                
                
            } seq:[self seq]];
        }
        
        
    }];
}

- (NSSet<NSString *> *)tags:(NSString*)str{
    NSArray * tagsList = [str componentsSeparatedByString:@","];
    NSMutableSet * tags = [[NSMutableSet alloc] init];
    [tags addObjectsFromArray:tagsList];
    return tags;
}
- (NSInteger)seq {
    return ++ seq;
}

-(void)getQrCodeInfo
{
    [_webViewBridge registerHandler:@"getQrCodeInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 扫一扫
        //进入扫一扫
        HHQRCodetController *vc = [[HHQRCodetController alloc] initWithNibName:@"HHQRCodetController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
        
        
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

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeNative) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //字体的多少为btn的大小
        [btn sizeToFit];
        //左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _closeItem.customView = btn;
    }
    return _closeItem;
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}



@end

