//
//  GBPositionViewModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface GBPositionViewModel : GBBassViewModel

/** 匹配职位 */
- (void)loadRequestPostionList:(NSInteger )pageNo pageSize:(NSInteger )pageSize intentionalIds:(NSArray *)intentionalIds;

/** 匹配解密 */
- (void)loadRequestDecryptList:(NSInteger )pageNo pageSize:(NSInteger )pageSize intentionalIds:(NSArray *)intentionalIds;

/** 获取意向列表 */
- (void)loadIntentionalPositions;

/** 职位详情  */
- (void)loadPositionsDeatail:(NSString *)positionId region:(NSInteger )region;

/** 获取经验 */
- (void)loadPositionsExperience;
/** 获取学历 */
- (void)loadPositionsEducation;
/** 保过详情页 */
- (void)loadPositionsAssurePassDetail:(NSInteger )assurePassId pageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSInteger )targetUserId;
/** 获取解密详情页 */
- (void)loadPositionsDecryptDetail:(NSInteger )decryptId pageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize targetUserId:(NSInteger )targetUserId;
/** 预约解密 */
- (void)loadPositionsOrderDecrypt:(NSString *)question
                personalSituation:(NSString *)personalSituation
               incumbentDecryptId:(NSInteger )incumbentDecryptId;
/** 预约保过 */
- (void)loadPositionsOrderAssurePass:(NSString *)leaveMesseges
                    zhimaCreditScore:(NSString *)zhimaCreditScore
                     positionInfoDic:(NSDictionary *)positionInfoDic
                        incumbentAssurePassId:(NSInteger )incumbentAssurePassId;
/** 解密可用性 */
- (void)loadPositionsDecryptAvailability:(NSInteger )incumbentDecryptId;
/** 保过可用性 */
- (void)loadPositionsAssurePassAvailability:(NSInteger )incumbentAssurePassId;

/** 职位意向管理-获取行业类型 */
- (void)loadPositionsIndustryType;
/** 职位意向管理-获取行业 */
- (void)loadPositionsIndustry:(NSString *)industryTypeId;
/** 删除意向职位 */
- (void)loadPositionsRemoval:(NSString *)intentionalId;
/** 新增更新意向职位 */
- (void)loadPositionIntentionalRenewal:(NSDictionary *)paramDic;

/** 支付 */
- (void)loadPositionPayWithType:(NSString *)type relatedId:(NSString *)relatedId payPwd:(NSString *)payPwd discountType:(NSString *)discountType;

/** 在招职位 */
- (void)loadPositionRecruiting:(NSString *)companyId pageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize;
/** 在职同事 */
- (void)loadPositionColleague:(NSString *)companyId pageNo:(NSInteger )pageNo pageSize:(NSInteger )pageSize;
/** 公司信息 */
- (void)loadPositionCompanyInfo:(NSString *)companyId;
/** 职位搜索 */
- (void)loadRequestPostitionSearch:(NSInteger )pageNo pageSize:(NSInteger )pageSize key:(NSString *)key;
/** 公司搜索 */
- (void)loadRequestCompanySearch:(NSInteger )pageNo pageSize:(NSInteger )pageSize key:(NSString *)key;
/** 同事搜索 */
- (void)loadRequestPersonalSearch:(NSInteger )pageNo pageSize:(NSInteger )pageSize key:(NSString *)key;

@end
