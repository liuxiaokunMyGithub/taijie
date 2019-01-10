//
//  GBHomePageSearchViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/15.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"
#import "GBFiltrateModel.h"
#import "GBCompanyFiltrateModel.h"

@interface GBHomePageSearchViewController : PYSearchViewController
/* <#describe#> */
@property (nonatomic, assign) SearchType searchType;
/* <#describe#> */
@property (nonatomic, strong) GBFiltrateModel *filtrateModel;
/* <#describe#> */
@property (nonatomic, strong) GBCompanyFiltrateModel *companyFitrateModel;
/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;

/* 筛选回调 */
@property (nonatomic, copy) void(^filtrateBlock)(GBFiltrateModel *filtrateModel);

@end
