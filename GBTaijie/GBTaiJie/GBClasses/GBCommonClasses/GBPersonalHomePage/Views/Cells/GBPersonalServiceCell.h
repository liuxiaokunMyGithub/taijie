//
//  GBPersonalServiceCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPositionServiceModel.h"

@interface GBPersonalServiceCell : UITableViewCell
/* 解密 */
@property (strong , nonatomic) GBPositionServiceModel *decryptionModel;
@property (strong , nonatomic) GBPositionServiceModel *assureModel;
/* <#describe#> */
@property (nonatomic, strong) UIView *lineView;

@end
