//
//  HHWorkViewController.m
//  EnjoyProject
//
//  Created by vanke on 2018/3/2.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import "HHWorkViewController.h"
#import "HHWorkVCCollectionViewCell.h"
#import "HHButon.h"

@interface HHWorkViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property(strong,nonatomic)UICollectionView *hhworkCollectionView;
@property(strong,nonatomic)NSArray *nameArray;
@end

@implementation HHWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleStr = @"工作台";
    
//    self.nameArray = @[@[@"公告",@"打卡",@"日报"],@[@"审批",@"新增订单",@"订单管理"],@[@"我的粉丝",@"合作渠道",@"客户"],@[@"网络申请",@"资金使用",@"统计查询"]];
//    [self.view addSubview:self.hhworkCollectionView];
    self.nameArray = @[@"公告",@"打卡",@"日报",@"审批",@"新增订单",@"订单管理",@"我的粉丝",@"合作渠道",@"客户",@"网络申请",@"资金使用",@"统计查询"];
 
    
    [self setUI];
}

- (void)setUI{
    self.view.backgroundColor = RGB(239, 239, 244);
    
    CGFloat ItemW = (kScreenWidth - 1)/3;
    CGFloat ItemH;
    if (ItemW * 4 + 2 <= kScreenHeight - 44 - 64) {
        ItemH = ItemW - 20;
    }else{
        ItemH = (kScreenHeight - 44 - 64 - 2)/4;
    }
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 8, kScreenWidth, ItemH * 4 + 2)];
    backView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:backView];
    
    for (int i = 0; i < 12; i++) {
        HHButon *button = [HHButon buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = 100+i;
        button.frame = CGRectMake(i%3 * ItemW + i%3 * 0.5, i/3 * ItemH + (int)i/3 * 0.5, ItemW, ItemH);
        [button setImage:[UIImage imageNamed:self.nameArray[i]] forState:UIControlStateNormal];
        [button setTitle:self.nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;

        [button addTarget:self action:@selector(buttonClink:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }
}

- (void)buttonClink:(UIButton *)sender{
    NSString *name = self.nameArray[sender.tag -100];
    
    NSDictionary *urlDic = @{
                             @"公告":@"noticeindex",
                             @"打卡":@"cSign",
                             @"日报":@"reportindex",
                             @"审批":@"auditindex",
                             @"新增订单":@"newordermanager",
                             @"订单管理":@"orderindex",
                             @"我的粉丝":@"",
                             @"合作渠道":@"applyPartner",
                             @"客户":@"custindex",
                             @"网络申请":@"",
                             @"资金使用":@"takemoney",
                             @"统计查询":@"orderquery"
                             };
    HHBaseViewController *baseCtl = [[HHBaseViewController alloc]init];
    baseCtl.titleStr = name;
    if ([name isEqualToString:@"我的粉丝"]) {
        baseCtl.url = [NSString stringWithFormat:@"%@fansfront_showFansBySelf.action?weixinid=%@",kHost,APPContext.weixinid];
    }else if ([name isEqualToString:@"网络申请"]){
        baseCtl.url = [NSString stringWithFormat:@"%@orderinfofront_listOrderInfo.action?weixinid=%@",kHost,APPContext.weixinid];
    }else if ([name isEqualToString:@"审批"]){
        //http://work.lovetoshare666.com/wxcustfront_toAppIndex.action?weixinid=oFRThwtlcC6Owi9ktETLqxHr30Cg#/app/auditindex
        baseCtl.url = [NSString stringWithFormat:@"%@wxcustfront_toAppIndex.action?weixinid=%@#/app/auditindex",kHost,APPContext.weixinid];
    }else if ([name isEqualToString:@"客户"]){
        //http://work.lovetoshare666.com/wxcustfront_toAppIndex.action?weixinid=oFRThwtlcC6Owi9ktETLqxHr30Cg#/app/custindex
        baseCtl.url = [NSString stringWithFormat:@"%@wxcustfront_toAppIndex.action?weixinid=%@#/app/custindex",kHost,APPContext.weixinid];
    }else if ([name isEqualToString:@"资金使用"]){
        //http://work.lovetoshare666.com/wxcustfront_toAppIndex.action?weixinid=oFRThwtlcC6Owi9ktETLqxHr30Cg#/app/takemoney
        baseCtl.url = [NSString stringWithFormat:@"%@wxcustfront_toAppIndex.action?weixinid=%@#/app/takemoney",kHost,APPContext.weixinid];
    }else if ([name isEqualToString:@"新增订单"]){
        //http://work.lovetoshare666.com/wxcustfront_toAppIndex.action?weixinid=oFRThwtlcC6Owi9ktETLqxHr30Cg#/inapp/newordermanager
        baseCtl.url = [NSString stringWithFormat:@"%@wxcustfront_toAppIndex.action?weixinid=%@#/inapp/newordermanager",kHost,APPContext.weixinid];
    }
    else{
        NSString *url = [NSString stringWithFormat:@"%@wxcustfront_toAppIndex.action?weixinid=%@#/inapp/%@",kHost,APPContext.weixinid,urlDic[name]];
        baseCtl.url = url;
    }
    
    baseCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baseCtl animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *ID = @"HHWorkVCCollectionViewCell";
    HHWorkVCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.name.text = self.nameArray[indexPath.section][indexPath.row];
    [cell.cellimg setImage:[UIImage imageNamed:self.nameArray[indexPath.section][indexPath.row]]];
    return cell;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHWorkVCCollectionViewCell *cell = (HHWorkVCCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *urlDic = @{
                             @"公告":@"noticeindex",
                             @"打卡":@"cSign",
                             @"日报":@"reportindex",
                             @"审批":@"auditindex",
                             @"新增订单":@"newordermanager",
                             @"订单管理":@"orderindex",
                             @"我的粉丝":@"",
                             @"合作渠道":@"applyPartner",
                             @"客户":@"custindex",
                             @"网络申请":@"",
                             @"资金使用":@"takemoney",
                             @"统计查询":@"orderquery"
                             };
    HHBaseViewController *baseCtl = [[HHBaseViewController alloc]init];
    baseCtl.titleStr = cell.name.text;
    
    if ([cell.name.text isEqualToString:@"我的粉丝"]) {
        baseCtl.url = [NSString stringWithFormat:@"%@fansfront_showFansBySelf.action?weixinid=%@",kHost,APPContext.weixinid];
    }else if ([cell.name.text isEqualToString:@"网络申请"]){
        baseCtl.url = [NSString stringWithFormat:@"%@orderinfofront_listOrderInfo.action?weixinid=%@",kHost,APPContext.weixinid];
    }else{
        NSString *url = [NSString stringWithFormat:@"%@wxcustfront_toAppIndex.action?weixinid=%@#/inapp/%@",kHost,APPContext.weixinid,urlDic[cell.name.text]];
        baseCtl.url = url;
    }
   
    baseCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baseCtl animated:YES];
}



- (UICollectionView *)hhworkCollectionView{
    if (!_hhworkCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize =CGSizeMake([UIScreen mainScreen].bounds.size.width/3 - 10, 150);
        _hhworkCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-44) collectionViewLayout:layout];
        _hhworkCollectionView.backgroundColor = [UIColor clearColor];
        _hhworkCollectionView.dataSource = self;
        _hhworkCollectionView.delegate = self;
        [_hhworkCollectionView registerNib:[UINib nibWithNibName:@"HHWorkVCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HHWorkVCCollectionViewCell"];
    }
    return _hhworkCollectionView;
}



@end
