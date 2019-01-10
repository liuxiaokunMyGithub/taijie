//
//  AppDelegate.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/831.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"

#import "UIImage+GIF.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIView *lunchView;

@end

@implementation AppDelegate

/** MARK: 启动 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    // MARK: 开启容错机制
    [[AppManager sharedAppManager] openAvoidCrash];
    // MARK: 系统导航栏样式管理
    [[AppManager sharedAppManager] managerSystemNavBar];
    // MARK: 键盘管理
    [[AppManager sharedAppManager] managerKeyboard];
    // MARK: 极光分享
    [self setupJShareSDK];
    // MARK: 极光IM
    [self setupIMSDK:launchOptions];
    // MARK: 极光统计
    [self setupJAnalytics];
    // MARK: 初始化服务
    [self initService];
    // MARK: 网络监听
    [self monitorNetworkStatus];
    // MARK: 初始化启动根视图
    [self initAppLaunchRootView];
    // 渠道推广AppKey
    [ShareInstallSDK setAppKey:@"ABBK7EF7K77AK6" withDelegate:self WithOptions:launchOptions];
    
    return YES;
}

/** MARK: 即将激活 */
- (void)applicationWillResignActive:(UIApplication *)application {
    //重置JPush服务器上面的badge值。如果下次服务端推送badge传"+1",则会在你当时JPush服务器上该设备的badge值的基础上＋1；
    [JPUSHService setBadge:0];
}

/** MARK: 进入后台 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application cancelAllLocalNotifications];
}

/** MARK: 进入前台 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    } else {
        [application cancelAllLocalNotifications];
    }
}

/** MARK: 激活 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

/** MARK: 程序终止 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark ShareInstallDelegate - 渠道推广
- (void)getInstallParamsFromSmartInstall:(id) params withError:(NSError *)error {
    NSLog(@"安装参数params=%@",params);
}

- (void)getWakeUpParamsFromSmartInstall: (id) params withError: (NSError *)error {
    NSLog(@"唤醒参数params=%@",params);
}

@end
