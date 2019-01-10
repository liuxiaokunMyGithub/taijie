//
//  GBOrderDetailsViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/12.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GBOrderDetailsViewController : GBBaseViewController

/* 订单详情状态 */
@property (nonatomic, assign) G_OrderDetailsType orderDetailsType;

/* 身份订单状态类型 */
@property (nonatomic, assign) G_RoleOrderType roleOrderType;

/* 订单id */
@property (nonatomic, assign) NSInteger orderId;


@end
