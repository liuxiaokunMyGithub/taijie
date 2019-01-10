//
//  UserManager.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "UserManager.h"
//#import <UMSocialCore/UMSocialCore.h>

@implementation UserManager

ImplementationSingleton(UserManager);

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

// 保存用户信息
- (void)saveCurrentUser:(UserModel *)user {
    [[NSUserDefaults standardUserDefaults] setValue: (user == nil ? nil : [user keyedArchiverObject]) forKey:UDK_CurrentUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
    currentUser = user;
}

// 获取用户信息
- (UserModel *)currentUser {
    if(currentUser == nil){
        NSData* currentData = [[NSUserDefaults standardUserDefaults] valueForKey:UDK_CurrentUser];
        currentUser = [UserModel unarchiveObjectWithDate:currentData];
    }
    
    return currentUser;
}

+ (id)getValueforKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)synchronize {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)synSetValue:(id)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 判断用户是否允许程序接收推送
- (BOOL)isAllowedNotification {
    //ios8及以上
    UIUserNotificationSettings*settings=[UIApplication sharedApplication].currentUserNotificationSettings;
    if (settings.types != UIUserNotificationTypeNone) {
        return YES;
    }else
        return NO;
}

#pragma mark ————— 三方登录 —————
- (void)login:(UserLoginType )loginType completion:(loginBlock)completion {

}

#pragma mark ————— 自动登录IM服务 —————
- (void)autoLoginToIMServer:(loginBlock)completion {
    if(userManager.currentUser) {
        NSLog(@"userid %@",userManager.currentUser.userId);
        //登录IM
        [[IMManager sharedIMManager] IMLogin:userManager.currentUser.userId IMPwd:userManager.currentUser.userId completion:^(BOOL success, NSString *des) {
            if (success) {
                self.isIMLogined = YES;
            }
        }];
    }
}

#pragma mark ————— 退出登录 —————
- (void)logout:(void (^)(BOOL, NSString *))completion {
    [GBLoadingWaitView showCircleJoinView:KEYWINDOW isClearBackgoundColor:YES margin:0];
    // 清除消息提示
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    // 清除用户数据
    [GBUserDefaults removeObjectForKey:UDK_CurrentUser];
    [GBUserDefaults removeObjectForKey:UDK_UserToken];
    [GBUserDefaults removeObjectForKey:UDK_UserId];
    [GBUserDefaults synchronize];
    
    [self saveCurrentUser:nil];
    
    // 退出IM
    [[IMManager sharedIMManager] IMLogout];
    // 登录状态通知
    GBPostNotification(LoginStateChangeNotification, @NO)
    
    [GBLoadingWaitView hide];
    // 动画通知
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GBPostNotification(LoginAnimationNotification, nil);
    });
    
    self.isIMLogined = NO;
}

@end
