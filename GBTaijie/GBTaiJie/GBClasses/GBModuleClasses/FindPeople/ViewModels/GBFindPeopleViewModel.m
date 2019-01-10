//
//  GBFindPeopleViewModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBFindPeopleViewModel.h"

@implementation GBFindPeopleViewModel
// MARK: 轮播图
- (void)loadRequestBanner {
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_Banner httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"找人banner:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"找人banner error:%@",error);

    }];
}

// MARK: 推荐的人
- (void)loadRequestPersonList:(NSInteger )pageNo pageSize:(NSInteger )pageSize intentionalIds:(NSArray *)intentionalIds {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            }];
    if (!userManager.currentUser) {
        [param setObject:@YES forKey:@"isAnnoymous"];
    }else {
        [param setObject:intentionalIds forKey:@"intentionalIds"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_PersonList httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"推荐的人:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"推荐的人 error:%@",error);
        
    }];
}

// MARK: 加入黑名单
- (void)loadRequestJoinBlackList:(NSString *)targetUserId location:(NSString *)location {
    NSDictionary *param = @{
                            @"targetUserId":targetUserId,
                            @"location":location,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_Join_blacklist httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"加入黑名单:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"加入黑名单 error:%@",error);
        
    }];
}

/** MARK: 获取找人意向 */
- (void)loadRequestIncumbent:(NSArray *)intentionalIds {
    NSDictionary *param = @{
                            @"intentionalIds":intentionalIds,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_Incumbent httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"获取找人意向:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"获取找人意向 error:%@",error);
        
    }];
}

/** MARK: 更新找人意向 */
- (void)loadRequestRenewalIncumbent:(NSString *)jobId
                            jobName:(NSString *)jobName
                             region:(NSString *)region
                         regionName:(NSString *)regionName
               intentionalCompanyId:(NSString *)intentionalCompanyId
             intentionalCompanyName:(NSString *)intentionalCompanyName
                     intentionalIds:(NSInteger )intentionalId {

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"jobId":jobId,@"jobName":jobName,
}];
    
        [param setObject:[NSNumber numberWithInteger:intentionalId] forKey:@"intentionalId"];
    
    
    if (ValidStr(region) && ![region isEqualToString:@"0"]) {
        [param setObject:region forKey:@"region"];
    }
    
    if (ValidStr(regionName)) {
        [param setObject:regionName forKey:@"regionName"];
    }
    
    if (ValidStr(intentionalCompanyId)) {
        [param setObject:intentionalCompanyId forKey:@"intentionalCompanyId"];
    }
    
    if (ValidStr(intentionalCompanyName)) {
        [param setObject:intentionalCompanyName forKey:@"intentionalCompanyName"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_Renewal httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更新找人意向:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更新找人意向 error:%@",error);
        
    }];
}

/** MARK: 城市列表 */
- (void)loadRequestCityRegion:(BOOL)isPersonal {
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_region httpMethod:@"POST" headerParams:nil params:@{@"isPersonal":[NSNumber numberWithBool:isPersonal]} file:nil success:^(id responseData) {
        NSLog(@"城市列表:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"城市列表 error:%@",error);
        
    }];
}

/** MARK: 根据地区拼音首字母获取地区 */
- (void)loadRequestCityCode:(NSString *)regionName {
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_CityCode httpMethod:@"POST" headerParams:nil params:@{@"regionName":regionName} file:nil success:^(id responseData) {
        NSLog(@"name定位城市:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"name定位城市 error:%@",error);
        
    }];
}

/** MARK: 搜索公司 */
- (void)loadRequestSearchCompanyI:(NSInteger )pageNo pageSize:(NSInteger )pageSize key:(NSString *)key {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"key":key
                            };
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_SearchCompany httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"搜索公司:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"搜索公司 error:%@",error);
        
    }];
}

/** MARK: 职位列表 */
- (void)loadRequestJobList:(NSString *)jobPid jobLayer:(NSString *)jobLayer limited:(BOOL )limited {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:@{@"limited":[NSNumber numberWithBool:limited]}];
    if (ValidStr(jobPid)) {
        [param setObject:jobPid forKey:@"jobPid"];
    }
    
    if (ValidStr(jobLayer)) {
        [param setObject:jobLayer forKey:@"jobLayer"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_jobList httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"职位列表:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"职位列表 error:%@",error);
        
    }];
}

/** 提交意向 */
- (void)loadRequestSkipPage:(NSDictionary *)intentionalIncumbent intentionalPosition:(NSDictionary *)intentionalPosition {
    NSDictionary *param = @{
                            @"intentionalIncumbent":intentionalIncumbent,
                            @"intentionalPosition":intentionalPosition
                            };
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_SkipPage httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"精准匹配标签提交:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"精准匹配标签提交 error:%@",error);
        
    }];
}

/** 个人主页-服务 */
- (void)loadRequestPersonalService:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSString *)targetUserId {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"targetUserId":targetUserId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_PersonalService httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"个人主页-服务:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"个人主页-服务 error:%@",error);
        
    }];
}

/** 个人主页-个人信息及评论 */
- (void)loadRequestPersonComment:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSString *)targetUserId {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"targetUserId":targetUserId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_Info_Comment httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"个人主页-信息及评论:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"个人主页-信息及评论 error:%@",error);
        
    }];
}

/** 举报 */
- (void)loadRequestRelatedId:(NSString *)relatedId reportReason:(NSString *)reportReason relatedType:(NSString *)relatedType remark:(NSString *)remark {
    NSDictionary *param = @{
                            @"relatedId":relatedId,
                            @"reportReason":reportReason,
                            @"relatedType":relatedType,
                            @"remark":[GBAppHelper objectSafeCheck:remark]
                            };
    [[NetDataServer sharedInstance] requestURL:URL_FindPeople_Report httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"举报:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"举报 error:%@",error);
        
    }];
}

/** 更多解密服务 */
- (void)loadRequestPersonMoreDecrypt:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSString *)targetUserId
{
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"targetUserId":targetUserId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_More_Decrypt httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更多解密服务:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更多解密服务 error:%@",error);
        
    }];
}
@end
