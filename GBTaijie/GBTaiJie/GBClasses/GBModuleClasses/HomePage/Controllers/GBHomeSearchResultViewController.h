//
//  GBHomeSearchResultViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/16.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"
#import "GBFiltrateModel.h"
#import "GBCompanyFiltrateModel.h"

@interface GBHomeSearchResultViewController : GBBaseViewController

@property (nonatomic, assign) SearchType searchType;
// 公司搜索
- (void)loadRequestCompanySearch:(NSString *)searchText companyFiltrateModel:(GBCompanyFiltrateModel *)companyFiltrateModel;

// 职位搜索
- (void)loadRequestPositionSearch:(NSString *)searchText filtrateModel:(GBFiltrateModel *)filtrateModel;

@end
