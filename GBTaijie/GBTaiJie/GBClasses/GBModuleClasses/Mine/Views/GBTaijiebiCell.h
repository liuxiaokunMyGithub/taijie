//
//  GBTaijiebiCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBTaijiebiCell : UITableViewCell
/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 交易金额 */
@property (nonatomic, strong) UIButton *priceButton;

/* <#describe#> */
@property (nonatomic, strong) NSIndexPath *indexPath;

/* <#describe#> */
//@property (nonatomic, copy) void (^payButtonClickBlock)(NSIndexPath *indexPatch);

@end
