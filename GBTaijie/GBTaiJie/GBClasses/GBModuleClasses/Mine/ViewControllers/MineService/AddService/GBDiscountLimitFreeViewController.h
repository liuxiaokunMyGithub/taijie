//
//  GBDiscountLimitFreeViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"

@interface GBDiscountLimitFreeViewController : GBBaseViewController
@property (nonatomic, copy) NSString *discountType;
@property (nonatomic, copy) NSString *originalPrice;

@property (nonatomic,copy) void(^saveBlock)(NSString *discountType,NSString *price);

@end
