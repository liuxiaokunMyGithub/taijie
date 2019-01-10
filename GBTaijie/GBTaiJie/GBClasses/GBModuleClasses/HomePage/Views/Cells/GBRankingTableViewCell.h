//
//  GBRankingTableViewCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBRankModel.h"

@interface GBRankingTableViewCell : UITableViewCell
/** 排行 */
@property (nonatomic, strong) NSMutableArray <GBRankModel *> *ranks;

@property (strong , nonatomic) UICollectionView *collectionView;

@end
