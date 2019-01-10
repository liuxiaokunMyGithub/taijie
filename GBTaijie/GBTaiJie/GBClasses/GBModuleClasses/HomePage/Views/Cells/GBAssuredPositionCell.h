//
//  GBAssuredPositionCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPositionModel.h"

typedef NS_ENUM (NSInteger , PostionCellType) {
    /** 首页 */
    PositionCellTypeHomePage  =  0,
    /** 公司搜索 */
    PositionCellTypeCompanySearch,
    /** 公司主页 */
    PositionCellTypeCompanyHome
};

@interface GBAssuredPositionCell : UITableViewCell
/* <#describe#> */
@property (nonatomic, assign) PostionCellType positionCellType;

/* <#describe#> */
@property (nonatomic, strong) GBPositionModel *positionModel;
@end
