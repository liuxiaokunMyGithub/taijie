//
//	GBAssureMasterModel.h
//
//	Create by 小坤 刘 on 15/8/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "GBBaseModel.h"

@interface GBAssureMasterModel : GBBaseModel
/* <#describe#> */
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSInteger assureCount;
@property (nonatomic, assign) BOOL badgeAuth;
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, assign) BOOL companyEmailAuth;
@property (nonatomic, strong) NSString * companyLogo;
@property (nonatomic, strong) NSString * companyName;
@property (nonatomic, assign) NSInteger decryptCount;
@property (nonatomic, assign) NSInteger evaluateCount;
@property (nonatomic, strong) NSString * evaluateRate;
@property (nonatomic, assign) NSInteger evaluateStar;
@property (nonatomic, assign) BOOL hasAssure;
@property (nonatomic, assign) BOOL hasDecrypt;
@property (nonatomic, assign) NSInteger helpCount;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) BOOL incumbencyAuth;
@property (nonatomic, assign) BOOL laborContractAuth;
@property (nonatomic, strong) NSString * positionName;
@property (nonatomic, assign) BOOL realNameAuth;
/* <#describe#> */
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *id;
/* <#describe#> */
@property (nonatomic, copy) NSString *assureSuccessRate;

/* <#describe#> */
@property (nonatomic, copy) NSString *sex;
/* <#describe#> */
@property (nonatomic, copy) NSString *headImg;
/* <#describe#> */
@property (nonatomic, assign) NSInteger assureHelpCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
