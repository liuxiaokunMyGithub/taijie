//
//  GBCompanyFiltrateModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBCompanyFiltrateModel : GBBaseModel

@property (nonatomic, assign) NSInteger id;
/* 公司 */
@property (nonatomic, copy) NSString *companyName;
/* 工作 */
@property (nonatomic, copy) NSString *companyFullName;

@property (nonatomic, assign) NSInteger industryId;
@property (nonatomic, assign) NSInteger companyId;

/* 规模 */
@property (nonatomic, copy) NSString *companyScaleName;

/* 规模Code
 @""
 @"COMPANY_SCALE_GT_0_LT_20"
 @"COMPANY_SCALE_GT_20_LT_99"
 @"COMPANY_SCALE_GT_100_LT_499"
 @"COMPANY_SCALE_GT_500_LT_999"
 @"COMPANY_SCALE_GT_1000_LT_9999"
 @"COMPANY_SCALE_GT_10000"]
 */
@property (nonatomic, copy) NSString *companyScaleCode;

@end
