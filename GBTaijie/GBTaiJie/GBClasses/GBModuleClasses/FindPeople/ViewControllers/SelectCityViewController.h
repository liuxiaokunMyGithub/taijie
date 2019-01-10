//
//  SelectCityViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/828.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "CityModel.h"

typedef void(^SelectCityBlock) (CityModel *city);

@interface SelectCityViewController : GBBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) SelectCityBlock cityBlock;
/* <#describe#> */
@property (nonatomic, assign) BOOL isPersonal;


@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *locationResultL;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@end
