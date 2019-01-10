//
//  GBCommonViewModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/22.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBCommonViewModel.h"

@implementation GBCommonViewModel
/** 阿里芝麻信用认证签名 */
- (void)loadRequestAlipayAccountAuthSign {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_getAlipayAccountAuthSign httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"阿里芝麻信用认证签名:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"阿里芝麻信用认证签名error:%@",error);
        
    }];
}

/** 阿里芝麻信用分 */
- (void)loadRequestAlipayGetZmScore {
    [[NetDataServer sharedInstance] requestURL:URL_Common_GetZmScore httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"阿里芝麻信用分:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"阿里芝麻信用分error:%@",error);
        
    }];
}

/** 获取技能列表 */
- (void)loadRequestSkills:(NSString *)skillPid {
    NSDictionary *param = ValidStr(skillPid) ? @{@"skillPid":skillPid} : nil;
    [[NetDataServer sharedInstance] requestURL:URL_Common_Skills httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"获取技能列表:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取技能列表error:%@",error);
        
    }];
}

/** 新增更新技能 */
- (void)loadRequestUpdateSkills:(NSArray *)skills {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_skillRenewal httpMethod:@"POST" headerParams:nil params:@{@"skills":skills} file:nil success:^(id responseData) {
        NSLog(@"新增更新技能:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"新增更新技能error:%@",error);
        
    }];
}

/** 校验支付密码 */
- (void)loadRequestPayPwdVerification:(NSString *)payPwd {
    NSDictionary *param = @{@"payPwd":payPwd};
    [[NetDataServer sharedInstance] requestURL:URL_Common_PayPwdVerification httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"校验支付密码:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"校验支付密码error:%@",error);
        
    }];
}

/** 检查用户是否有支付密码 */
- (void)loadRequestCheckUserHasPayPwd {
    [[NetDataServer sharedInstance] requestURL:URL_Common_CheckUserHasPayPwd httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"检查用户是否有支付密码:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"检查用户是否有支付密码error:%@",error);
        
    }];
}

/** 关注保过职位V1 */
- (void)loadRequestWatchPosition:(NSString *)incumbentAssurePassId {
    [[NetDataServer sharedInstance] requestURL:URL_Common_WatchPosition httpMethod:@"POST" headerParams:nil params:@{@"incumbentAssurePassId":incumbentAssurePassId} file:nil success:^(id responseData) {
        NSLog(@"关注保过职位:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"关注保过职位error:%@",error);
        
    }];
}

/** 关注解密V1 */
- (void)loadRequestWatchDecrypt:(NSString *)incumbentDecryptId {
    [[NetDataServer sharedInstance] requestURL:URL_Common_WatchDecrypt httpMethod:@"POST" headerParams:nil params:@{@"incumbentDecryptId":incumbentDecryptId} file:nil success:^(id responseData) {
        NSLog(@"关注解密:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"关注解密error:%@",error);
        
    }];
}

/** 极光推送id更新 */
- (void)loadRequestRegIdRenewal:(NSString *)registrationId {
    [[NetDataServer sharedInstance] requestURL:URL_Common_RegIdRenewal httpMethod:@"POST" headerParams:nil params:@{@"registrationId":registrationId} file:nil success:^(id responseData) {
        NSLog(@"极光推送id更:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"极光推送id更error:%@",error);
        
    }];
}

/** 红包弹出校验 */
- (void)loadRequestCheckRedPacketOpened {
    [[NetDataServer sharedInstance] requestURL:URL_Common_CheckRedPacketOpened httpMethod:@"POST" headerParams:nil params:@{@"redPacketType":@"NEWBEE_5"} file:nil success:^(id responseData) {
        NSLog(@"红包弹出校验:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"红包弹出校验error:%@",error);
    }];
}

/** 红包领取 */
- (void)loadRequestOpenRedPacket {
    [[NetDataServer sharedInstance] requestURL:URL_Common_OpenRedPacket httpMethod:@"POST" headerParams:nil params:@{@"redPacketType":@"NEWBEE_5"} file:nil success:^(id responseData) {
        NSLog(@"红包领取:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"红包领取error:%@",error);
    }];
}

@end
