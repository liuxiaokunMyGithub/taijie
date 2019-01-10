//
//  GBMoreListTableViewCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPositionCommonModel.h"
#import "CompanyModel.h"

@interface GBMoreListTableViewCell : UITableViewCell
/* 匹配职位 */
@property (strong , nonatomic) GBPositionCommonModel *positionModel;
/* 公司 */
@property (nonatomic, strong) CompanyModel *companyModel;

@end
