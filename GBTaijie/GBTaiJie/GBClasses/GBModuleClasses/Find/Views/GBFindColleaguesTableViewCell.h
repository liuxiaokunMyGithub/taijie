//
//  GBFindColleaguesTableViewCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBFindColleaguesModel.h"
@interface GBFindColleaguesTableViewCell : UITableViewCell
/* <#describe#> */
@property (nonatomic, strong) UICollectionView *collectionView;
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBFindColleaguesModel *> *colleaguesModels;

@end
