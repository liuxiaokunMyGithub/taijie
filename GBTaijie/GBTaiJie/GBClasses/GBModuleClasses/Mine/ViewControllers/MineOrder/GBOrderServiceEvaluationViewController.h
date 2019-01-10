//
//  GBOrderServiceEvaluationViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/24.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"
#import "GBOrderDetailsModel.h"

@interface GBOrderServiceEvaluationViewController : GBBaseViewController
/* 订单详情状态 */
@property (nonatomic, assign) G_OrderDetailsType orderDetailsType;
@property (nonatomic, strong) GBOrderDetailsModel *orderDeailsModel;

@end
