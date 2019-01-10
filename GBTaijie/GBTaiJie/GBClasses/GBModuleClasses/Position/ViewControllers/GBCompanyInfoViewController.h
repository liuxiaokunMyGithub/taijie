//
//  GBCompanyInfoViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/5.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyModel;

@interface GBCompanyInfoViewController : GBBaseViewController

/* 职位模型 */
//@property (nonatomic, strong) NSString *companyIntroduction;
/* <#describe#> */
@property (nonatomic, strong) CompanyModel *companyModel;

@end
