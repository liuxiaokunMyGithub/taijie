//
//  GBMineHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface GBMineHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

/* 编辑回调 */
@property (nonatomic, copy) dispatch_block_t homePageButtonBlock;
/* 用户个人信息 */
@property (nonatomic, strong) UserModel *userModel;
/* 认证V标志图 */
@property (nonatomic, strong) UIImageView *vFlagImageView;

@end
