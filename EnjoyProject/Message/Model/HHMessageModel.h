//
//  HHMessageModel.h
//  EnjoyProject
//
//  Created by vanke on 2018/3/4.
//  Copyright © 2018年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JKDBModel.h>

@interface HHMessageModel : JKDBModel

@property (nonatomic, copy) NSString *transType;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *msgTime;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *headName;
@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *isNotRead; //是否阅读

@end
