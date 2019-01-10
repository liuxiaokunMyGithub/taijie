//
//	GBPositionCommonModel.h
//
//	Create by 小坤 刘 on 27/6/2018
//	Copyright © 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

//*---------------------
// MARK: 职位相关同意model
//---------------------*

@interface GBPositionCommonModel : GBBaseModel
/** 平均分 */
@property (nonatomic, copy) NSString * avgScore;
/** 卡片背景色 */
@property (nonatomic, copy) NSString * backgroundColor;
/** 公司地址 */
@property (nonatomic, copy) NSString * companyAbbreviatedName;
/** 公司id */
@property (nonatomic, assign) NSInteger companyId;
/** 公司所属行业 */
@property (nonatomic, copy) NSString * companyIndustry;
/** 公司logo */
@property (nonatomic, copy) NSString * companyLogo;
/** 当前地区 */
@property (nonatomic, copy) NSString * currentRegion;
/** 融资规模 */
@property (nonatomic, copy) NSString * financingScale;
/** 当前计数 */
@property (nonatomic, assign) NSInteger incumbentCount;
/** 是否收藏 */
@property (nonatomic, assign) BOOL  isCollected;
/** jobId */
@property (nonatomic, assign) NSInteger jobId;
/** 工作名称 */
@property (nonatomic, copy) NSString * jobName;
/** 最高薪资 */
@property (nonatomic, assign) NSInteger maxSalary;
/** 最低薪资 */
@property (nonatomic, assign) NSInteger minSalary;
/** 当前职位名称 */
@property (nonatomic, copy) NSString * parentJobName;
/** 人员规模 */
@property (nonatomic, copy) NSString * personnelScale;
/** 职位平均薪资 */
@property (nonatomic, copy) NSString * positionAvgSalary;
/** 职位详情url */
@property (nonatomic, copy) NSString * positionDetailUrl;
/** 职位id */
@property (nonatomic, assign) NSInteger positionId;
/** 职位最高薪资 */
@property (nonatomic, copy) NSString * positionMaxSalary;
/** 职位最低薪资 */
@property (nonatomic, copy) NSString * positionMinSalary;
/** 职位名称 */
@property (nonatomic, copy) NSString * positionName;
/** 职位发布时间 */
@property (nonatomic, copy) NSString * positionReleaseTime;
/** 职位标注 */
@property (nonatomic, copy) NSString * positionRemark;
/** 职位薪资 */
@property (nonatomic, copy) NSString * positionSalary;
/** 职位区域薪资 */
@property (nonatomic, copy) NSString * positionSalaryOfRegion;
/** 招聘人数 */
@property (nonatomic, copy) NSString * recruitCount;
/** 地区 */
@property (nonatomic, assign) NSInteger region;
/** 地区名 */
@property (nonatomic, strong) NSString * regionName;
/** 教育水平 */
@property (nonatomic, strong) NSString * requiredEducational;
/** 教育水平名称 */
@property (nonatomic, strong) NSString * requiredEducationalName;
/** 工作经验 */
@property (nonatomic, strong) NSString * requiredExperience;
/** 工作经验时长名称 */
@property (nonatomic, strong) NSString * requiredExperienceName;
/** 技能要求 */
@property (nonatomic, strong) NSString * skillsTags;
/** 数据来源 */
@property (nonatomic, strong) NSString * source;
/** 来源名称 */
@property (nonatomic, strong) NSString * sourceName;
/** 目标公司 */
@property (nonatomic, assign) BOOL targetCompany;
/** 福利标签 */
@property (nonatomic, strong) NSString * welfareTags;
/** 工作地点 */
@property (nonatomic, strong) NSString * workingPlace;
/** 工作区域 */
@property (nonatomic, strong) NSString * workingPlaceTradingArea;
/** 简介 */
@property (nonatomic, copy) NSString *companyIntroduction;
/* 公司全称 */
@property (nonatomic, strong) NSString *companyFullName;
/* 更多 */
@property (nonatomic, assign) BOOL isMore;
/* <#describe#> */
@property (nonatomic, assign) NSInteger incumbentDecryptId;
/* <#describe#> */
@property (nonatomic, assign) NSInteger userId;
/* <#describe#> */
@property (nonatomic, assign) NSInteger id;

@end
