//
//  GBAssuredMasterTableViewCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBAssureMasterModel.h"


@interface GBAssuredMasterTableViewCell : UITableViewCell

@property (nonatomic, assign) MasterCardCellType masterCardCellType;

/** 大师 */
@property (nonatomic, strong) NSMutableArray <GBAssureMasterModel *> *assureMasters;

@property (strong , nonatomic) UICollectionView *collectionView;
/* <#describe#> */
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end
