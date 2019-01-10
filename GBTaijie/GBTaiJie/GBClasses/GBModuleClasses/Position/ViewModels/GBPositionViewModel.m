//
//  GBPositionViewModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBPositionViewModel.h"

@implementation GBPositionViewModel

/** 匹配职位 */
- (void)loadRequestPostionList:(NSInteger )pageNo pageSize:(NSInteger )pageSize intentionalIds:(NSArray *)intentionalIds {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            }];
    if (!userManager.currentUser) {
        [param setObject:@YES forKey:@"isAnnoymous"];
    }else {
        [param setObject:intentionalIds forKey:@"intentionalIds"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Position_PostionList httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"匹配职位 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"匹配职位 error %@",error);
    }];
}

/** 匹配解密 */
- (void)loadRequestDecryptList:(NSInteger )pageNo pageSize:(NSInteger )pageSize intentionalIds:(NSArray *)intentionalIds  {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                    @"pageNo":[NSNumber numberWithInteger:pageNo],
                                    @"pageSize":[NSNumber numberWithInteger:pageSize],
                                    @"intentionalIds":intentionalIds
                                    }];
    if (!userManager.currentUser) {
        [param setObject:@YES forKey:@"isAnnoymous"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Position_Decrypt httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"匹配解密 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"匹配解密 error %@",error);
    }];
}

/** 获取意向列表 */
- (void)loadIntentionalPositions {
    [[NetDataServer sharedInstance] requestURL:URL_Position_IntentionalPositions httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"获取职位意向列表 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取职位意向列表 error %@",error);
    }];

}

/** 职位详情 */
- (void)loadPositionsDeatail:(NSString *)positionId region:(NSInteger )region {
    NSDictionary *params = @{
                             @"positionId":positionId,
                             @"region":[NSNumber numberWithInteger:region]
                             };
    [[NetDataServer sharedInstance] requestURL:URL_Position_Deatail httpMethod:@"POST" headerParams:nil params:params file:nil success:^(id responseData) {
        NSLog(@"职位详情 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
        [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"职位详情 error %@",error);
    }];
}

/** 获取经验 */
- (void)loadPositionsExperience {
    [[NetDataServer sharedInstance] requestURL:URL_Position_Experience httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"获取经验 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取经验 error %@",error);
    }];
}

/** 获取学历 */
- (void)loadPositionsEducation {
    [[NetDataServer sharedInstance] requestURL:URL_Position_DilamorCode httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"获取学历 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取学历 error %@",error);
    }];
}

/** 删除意向职位 */
- (void)loadPositionsRemoval:(NSString *)intentionalId {
    [[NetDataServer sharedInstance] requestURL:URL_Position_IntentionalPositionRemoval httpMethod:@"POST" headerParams:nil params:@{@"intentionalId":intentionalId} file:nil success:^(id responseData) {
        NSLog(@"删除意向职位 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"删除意向职位 error %@",error);
    }];
}

/** 保过详情页 */
- (void)loadPositionsAssurePassDetail:(NSInteger )assurePassId pageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSInteger )targetUserId {
    NSDictionary *param = @{
                            @"assurePassId":[NSNumber numberWithInteger:assurePassId],
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"targetUserId":[NSNumber numberWithInteger:targetUserId]
                            };
    
    [[NetDataServer sharedInstance] requestURL:URL_Position_AssurePassDetail httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"保过详情页 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"保过详情页 error %@",error);
    }];
}

/** 获取解密详情页 */
- (void)loadPositionsDecryptDetail:(NSInteger )decryptId pageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSInteger )targetUserId {
    NSDictionary *param = @{
                            @"decryptId":[NSNumber numberWithInteger:decryptId],
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"targetUserId":[NSNumber numberWithInteger:targetUserId]
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Position_DecryptDetail httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"获取解密详情页 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取解密详情页 error %@",error);
    }];
}

/** 预约解密 */
- (void)loadPositionsOrderDecrypt:(NSString *)question
                personalSituation:(NSString *)personalSituation
               incumbentDecryptId:(NSInteger )incumbentDecryptId
{
    NSDictionary *param = @{
                            @"question":question,
                            @"personalSituation":personalSituation,
                            @"incumbentDecryptId":[NSNumber numberWithInteger:incumbentDecryptId]
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Position_OrderDecrypt httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"预约解密 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"预约解密 error %@",error);
    }];
}

/** 预约保过 */
- (void)loadPositionsOrderAssurePass:(NSString *)leaveMesseges
                    zhimaCreditScore:(NSString *)zhimaCreditScore
                positionInfoDic:(NSDictionary *)positionInfoDic
               incumbentAssurePassId:(NSInteger )incumbentAssurePassId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:positionInfoDic];
    
    [param setObject:leaveMesseges forKey:@"leaveMesseges"];
    [param setObject:[NSNumber numberWithInteger:incumbentAssurePassId] forKey:@"incumbentAssurePassId"];
    if (ValidStr(zhimaCreditScore)) {
        [param setObject:zhimaCreditScore forKey:@"zhimaCreditScore"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Position_OrderAssurePass httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"预约保过 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"预约保过 error %@",error);
    }];
}

/** 解密可用性 */
- (void)loadPositionsDecryptAvailability:(NSInteger )incumbentDecryptId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_Decrypt_Availability httpMethod:@"POST" headerParams:nil params:@{@"incumbentDecryptId":[NSNumber numberWithInteger:incumbentDecryptId]} file:nil success:^(id responseData) {
        NSLog(@"解密可用性 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
           [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"解密可用性 error %@",error);
    }];
}

/** 保过可用性 */
- (void)loadPositionsAssurePassAvailability:(NSInteger )incumbentAssurePassId {
    [[NetDataServer sharedInstance] requestURL:URL_Mine_AssurePass_Availability httpMethod:@"POST" headerParams:nil params:@{@"incumbentAssurePassId":[NSNumber numberWithInteger:incumbentAssurePassId]} file:nil success:^(id responseData) {
        NSLog(@"保过可用性 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
           [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"保过可用性 error %@",error);
    }];
}

/** 获取行业类型 */
- (void)loadPositionsIndustryType {
    [[NetDataServer sharedInstance] requestURL:URL_Position_IndustryType httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"获取行业类型 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取行业类型 error %@",error);
    }];
}

/** 获取行业 */
- (void)loadPositionsIndustry:(NSString *)industryTypeId {
    [[NetDataServer sharedInstance] requestURL:URL_Position_Industries httpMethod:@"POST" headerParams:nil params:@{@"industryTypeId":industryTypeId} file:nil success:^(id responseData) {
        NSLog(@"获取行业列表 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取行业列表 error %@",error);
    }];
}

/** 新增更新意向职位 */
- (void)loadPositionIntentionalRenewal:(NSDictionary *)paramDic {
    [[NetDataServer sharedInstance] requestURL:URL_Position_IntentionalPositionRenewal httpMethod:@"POST" headerParams:nil params:paramDic file:nil success:^(id responseData) {
        NSLog(@"新增更新意向职位 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"新增更新意向职位 error %@",error);
    }];
}

/*
 方法描述:
 type类型
 问答:GOODS_TYPE_WD
 偷听:GOODS_TYPE_TT
 解密:GOODS_TYPE_JM
 保过:GOODS_TYPE_BG
 */
- (void)loadPositionPayWithType:(NSString *)type relatedId:(NSString *)relatedId payPwd:(NSString *)payPwd discountType:(NSString *)discountType {
    NSDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                            @"relatedId":relatedId,
                            @"relatedType":type,
                            @"payType":@"PAY_TYPE_PG_TJB",
                            }];
    if (ValidStr(discountType)) {
        [param setValue:discountType forKey:@"discountType"];
    }
    
    if (ValidStr(payPwd)) {
        [param setValue:payPwd forKey:@"payPwd"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Position_Pay httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"支付 responseData %@",responseData);
        self.returnBlock(responseData);
    } fail:^(NSError *error) {
        NSLog(@"支付 error %@",error);
    }];
};

/** 在招职位 */
- (void)loadPositionRecruiting:(NSString *)companyId pageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize {
    NSDictionary *param = @{
                            @"companyId":companyId,
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize]
                            };
    
    [[NetDataServer sharedInstance] requestURL:URL_Position_Recruiting httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"在招职位 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"在招职位 error %@",error);
    }];
}

/** 在职同事 */
- (void)loadPositionColleague:(NSString *)companyId pageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize {
    NSDictionary *param = @{
                            @"companyId":companyId,
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize]
                            };
    
    [[NetDataServer sharedInstance] requestURL:URL_Position_Colleague httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"在职同事 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"在职同事 error %@",error);
    }];
}

/** 公司信息 */
- (void)loadPositionCompanyInfo:(NSString *)companyId {
    NSDictionary *param = @{
                            @"companyId":companyId,
                            };
    
    [[NetDataServer sharedInstance] requestURL:URL_Position_CompanyInfo httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"公司信息 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
           [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"公司信息 error %@",error);
    }];
}

/** 综合搜索 */
- (void)loadRequestPostitionSearch:(NSInteger )pageNo pageSize:(NSInteger )pageSize key:(NSString *)key {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":[NSNumber numberWithInteger:pageNo],@"pageSize":[NSNumber numberWithInteger:pageSize],@"key":key                            }];
    
    [[NetDataServer sharedInstance] requestURL:URL_Postition_Search httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"职位搜索 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"职位搜索 error %@",error);
    }];
}

/** 公司搜索 */
- (void)loadRequestCompanySearch:(NSInteger )pageNo pageSize:(NSInteger )pageSize key:(NSString *)key {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":[NSNumber numberWithInteger:pageNo],@"pageSize":[NSNumber numberWithInteger:pageSize],@"key":key                            }];
    
    [[NetDataServer sharedInstance] requestURL:URL_Company_Search httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"公司搜索 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"公司搜索 error %@",error);
    }];
}

/** 同事搜索 */
- (void)loadRequestPersonalSearch:(NSInteger )pageNo pageSize:(NSInteger )pageSize key:(NSString *)key {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":[NSNumber numberWithInteger:pageNo],@"pageSize":[NSNumber numberWithInteger:pageSize],@"key":key                            }];
    
    [[NetDataServer sharedInstance] requestURL:URL_Personal_Search httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"同事搜索 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"同事搜索 error %@",error);
    }];
}

@end
