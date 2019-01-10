//
//  UIView+Extension.m
//  mobo
//
//  Created by liuxiaokun on 15/9/14.
//  Copyright (c) 2015年 liuxiaokun. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (Extension)
@property CGPoint origin;
@property CGSize size;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void)moveBy:(CGPoint) delta;
- (void)scaleBy:(CGFloat) scaleFactor;
- (void)fitInSize:(CGSize) aSize;

/**   纯文本弹出框提示- 固定时长   */
+ (void)showHubWithTip:(NSString *)tip;

/**   纯文本弹出框提示   */
+ (void)showHubWithTip:(NSString *)tip timeintevel:(CGFloat)intever;

@end
