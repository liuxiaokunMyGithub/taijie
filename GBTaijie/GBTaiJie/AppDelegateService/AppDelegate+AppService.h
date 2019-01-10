//
//  AppDelegate+AppService.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/25.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)
// 初始化登录及网络监听服务
- (void)initService;

//监听网络状态
- (void)monitorNetworkStatus;

#pragma mark ————— 初始化APP启动根视图 —————
- (void)initAppLaunchRootView;

@end
