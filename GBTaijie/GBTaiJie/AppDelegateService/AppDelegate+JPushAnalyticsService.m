//
//  AppDelegate+JPushAnalyticsService.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 极光相关服务
//  @discussion 推送，统计
//

#import "AppDelegate+JPushAnalyticsService.h"
#import "GBMessageViewController.h"

@implementation AppDelegate (JPushAnalyticsService)

//*------------------
// MARK: 统计
//-------------------*

/** 初始化极光统计 */
- (void)setupJAnalytics {
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
    config.appKey = JGuang_APP_KEY;
    config.channel = @"App Store";
    [JANALYTICSService setupWithConfig:config];
}

/** 注册事件 */
- (void)setupJAnalyticsRegisterEvent {
    JANALYTICSRegisterEvent * event = [[JANALYTICSRegisterEvent alloc] init];
    event.success = YES;
    event.method = @"MobileVerificationCode";
    [JANALYTICSService eventRecord:event];
}

/** 页面流统计开始 */
- (void)startLogPageView:(NSString *)pageName {
    [JANALYTICSService startLogPageView:pageName];
}

/** 页面流统计结束 */
- (void)stopLogPageView:(NSString *)pageName {
    [JANALYTICSService stopLogPageView:pageName];
}

/** 计数事件 */
- (void)setupJAnalyticsCountEvent:(NSString *)eventId {
    JANALYTICSCountEvent * event = [[JANALYTICSCountEvent alloc] init];
    event.eventID = eventId;
    [JANALYTICSService eventRecord:event];
}

/** 购买事件 */
- (void)setupJAnalyticsPurchaseEvent:(NSDictionary *)purchaseParam {
    JANALYTICSPurchaseEvent * event = [[JANALYTICSPurchaseEvent alloc] init];
    event.success = YES;
    event.price = [purchaseParam[@"price"] floatValue];
    event.goodsName = purchaseParam[@"goodsName"];
    event.goodsType = purchaseParam[@"goodsType"];
    event.quantity = 1;
    event.goodsID = purchaseParam[@"goodsID"];
    event.currency = JANALYTICSCurrencyCNY;
    event.extra = @{@"用户ID":userManager.currentUser.userId};
    [JANALYTICSService eventRecord:event];
}

/** 用户信息统计 */
- (void)setupJAnalyticsUserInfoEvent {
    JANALYTICSUserInfo * userinfo = [[JANALYTICSUserInfo alloc] init];
    userinfo.accountID = userManager.currentUser.userId;
    userinfo.sex = [userManager.currentUser.sex isEqualToString:@"MALE"] ? JANALYTICSSexMale : [userManager.currentUser.sex isEqualToString:@"FEMALE"] ? JANALYTICSSexFemale : JANALYTICSSexUnknown;
    userinfo.birthdate = userManager.currentUser.birthday;
    [userinfo setExtraObject:@"extraObj1" forKey:@"extrakey1"];
    [JANALYTICSService identifyAccount:userinfo with:^(NSInteger err, NSString *msg) {
        if (err) {
            NSLog(@"identify ERR:%ld|%@", (long)err, msg);
        }else {
            NSLog(@"identify success");
        }
    }];
}

//*------------------
// MARK: 推送
//-------------------*

/** 初始化极光推送服务 */
- (void)setupJPushService:(NSDictionary *)launchOptions {
    // 设置apns
    [self setupAPNS];
    // 设置推送服务
    [self setupJPush:launchOptions];
}

- (void)setupAPNS {
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}

// 设置推送服务
- (void)setupJPush:(NSDictionary *)launchOptions {
    // MARK: TODO:发布上线需改配置
    [JPUSHService setupWithOption:launchOptions
                           appKey:JGuang_APP_KEY
                          channel:@"App Store"
                 apsForProduction:YES];
}

/** App系统通知 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    // 更新未读消息数
    NSInteger imBadge = [[[IMManager sharedIMManager] getImBadge] intValue] +1;
    [[IMManager sharedIMManager] saveUpdateBadge:imBadge];
    
    // 如果是由后台通知打开的,application状态会为UIApplicationStateInactive
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        GBMessageViewController *systemMessageVC = [[GBMessageViewController alloc] init];
        [[GBAppHelper getPushNavigationContr] pushViewController:systemMessageVC animated:YES];
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        // 如果当前app处于前台, application状态会为 UIApplicationStateActive,
        //        [GBRootViewController AlertWithTitle:@"收到通知" message:userInfo[@"aps"][@"alert"] andOthers:@[@"取消",@"打开"] animated:YES action:^(NSInteger index) {
        //            if (index == 1) {
        //                GBSystemMessageViewController *systemMessageVC = [[GBSystemMessageViewController alloc] init];
        //                [[GBAppHelper getPushNavigationContr] pushViewController:systemMessageVC animated:YES];
        //            }
        //        }];
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    [GBNotificationCenter postNotificationName:MineMessageBadgeRefreshNotification object:nil];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#pragma mark- JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"JPUSHRegisterDelegate ~~~ iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }else {
        // 收到推送的请求
        UNNotificationRequest *request = notification.request;
        // 收到推送的消息内容
        UNNotificationContent *content = request.content;
//        // 推送消息的角标
//        NSNumber *badge = content.badge;
//        // 推送消息体
//        NSString *body = content.body;
//        // 推送消息的声音
//        UNNotificationSound *sound = content.sound;
//        // 推送消息的副标题
//        NSString *subtitle = content.subtitle;
//        // 推送消息的标题
//        NSString *title = content.title;
//
//        // 判断为本地通知
//        NSLog(@"JPUSHRegisterDelegate ~~~ iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        NSLog(@"本地推送%@",content);
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"JPUSHRegisterDelegate ~~~ iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }else {
        // 收到推送的请求
        UNNotificationRequest *request = response.notification.request;
        // 收到推送的消息内容
        UNNotificationContent *content = request.content;
//        // 推送消息的角标
//        NSNumber *badge = content.badge;
//        // 推送消息体
//        NSString *body = content.body;
//        // 推送消息的声音
//        UNNotificationSound *sound = content.sound;
//        // 推送消息的副标题
//        NSString *subtitle = content.subtitle;
//        // 推送消息的标题
//        NSString *title = content.title;
//
//        // 判断为本地通知
//        NSLog(@"JPUSHRegisterDelegate ~~~ iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        NSLog(@"本地通知%@",content);
    }
    
    // 系统要求执行这个方法
    completionHandler();
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    
    return str;
}

@end
