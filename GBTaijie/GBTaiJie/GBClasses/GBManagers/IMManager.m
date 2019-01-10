//
//  IMManager.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "IMManager.h"

@interface IMManager ()<JMessageDelegate>

@end

@implementation IMManager

ImplementationSingleton(IMManager);

#pragma mark ————— 初始化IM —————
- (void)setupConversation:(NSString *)userName {
    JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:userName];

    if (conversation == nil) {
        [JMSGConversation createSingleConversationWithUsername:userName completionHandler:^(id resultObject, NSError *error) {
            if (error) {
                NSLog(@"创建会话失败 error%@",error);
                return ;
            }
            
            ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
            conversationVC.conversation = resultObject;
            [[GBAppHelper getPushNavigationContr] pushViewController:conversationVC animated:YES];
        }];
    }else {
        ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
        conversationVC.conversation = conversation;
        [[GBAppHelper getPushNavigationContr] pushViewController:conversationVC animated:YES];
    }
}

#pragma mark ————— IM登录 —————
- (void)IMLogin:(NSString *)IMID IMPwd:(NSString *)IMPwd completion:(loginBlock)completion {
    //SDK：登录
    [JMSGUser loginWithUsername:IMID password:IMPwd completionHandler:^(id resultObject, NSError *error)   {
        if (!error) {
            NSLog(@"IM登录成功");
            if (completion) {
                completion(YES,nil);
            }
        } else {
            NSLog(@"IM登录失败%@",error);
            if (completion) {
                completion(NO,nil);
            }
        }
    }];
}

#pragma mark ————— IM退出 —————
- (void)IMLogout {
    // 清除用户IM本地头像
    [GBUserDefaults removeObjectForKey:UDK_CurrentUserImAvatar];
    [GBUserDefaults synchronize];
    // 退出IM
    [JMSGUser logout:^(id resultObject, NSError *error) {
        if (!error){
            NSLog(@"IM 退出成功");
        }else {
            NSLog(@"IM 退出失败 code: %@",error);
        }
    }];
}

// 当前用户IM头像
- (UIImage *)currentUserImAvatar {
    if(currentUserImAvatar == nil){
        currentUserImAvatar = [DCSpeedy Base64StrToUIImage:ValidStr([GBUserDefaults objectForKey:UDK_CurrentUserImAvatar]) ? [GBUserDefaults objectForKey:UDK_CurrentUserImAvatar] : @""];
    }
    
    return currentUserImAvatar;
}

/** 更新当前用户本地IM头像 */
- (void)updateCurrentUserLocalImAvatar {
    // 重置
    currentUserImAvatar = nil;
    
    UIImage *imAvatar = [UIImage getImageURL:GBImageURL(userManager.currentUser.headImg)];
    [GBUserDefaults setObject:[DCSpeedy UIImageToBase64Str:imAvatar] forKey:UDK_CurrentUserImAvatar];
    [GBUserDefaults synchronize];
}

/** 更新用户IM信息 */
- (void)updateIMUserInfo:(id)parameter userFieldType:(JMSGUserField)type {
    [JMSGUser updateMyInfoWithParameter:parameter userFieldType:type completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"用户IM信息更新成功");
            if (type == kJMSGUserFieldsAvatar) {
                // 更新当前用户本地IM头像
                [self updateCurrentUserLocalImAvatar];
            }
        } else {
            NSLog(@"用户IM信息更新失败error:%@",error);
        }
    }];
}

/** 更新未读消息数 */
- (void)saveUpdateBadge:(NSInteger)badge {
    [GBUserDefaults setObject:[NSString stringWithFormat:@"%zd",badge] forKey:UDK_CurrentUserImBadge];
    [GBUserDefaults synchronize];
}

/** 获取未读消息数 */
- (NSString *)getImBadge {
    return [GBUserDefaults stringForKey:UDK_CurrentUserImBadge] ? [GBUserDefaults stringForKey:UDK_CurrentUserImBadge] : @"";
}

@end
