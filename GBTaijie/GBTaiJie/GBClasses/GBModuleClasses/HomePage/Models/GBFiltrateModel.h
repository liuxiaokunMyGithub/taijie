//
//  GBFiltrateModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBFiltrateModel : GBBaseModel
// 解密类型对应后台字符
@property (nonatomic, copy) NSString *type;

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

/* 最高薪资 */
@property (nonatomic, assign) NSString *maxSalary;
/* 最小薪资 */
@property (nonatomic, assign) NSString *minSalary;

@end
