//
//  GBHomePageViewModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBHomePageViewModel.h"

@implementation GBHomePageViewModel

/** 首页列表 */
- (void)loadRequestHomePageList {
    NSDictionary *param = @{@"pageNo":@1,@"pageSize":@3};
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_List httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"首页列表:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"首页列表 error:%@",error);
        
    }];
}

/** 换一批老司机 */
- (void)loadRequestRandDecrypts {
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_RandDecrypts httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"换一批老司机:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"换一批老司机 error:%@",error);
        
    }];
}

/** 推荐保过大师数 */
- (void)loadRequestMastersCount {
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MastersCount httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"推荐保过大师数:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"推荐保过大师数 error:%@",error);
        
    }];
}

/** 更多保过大师 */
- (void)loadRequestMoreMasters:(NSInteger )pageNo pageSize:(NSInteger )pageSize orderBy:(NSString *)orderBy {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNo":[NSNumber numberWithInteger:pageNo],@"pageSize":[NSNumber numberWithInteger:pageSize]}];
    if (ValidStr(orderBy)) {
        [param setObject:orderBy forKey:@"orderBy"];
    }
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MoreMasters httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更多保过大师:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更多保过大师 error:%@",error);
        
    }];
}

/** 更多保过职位 */
- (void)loadRequestMorePositions:(NSInteger )pageNo pageSize:(NSInteger )pageSize {
    NSDictionary *param = @{@"pageNo":[NSNumber numberWithInteger:pageNo],@"pageSize":[NSNumber numberWithInteger:pageSize]};
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MorePositions httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更多保过职位 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更多保过职位  error:%@",error);
        
    }];
}
/** 更多文章 */
- (void)loadRequestMoreEssays:(NSInteger )pageNo pageSize:(NSInteger )pageSize {
    NSDictionary *param = @{@"pageNo":[NSNumber numberWithInteger:pageNo],@"pageSize":[NSNumber numberWithInteger:pageSize]};
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MoreEssays httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更多文章 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更多文章  error:%@",error);
        
    }];
}

/** 关注保过职位 */
- (void)loadRequestWatchPosition:(NSInteger )incumbentAssurePassId {
    NSDictionary *param = @{@"incumbentAssurePassId":[NSNumber numberWithInteger:incumbentAssurePassId]};
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_WatchPosition httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"关注保过职位 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"关注保过职位  error:%@",error);
        
    }];
}

/** 关注解密 */
- (void)loadRequestWatchDecrypt:(NSInteger )incumbentAssurePassId {
    NSDictionary *param = @{@"incumbentAssurePassId":[NSNumber numberWithInteger:incumbentAssurePassId]};
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_WatchDecrypt httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"关注解密 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"关注解密  error:%@",error);
        
    }];
}

/** 职位搜索 */
- (void)loadRequestPositionSearch:(NSInteger )pageNo
                         pageSize:(NSInteger )pageSize
                          jobName:(NSString *)jobName
                        minSalary:(NSString *)minSalary
                        maxSalary:(NSString *)maxSalary
                   experienceCode:(NSString *)experienceCode
{
    NSDictionary *tempparam = @{@"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"jobName":jobName
                            };
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:tempparam];
    if (ValidStr(minSalary)) {
        [param setObject:minSalary forKey:@"minSalary"];
    }
    if (ValidStr(maxSalary)) {
        [param setObject:maxSalary forKey:@"maxSalary"];
    }
    if (ValidStr(experienceCode)) {
        [param setObject:experienceCode forKey:@"experienceCode"];
    }
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_PositionSearch httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"职位搜索 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"职位搜索  error:%@",error);
        
    }];
}

/** 职位搜索主页谁能邦你-更多V1 */
- (void)loadRequestMorePositionRelatedMasters:(NSInteger )pageNo
                                     pageSize:(NSInteger )pageSize
                                      jobName:(NSString *)jobName
                                    minSalary:(NSString *)minSalary
                                    maxSalary:(NSString *)maxSalary
                               experienceCode:(NSString *)experienceCode
{
    NSDictionary *param = @{@"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"jobName":jobName,
                            @"minSalary":minSalary,
                            @"maxSalary":maxSalary,
                            @"experienceCode":experienceCode,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MorePositionRelatedMasters httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"职位搜索主页谁能邦你-更多 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"职位搜索主页谁能邦你-更多  error:%@",error);
        
    }];
}
/** 职位搜索主页相关解密-更多V1 */
- (void)loadRequestMorePositionRelatedDecrypts:(NSInteger )pageNo
                                      pageSize:(NSInteger )pageSize
                                       jobName:(NSString *)jobName
{
    NSDictionary *param = @{@"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"jobName":jobName,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MorePositionRelatedDecrypts httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"职位搜索主页相关解密-更多 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"职位搜索主页相关解密-更多  error:%@",error);
        
    }];
}

/** 职位搜索主页-热门职位V1 */
- (void)loadRequestHomePageHotJob {
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_hotJob httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"热门职位 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"热门职位  error:%@",error);
        
    }];
}

/** 公司搜索主页-公司名称检索V1 - 实时显示 */
- (void)loadRequestCompanyNamesSearch:(NSString *)companyName
{
    NSDictionary *param = @{@"companyName":companyName};
    [[NetDataServer sharedInstance] requestURL:URL_Home_CompanyNamesSearch httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"公司名称检索 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"公司名称检索  error:%@",error);
        
    }];
}

/** 公司搜索主页-搜索加载V1 */
- (void)loadRequestCompanySearch:(NSString *)companyName
              personelScaleCode:(NSString *)personelScaleCode
                      industryId:(NSInteger )industryId
                       companyId:(NSInteger )companyId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"companyName":companyName}];
    if (ValidStr(personelScaleCode)) {
        [param setObject:personelScaleCode forKey:@"personelScaleCode"];
    }
    if (industryId) {
        [param setObject:[NSNumber numberWithInteger:industryId] forKey:@"industryId"];
    }
    if (companyId) {
        [param setObject:[NSNumber numberWithInteger:industryId] forKey:@"companyId"];
    }
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_CompanySearch httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"公司搜索主页 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"公司搜索主页  error:%@",error);
        
    }];
}

///** 公司搜索主页-职位换一批V1 */
//- (void)loadRequestCompanyPositionChanging:(NSInteger )pageNo
//                                  pageSize:(NSInteger )pageSize
//                                 companyId:(NSInteger )companyId
//{
//    NSDictionary *param = @{@"pageNo":[NSNumber numberWithInteger:pageNo],
//                            @"pageSize":[NSNumber numberWithInteger:pageSize],
//                            @"companyId":[NSNumber numberWithInteger:companyId]
//                            };
//    [[NetDataServer sharedInstance] requestURL:URL_HomePage_CompanyPositionChanging httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
//        NSLog(@"职位换一批 :%@",responseData);
//        if ([responseData[@"result"] integerValue] == 1) {
//            self.returnBlock(responseData[@"data"]);
//        }else {
//            [UIView showHubWithTip:responseData[@"msg"]];
//        }
//    } fail:^(NSError *error) {
//        NSLog(@"职位换一批  error:%@",error);
//        
//    }];
//}
/** 公司搜索主页-认证同事更多V1 */
- (void)loadRequestMoreCompanyIncumbents:(NSInteger )pageNo
                                pageSize:(NSInteger )pageSize
                               companyId:(NSInteger )companyId
{
    NSDictionary *param = @{@"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"companyId":[NSNumber numberWithInteger:companyId]
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MoreCompanyIncumbents httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"认证同事更多 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"认证同事更多 error:%@",error);
        
    }];
}
/** 公司搜索主页-相关解密更多V1 */
- (void)loadRequestMoreCompanyDecrypts:(NSInteger )pageNo
                              pageSize:(NSInteger )pageSize
                             companyId:(NSString *)companyId
{
    NSDictionary *param = @{@"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"companyId":companyId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MoreCompanyDecrypts httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"相关解密更多 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"相关解密更多 error:%@",error);
        
    }];
}

/** 公司搜索-推荐公司V1 */
- (void)loadRequestHotCompanies {
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_HotCompanies httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"热门公司:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"热门公司 error:%@",error);
        
    }];
}

/** 搜索轨迹V1 */
- (void)loadRequestSearchTrace:(NSString *)companyName
                       jobName:(NSString *)jobName {
    NSDictionary *param;
    if (ValidStr(companyName)) {
        param = @{
                  @"companyName":companyName
                  };
    }else if (ValidStr(jobName)) {
        param = @{
                  @"jobName":jobName
                  };
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_SearchTrace httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"搜索轨迹:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"搜索轨迹 error:%@",error);
        
    }];
    
}

/** 爬取的更多职位 */
- (void)loadRequestCpositions:(NSString *)searchJobName
                        param:(NSDictionary *)param
                       pageNo:(NSInteger )pageNo
                     pageSize:(NSInteger )pageSize

{
    NSDictionary *mutParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [mutParam setValue:searchJobName forKey:@"jobName"];
    [mutParam setValue:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    [mutParam setValue:[NSNumber numberWithInteger:pageNo] forKey:@"pageNo"];
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_Cpositions httpMethod:@"POST" headerParams:nil params:mutParam file:nil success:^(id responseData) {
        NSLog(@"爬取的更多职位:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"爬取的更多职位 error:%@",error);
        
    }];
}
/** 公司搜索在招职位换一批 */
- (void)loadRequestCompanyPositionChanging:(NSString *)companyId {
    NSDictionary *param = @{
                            @"companyId":companyId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_CompanyPositionChanging httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"公司搜索在招职位换一批:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"公司搜索在招职位换一批 error:%@",error);
        
    }];
}

/** 更多公司 */
- (void)loadRequestMoreCompanies:(NSInteger )pageNo pageSize:(NSInteger )pageSize companyName:(NSString *)companyName {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"companyName":companyName
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MoreCompanies httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更多公司:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更多公司 error:%@",error);
        
    }];
}

/** 公司主页 */
- (void)loadRequestCompanyMainPage:(NSString *)companyId {
    NSDictionary *param = @{
                            @"companyId":companyId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_CompanyMainPage httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"公司主页:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"公司主页error:%@",error);
        
    }];
}

/** 个人主页增加访问量 */
- (void)loadRequestPersonalHomePageVisitOnce:(NSString *)targetUserId {
    NSDictionary *param = @{
                            @"targetUserId":targetUserId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_VisitOnce httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"个人主页增加访问量:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"个人主页增加访问量error:%@",error);
        
    }];
}

/** 公司主页在职同事换一批 */
- (void)loadRequestCompanyIncumbentsChanging:(NSString *)companyId {
    NSDictionary *param = @{
                            @"companyId":companyId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_CompanyIncumbentsChanging httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"公司主页在职同事换一批:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"公司主页在职同事换一批error:%@",error);
        
    }];
}

/** 更多公司在招职位 */
- (void)loadRequestMoreCompanyPositions:(NSString *)companyId
                            companyName:(NSString *)companyName
                                 pageNo:(NSInteger )pageNo
                               pageSize:(NSInteger )pageSize
                              minSalary:(NSString *)minSalary
                              maxSalary:(NSString *)maxSalary
                         experienceCode:(NSString *)experienceCode
{
    NSDictionary *tempparam = @{
                            @"companyId":companyId,
                            @"companyName":companyName,
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize]
                            };
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:tempparam];

    if (ValidStr(minSalary)) {
        [param setObject:minSalary forKey:@"minSalary"];
    }
    if (ValidStr(maxSalary)) {
        [param setObject:maxSalary forKey:@"maxSalary"];
    }
    if (ValidStr(experienceCode)) {
        [param setObject:experienceCode forKey:@"experienceCode"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MoreCompanyPositions httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更多公司在招职位:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更多公司在招职位error:%@",error);
        
    }];
}

/** 爬取职位观注V1 */
- (void)loadRequestWatchcPosition:(NSString *)positionId {
    NSDictionary *param = @{
                            @"positionId":positionId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_WatchcPosition httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"爬取职位观注V1:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"爬取职位观注V1error:%@",error);
        
    }];
}

/** 更多解密咨询 */
- (void)loadRequestMoreDecrypts:(NSInteger )pageNo
                       pageSize:(NSInteger )pageSize
{
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageNo":[NSNumber numberWithInteger:pageSize]
                            };
    [[NetDataServer sharedInstance] requestURL:URL_HomePage_MoreDecrypts httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更多解密咨询V2:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更多解密咨询V2error:%@",error);
        
    }];
}
@end
