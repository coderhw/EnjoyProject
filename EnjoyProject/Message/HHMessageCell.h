//
//  HHMessageCell.h
//  EnjoyProject
//
//  Created by vanke on 2018/3/4.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *redDot;

@end
