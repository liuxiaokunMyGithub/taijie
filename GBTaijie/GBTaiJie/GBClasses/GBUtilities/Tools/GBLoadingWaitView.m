//
//  GBLoadingWaitView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/4.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBLoadingWaitView.h"
#import "UIImage+GIF.h"

static GBLoadingWaitView *loadView;

@implementation GBLoadingWaitView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        UIImageView *loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        loadingImageView.image = GBImageNamed(@"loading");
        //------- 旋转动画 -------//
        CABasicAnimation *animation = [ CABasicAnimation
                                       animationWithKeyPath: @"transform" ];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        // 围绕Z轴旋转,垂直与屏幕
        animation.toValue = [ NSValue valueWithCATransform3D:
                             CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
        animation.duration = 0.5;
        // 旋转效果累计,先转180度,接着再旋转180度,从而实现360旋转
        animation.cumulative = YES;
        animation.repeatCount = 1000;
        //在图片边缘添加一个像素的透明区域,去图片锯齿
        CGRect imageRrect = CGRectMake(0, 0,loadingImageView.frame.size.width, loadingImageView.frame.size.height);
        UIGraphicsBeginImageContext(imageRrect.size);
        [loadingImageView.image drawInRect:CGRectMake(1,1,loadingImageView.frame.size.width-2,loadingImageView.frame.size.height-2)];
        loadingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 添加动画
        [loadingImageView.layer addAnimation:animation forKey:nil];
        
        [self addSubview:loadingImageView];
        loadingImageView.center = self.center;
        self.loadingImageView = loadingImageView;
    }
    return self;
}

+ (void)showCircleJoinView:(UIView *)view isClearBackgoundColor:(BOOL)isClear margin:(CGFloat )margin
{
    [self hide];
    
    loadView = [[GBLoadingWaitView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    loadView.backgroundColor = isClear?[UIColor clearColor]:[UIColor whiteColor];
    loadView.centerX = GBAppDelegate.window.centerX;
    loadView.centerY = GBAppDelegate.window.centerY + margin;
    [view addSubview:loadView];
    [view bringSubviewToFront:loadView];
    
}

+ (void)hide {
    if (loadView) {
        [loadView removeFromSuperview];
    }
}


@end
