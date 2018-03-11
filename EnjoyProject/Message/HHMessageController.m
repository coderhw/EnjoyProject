//
//  HHMessageController.m
//  EnjoyProject
//
//  Created by vanke on 2018/3/2.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import "HHMessageController.h"
#import <AFNetworking.h>
#import <JPUSHService.h>
#import "HHMessageModel.h"
#import "HHMessageCell.h"
#import "HHTimeTool.h"
#import "HHTabBarController.h"
#import "HHTimeTool.h"

@interface HHMessageController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, assign) int notReadCount;


@end

@implementation HHMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
     self.view.backgroundColor = RGB(239, 239, 244);
    
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageUpdateNotification:)
                                                 name:@"kMessageUpdateNotification" object:nil];
    
    
    self.titleStr = @"消息";
    
    //初试化TableView
    [self configTableView];
    
    //获取个人用户信息
    [self fecthPersonUserInfo];
    
    //绑定用户别名
    [JPUSHService setAlias:LocalFlagGET completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self handleDBMessage];
}

#pragma mark - UI

- (void)configTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHMessageCell" bundle:nil] forCellReuseIdentifier:@"CellIdentifier"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
}

#pragma mark - Request
//获取个人用户信息
- (void)fecthPersonUserInfo {
    
    NSDictionary *parmas = @{@"wxUser":LocalFlagGET};
    NSString *urlStr = [NSString stringWithFormat:@"%@chatfront_getFansInfo.action",kHost];
    [self startRequestWithParams:parmas url:urlStr complete:^(BOOL success, NSError *error, NSDictionary *info) {
        NSLog(@"获取个人信息");
        APPContext.headimgurl = info[@"headimgurl"];
        APPContext.userName = info[@"username"];

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
        if([responseObject isKindOfClass:[NSDictionary class]]){
            completeBlock(YES, nil, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(NO, error, nil);
        NSLog(@"error%@",error);
    }];
}

#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dic = @{@"0":@"消息",
                          @"2":@"打卡",
                          @"3":@"审批",
                          @"4":@"公告",
                          @"5":@"日报",
                          @"6":@"订单",
                          @"7":@"提醒",
                          @"8":@"现金业务"
                          };
    
    NSDictionary *imageDic = @{@"0":@"message",
                               @"2":@"signMsgs",
                               @"3":@"examineMsgs",
                               @"4":@"noticeMsgs",
                               @"5":@"dailyMsgs",
                               @"6":@"orderMsgs",
                               @"7":@"remindMsgs",
                               @"8":@"cashMsgs"};
    
    HHMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    

    
    HHMessageModel *model = self.messages[indexPath.row];
    NSString *title = dic[model.transType];
    NSString *imageName = imageDic[model.transType];
    UIImage *titleImg = [UIImage imageNamed:imageName];

    
    CGFloat time = [model.msgTime floatValue];
    cell.titleLabel.text = title;
    cell.content.text = model.content;
    cell.timeLabel.text = [HHTimeTool timeStr:time];
    cell.avatorView.image = titleImg;
    cell.redDot.hidden = ![model.isNotRead boolValue];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = @{@"0":@"消息",
                          @"2":@"打卡",
                          @"3":@"审批",
                          @"4":@"公告",
                          @"5":@"日报",
                          @"6":@"订单",
                          @"7":@"提醒",
                          @"8":@"现金业务"
                          };
    
    HHMessageModel *msgModel = self.messages[indexPath.row];
    msgModel.isNotRead = @"0";
    HHBaseViewController *baseCtl = [[HHBaseViewController alloc] init];
    baseCtl.titleStr = dic[msgModel.transType];
    baseCtl.url = msgModel.linkUrl;
    baseCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baseCtl animated:YES];
    
    //更新数据库信息
    [msgModel update];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 72;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 8, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(self.messages.count >= indexPath.row){
            HHMessageModel *msgModel = self.messages[indexPath.row-1];
            [msgModel deleteObject];
            [self.messages removeObjectAtIndex:indexPath.row];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES];
            [self handleDBMessage];            
        }
    }
}
#pragma mark -  Notification
- (void)messageUpdateNotification:(NSNotification *)note {
    
    [self handleDBMessage];
}


- (void)handleDBMessage {
    
    self.notReadCount = 0;
    if(self.messages.count) [self.messages removeAllObjects];
    self.messages = [[NSMutableArray alloc] initWithArray:[HHMessageModel findAll]];
    
    
    [self.messages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HHMessageModel *msgModel = obj;
        if([msgModel.isNotRead isEqualToString:@"1"]){
            self.notReadCount ++;
        }
    }];
    
    [self.tableView reloadData];
    
    HHTabBarController *tabBar = APPContext.tabBar;
    [tabBar setBage:[NSString stringWithFormat:@"%d", self.notReadCount]];
    APPContext.notReadCount = self.notReadCount;

}



@end
