//
//  LCLoginViewModel.m
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2018/84.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import "GBLoginViewModel.h"

@implementation GBLoginViewModel

/** 注册 */
- (void)loginRequestRegister:(NSString *)loginName password:(NSString *)password smsCode:(NSString *)smsCode {
    NSDictionary *params = @{
                             @"tel":loginName,
                             @"password":password,
                             @"smsCode":smsCode
                             };
    NSLog(@"注册%@",params);
    [[NetDataServer sharedInstance] requestURL:URL_Login_Register httpMethod:@"POST" headerParams:nil params:params file:nil success:^(id responseData) {
        NSLog(@"注册responseData = %@",responseData);
        
        if ([responseData[@"result"] intValue] == 1) {
            // 注册成功，自动调用登录
            [self loginRequestLoginName:loginName password:password];
        }else {
            [UIView showHubWithTip:GBNSStringFormat(@"%@", responseData[@"msg"])];
        }
    } fail:^(NSError *error) {
        [UIView showHubWithTip:[NSString stringWithFormat:@"%@",error]];
        NSLog(@"注册error = %@",error);
    }];
}

/** 账号密码登录 */
- (void)loginRequestLoginName:(NSString *)loginName password:(NSString *)password {
    NSDictionary *params = @{
                             @"tel":loginName,
                             @"password":password,
                             };
    NSLog(@"登录%@",params);
    [[NetDataServer sharedInstance] requestURL:URL_Login httpMethod:@"POST" headerParams:@{@"platform":@"1"} params:params file:nil success:^(id responseData) {
        NSLog(@"密码登录responseData = %@",responseData);
        
        if ([responseData[@"result"] intValue] == 1) {
            /**登录成功*/
            UserModel *user = [UserModel mj_objectWithKeyValues:[responseData objectForKey:@"data"]];
            [userManager saveCurrentUser:user];
            
            [GBUserDefaults setObject:responseData[@"data"][@"token"] forKey:UDK_UserToken];
            [GBUserDefaults setObject:responseData[@"data"][@"userId"] forKey:UDK_UserId];
            
            [GBUserDefaults synchronize];
            
            self.returnBlock(responseData);
        }else {
            [UIView showHubWithTip:GBNSStringFormat(@"%@", responseData[@"msg"])];
        }
    } fail:^(NSError *error) {
        [UIView showHubWithTip:[NSString stringWithFormat:@"%@",error]];
        NSLog(@"密码登录error = %@",error);
    }];
}

/** 验证码登录 */
- (void)loginRequestLoginName:(NSString *)loginName smsCode:(NSString *)smsCode {
    NSDictionary *params = @{
                             @"tel":loginName,
                             @"smsCode":smsCode
                             };
    NSLog(@"验证码登录%@",params);
    [[NetDataServer sharedInstance] requestURL:URL_Login httpMethod:@"POST" headerParams:@{@"platform":@"1"} params:params file:nil success:^(id responseData) {
        NSLog(@"登录responseData = %@",responseData);
        
        if ([responseData[@"result"] intValue] == 1) {
            /**登录成功*/
            UserModel *user = [UserModel mj_objectWithKeyValues:[responseData objectForKey:@"data"]];
            [userManager saveCurrentUser:user];
            
            [GBUserDefaults setObject:responseData[@"data"][@"token"] forKey:UDK_UserToken];
            [GBUserDefaults setObject:responseData[@"data"][@"userId"] forKey:UDK_UserId];
            
            [GBUserDefaults synchronize];
            
            self.returnBlock(responseData);
        }else {
            [UIView showHubWithTip:GBNSStringFormat(@"%@", responseData[@"msg"])];
        }
    } fail:^(NSError *error) {
        [UIView showHubWithTip:[NSString stringWithFormat:@"%@",error]];
        NSLog(@"验证码登录error = %@",error);
    }];
}

/** 获取验证码 */
- (void)loadRequestCheckCode:(NSString *)mobile type:(NSString *)type {
    NSDictionary *params = @{
                             @"tel":mobile,
                             @"type":type
                             };
    NSLog(@"登录%@",params);
    [[NetDataServer sharedInstance] requestURL:URL_Login_Code httpMethod:@"POST" headerParams:nil params:params file:nil success:^(id responseData) {
        NSLog(@"登录验证码responseData = %@",responseData);
        if ([responseData[@"result"] intValue] == 1) {
            [UIView showHubWithTip:@"验证码已发送"];
            self.returnBlock(responseData);
        }else {
            [UIView showHubWithTip:GBNSStringFormat(@"%@",responseData[@"msg"])];
        }
    } fail:^(NSError *error) {
        NSLog(@"登录error = %@",error);
        
    }];
}

/** 检测账号是否已注册 */
- (void)chekLoginName:(NSString *)loginName {
    NSDictionary *params = @{
                             @"tel":loginName,
                             };
    NSLog(@"检测账号%@",params);
    [[NetDataServer sharedInstance] requestURL:URL_Login_CheckRegister httpMethod:@"POST" headerParams:nil params:params file:nil success:^(id responseData) {
        NSLog(@"检测账号responseData = %@",responseData);
        if ([responseData[@"result"] intValue] == 1) {
            self.returnBlock(responseData);
        }else {
            [UIView showHubWithTip:GBNSStringFormat(@"%@",responseData[@"msg"])];
        }
    } fail:^(NSError *error) {
        NSLog(@"检测账号error = %@",error);
        
    }];
}

/** 第三方登录 */
- (void)thirdLogin:(NSString *)nickName sex:(NSString *)sex openId:(NSString *)openId address:(NSString *)address origin:(NSString *)origin avatar:(NSString *)avatar {
//    NSDictionary *params = @{
//                             @"nickName":nickName,
//                             @"sex":sex,
//                             @"openId":openId,
//                             @"address":address,
//                             @"origin":origin,
//                             @"avatar":avatar,
//                             };
//    NSLog(@"第三方登录注册%@",params);
//    [[NetDataServer sharedInstance] requestURL:POST_ThIRD_LOGIN httpMethod:@"POST" headerParams:@{@"term_id":@"_APPIOS_"} params:params file:nil success:^(id responseData) {
//        NSLog(@"第三方登录注册responseData = %@",responseData);
//        [SVProgressHUD dismiss];
//        if ([responseData[@"code"] intValue] == 0) {
//            [UIView showHubWith:@"登录成功" andTimeintevel:1.5];
//            //保存用户信息
//            LCUserInfo *userInfo;
//            userInfo = [LCUserInfo mj_objectWithKeyValues:responseData[@"data"]];
//
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{//异步保存
//                [userInfo save];
//            });
//
//            [NSUDF setObject:responseData[@"token"] forKey:@"token"];
//            [NSUDF setObject:responseData[@"data"][@"id"] forKey:@"userId"];
//
//            [NSUDF synchronize];
//            // socket连接
//            [[LCSocketManager sharedInstance] lc_webSocketConnect];
//
//            [NSNOTFC postNotificationName:kNotificationCartCountUpdate object:nil];
//
//            self.returnBlock(responseData);
//        }else {
//            [UIView showHubWith:[NSString stringWithFormat:@"%@",responseData[@"msg"]] andTimeintevel:2.0];
//        }
//
//    } fail:^(NSError *error) {
//        NSLog(@"注册error = %@",error);
//
//    }];
}


/** 校验第三方登录是否绑定过手机号 */
- (void)checkThirdLogin:(NSString *)openId origin:(NSString *)origin {
//    NSDictionary *params = @{
//                             @"unionId":openId,
//                             @"origin":origin,
//                             };
//    NSLog(@"校验第三方登录是否绑定过手机号%@",params);
//    [[NetDataServer sharedInstance] requestURL:POST_ThIRD_LOGIN_HASPHONE httpMethod:@"POST" headerParams:@{@"term_id":@"_APPIOS_"} params:params file:nil success:^(id responseData) {
//        NSLog(@"校验第三方登录是否绑定过手机号responseData = %@",responseData);
//        [SVProgressHUD dismiss];
//        // 绑定过直接登录
//        if ([responseData[@"code"] intValue] == 0) {
//            [UIView showHubWith:@"登录成功" andTimeintevel:1.5];
//            //保存用户信息
//            LCUserInfo *userInfo;
//            userInfo = [LCUserInfo mj_objectWithKeyValues:responseData[@"data"]];
//
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{//异步保存
//                [userInfo save];
//            });
//
//            [NSUDF setObject:responseData[@"token"] forKey:@"token"];
//            [NSUDF setObject:responseData[@"data"][@"id"] forKey:@"userId"];
//
//            [NSUDF synchronize];
//            // socket连接
//            [[LCSocketManager sharedInstance] lc_webSocketConnect];
//            self.returnBlock(responseData);
//
//            [NSNOTFC postNotificationName:kNotificationCartCountUpdate object:nil];
//        }else {
//            self.returnBlock(nil);
//        }
//
//    } fail:^(NSError *error) {
//        NSLog(@"注册error = %@",error);
//
//    }];
}

/** 第三方登录手机号绑定 */
- (void)thirdLogin:(NSString *)openId phone:(NSString *)phone code:(NSString *)code origin:(NSString *)origin {
//    NSDictionary *params = @{
//                             @"unionId":openId?openId:@"",
//                             @"code":code,
//                             @"phone":phone,
//                             @"origin":origin?origin:@"",
//                             };
//    NSLog(@"第三方登录绑定手机号%@",params);
//    [[NetDataServer sharedInstance] requestURL:POST_ThIRD_LOGIN_UPDATEPHONE httpMethod:@"POST" headerParams:@{@"term_id":@"_APPIOS_"} params:params file:nil success:^(id responseData) {
//        NSLog(@"第三方登录绑定手机responseData = %@",responseData);
//        [SVProgressHUD dismiss];
//        if ([responseData[@"code"] intValue] == 0) {
//            [UIView showHubWith:@"绑定成功" andTimeintevel:1.5];
//            //保存用户信息
//            LCUserInfo *userInfo;
//            userInfo = [LCUserInfo mj_objectWithKeyValues:responseData[@"data"]];
//
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{//异步保存
//                [userInfo save];
//            });
//
//            [NSUDF setObject:responseData[@"token"] forKey:@"token"];
//            [NSUDF setObject:responseData[@"data"][@"id"] forKey:@"userId"];
//
//            [NSUDF synchronize];
//            // socket连接
//            [[LCSocketManager sharedInstance] lc_webSocketConnect];
//
//            [NSNOTFC postNotificationName:kNotificationCartCountUpdate object:nil];
//
//            self.returnBlock(responseData);
//        }else {
//            [UIView showHubWith:[NSString stringWithFormat:@"%@",responseData[@"msg"]] andTimeintevel:2.0];
//        }
//
//    } fail:^(NSError *error) {
//        NSLog(@"注册error = %@",error);
//
//    }];
}

/** 注册 （现在去掉注册功能了） */
- (void)registRequestWithLoginName:(NSString *)loginName password:(NSString *)password code:(NSString *)code {
//    NSDictionary *params = @{
//                             @"loginName":loginName,
//                             @"password":password.md5Str,  //MD5加密
//                             @"code":code
//                             };
//    NSLog(@"注册%@",params);
//    [[NetDataServer sharedInstance] requestURL:POST_REGISTRA_USER httpMethod:@"POST" headerParams:@{@"term_id":@"_APPIOS_"} params:params file:nil success:^(id responseData) {
//        NSLog(@"注册responseData = %@",responseData);
//        [SVProgressHUD dismiss];
//        if ([responseData[@"code"] intValue] == 0) {
//            [UIView showHubWith:@"注册成功" andTimeintevel:2.0];
//
//            //保存用户信息
//            LCUserInfo *userInfo;
//            userInfo = [LCUserInfo mj_objectWithKeyValues:responseData[@"data"]];
//
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{//异步保存
//                [userInfo save];
//            });
//
//            [NSUDF setObject:responseData[@"token"] forKey:@"token"];
//            [NSUDF setObject:responseData[@"data"][@"id"] forKey:@"userId"];
//
//            [NSUDF synchronize];
//            // socket连接
//            [[LCSocketManager sharedInstance] lc_webSocketConnect];
//
//            [NSNOTFC postNotificationName:kNotificationCartCountUpdate object:nil];
//
//            self.returnBlock(responseData);
//
//        }else {
//            [UIView showHubWith:[NSString stringWithFormat:@"%@",responseData[@"msg"]] andTimeintevel:2.0];
//        }
//
//    } fail:^(NSError *error) {
//        NSLog(@"注册error = %@",error);
//
//    }];
}

/** 忘记密码 */
- (void)forgetPassWordRequestWithLoginName:(NSString *)loginName password:(NSString *)password code:(NSString *)code {
//    NSDictionary *params = @{
//                             @"loginName":loginName,
//                             @"password":password.md5Str,  //MD5加密
//                             @"code":code
//                             };
//    NSLog(@"更改密码%@",params);
//    [[NetDataServer sharedInstance] requestURL:POST_UPDATE_USER_PASSWORD httpMethod:@"POST" headerParams:@{@"term_id":@"_APPIOS_"} params:params file:nil success:^(id responseData) {
//        NSLog(@"更改密码responseData = %@",responseData);
//        [SVProgressHUD dismiss];
//        if ([responseData[@"code"] intValue] == 0) {
//            self.returnBlock(responseData);
//        }else {
//            [UIView showHubWith:responseData[@"msg"] andTimeintevel:2.0];
//        }
//    } fail:^(NSError *error) {
//        NSLog(@"注册error = %@",error);
//
//    }];

}



/** 用户登出 */
- (void)loginOutRequestWithToken:(NSString *)token {
//    NSDictionary *params = @{
//                             @"token":token,
//                             };
//    NSLog(@"用户登出%@",params);
//    [[NetDataServer sharedInstance] requestURL:POST_REGISTRA_USER httpMethod:@"POST" headerParams:@{@"term_id":@"_APPIOS_"} params:params file:nil success:^(id responseData) {
//        NSLog(@"用户登出responseData = %@",responseData);
//        [SVProgressHUD dismiss];
//        if ([responseData[@"code"] intValue] == 0) {
//            [UIView showHubWith:@"成功退出" andTimeintevel:2.0];
//        }else {
//            [UIView showHubWith:responseData[@"msg"] andTimeintevel:2.0];
//        }
//
//    } fail:^(NSError *error) {
//        NSLog(@"用户登出error = %@",error);
//
//    }];
}

@end
