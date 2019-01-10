//
//  GBSearchCompanyViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/17.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"
#import "CompanyModel.h"

typedef void(^CompanyOrCitySelectBlock) (NSString *companyOrCity);

typedef void(^CompanySelectBlock) (CompanyModel *company);
typedef void(^CitySelectBlock) (CityModel *city);

@interface GBSearchCompanyViewController : GBBaseViewController

/** index == 0: 求职者搜索公司，index == 1: 在职者搜索公司, index == 2:搜索城市 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) CompanyOrCitySelectBlock companyOrCityBlock;
@property (nonatomic, copy) CompanySelectBlock companyBlock;
@property (nonatomic, copy) CitySelectBlock cityBlock;

@end
