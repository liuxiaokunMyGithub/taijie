//
//  GBPastExperienceTableViewCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/30.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPastExperienceModel.h"

@interface GBPastExperienceTableViewCell : UITableViewCell
/* <#describe#> */
@property (nonatomic, strong) GBPastExperienceModel *pastExperienceModel;
@property (strong, nonatomic)UILabel *line;
/* <#describe#> */
@property (nonatomic, strong) UIView *point;

@end
