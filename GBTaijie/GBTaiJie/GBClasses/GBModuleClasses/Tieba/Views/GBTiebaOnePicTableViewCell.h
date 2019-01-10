//
//  GBTiebaOnePicTableViewCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/7.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBTiebaModel.h"

@interface GBTiebaOnePicTableViewCell : UITableViewCell
/* 帖子模型 */
@property (nonatomic, strong) GBTiebaModel *tiebaModel;

/* 分割线 */
@property (nonatomic, strong) UIView *line;

@end
