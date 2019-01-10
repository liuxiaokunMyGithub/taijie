//
//  GBPositionModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/15.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBPositionModel : GBBaseModel

@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * dilamorName;
@property (nonatomic, strong) NSString * experienceName;
@property (nonatomic, assign) NSInteger incumbentAssurePassId;
@property (nonatomic, strong) NSString * jobName;
@property (nonatomic, assign) NSInteger maxSalary;
@property (nonatomic, assign) NSInteger minSalary;
@property (nonatomic, strong) NSString * targetCompanyLogo;
@property (nonatomic, strong) NSString * targetCompanyName;
/* <#describe#> */
@property (nonatomic, assign) NSInteger userId;
/* <#describe#> */
@property (nonatomic, assign) NSInteger id;

/* 公司 */
@property (nonatomic, copy) NSString *companyName;
/* <#describe#> */
@property (nonatomic, strong) NSDictionary *company;
/* <#describe#> */
@property (nonatomic, strong) NSString *companyFullName;
@property (nonatomic, strong) NSString * requiredExperience;
@property (nonatomic, strong) NSString * requiredEducation;
/* <#describe#> */
@property (nonatomic, copy) NSString *positionName;

@property (nonatomic, assign) NSInteger watchCount;
/* <#describe#> */
@property (nonatomic, copy) NSString *companyLogo;

@end
