//
//  GBPositioinCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBPositionCommonModel;

@interface GBPositioinCell : UICollectionViewCell
/* 匹配职位 */
@property (strong , nonatomic) GBPositionCommonModel *positionModel;
/* 图片 */
@property (strong , nonatomic) UIImageView *goodsImageView;
@property (strong , nonatomic) UIImageView *backImageView;
/* 职位 */
@property (strong , nonatomic) UILabel *positionLabel;
/* 公司 */
@property (strong , nonatomic) UILabel *companyLabel;
@property (strong , nonatomic) NSIndexPath *indexPath;
/* 价格 */
@property (strong , nonatomic)UILabel *priceLabel;

@end
