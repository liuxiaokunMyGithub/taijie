//
//  AppDelegate+AppService.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/25.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "GBBaseNavigationController.h"
// 登录验证
#import "GBLoginFirstPageViewController.h"
// 广告页
#import "AdPageView.h"
#import "LCBassLaunchAdManager.h"

@implementation AppDelegate (AppService)

#pragma mark ————— 初始化服务 —————
- (void)initService {
    //注册登录状态监听
    [GBNotificationCenter addObserver:self
                             selector:@selector(loginStateChange:)
                                 name:LoginStateChangeNotification
                               object:nil];
    
    //网络状态监听
    [GBNotificationCenter addObserver:self
                             selector:@selector(netWorkStateChange:)
                                 name:NetWorkStateChangeNotification
                               object:nil];
}

#pragma mark ————— 初始化根视图 —————
- (void)initAppLaunchRootView {
    // MARK: 启动页
    [[LCBassLaunchAdManager shareManager] setupXHLaunchAd];
    [[LCBassLaunchAdManager shareManager] setLaunchAdShowFinishBlock:^{
        // 启动页完成开启登录页动画
        //            GBPostNotification(LoginAnimationNotification, nil);
        //            self.mainTabBarController = [GBMainTabBarController new];
        //            self.window.rootViewController = self.mainTabBarController;
    }];
    //        // 进入登录页
    //        GBPostNotification(LoginStateChangeNotification, @NO);
    //    }
    self.mainTabBarController = [GBMainTabBarController new];
    self.window.rootViewController = self.mainTabBarController;
    
    //自动登录IM
    [userManager autoLoginToIMServer:nil];
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification {
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {
        [GBUserDefaults setObject:@"Login_First" forKey:UDK_Login_First];
        [GBUserDefaults synchronize];
        // 登录成功加载主窗口控制器
        if (!self.mainTabBarController || ![self.window.rootViewController isKindOfClass:[GBMainTabBarController class]]) {
            self.mainTabBarController = [GBMainTabBarController new];
            self.window.rootViewController = self.mainTabBarController;
        }
        
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
            // 更新极光registrationID
            [self loadRequestRegIdRenewal:registrationID];
        }];
        
        // 自动登录IM
        [userManager autoLoginToIMServer:nil];
        // 更新当前用户IM本地头像
        [[IMManager sharedIMManager] updateCurrentUserLocalImAvatar];
    }else {
        // 未登录加载登陆页面控制器
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            GBPostNotification(LoginAnimationNotification, nil);
        });
        
        self.mainTabBarController = nil;
        GBBaseNavigationController *loginNavi = [[GBBaseNavigationController alloc] initWithRootViewController:[GBLoginFirstPageViewController new]];
        self.window.rootViewController = loginNavi;
    }
}

- (void)loadRequestRegIdRenewal:(NSString *)registrationID {
    GBCommonViewModel *commonVM = [[GBCommonViewModel alloc] init];
    [commonVM loadRequestRegIdRenewal:registrationID];
    [commonVM setSuccessReturnBlock:^(id returnValue) {
        
    }];
}

#pragma mark ————— 网络状态变化通知 —————
- (void)netWorkStateChange:(NSNotification *)notification {
    BOOL isNetWork = [notification.object boolValue];
    if (isNetWork) {
        //有网络
        if (userManager.currentUser && !isIMLogin) {
            //有用户数据 并且 IM未登录成功 重新来一次IM自动登录
            [userManager autoLoginToIMServer:nil];
        }
    }else {
        // 断网提示
        [UIView showHubWithTip:@"网络状态不佳"];
    }
}

#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus {
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [NetDataServer networkStatusWithBlock:^(NetworkStatusType networkStatus) {
        switch (networkStatus) {
                // 未知网络
            case NetworkStatusUnknown:
                NSLog(@"网络环境：未知网络");
                GBPostNotification(NetWorkStateChangeNotification, @NO);
                // 无网络
            case NetworkStatusNotReachable:
                NSLog(@"网络环境：无网络");
                GBPostNotification(NetWorkStateChangeNotification, @NO);
                break;
                // 手机网络
            case NetworkStatusReachableViaWWAN:
                NSLog(@"网络环境：手机自带网络");
                GBPostNotification(NetWorkStateChangeNotification, @YES);
                // 无线网络
            case NetworkStatusReachableViaWiFi:
                NSLog(@"网络环境：WiFi");
                GBPostNotification(NetWorkStateChangeNotification, @YES);
                break;
        }
    }];
}


@end
