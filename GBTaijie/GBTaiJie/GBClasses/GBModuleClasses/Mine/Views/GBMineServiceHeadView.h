//
//  GBMineServiceHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBLLRIButton.h"

@interface GBMineServiceHeadView : UIView

/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/* 子标题 */
@property (strong , nonatomic)UILabel *subTitleLabel;
/** 价格 */
@property (strong , nonatomic) UILabel *priceLabel;
/* 底部子标题 */
@property (strong , nonatomic)UILabel *bottomSubTitleLabel;

/* 右侧按钮 */
@property (strong , nonatomic) GBLLRIButton *rightButton;

/* 背景图 */
@property (nonatomic, strong) UIImageView *bgImageView;

/* 右侧按钮 */
@property (nonatomic, copy) dispatch_block_t rightButtonClickBlock;

@end
