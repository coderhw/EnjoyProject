//
//  HHMeViewController.m
//  EnjoyProject
//
//  Created by vanke on 2018/3/2.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import "HHMeViewController.h"
#import "HHMeTableViewCell.h"
#import "HHMeHeadTableViewCell.h"


@interface HHMeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property(nonatomic,strong)UITableView *hhmeTableview;
@property(strong,nonatomic)NSArray *nameArray;
@end

@implementation HHMeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.titleStr = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameArray = @[@[@""],@[@"提醒",@"我的二维码",@"短信模板"],@[@"设置"]];
    [self.view addSubview:self.hhmeTableview];

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HHMeHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMeHeadTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    HHMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = self.nameArray[indexPath.section][indexPath.row];
    [cell.cellimg setImage:[UIImage imageNamed:self.nameArray[indexPath.section][indexPath.row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 140;
    }
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        HHMeTableViewCell *cell = (HHMeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        
        NSDictionary *urlDic = @{
                                 @"提醒":@"meremind",
                                 @"我的二维码":@"QRcode",
                                 @"短信模板":@"",
                                 @"设置":@"setindex"
                                 };
        HHBaseViewController *baseCtl = [[HHBaseViewController alloc]init];
        baseCtl.titleStr = cell.name.text;
        if ([cell.name.text isEqualToString:@"短信模板"]) {
            baseCtl.url = [NSString stringWithFormat:@"%@messagetemplatefront_indexTemplate.action?weixinid=%@",kHost,APPContext.weixinid];
        }else if ([cell.name.text isEqualToString:@"提醒"]) {
            //http://work.lovetoshare666.com/wxcustfront_toAppIndex.action?weixinid=oFRThwtlcC6Owi9ktETLqxHr30Cg#/app/meremind

            baseCtl.url = [NSString stringWithFormat:@"%@wxcustfront_toAppIndex.action?weixinid=%@#/app/meremind",kHost,APPContext.weixinid];
        }
        else{
            NSString *url = [NSString stringWithFormat:@"%@wxcustfront_toAppIndex.action?weixinid=%@#/inapp/%@",kHost,APPContext.weixinid,urlDic[cell.name.text]];
            baseCtl.url = url;
        }
        baseCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baseCtl animated:YES];
    }else{
        //
        
    }
}

- (UITableView *)hhmeTableview{
    if (!_hhmeTableview) {
        _hhmeTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _hhmeTableview.delegate = self;
        _hhmeTableview.dataSource = self;
        _hhmeTableview.estimatedRowHeight = 50;
        _hhmeTableview.estimatedSectionFooterHeight = 0;
        _hhmeTableview.estimatedSectionHeaderHeight = 0;

        [_hhmeTableview registerNib:[UINib nibWithNibName:@"HHMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HHMeTableViewCell"];
        [_hhmeTableview registerNib:[UINib nibWithNibName:@"HHMeHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"HHMeHeadTableViewCell"];

    }
    return _hhmeTableview;
}

@end
