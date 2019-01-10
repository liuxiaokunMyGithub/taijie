//
//	GBPositionServiceModel.h
//
//	Create by 小坤 刘 on 27/6/2018
//	Copyright © 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

//*------------------------------------
// MARK: 职位服务 model - 包括（解密，保过）
//-------------------------------------*

@interface GBPositionServiceModel : NSObject

// MARK: 保过特有字段
/* 保过id */
@property (nonatomic, assign) NSInteger incumbentAssurePassId;
@property (nonatomic, assign) NSInteger assurePassId;
/* 工作id */
@property (nonatomic, assign) NSInteger jobId;
/* 职位 */
@property (nonatomic, copy) NSString *jobName;
/** 地点 */
@property (nonatomic, copy) NSString *regionName;
/** 公司 */
@property (nonatomic, copy) NSString *companyName;
/** 经验 */
@property (nonatomic, copy) NSString *experienceName;
/** 学历 */
@property (nonatomic, copy) NSString *dilamorName;
/** 最小薪资 */
@property (nonatomic, copy) NSString *minSalary;
/** 最大薪资 */
@property (nonatomic, copy) NSString *maxSalary;

/** 用户id */
@property (nonatomic, copy) NSString * appUserId;
/** 公司logo */
@property (nonatomic, copy) NSString * companyLogo;
/** 详情 */
@property (nonatomic, copy) NSString * details;
/** 评论数 */
@property (nonatomic, assign) NSInteger evaluateCount;
/** 当前解密id */
@property (nonatomic, assign) NSInteger incumbentDecryptId;
/** 是否有效 */
@property (nonatomic, assign) BOOL isEnable;
/** 价格 */
@property (nonatomic, assign) NSInteger price;
/* <#describe#> */
@property (nonatomic, assign) NSInteger originalPrice;

/** 发布时间 */
@property (nonatomic, copy) NSString * publishTime;
/** 发布者 */
@property (nonatomic, copy) NSString * publisher;
/** 发布公司 */
@property (nonatomic, copy) NSString * publisherCompany;
/** 发布公司id */
@property (nonatomic, assign) NSInteger publisherCompanyId;
/** 发布者头像 */
@property (nonatomic, copy) NSString * publisherHeadImg;
/** 发布者id */
@property (nonatomic, assign) NSInteger publisherId;
/** 发布者职位 */
@property (nonatomic, copy) NSString * publisherPosition;
/* 发布的职位 */
@property (nonatomic, copy) NSString *publisherJobName;
/* 发布者的职位 */
@property (nonatomic, copy) NSString *publisherManualPositionName;
/* 发布者所在地区 */
@property (nonatomic, copy) NSString *publisherRegionName;

/* 发布者在职时间 */
@property (nonatomic, assign) NSInteger inServiceTime;

/** 是否已购买 */
@property (nonatomic, assign) BOOL purchased;
/** 购买数量 */
@property (nonatomic, assign) NSInteger quantityPurchased;
/** 点赞 */
@property (nonatomic, copy) NSString * star;
/** 标题 */
@property (nonatomic, copy) NSString * title;
/** 用户token */
@property (nonatomic, copy) NSString * token;
/** 类型 */
@property (nonatomic, copy) NSString * type;
/** 类型 */
@property (nonatomic, copy) NSArray * types;
/** 类型 */
@property (nonatomic, copy) NSString * classifiedName;

/** 类型名称 */
@property (nonatomic, copy) NSString * typeName;

// MARK: 解密详情
/* 标题 */
@property (nonatomic, copy) NSString *detail;
/* 限时 */
@property (nonatomic, copy) NSString *limitedTime;
/* 已购人数 */
@property (nonatomic, assign) NSInteger purchasedCount;

@property (nonatomic, strong) NSString * serviceType;

/* 是否折扣 */
@property (nonatomic, assign) BOOL discountEnable;

/* <#describe#> */
@property (nonatomic, copy) NSString *orderCount;
/* <#describe#> */
@property (nonatomic, copy) NSString *goodRate;
/* <#describe#> */
@property (nonatomic, strong) NSArray *labels;
/* <#describe#> */
@property (nonatomic, copy) NSString *discountType;
/* <#describe#> */
@property (nonatomic, copy) NSString *labelNames;

@end
