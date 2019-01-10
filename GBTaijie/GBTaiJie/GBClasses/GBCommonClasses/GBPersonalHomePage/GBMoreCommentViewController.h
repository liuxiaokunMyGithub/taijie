//
//  GBMoreCommentViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/25.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"

@interface GBMoreCommentViewController : GBBaseViewController
/* 服务详情类型 */
@property (nonatomic, assign) NSString *serviceDetailsType;

/** 个人主页targetUsrid */
@property (nonatomic, copy) NSString *targetUsrid;
/* <#describe#> */
@property (nonatomic, copy) NSString *assuredId;
@property (nonatomic, copy) NSString *decryptionId;

@end
