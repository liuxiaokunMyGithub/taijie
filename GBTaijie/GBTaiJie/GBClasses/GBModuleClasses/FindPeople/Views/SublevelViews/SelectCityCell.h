//
//  SelectCityCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/814.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"

typedef void(^CitySelectBlock) (CityModel *city);

@interface SelectCityCell : UITableViewCell

@property (nonatomic, strong) CitySelectBlock cityBlock;
@property (nonatomic, strong) NSArray *cityArray;

@end
