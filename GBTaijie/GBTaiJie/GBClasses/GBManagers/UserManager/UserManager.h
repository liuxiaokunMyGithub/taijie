//
//  UserManager.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "IMManager.h"

typedef NS_ENUM(NSInteger, UserLoginType){
    kUserLoginTypeUnKnow = 0,//未知
    kUserLoginTypeWeChat,//微信登录
    kUserLoginTypeQQ,///QQ登录
    kUserLoginTypePwd,///账号登录
};

typedef void (^loginBlock)(BOOL success, NSString * des);

#define isIMLogin [UserManager sharedUserManager].isIMLogined
#define curUser [UserManager sharedUserManager].curUserInfo
#define userManager [UserManager sharedUserManager]

static UserModel *currentUser = nil;

/**
 包含用户相关服务
 */
@interface UserManager : NSObject
//单例
InterfaceSingleton(UserManager);


@property (nonatomic, assign) UserLoginType loginType;
@property (nonatomic, assign) BOOL isIMLogined;

#pragma mark - ——————— 登录相关 ————————

- (void)saveCurrentUser:(UserModel *)user;

//当前用户
- (UserModel *)currentUser;

+ (void)synchronize;
+ (id)getValueforKey:(NSString*)key;
+ (void)synSetValue:(id)value forKey:(NSString*)key;

// 判断用户是否允许程序接收推送
- (BOOL)isAllowedNotification;

/**
 三方登录

 @param loginType 登录方式
 @param completion 回调
 */
- (void)login:(UserLoginType )loginType completion:(loginBlock)completion;

/**
 自动登录IM服务

 @param completion 回调
 */
-(void)autoLoginToIMServer:(loginBlock)completion;

/**
 退出登录

 @param completion 回调
 */
- (void)logout:(loginBlock)completion;

@end
