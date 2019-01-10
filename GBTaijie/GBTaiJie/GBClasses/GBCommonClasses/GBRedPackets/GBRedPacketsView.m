//
//  GBRedPacketsView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/13.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBRedPacketsView.h"

static GBRedPacketsView *redPacketsView;

@implementation GBRedPacketsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.redBgView];
        self.redBgView.center = self.center;
        
        UIImageView *redPacketImageOpenedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,329,317)];
        redPacketImageOpenedView.image = GBImageNamed(@"img_redPackets_opened");
        redPacketImageOpenedView.userInteractionEnabled = YES;
        [self addSubview:redPacketImageOpenedView];
        redPacketImageOpenedView.center = self.redBgView.center;
        self.redPacketImageOpenedView = redPacketImageOpenedView;
        [self.redBgView addSubview:redPacketImageOpenedView];
        UITapGestureRecognizer *tapCloseGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [redPacketImageOpenedView addGestureRecognizer:tapCloseGesture];
        
        UIImageView *redPacketImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,329,317)];
        redPacketImageView.image = GBImageNamed(@"img_redPackets_open");
        redPacketImageView.userInteractionEnabled = YES;
        [self addSubview:redPacketImageView];
        redPacketImageView.center = self.redBgView.center;
        self.redPacketImageView = redPacketImageView;
        [self.redBgView addSubview:redPacketImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOpened)];
        [redPacketImageView addGestureRecognizer:tapGesture];
        
        UIButton *closeButton = [UIButton createButtonWihtImage:GBImageNamed(@"icon_close_redPacket") target:self action:@selector(close)];
        [self addSubview:closeButton];
        self.closeButton = closeButton;
    }
    
    return self;
}

- (void)tapOpened {
    if (ValidStr([GBUserDefaults stringForKey:UDK_UserId])) {
        // 已登录
        GBCommonViewModel *commonVM = [[GBCommonViewModel alloc] init];
        [commonVM loadRequestOpenRedPacket];
        [commonVM setSuccessReturnBlock:^(id returnValue) {
            // 切换
            [self exchangeSubviewWithSuperView:self.redBgView];
            // 刷新系统消息
            [GBNotificationCenter postNotificationName:SystemMessageRefreshNotification object:nil];
        }];
    }else {
        // 未登录
        GBPostNotification(LoginStateChangeNotification, @NO);
        [UIView showHubWithTip:@"当前操作需要您先注册登录" timeintevel:2.0];
    }
}

 //根据父视图旋转切换子视图
 - (void)exchangeSubviewWithSuperView:(UIView *)superView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.85];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:superView cache:YES];
    
    //切换该视图两个子视图的索引位置
    [superView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    [UIView commitAnimations];
}
 
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.redPacketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.redBgView);
    }];
    
    [self.redPacketImageOpenedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.redBgView);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redPacketImageView.mas_bottom).offset(44);
        make.centerX.equalTo(self);
    }];
}

+ (void)showRedPacketJoinView:(UIView *)view margin:(CGFloat )margin
{
    [self hide];
    
    redPacketsView = [[GBRedPacketsView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    redPacketsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    redPacketsView.centerX = KEYWINDOW.centerX;
    redPacketsView.centerY = KEYWINDOW.centerY + margin;
    [KEYWINDOW addSubview:redPacketsView];
    [KEYWINDOW bringSubviewToFront:redPacketsView];
    
}

+ (void)hide {
    if (redPacketsView) {
        [redPacketsView removeFromSuperview];
    }
}

- (void)close {
    [UIView transitionWithView:self duration:.75 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (redPacketsView) {
            [redPacketsView removeFromSuperview];
        }
    }];
    
    
}

- (UIView *)redBgView {
    if (!_redBgView) {
        _redBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,329,317)];
    }
    
    return _redBgView;
}

@end
