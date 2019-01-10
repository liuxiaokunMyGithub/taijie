//
//  GBLoadingWaitView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/4.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBLoadingWaitView : UIView

@property (nonatomic, strong) UIImageView *loadingImageView;

/**
 加载等待视图

 @param view 等待视图的父视图
 @param isClear 是否清空背景色
 */
+ (void)showCircleJoinView:(UIView *)view isClearBackgoundColor:(BOOL)isClear margin:(CGFloat )margin;

// 隐藏
+ (void)hide;

@end
