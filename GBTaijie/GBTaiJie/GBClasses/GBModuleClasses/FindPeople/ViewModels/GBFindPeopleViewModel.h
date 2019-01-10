//
//  GBFindPeopleViewModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBFindPeopleViewModel : GBBassViewModel
/** 轮播图 */
- (void)loadRequestBanner;
/** 推荐的人 */
- (void)loadRequestPersonList:(NSInteger )pageNo pageSize:(NSInteger )pageSize intentionalIds:(NSArray *)intentionalIds;

/** 加入黑名单 */
- (void)loadRequestJoinBlackList:(NSString *)targetUserId location:(NSString *)location;

// MARK: 重置意向相关
/** 获取找人意向 */
- (void)loadRequestIncumbent:(NSArray *)intentionalIds;
/**
 更新或匹配找人意向
 intentionalId 新建可为空 更新需要值
 */
- (void)loadRequestRenewalIncumbent:(NSString *)jobId
                            jobName:(NSString *)jobName
                             region:(NSString *)region
                         regionName:(NSString *)regionName
               intentionalCompanyId:(NSString *)intentionalCompanyId
             intentionalCompanyName:(NSString *)intentionalCompanyName
                     intentionalIds:(NSInteger )intentionalId;
/** 城市列表 */
- (void)loadRequestCityRegion:(BOOL)isPersonal;
/** 根据地区拼音首字母获取地区 */
- (void)loadRequestCityCode:(NSString *)regionName;
/** 搜索公司 */
- (void)loadRequestSearchCompanyI:(NSInteger )pageNo pageSize:(NSInteger )pageSize key:(NSString *)key;
/**
 职位列表

 @param jobPid 职位id (为空时获取一级目录)
 @param jobLayer 层级（1,2,3分别对应三级目录）
 @param limited  YES（表示只推荐10条精准匹配）NO（表示全部推荐）
 */
- (void)loadRequestJobList:(NSString *)jobPid jobLayer:(NSString *)jobLayer limited:(BOOL )limited;
/**
 精准匹配兴趣标签提交

 @param intentionalIncumbent (两份数据内容一样)
 @param intentionalPosition （用于后台方便区分）
 */
- (void)loadRequestSkipPage:(NSDictionary *)intentionalIncumbent intentionalPosition:(NSDictionary *)intentionalPosition;

/** 个人主页-服务 */
- (void)loadRequestPersonalService:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSString *)targetUserId;

/** 个人主页-个人信息及评论 */
- (void)loadRequestPersonComment:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSString *)targetUserId;

/** 更多解密服务 */
- (void)loadRequestPersonMoreDecrypt:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSString *)targetUserId;

/**
 举报
 关联内容类型 relatedType
 职位:REPORT_TYPE_POSITION
 公司:REPORT_TYPE_COMPANY
 求职者:REPORT_TYPE_CANDIDATE
 在职者:REPORT_TYPE_INCUMBENT
 在职者问答:REPORT_TYPE_INCUMBENT_QUESTION
 在职者解密:REPORT_TYPE_INCUMBENT_DECRYPT
 在职者保过:REPORT_TYPE_INCUMBENT_ASSURE_PASS
 问答:REPORT_TYPE_QUESTION
 解密:REPORT_TYPE_DECRYPT
 保过:REPORT_TYPE_ASSURE_PASS
 八卦举报：REPORT_GOSSIP
 八卦评论举报：REPORT_GOSSIP_COMMENT
 举报人：REPORT_TYPE_USER
 
 @param relatedId （举报的id 人就是userid 职位就是职位id）
 @param relatedType
 @param reportReason 举报理由
 @param remark 输入内容
 */
- (void)loadRequestRelatedId:(NSString *)relatedId reportReason:(NSString *)reportReason relatedType:(NSString *)relatedType remark:(NSString *)remark;

@end
