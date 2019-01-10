//
//  GBOrderDetailsPersonalInfoCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/24.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBOrderDetailsPersonalInfoCell : UITableViewCell
/* 订单详情状态 */
@property (nonatomic, assign) G_OrderDetailsType orderDetailsType;

/* 星星 */
@property (strong , nonatomic) HCSStarRatingView *starView;

// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 子标题
@property (nonatomic, strong) UILabel *subTitleLabel;
// 子标题1
@property (nonatomic, strong) UILabel *subTitleLabel1;

/* 图标 */
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIView *line;

// 解密
@property (nonatomic, strong) UILabel *decryptionLabel;

@end
