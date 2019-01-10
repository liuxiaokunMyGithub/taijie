//
//  GBFindColleaguesModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBFindColleaguesModel : GBBaseModel
@property (nonatomic, assign) NSInteger assureCount;
@property (nonatomic, strong) NSObject * assureJobName;
@property (nonatomic, strong) NSObject * assureMaxSalary;
@property (nonatomic, strong) NSObject * assureMinSalary;
@property (nonatomic, assign) BOOL badgeAuth;
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, assign) BOOL companyEmailAuth;
@property (nonatomic, strong) NSObject * companyLogo;
@property (nonatomic, strong) NSObject * companyName;
@property (nonatomic, assign) NSInteger decryptCount;
@property (nonatomic, assign) NSInteger evaluateCount;
@property (nonatomic, strong) NSObject * evaluateRate;
@property (nonatomic, assign) NSInteger evaluateStar;
@property (nonatomic, assign) NSInteger fullStarEvaluateCount;
@property (nonatomic, assign) BOOL hasAssure;
@property (nonatomic, assign) BOOL hasDecrypt;
@property (nonatomic, strong) NSObject * headImg;
@property (nonatomic, assign) NSInteger helpCount;
@property (nonatomic, strong) NSObject * idField;
@property (nonatomic, assign) BOOL incumbencyAuth;
@property (nonatomic, assign) BOOL laborContractAuth;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSObject * positionName;
@property (nonatomic, assign) BOOL realNameAuth;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString *userId;
/* <#describe#> */
@property (nonatomic, copy) NSString *adeptSkill;

/* <#describe#> */
@property (nonatomic, assign) BOOL isMore;

@end
