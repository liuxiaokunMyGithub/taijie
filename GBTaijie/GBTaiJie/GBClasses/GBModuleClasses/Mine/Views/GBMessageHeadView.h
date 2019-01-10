//
//  GBMessageHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/13.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBGridView.h"

@interface GBMessageHeadView : UIView
/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;

/* 九宫格按钮 */
@property (nonatomic, strong) GBGridView *messageGridView;

/* 分割线 */
@property (nonatomic, strong) UIView *line;

@end
