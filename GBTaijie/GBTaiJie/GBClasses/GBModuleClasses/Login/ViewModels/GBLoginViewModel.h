//
//  LCLoginViewModel.h
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2018/84.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBLoginViewModel : GBBassViewModel

/** 注册 */
- (void)loginRequestRegister:(NSString *)loginName password:(NSString *)password smsCode:(NSString *)smsCode;

/** 密码登录 */
- (void)loginRequestLoginName:(NSString *)loginName password:(NSString *)password;
/** 验证码登录 */
- (void)loginRequestLoginName:(NSString *)loginName smsCode:(NSString *)smsCode;

/**
 获取验证码

 @param mobile 手机号
 @param type
 （modifyMobile:修改手机号
   modifyPayPwd:修改交易密码
          login:登录
   userRegister:注册
 modifyAlipayAccount:修改支付宝账户）
 */
- (void)loadRequestCheckCode:(NSString *)mobile type:(NSString *)type;

/** 第三方登录 */
- (void)thirdLogin:(NSString *)nickName sex:(NSString *)sex openId:(NSString *)openId address:(NSString *)address origin:(NSString *)origin avatar:(NSString *)avatar;

/** 校验第三方登录是否绑定过手机号 */
- (void)checkThirdLogin:(NSString *)openId origin:(NSString *)origin;

/** 第三方登录手机号绑定 */
- (void)thirdLogin:(NSString *)openId phone:(NSString *)phone code:(NSString *)code origin:(NSString *)origin;

/** 注册 */
- (void)registRequestWithLoginName:(NSString *)loginName password:(NSString *)password code:(NSString *)code;

/** 忘记密码 */
- (void)forgetPassWordRequestWithLoginName:(NSString *)loginName password:(NSString *)password code:(NSString *)code;

/** 检查账号是否注册 */
- (void)chekLoginName:(NSString *)loginName;

/** 用户登出 */
- (void)loginOutRequestWithToken:(NSString *)token;

@end
