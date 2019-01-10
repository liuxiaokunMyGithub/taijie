//
//  GBOrderRecodCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionListModel.h"
#import "BuyOrderModel.h"

@interface GBOrderRecodCell : UITableViewCell
/* 身份订单状态类型 */
@property (nonatomic, assign) G_RoleOrderType roleOrderType;

/* 订单状态 */
@property (nonatomic, strong) UIButton *stateButton;

/* 记录模型 */
@property (nonatomic, strong) TransactionListModel *recodeModel;

/* 订单模型 */
@property (nonatomic, strong) BuyOrderModel *orderModel;

@end
