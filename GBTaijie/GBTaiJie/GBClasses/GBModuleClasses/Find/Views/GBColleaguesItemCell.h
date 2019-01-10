//
//  GBColleaguesItemCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBFindColleaguesModel.h"

@interface GBColleaguesItemCell : UICollectionViewCell
/* 匹配职位 */
@property (strong , nonatomic) GBFindColleaguesModel *colleaguesModel;
/* 图片 */
@property (strong , nonatomic) UIImageView *goodsImageView;
@property (strong , nonatomic) UIImageView *backImageView;
/* 职位 */
@property (strong , nonatomic) UILabel *nickLabel;
/* 地址 */
@property (strong , nonatomic) UILabel *positionLabel;
@property (strong , nonatomic) UILabel *scoreLabel;

@property (strong , nonatomic) NSIndexPath *indexPath;

@end
