//
//  HHTextField.m
//  EnjoyProject
//
//  Created by HYH on 2018/3/6.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import "HHTextField.h"

@implementation HHTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
//    iconRect.origin.x += 15; //像右边偏15
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 35, 0);

}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 35, 0);
}


@end
