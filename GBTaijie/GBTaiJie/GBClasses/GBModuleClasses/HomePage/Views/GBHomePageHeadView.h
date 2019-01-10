//
//  GBHomePageHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBNavSearchBarView.h"

@interface GBHomePageHeadView : UIView

/* 自定义搜索 */
@property (nonatomic, strong) GBNavSearchBarView *searchBar;
/* 数据提示Label */
@property (nonatomic, strong) UILabel *numberTitleLabel;

@end
