//
//  SalarySelectViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseViewController.h"

typedef void(^SalarySelectBlock)(NSString *minSalary, NSString *maxSalary);

@interface SalarySelectViewController : GBBaseViewController

@property (nonatomic, copy) SalarySelectBlock selectBlock;

@end
