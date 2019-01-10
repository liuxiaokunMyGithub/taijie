//
//	GBFindPeopleModel.h
//
//	Create by 小坤 刘 on 26/6/2018
//	Copyright © 2018. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GBFindPeopleModel : GBBaseModel
@property (nonatomic, copy) NSString * adeptSkill;
@property (nonatomic, strong) NSArray * assurePassNames;
@property (nonatomic, strong) NSString * companyId;
@property (nonatomic, strong) NSString * companyName;
@property (nonatomic, assign) NSInteger degreeOfSatisfaction;
@property (nonatomic, assign) NSInteger entryTime;
@property (nonatomic, assign) BOOL hasAssurePassService;
@property (nonatomic, strong) NSString * headImg;
@property (nonatomic, assign) NSInteger helpedCount;
/* <#describe#> */
@property (nonatomic, assign) NSInteger collectedCount;
/* 好评率 */
@property (nonatomic, copy) NSString *goodRate;
/* 访问过 */
@property (nonatomic, assign) NSInteger visitCount;
/* 帮助过 */
@property (nonatomic, copy)  NSString *orderCount;
/* 及时性 */
@property (nonatomic, copy) NSString *responseTimeStr;
/* 故事 */
@property (nonatomic, copy) NSString *story;

/* 专业性 */
@property (nonatomic, copy) NSString *proficiencyRate;
/* 接单率 */
@property (nonatomic, copy) NSString *receiveRate;
/* 几0后 */
@property (nonatomic, copy) NSString *times;
/* 星座 */
@property (nonatomic, copy) NSString *constellation;
/* 认证多少天 */
@property (nonatomic, assign) NSInteger entryDays;

@property (nonatomic, assign) NSInteger inServiceTime;
@property (nonatomic, strong) NSArray * jobMatched;
@property (nonatomic, strong) NSString * nickName;

@property (nonatomic, strong) NSString * positionName;
/* 实名 */
@property (nonatomic, assign) BOOL realNameAuthentication;
/* 企业邮箱 */
@property (nonatomic, assign) BOOL companyEmailAuthentication;
/* 芝麻 */
@property (nonatomic, assign) BOOL zhimaCreditAuthentication;
/* 工牌 */
@property (nonatomic, assign) BOOL badgeAuthentication;
/* 在职证明 */
@property (nonatomic, assign) BOOL incumbencyCertification;
/* 劳动合同 */
@property (nonatomic, assign) BOOL laborContract;

@property (nonatomic, strong) NSString * region;
@property (nonatomic, strong) NSString * regionName;
@property (nonatomic, assign) NSInteger userId;
/* 创建时间 */
@property (nonatomic, copy) NSString *createTime;

/* 是否收藏 */
@property (nonatomic, copy) NSString *isCollected;

/* 性别 */
@property (nonatomic, copy) NSString *sex;
/* 工作经验 */
@property (nonatomic, copy) NSString *workingYear;

@end
