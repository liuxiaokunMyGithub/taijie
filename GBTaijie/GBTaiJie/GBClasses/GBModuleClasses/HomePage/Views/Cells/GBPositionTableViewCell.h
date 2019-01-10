//
//  GBPositionTableViewCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPositionCommonModel.h"

@interface GBPositionTableViewCell : UITableViewCell

/* 匹配职位 */
@property (strong , nonatomic) NSMutableArray <GBPositionCommonModel *> *positionModelArray;
/* collectionView */
@property (strong , nonatomic) UICollectionView *collectionView;

/* 点解更多回调 */
@property (nonatomic, copy) dispatch_block_t didselectMoreBlock;

@end
