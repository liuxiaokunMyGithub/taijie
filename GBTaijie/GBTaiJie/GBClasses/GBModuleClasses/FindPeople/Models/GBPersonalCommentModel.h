//
//  GBPersonalCommentModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBPersonalCommentModel : GBBaseModel
// 评论id
@property (nonatomic, assign) NSInteger evaluateId;
// 评论内容
@property (nonatomic, copy) NSString *content;
// 发布者
@property (nonatomic, copy) NSString *publisher;
// 发布时间
@property (nonatomic, copy) NSString *publishTime;
// 发布者头像
@property (nonatomic, copy) NSString *publisherHeadImg;

@end
