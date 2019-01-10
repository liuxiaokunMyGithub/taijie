//
//  GBBigTitleHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/27.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BigTitleHeadViewType) {
    // 仅有大标题
    BigTitleHeadViewTypeTitle = 0,
    // 大标题加右侧小标题
    BigTitleHeadViewTypeRightSubTitle,
    // 大标题加底部小标题
    BigTitleHeadViewTypeBottomSubTitle,
};

@interface GBBigTitleHeadView : UIView

/* <#describe#> */
@property (nonatomic, assign) BigTitleHeadViewType bigTitleType;

/* 顶部偏移 */
@property (nonatomic, assign) NSInteger topMargin;

/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/* 子标题 */
@property (strong , nonatomic)UILabel *subTitleLabel;
/* 底部子标题 */
@property (strong , nonatomic)UILabel *bottomSubTitleLabel;

/* 右侧按钮 */
@property (strong , nonatomic) UIButton *rightButton;

/* 右侧按钮 */
@property (nonatomic, copy) dispatch_block_t rightButtonClickBlock;

@end
