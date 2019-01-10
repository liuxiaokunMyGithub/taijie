//
//  AppDelegate+ShareService.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "AppDelegate+ShareService.h"
#import "GBLoginViewController.h"

@implementation AppDelegate (ShareService)

/** 设置友盟SDK */
- (void)setupJShareSDK {
    NSLog(@"设置极光分享SDK");
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = JGuang_APP_KEY;
    // QQ
    config.QQAppId = QQ_APP_ID;
    config.QQAppKey = QQ_APP_Secret;
    // 微信
    config.WeChatAppId = WX_APP_ID;
    config.WeChatAppSecret = WX_APP_Secret;
    
    [JSHAREService setupWithConfig:config];
}

#pragma mark ————— OpenURL 回调 —————
//仅支持 iOS9 以上系统，iOS8 及以下系统不会回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    //判断是否通过ShareInstall URL Scheme 唤起App
    if ([ShareInstallSDK handLinkURL:url]) {
        return YES;
    }
    
    [JSHAREService handleOpenUrl:url];
    
    return YES;
}

@end
