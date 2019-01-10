//
//  AppDelegate+JPushAnalyticsService.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "AppDelegate+JPushAnalyticsService.h"
#import "JPUSHService.h"

/**
 推送、统计相关在这里处理
 */
@interface AppDelegate (JPushAnalyticsService)<JPUSHRegisterDelegate>

/** 极光推送服务 */
- (void)setupJPushService:(NSDictionary *)launchOptions;

/** 初始化极光统计 */
- (void)setupJAnalytics;
/** 注册事件 */
- (void)setupJAnalyticsRegisterEvent;
/** 页面流统计开始 */
- (void)startLogPageView:(NSString *)pageName;
/** 页面流统计结束 */
- (void)stopLogPageView:(NSString *)pageName;
/** 计数事件 */
- (void)setupJAnalyticsCountEvent:(NSString *)eventId;
/** 购买事件 */
- (void)setupJAnalyticsPurchaseEvent:(NSDictionary *)purchaseParam;
/** 用户信息统计 */
- (void)setupJAnalyticsUserInfoEvent;

@end
