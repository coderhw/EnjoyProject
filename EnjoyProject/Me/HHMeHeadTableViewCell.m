//
//  HHMeHeadTableViewCell.m
//  EnjoyProject
//
//  Created by HYH on 2018/3/2.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import "HHMeHeadTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation HHMeHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cellimg.contentMode = UIViewContentModeScaleAspectFit;
    self.cellimg.layer.cornerRadius = 35;
    self.cellimg.layer.masksToBounds = YES;
    NSString *imageStr = APPContext.headimgurl;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
    UIImage *image = [UIImage imageWithData:data];
    UIGraphicsBeginImageContextWithOptions(self.cellimg.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:self.cellimg.bounds cornerRadius:image.size.width/2] addClip];
    [image drawInRect:self.cellimg.bounds];
    self.cellimg.image = UIGraphicsGetImageFromCurrentImageContext();
    
    self.nameLabel.text = APPContext.userName;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
