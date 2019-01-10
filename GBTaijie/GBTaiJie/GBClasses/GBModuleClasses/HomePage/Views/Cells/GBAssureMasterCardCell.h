//
//  GBAssureMasterCardCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBAssureMasterModel.h"

@interface GBAssureMasterCardCell : UICollectionViewCell
/* <#describe#> */
@property (nonatomic, assign) MasterCardCellType masterCardCellType;

/* <#describe#> */
@property (nonatomic, strong) GBAssureMasterModel *assureMasterModel;
@end
