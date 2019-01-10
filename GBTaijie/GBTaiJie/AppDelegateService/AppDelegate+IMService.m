//
//  AppDelegate+IMService.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "AppDelegate+IMService.h"

@interface AppDelegate ()<JMessageDelegate>

@end

@implementation AppDelegate (IMService)

/** 设置极光SDK */
- (void)setupIMSDK:(NSDictionary *)launchOptions {
    NSLog(@"设置极光IMSDK ：launchOptions %@",launchOptions);
    // 关闭SDK的日志
    [JMessage setLogOFF];
    // Required - 添加 JMessage SDK 监听。这个动作放在启动前
    [JMessage addDelegate:self withConversation:nil];
    // Required - 启动 JMessage SDK
    [JMessage setupJMessage:launchOptions
                     appKey:JGuang_APP_KEY
                    channel:@"App Store"
           apsForProduction:YES
                   category:nil
             messageRoaming:NO];
    // Required - 注册 APNs 通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    }
    
    [self registerJPushStatusNotification];
}

- (void)registerJPushStatusNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJMSGNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkIsConnecting:)
                          name:kJMSGNetworkIsConnectingNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJMSGNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJMSGNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJMSGNetworkDidLoginNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(receivePushMessage:)
                          name:kJMSGNetworkDidReceiveMessageNotification
                        object:nil];
    
}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"Event - networkDidSetup 已连接");
}

- (void)networkIsConnecting:(NSNotification *)notification {
    NSLog(@"Event - networkIsConnecting");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"Event - networkDidClose 未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"Event - networkDidRegister 已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"Event - networkDidLogin 已登录");
}

- (void)receivePushMessage:(NSNotification *)notification {
    NSLog(@"Event - receivePushMessage");
    
    NSDictionary *info = notification.userInfo;
    if (info) {
        NSLog(@"The message - %@", info);
    } else {
        NSLog(@"Unexpected - no user info in jpush mesasge");
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken %@",deviceToken);
    // Required - 注册token
    [JMessage registerDeviceToken:deviceToken];
}

# pragma - mark JMessageDelegate
// 当前用户登录状态变更事件，在 JMSGUserDelegate 类
- (void)onReceiveLoginUserStatusChangeEvent:(JMSGUserLoginStatusChangeEvent *)event {
    NSLog(@"\n ===当前登录用户状态变更事件===\n");
    switch (event.eventType) {
        case kJMSGEventNotificationLoginKicked:
            NSLog(@"login user notification event: Kicked.");
            break;
        case kJMSGEventNotificationServerAlterPassword:
            NSLog(@"login user notification event: alter password.");
            break;
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"login user notification event: status unexpected.");
            // 用户登录状态异常事件（需要重新登录）
            [userManager autoLoginToIMServer:nil];
            break;
        case kJMSGEventNotificationCurrentUserDeleted:
            NSLog(@"login user notification event: deleted.");
            break;
        case kJMSGEventNotificationCurrentUserDisabled:
            NSLog(@"login user notification event: disabled.");
            break;
        case kJMSGEventNotificationCurrentUserInfoChange:
            NSLog(@"login user notification event: info change.");
            break;
        default:
            break;
    }
    
    if (event.eventType == kJMSGEventNotificationCurrentUserInfoChange) {
        //当前用户信息更新了
    }else{
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert setHorizontalButtons:YES];
        
        [alert addButton:@"取消" actionBlock:nil];
        [alert addButton:@"确定" actionBlock:^{
            [userManager logout:nil];
        }];
        alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromBottom;
        alert.customViewColor = [UIColor kBaseColor];
        [alert showQuestion:GBRootViewController title:@"登录状态出错" subTitle:event.eventDescription closeButtonTitle:nil duration:0.0f];
    }
}

// 好友相关事件
- (void)onReceiveFriendNotificationEvent:(JMSGFriendNotificationEvent *)event {
    NSLog(@"\n ===好友相关事件===\n:");
    SInt32 eventType = (JMSGEventNotificationType)event.eventType;
    switch (eventType) {
        case kJMSGEventNotificationReceiveFriendInvitation:
        case kJMSGEventNotificationAcceptedFriendInvitation:
        case kJMSGEventNotificationDeclinedFriendInvitation:
        case kJMSGEventNotificationDeletedFriend: {
            NSLog(@"Friend Notification Event");
//            [[NSNotificationCenter defaultCenter] postNotificationName:kFriendInvitationNotification object:event];
        }
            break;
        case kJMSGEventNotificationReceiveServerFriendUpdate:
            NSLog(@"Receive Server Friend update Notification Event");
            break;
        default:
            break;
    }
}

@end
