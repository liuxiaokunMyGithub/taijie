//
//  GBMineViewModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/3.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMineViewModel.h"

@implementation GBMineViewModel

// MARK: 个人信息
- (void)loadRequestPersonalInfo:(NSString *)targetUserId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_Info httpMethod:@"POST" headerParams:nil params:@{@"targetUserId":targetUserId} file:nil success:^(id responseData) {
        NSLog(@"个人信息:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"个人信息 error:%@",error);
        
    }];
}

// MARK: 编辑页带技能个人信息
- (void)loadRequestPersonalEditInfo {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_EditInfo httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"带技能个人信息:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"带技能个人信息 error:%@",error);
        
    }];
}

// MARK: 更新个人资料
- (void)loadRequestPersonalEditInfoUpdate:(NSDictionary *)param {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_UpdateEditInfo httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更新个人资料:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更新个人资料 error:%@",error);
        
    }];
}

// MARK: 余额
- (void)loadRequestBalance {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_Balance httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"余额:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"余额 error:%@",error);
        
    }];
}

// MARK: 内购充值
- (void)loadRequestInAppPurchase:(NSString *)receipt {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_InAppPurchase httpMethod:@"POST" headerParams:nil params:@{@"receipt":receipt} file:nil success:^(id responseData) {
        NSLog(@"内购充值:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"内购充值 error:%@",error);
        
    }];
}

// MARK: 交易流水
- (void)loadRequestUserMoneyRecordList:(NSInteger )pageNo pageSize:(NSInteger )pageSize serviceType:(NSString *)serviceType payDirection:(NSString *)payDirection {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"serviceType":serviceType,
                            @"payDirection":payDirection
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_UserMoneyRecord httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"交易流水:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"交易流水 error:%@",error);
        
    }];
}

// MARK: 已购订单
- (void)loadRequestPurchasedOrderList:(NSInteger )pageNo
                             pageSize:(NSInteger )pageSize
                               status:(NSString *)status
                          serviceType:(NSString *)serviceType {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"serviceType":serviceType,
                            @"status":status
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_PurchasedOrder httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"已购订单:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"已购订单 error:%@",error);
        
    }];
}

/** 服务订单列表 */
- (void)loadRequestIncumbentOrderList:(NSInteger )pageNo pageSize:(NSInteger )pageSize status:(NSString *)status
                          serviceType:(NSString *)serviceType {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"serviceType":serviceType,
                            @"status":status
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_IncumbentOrder httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"服务订单:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"服务订单 error:%@",error);
        
    }];
}

/** 保过订单详情 */
- (void)loadRequestAssurePassOrderDetails:(NSInteger )assurePassId {
    NSDictionary *param = @{
                            @"assurePassId":[NSNumber numberWithInteger:assurePassId],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_GetAssurePassOrderDetails httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"保过订单详情:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"保过订单详情 error:%@",error);
        
    }];
}

/** 解密订单详情 */
- (void)loadRequestDecryptOrderDetails:(NSInteger )decryptId {
    NSDictionary *param = @{
                            @"decryptId":[NSNumber numberWithInteger:decryptId],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_GetDecryptOrderDetails httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"解密订单详情 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"解密订单详情  error:%@",error);
        
    }];
}

/** 订单小红点 */
- (void)loadRequestOrderNoticeStatusRenewal:(NSString *)userType
                                serviceType:(NSString *)serviceType
                                  serviceId:(NSInteger )serviceId {
    NSDictionary *param = @{
                            @"serviceId":[NSNumber numberWithInteger:serviceId],
                            @"userType":userType,
                            @"serviceType":serviceType,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_NoticeStatusRenewal httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"服务订单:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"服务订单 error:%@",error);
        
    }];
}

/** 检查订单总状态及分TAB状态 */
- (void)loadRequestMineOrderNewStatus {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_OrderNewStatus httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"检查订单总状态及分TAB状态:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"检查订单总状态及分TAB状态error:%@",error);
        
    }];
}

/** 更新用户手机号 */
- (void)loadRequestUserTelRenewal:(NSString *)tel smsCode:(NSString *)smsCode {
    NSDictionary *param = @{
                            @"smsCode":smsCode,
                            @"tel":tel,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_UserTelRenewal httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更新用户手机号:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更新用户手机号error:%@",error);
        
    }];
}

/** 更新支付密码 */
- (void)loadRequestPayPwdRenewal:(NSString *)payPwd smsCode:(NSString *)smsCode {
    NSDictionary *param = @{
                            @"payPwd":payPwd,
                            @"smsCode":smsCode,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_PayPwdRenewal httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更新支付密码:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更新支付密码 error:%@",error);
        
    }];
}

/** 更新登录密码 */
- (void)loadRequestLoginPasswordRenewal:(NSString *)tel password:(NSString *)password smsCode:(NSString *)smsCode {
    NSDictionary *param = @{
                            @"tel":tel,
                            @"confirmPassword":password,
                            @"password":password,
                            @"smsCode":smsCode,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_PwdRenewal httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更新支付密码:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更新支付密码 error:%@",error);
        
    }];
}

/** 更新用户支付宝账户 */
- (void)loadRequestUpdateUserAlipayAccount:(NSString *)alipayAccount smsCode:(NSString *)smsCode {
    NSDictionary *param = @{
                            @"alipayAccount":alipayAccount,
                            @"smsCode":smsCode,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_UpdateUserAlipayAccount httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更新用户支付宝账户:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更新用户支付宝账户 error:%@",error);
        
    }];
}

/** 认证状态 */
- (void)loadRequestMineIncumbentAuthenticationState {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_IncumbentAuthenticationState httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"认证状态 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"认证状态 error:%@",error);
        
    }];
}

/** 获取认证信息 */
- (void)loadRequestMineIncumbentAuthenticationInfo {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_IncumbentAuthenticationInfo httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"认证信息:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            // [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"认证信息 error:%@",error);
        
    }];
}

/** 提交认证信息 */
- (void)loadRequestMineIncumbentAuthenticationInfoSubmition:(NSDictionary *)param {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_IncumbentAuthenticationInfoSubmition httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"提交认证信息:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"提交认证信息 error:%@",error);
        
    }];
}

/** 提交认证信息审核 */
- (void)loadRequestMineAuditionSubmition:(NSString *)authenticationId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_AuditionSubmition httpMethod:@"POST" headerParams:nil params:@{@"authenticationId": authenticationId} file:nil success:^(id responseData) {
        NSLog(@"提交认证信息:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"提交认证信息 error:%@",error);
        
    }];
}

/** 芝麻认证 */
- (void)loadRequestMineInitAntAuthenticate:(NSString *)certName certNo:(NSString *)certNo {
    NSDictionary *param = @{@"certName":certName,@"certNo":certNo};
    [[NetDataServer sharedInstance] requestURL:URL_Mine_InitAntAuthenticate httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"初始化芝麻认证:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"初始化芝麻认证 error:%@",error);
        
    }];
}

/** 新增/更新在职者解密服务  */
- (void)loadRequestMineDecryptRenewal:(NSString *)discountType types:(NSArray *)types originalPrice:(NSString *)originalPrice price:(NSString *)price title:(NSString *)title  details:(NSString *)details isEnable:(BOOL )isEnable incumbentDecryptId:(NSString *)incumbentDecryptId {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                            @"discountType":discountType,
                            @"types":types,
                            @"originalPrice":originalPrice,
                            @"title":title,
                            @"details":details,
                            @"isEnable":[NSNumber numberWithBool:isEnable],
                            }];
    
    if (ValidStr(incumbentDecryptId)) {
        [param setObject:incumbentDecryptId forKey:@"incumbentDecryptId"];
    }
    if (ValidStr(price)) {
        [param setObject:price forKey:@"price"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Mine_DecryptRenewal httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"新增/更新在职者解密服务:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"新增/更新在职者解密服务 error:%@",error);
        
    }];
}

/** 新增/更新在职者保过服务 */
- (void)loadRequestMineAssureRenewal:(NSDictionary *)positionDic price:(NSString *)price  content:(NSString *)content isEnable:(BOOL )isEnable assurePassId:(NSInteger )assurePassId {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:positionDic];
    
    if (ValidNum([NSNumber numberWithBool:assurePassId])) {
        [param setObject:[NSNumber numberWithInteger:assurePassId] forKey:@"incumbentAssurePassId"];
    }
    
    if (ValidStr(price)) {
        [param setObject:price forKey:@"price"];
    }
    
    [param setObject:content forKey:@"details"];
    [param setObject:[NSNumber numberWithBool:isEnable] forKey:@"isEnable"];
    
    [[NetDataServer sharedInstance] requestURL:URL_Mine_AssurePassRenewal httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"新增/更新在职者解密服务:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"新增/更新在职者解密服务 error:%@",error);
        
    }];
}

/** 解密服务列表 */
- (void)loadRequestMineDecryptServiceList:(NSInteger )pageNo pageSize:(NSInteger )pageSize {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_DecryptServiceList httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"解密服务列表:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"解密服务列表 error:%@",error);
        
    }];
}

/** 保过服务列表 */
- (void)loadRequestMineAssurePasstServiceList:(NSInteger )pageNo pageSize:(NSInteger )pageSize {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_AssurePasstServiceList httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"保过服务列表:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"保过服务列表 error:%@",error);
        
    }];
}
/** 在职者解密服务详情  */
- (void)loadRequestMineIncumbentDecrypt:(NSInteger )incumbentDecryptId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_myIncumbentDecrypt httpMethod:@"POST" headerParams:nil params:@{@"incumbentDecryptId":[NSNumber numberWithInteger:incumbentDecryptId]} file:nil success:^(id responseData) {
        NSLog(@"在职者解密服务详情:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"在职者解密服务详情 error:%@",error);
        
    }];
}

/** 删除解密服务 */
- (void)loadRequestMineDeleteIncumbentDecrypt:(NSInteger )incumbentDecryptId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_DeleteIncumbentDecrypt httpMethod:@"POST" headerParams:nil params:@{@"incumbentDecryptId":[NSNumber numberWithInteger:incumbentDecryptId]} file:nil success:^(id responseData) {
        NSLog(@"删除解密服务:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"删除解密服务 error:%@",error);
        
    }];
}

/** 在职者保过服务详情  */
- (void)loadRequestMineIncumbentAssurePass:(NSInteger )incumbentAssurePassId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_IncumbentDetail httpMethod:@"POST" headerParams:nil params:@{@"incumbentAssurePassId":[NSNumber numberWithInteger:incumbentAssurePassId]} file:nil success:^(id responseData) {
        NSLog(@"在职者保过服务详情 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"在职者保过服务详情  error:%@",error);
        
    }];
}

/** 删除保过服务 */
- (void)loadRequestMineDeleteIncumbentAssurePass:(NSInteger )incumbentAssurePassId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_DeleteIncumbentAssurePass httpMethod:@"POST" headerParams:nil params:@{@"incumbentAssurePassId":[NSNumber numberWithInteger:incumbentAssurePassId]} file:nil success:^(id responseData) {
        NSLog(@"删除解密服务:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"删除解密服务 error:%@",error);
        
    }];
}

/** 保过服务评价 */
- (void)loadRequestMineAssurePassEvaluate:(NSInteger )assurePassId content:(NSString *)content star:(NSString *)star responseStar:(NSString *)responseStar proficiencyStar:(NSString *)proficiencyStar {
    NSDictionary *param = @{
                            @"assurePassId":[NSNumber numberWithInteger:assurePassId],
                            @"content":content,
                            @"star":star,
                            @"responseStar":responseStar,
                            @"proficiencyStar":proficiencyStar
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_AssurePass_Evaluate httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"保过服务评价:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"保过服务评价 error:%@",error);
        
    }];
}

/** 解密服务评价 */
- (void)loadRequestMineDecryptEvaluate:(NSInteger )decryptId content:(NSString *)content star:(NSString *)star responseStar:(NSString *)responseStar proficiencyStar:(NSString *)proficiencyStar {
    NSDictionary *param = @{
                            @"decryptId":[NSNumber numberWithInteger:decryptId],
                            @"content":content,
                            @"star":star,
                            @"responseStar":responseStar,
                            @"proficiencyStar":proficiencyStar
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_Decrypt_Evaluate httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"解密服务评价:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"解密服务评价 error:%@",error);
        
    }];
}

/** 接受解密 */
- (void)loadRequestMineDecryptAccept:(NSInteger )decryptId {
    NSDictionary *param = @{
                            @"decryptId":[NSNumber numberWithInteger:decryptId],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_Decrypt_Accept httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"接受解密:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"接受解密 error:%@",error);
        
    }];
}

/** 结束解密  */
- (void)loadRequestMineDecryptFinish:(NSInteger )decryptId {
    NSDictionary *param = @{
                            @"decryptId":[NSNumber numberWithInteger:decryptId],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_Decrypt_Finish httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"结束解密:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"结束解密 error:%@",error);
        
    }];
}

/** 拒绝解密  */
- (void)loadRequestMineDecryptReject:(NSInteger )decryptId {
    NSDictionary *param = @{
                            @"decryptId":[NSNumber numberWithInteger:decryptId],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_Decrypt_Reject httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"拒绝解密:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"拒绝解密 error:%@",error);
        
    }];
}

/** 解密取消  */
- (void)loadRequestMineDecyptPassCancel:(NSInteger )decryptId {
    NSDictionary *param = @{
                            @"decryptId":[NSNumber numberWithInteger:decryptId],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_Decrypt_Cancel httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"解密取消:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"解密取消 error:%@",error);
        
    }];
}

/** 接受保过  */
- (void)loadRequestMineAssurePassAccept:(NSInteger )assurePassId {
    NSDictionary *param = @{
                            @"assurePassId":[NSNumber numberWithInteger:assurePassId],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_AssurePass_Accept httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"接受保过:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"接受保过 error:%@",error);
        
    }];
}

/** 结束保过  */
- (void)loadRequestMineAssurePassFinish:(NSInteger )assurePassId reasonType:(NSString *)reasonType remark:(NSString *)remark refundAmount:(NSString *)refundAmount rewardAmount:(NSString *)rewardAmount {
    NSMutableDictionary *param =[NSMutableDictionary dictionaryWithDictionary:@{
                            @"assurePassId":[NSNumber numberWithInteger:assurePassId],
                            @"reasonType":reasonType,
                            @"remark":remark,
                            }];
    
    if (ValidStr(refundAmount)) {
        [param setObject:refundAmount forKey:@"refundAmount"];
    }
    
    if (ValidStr(rewardAmount)) {
        [param setObject:rewardAmount forKey:@"rewardAmount"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Mine_AssurePass_Finish httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"保过结束:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"保过结束 error:%@",error);
        
    }];
}

/** 拒绝保过  */
- (void)loadRequestMineAssurePassReject:(NSInteger )assurePassId {
    NSDictionary *param = @{
                            @"assurePassId":[NSNumber numberWithInteger:assurePassId],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_AssurePass_Reject httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"保过拒绝:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"保过拒绝 error:%@",error);
        
    }];
}

/** 保过取消  */
- (void)loadRequestMineAssurePassCancel:(NSInteger )assurePassId {
    NSDictionary *param = @{
                            @"assurePassId":[NSNumber numberWithInteger:assurePassId],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_AssurePass_Cancel httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"保过取消:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"保过取消 error:%@",error);
        
    }];
}

/** 我的收藏列表 */
- (void)loadRequestMineCollectionList:(NSInteger )pageNo pageSize:(NSInteger )pageSize type:(NSString *)type {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"type":type
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_CollectionList httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"我的收藏列表:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"我的收藏列表 error:%@",error);
        
    }];
}

/** 提现  */
- (void)loadRequestMineWithdrawDeposit:(NSInteger )amount alipayAccount:(NSString *)alipayAccount {
    NSDictionary *param = @{
                            @"alipayAccount":alipayAccount,
                            @"amount":[NSNumber numberWithInteger:amount]
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_WithdrawDeposit httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"提现:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"提现 error:%@",error);
        
    }];
}

/** 获取支付宝账号 */
- (void)loadRequestMineUserAlipayAccount {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_GetUserAlipayAccount httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"获取支付宝账号:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取支付宝账号 error:%@",error);
    }];
}

/** 意见反馈 */
- (void)loadRequestMineFeedBack:(NSString *)feedBack contactType:(NSString *)contactType contactDetail:(NSString *)contactDetail {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"feedBack":feedBack}];
    if (ValidStr(contactDetail)) {
        [param setObject:contactType forKey:@"contactType"];
        [param setObject:contactDetail forKey:@"contactDetail"];
    }
   
    [[NetDataServer sharedInstance] requestURL:URL_Mine_FeedBack httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"意见反馈:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"意见反馈 error:%@",error);
    }];
}

/** 提现记录 */
- (void)loadRequestMineWithdrawDepositList:(NSInteger )pageNo pageSize:(NSInteger )pageSize {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_WithdrawDepositList httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"提现记录:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"提现记录 error:%@",error);
        
    }];
}

/** 过往微经验 */
- (void)loadRequestMineMicroExperienceList:(NSString *)targetUserId {
    NSDictionary *param = nil;
    if (ValidStr(targetUserId)) {
        param = @{@"targetUserId":targetUserId};
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Mine_MicroExperience httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"过往微经验:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"过往微经验 error:%@",error);
        
    }];
}

/** 编辑添加微经验 */
- (void)loadRequestUpdateMineMicroExperience:(NSString *)startTime endTime:(NSString *)endTime companyName:(NSString *)companyName positionName:(NSString *)positionName evaluateContent:(NSString *)evaluateContent experienceId:(NSInteger )experienceId {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                    @"startTime":startTime,
                                    @"endTime":endTime,
                                    @"companyName":companyName,
                                    @"positionName":positionName,
                                    @"evaluateContent":evaluateContent
                                    }];
    if (experienceId) {
        [param setObject:[NSNumber numberWithInteger:experienceId] forKey:@"id"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Mine_SingleMicroExperienceRenewal httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"编辑添加微经验:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"编辑添加微经验 error:%@",error);
    }];
}

/** 微经验删除 */
- (void)loadRequestMineMicroExperienceDelete:(NSInteger )experienceId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_MicroExperienceRemoval httpMethod:@"POST" headerParams:nil params:@{@"id":[NSNumber numberWithInteger:experienceId]} file:nil success:^(id responseData) {
        NSLog(@"微经验删除:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"微经验删除 error:%@",error);
        
    }];
}

/** 保过标签 */
- (void)loadRequestMineassurePassLabels {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_assurePassLabels httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"保过标签:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"保过标签 error:%@",error);
        
    }];
}

/** 认证重置校验 */
- (void)loadRequestReviewTimeVerification {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_ReviewTimeVerification httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"认证重置校验:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"认证重置校验 error:%@",error);
        
    }];
}

/** 系统消息 */
- (void)loadRequestSystemsMessages:(NSInteger )pageNo
                          pageSize:(NSInteger )pageSize {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize]
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Mine_SystemsMessages httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"系统消息:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"系统消息error:%@",error);
        
    }];
}

/** 外层系统消息 */
- (void)loadRequestOuterSystemMessage {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_OuterSystemMessage httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"外层系统消息:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"外层系统消息error:%@",error);
        
    }];
}

/** 系统消息操作 */
- (void)loadRequestSystemsMessageAction:(NSString *)relatedServiceType
                                 action:(NSString *)action
                              messageId:(NSString *)messageId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                   @"action":action,
                                   @"messageId":messageId
                                   }];
    if (ValidStr(relatedServiceType)) {
        [param setObject:relatedServiceType forKey:@"relatedServiceType"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Mine_SystemsMessageAction httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"系统消息操作:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"系统消息操作error:%@",error);
        
    }];
}


/** 省份 */
- (void)loadRequestListProvinces {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_ListProvinces httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"省份:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"省份error:%@",error);
        
    }];
}
/** 大学 */
- (void)loadRequestListUniversities:(NSString *)provinceId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_ListUniversities httpMethod:@"POST" headerParams:nil params:@{@"provinceId":provinceId} file:nil success:^(id responseData) {
        NSLog(@"大学:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"大学error:%@",error);
        
    }];
}
/** 专业 */
- (void)loadRequestListMajors:(NSString *)universityId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_ListMajors httpMethod:@"POST" headerParams:nil params:@{@"universityId":universityId} file:nil success:^(id responseData) {
        NSLog(@"专业:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"专业error:%@",error);
        
    }];
}
/** 新增或更新教育经历 */
- (void)loadRequestEducationExperienceRenewal:(NSString *)pcname
                               universityName:(NSString *)universityName
                                    majorName:(NSString *)majorName
                                      diploma:(NSString *)diploma
                                    startTime:(NSString *)startTime
                                      endTime:(NSString *)endTime
                                   isDomestic:(BOOL)isDomestic
                                 experienceId:(NSString *)experienceId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                            @"pcname":pcname,
                            @"universityName":universityName,
                            @"majorName":majorName,
                            @"diploma":diploma,
                            @"startTime":startTime,
                            @"endTime":endTime,
                            @"isDomestic":[NSNumber numberWithBool:isDomestic]
                            }];
    if (ValidStr(experienceId)) {
        [param setObject:experienceId forKey:@"id"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Mine_EducationExperienceRenewal httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"新增或更新教育经历:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"新增或更新教育经历error:%@",error);
        
    }];
}
/** 删除教育经历 */
- (void)loadRequestEducatiopnExerienceRemoval:(NSString *)edcationID
{
    [[NetDataServer sharedInstance] requestURL:URL_Mine_EducatiopnExerienceRemoval httpMethod:@"POST" headerParams:nil params:@{@"id":edcationID} file:nil success:^(id responseData) {
        NSLog(@"删除教育经历 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"删除教育经历 error:%@",error);
        
    }];
}

/** 获取教育经历 */
- (void)loadRequestEducatiopnExerience {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_EducationExperienceList httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"获取教育经历 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取教育经历 error:%@",error);
        
    }];
}

@end
