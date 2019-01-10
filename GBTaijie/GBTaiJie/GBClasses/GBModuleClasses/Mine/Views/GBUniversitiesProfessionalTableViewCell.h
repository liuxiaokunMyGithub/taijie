//
//  GBUniversitiesProfessionalTableViewCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBUniversitiesOverseasItemCell.h"

#import "GBEducationExperienceModel.h"

@interface GBUniversitiesProfessionalTableViewCell : UITableViewCell

@property (strong , nonatomic) UICollectionView *collectionView;
/* <#describe#> */
/* 国内 */
@property (nonatomic, strong) GBEducationExperienceModel *educationDomesticModel;
/* 海外 */
@property (nonatomic, strong) GBEducationExperienceModel *educationOverseasModel;
/* <#describe#> */
@property (nonatomic, strong) GBUniversitiesOverseasItemCell *overseasItemCell;
@end
