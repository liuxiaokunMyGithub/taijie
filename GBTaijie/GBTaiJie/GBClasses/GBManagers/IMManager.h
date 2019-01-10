//
//  IMManager.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewController.h"

typedef void (^loginBlock)(BOOL success, NSString * des);

static UIImage *currentUserImAvatar = nil;

/**
 IM服务与管理
 */
@interface IMManager : NSObject

InterfaceSingleton(IMManager);

 /** 设置会话 */
- (void)setupConversation:(NSString *)userName;

// 当前用户IM头像
- (UIImage *)currentUserImAvatar;

/** 更新当前用户本地IM头像 */
- (void)updateCurrentUserLocalImAvatar;

/**
 登录IM

 @param IMID IM账号
 @param IMPwd IM密码
 @param completion block回调
 */
- (void)IMLogin:(NSString *)IMID IMPwd:(NSString *)IMPwd completion:(loginBlock)completion;

/**
 退出IM
 */
- (void)IMLogout;

/** 更新用户IM信息 */
- (void)updateIMUserInfo:(id)parameter userFieldType:(JMSGUserField)type;
/** 保存更新IM未读消息数 */
- (void)saveUpdateBadge:(NSInteger)badge;
/** 获取未读消息数 */
- (NSString *)getImBadge;

@end
