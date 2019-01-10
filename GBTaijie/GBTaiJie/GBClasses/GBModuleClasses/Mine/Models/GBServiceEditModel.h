//
//  GBServiceEditModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/23.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBServiceEditModel : GBBaseModel

// 解密类型
@property (nonatomic, copy) NSString *typeName;
// 解密类型对应后台字符
@property (nonatomic, copy) NSString *type;

// 服务标题
@property (nonatomic, copy) NSString *title;
// 服务内容
@property (nonatomic, copy) NSString *details;
// 价格
@property (nonatomic, copy) NSString *price;
/* <#describe#> */
@property (nonatomic, copy) NSString *originalPrice;
/* 折扣类型
 免费:FREE
 折扣:DISCOUNT
 */
@property (nonatomic, copy) NSString *discountType;

// 限时
@property (nonatomic, copy) NSString *limitedTime;

/* 服务id */
@property (nonatomic, copy) NSString *incumbentDecryptId;
@property (nonatomic, assign) NSInteger assurePassId;

/* 学历code
 EDUCATION_NO
 EDUCATION_ZH
 EDUCATION_GZ
 EDUCATION_ZK
 EDUCATION_XS
 EDUCATION_SX
 EDUCATION_BS
 
 */
@property (nonatomic, copy) NSString *dilamorCode;
/* 学历 */
@property (nonatomic, copy) NSString *dilamorName;
/* 经验 */
@property (nonatomic, copy) NSString *experienceName;
/* 经验code
 JOB_WORK_YEAR_NO
 JOB_WORK_YEAR_GT_0LT_0
 JOB_WORK_YEAR_LT_0
 JOB_WORK_YEAR_GT_1_LT_0
 JOB_WORK_YEAR_GT_5_LT_3
 JOB_WORK_YEAR_GT_10_LT_5
 JOB_WORK_YEAR_GT_10
 
 */
@property (nonatomic, copy) NSString *experienceCode;
/* 公司 */
@property (nonatomic, copy) NSString *companyName;
/* 工作 */
@property (nonatomic, copy) NSString *jobName;

/* 位置 */
@property (nonatomic, copy) NSString *regionName;
/* <#describe#> */
@property (nonatomic, copy) NSString *publisherRegionName;


/* 工作id */
@property (nonatomic, assign) NSString *jobId;
/* 最高薪资 */
@property (nonatomic, assign) NSString *maxSalary;
/* 最低薪资 */
@property (nonatomic, assign) NSInteger purchasedCount;
/* 位置id */
@property (nonatomic, copy) NSString *regionId;
/* 最小薪资 */
@property (nonatomic, assign) NSString *minSalary;
/** 得分 */
@property (nonatomic, assign) NSInteger score;

// 是否开启
@property (nonatomic, assign) BOOL isEnable;

/* 保过服务标签 */
@property (nonatomic, strong) NSString *labelNames;
/* 保过服务 */
@property (nonatomic, strong) NSString *labelNamesIds;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *labels;

@end
