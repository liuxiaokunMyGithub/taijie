//
//  GBHomePageViewModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBHomePageViewModel : GBBassViewModel
/** 首页列表 */
- (void)loadRequestHomePageList;

/** 换一批老司机 */
- (void)loadRequestRandDecrypts;
/** 更多保过大师
 orderBy : HELP(保过数) RATE(好评率)
 */
- (void)loadRequestMoreMasters:(NSInteger )pageNo
                      pageSize:(NSInteger )pageSize
                       orderBy:(NSString *)orderBy;
/** 推荐保过大师数 */
- (void)loadRequestMastersCount;
/** 更多保过职位 */
- (void)loadRequestMorePositions:(NSInteger )pageNo pageSize:(NSInteger )pageSize;
/** 更多文章 */
- (void)loadRequestMoreEssays:(NSInteger )pageNo pageSize:(NSInteger )pageSize;
/** 关注保过职位 */
- (void)loadRequestWatchPosition:(NSInteger )incumbentAssurePassId;
/** 关注解密 */
- (void)loadRequestWatchDecrypt:(NSInteger )incumbentAssurePassId;

/** 职位搜索 */
- (void)loadRequestPositionSearch:(NSInteger )pageNo
                         pageSize:(NSInteger )pageSize
                          jobName:(NSString *)jobName
                        minSalary:(NSString *)minSalary
                        maxSalary:(NSString *)maxSalary
                   experienceCode:(NSString *)experienceCode;

/** 职位搜索主页谁能邦你-更多V1 */
- (void)loadRequestMorePositionRelatedMasters:(NSInteger )pageNo
                                     pageSize:(NSInteger )pageSize
                                      jobName:(NSString *)jobName
                                    minSalary:(NSString *)minSalary
                                    maxSalary:(NSString *)maxSalary
                               experienceCode:(NSString *)experienceCode;
/** 职位搜索主页相关解密-更多V1 */
- (void)loadRequestMorePositionRelatedDecrypts:(NSInteger )pageNo
                                      pageSize:(NSInteger )pageSize
                                       jobName:(NSString *)jobName;

/** 职位搜索主页-热门职位V1 */
- (void)loadRequestHomePageHotJob;

/** 公司搜索主页-公司名称检索V1 - 实时显示 */
- (void)loadRequestCompanyNamesSearch:(NSString *)companyName;
/** 公司搜索主页-搜索加载V1 */
- (void)loadRequestCompanySearch:(NSString *)companyName
               personelScaleCode:(NSString *)personelScaleCode
                      industryId:(NSInteger )industryId
                       companyId:(NSInteger )companyId;

///** 公司搜索主页-职位换一批V1 */
//- (void)loadRequestCompanyPositionChanging:(NSInteger )pageNo
//                        pageSize:(NSInteger )pageSize
//                       companyId:(NSInteger )companyId;

/** 公司搜索主页-认证同事更多V1 */
- (void)loadRequestMoreCompanyIncumbents:(NSInteger )pageNo
                                pageSize:(NSInteger )pageSize
                               companyId:(NSInteger )companyId;
/** 公司搜索主页-相关解密更多V1 */
- (void)loadRequestMoreCompanyDecrypts:(NSInteger )pageNo
                              pageSize:(NSInteger )pageSize
                             companyId:(NSString *)companyId;

/** 公司搜索-推荐公司V1 */
- (void)loadRequestHotCompanies;
/** 搜索轨迹V1 */
- (void)loadRequestSearchTrace:(NSString *)companyName
                       jobName:(NSString *)jobName;

/** 爬取的更多职位 */
- (void)loadRequestCpositions:(NSString *)searchJobName
                        param:(NSDictionary *)param
                       pageNo:(NSInteger )pageNo
                     pageSize:(NSInteger )pageSize;
/** 公司搜索在招职位换一批 */
- (void)loadRequestCompanyPositionChanging:(NSString *)companyId;
/** 更多公司 */
- (void)loadRequestMoreCompanies:(NSInteger )pageNo pageSize:(NSInteger )pageSize companyName:(NSString *)companyName;
/** 公司主页 */
- (void)loadRequestCompanyMainPage:(NSString *)companyId;
/** 个人主页增加访问量 */
- (void)loadRequestPersonalHomePageVisitOnce:(NSString *)targetUserId;
/** 公司主页在职同事换一批 */
- (void)loadRequestCompanyIncumbentsChanging:(NSString *)companyId;
/** 更多公司在招职位 */
- (void)loadRequestMoreCompanyPositions:(NSString *)companyId
                            companyName:(NSString *)companyName
                                 pageNo:(NSInteger )pageNo
                               pageSize:(NSInteger )pageSize
                              minSalary:(NSString *)minSalary
                              maxSalary:(NSString *)maxSalary
                         experienceCode:(NSString *)experienceCode;
/** 爬取职位观注V1 */
- (void)loadRequestWatchcPosition:(NSString *)positionId;
/** 更多解密咨询 */
- (void)loadRequestMoreDecrypts:(NSInteger )pageNo
                       pageSize:(NSInteger )pageSize;

@end
