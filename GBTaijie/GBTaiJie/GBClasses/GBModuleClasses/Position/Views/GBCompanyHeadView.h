//
//  GBCompanyHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/15.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"

@interface GBCompanyHeadView : UIView

/* <#describe#> */
@property (nonatomic, strong) CompanyModel *companyModel;
/* 是否显示大标题 */
@property (nonatomic, assign) BOOL isShowBigTitle;
/* 标题 */
@property (strong , nonatomic) UILabel *titleLabel;

@end
