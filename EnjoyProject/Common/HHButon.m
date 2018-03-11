//
//  HHButon.m
//  EnjoyProject
//
//  Created by HYH on 2018/3/6.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import "HHButon.h"

@implementation HHButon

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW = 30;
    CGFloat imageH = 30;
    CGFloat imageX = (contentRect.size.width-imageW) * 0.5;
    CGFloat imageY = (contentRect.size.height - 60)/2;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = 20;
    CGFloat imageX = 0;
    CGFloat imageY = (contentRect.size.height - 60)/2 + 50;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
