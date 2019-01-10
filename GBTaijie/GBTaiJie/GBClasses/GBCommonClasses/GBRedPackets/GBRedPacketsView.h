//
//  GBRedPacketsView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/13.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBRedPacketsView : UIView

/* <#describe#> */
@property (nonatomic, strong) UIView *redBgView;
@property (nonatomic, strong) UIImageView *redPacketImageView;
@property (nonatomic, strong) UIImageView *redPacketImageOpenedView;

/* <#describe#> */
@property (nonatomic, strong) UIButton *closeButton;
/**
 红包视图
 
 @param view 等待视图的父视图
 @param isClear 是否清空背景色
 */
+ (void)showRedPacketJoinView:(UIView *)view margin:(CGFloat )margin;

// 隐藏
+ (void)hide;

@end
