//
//  GBSearchCompanyCardHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"

@interface GBSearchCompanyCardHeadView : UIView
/* <#describe#> */
@property (nonatomic, strong) UIView *bgView;

- (void)reloadHeadView:(CompanyModel *)companyModel;

@end
