//
//  CompanyModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/825.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : GBBaseModel

@property (nonatomic, copy) NSString *companyId;
/* <#describe#> */
@property (nonatomic, copy) NSString *id;

/* <#describe#> */
@property (nonatomic, copy) NSString *companyIncumbentsCount;

@property (nonatomic, copy) NSString *companyAbbreviatedName;
/* 公司全称 */
@property (nonatomic, copy) NSString *companyFullName;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, copy) NSString *industryName;
@property (nonatomic, copy) NSString *financingScale;
@property (nonatomic, copy) NSString *financingScaleName;
@property (nonatomic, copy) NSString *personnelScale;
@property (nonatomic, copy) NSString *personnelScaleName;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *avgScore;
@property (nonatomic, copy) NSString *incumbentCount;
@property (nonatomic, copy) NSString *inServiceTime;

@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *sourceName;
@property (nonatomic, copy) NSString *companyUrl;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyWebsite;
@property (nonatomic, copy) NSString *companyIntroduction;
@property (nonatomic, strong) NSMutableArray *scores;
@property (nonatomic, copy) NSString *recruitingPositionCount;
@property (nonatomic, copy) NSString *tags;

@property (nonatomic, copy) NSString *jobName;
@property (nonatomic, copy) NSString *entryTime;
/* <#describe#> */
@property (nonatomic, copy) NSString *introduction;


/* <#describe#> */
@property (nonatomic, strong) NSString *personelScaleName;
/** 是否实名认证 */
@property (nonatomic, assign) BOOL realNameAuthentication;
/** 是否认证企业邮箱 */
@property (nonatomic, assign) BOOL companyEamilAuthentication;
/** 在职证明认证 */
@property (nonatomic, assign) BOOL incumbentAuthentication;
/** 劳动合同认证 */
@property (nonatomic, assign) BOOL laborContractAuthentication;
/** 员工牌认证 */
@property (nonatomic, assign) BOOL employeeCardAuthentication;

@property (nonatomic, copy) NSString *recommendScore;
/* <#describe#> */
@property (nonatomic, assign) BOOL collected;

@end
