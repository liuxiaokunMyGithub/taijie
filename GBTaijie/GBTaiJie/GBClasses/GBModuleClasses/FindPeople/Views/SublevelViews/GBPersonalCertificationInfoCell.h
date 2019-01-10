//
//  GBPersonalCertificationInfoCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBFindPeopleModel.h"

@interface GBPersonalCertificationInfoCell : UITableViewCell
/* <#describe#> */
@property (nonatomic, strong) GBFindPeopleModel *peopleModel;
/* 认证信息图标 */
@property (nonatomic, strong) NSMutableArray *certificatIcons;
/* 认证信息标题 */
@property (nonatomic, strong) NSMutableArray *certificatTitles;

@property (strong , nonatomic) UICollectionView *collectionView;


@end
