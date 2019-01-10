//
//  GBCollectionModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBCommenCollectionModel : GBBaseModel

@property (nonatomic, assign) CGFloat avgScore;
@property (nonatomic, strong) NSString * companyAbbreviatedName;
@property (nonatomic, strong) NSString * companyAddress;
@property (nonatomic, assign) NSInteger companyId;//公司id
@property (nonatomic, strong) NSString * companyLogo;
@property (nonatomic, strong) NSString * financingScale;
@property (nonatomic, strong) NSString * financingScaleName;
@property (nonatomic, assign) NSInteger industryId;
@property (nonatomic, strong) NSString * industryName;
@property (nonatomic, strong) NSString * personnelScale;
@property (nonatomic, strong) NSString * personnelScaleName;
@property (nonatomic, assign) NSInteger region;
@property (nonatomic, strong) NSString * regionName;

@property (nonatomic, strong) NSString * companyIndustry;
@property (nonatomic, assign) NSInteger maxSalary;
@property (nonatomic, assign) NSInteger minSalary;
@property (nonatomic, assign) NSInteger positionId;//职位id
@property (nonatomic, strong) NSString * positionName;
@property (nonatomic, strong) NSString * positionReleaseTime;
@property (nonatomic, strong) NSString * requiredEducational;
@property (nonatomic, strong) NSString * requiredEducationalName;
@property (nonatomic, strong) NSString * requiredExperience;
@property (nonatomic, strong) NSString * requiredExperienceName;
@property (nonatomic, assign) BOOL targetCompany;
@property (nonatomic, strong) NSString * workingPlace;
@property (nonatomic, strong) NSString * workingPlaceTradingArea;

@property (nonatomic, strong) NSString * companyName;
@property (nonatomic, assign) CGFloat degreeOfSatisfaction;
@property (nonatomic, assign) NSInteger entryTime;
@property (nonatomic, assign) BOOL hasAssurePassService;
@property (nonatomic, strong) NSString * headImg;
@property (nonatomic, assign) NSInteger helpedCount;
@property (nonatomic, assign) NSInteger inServiceTime;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, assign) NSInteger userId;//同事id
@end

@interface GBCollectionModel : GBBaseModel

/* 当前类型 */
@property (nonatomic, copy) NSString *type;

/* 收藏数据模型 */
@property (nonatomic, strong) GBCommenCollectionModel *details;

@end
