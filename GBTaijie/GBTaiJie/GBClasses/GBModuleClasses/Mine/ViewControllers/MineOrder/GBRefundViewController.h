//
//  GBRefundViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/24.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"
#import "GBOrderDetailsModel.h"

@interface GBRefundViewController : GBBaseViewController
/* 订单详情 */
@property (nonatomic, strong) GBOrderDetailsModel *orderDeailsModel;
/* <#describe#> */
@property (nonatomic, copy) NSString *reasonType;
@property (nonatomic, copy) NSString *remark;

@end
