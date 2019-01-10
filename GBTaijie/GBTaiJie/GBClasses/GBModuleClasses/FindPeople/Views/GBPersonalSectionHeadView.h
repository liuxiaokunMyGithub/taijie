//
//  GBPersonalSectionHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GBLIRLButton.h"

@interface GBPersonalSectionHeadView : UITableViewHeaderFooterView
/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/* 子标题 */
@property (strong , nonatomic)UILabel *subTitleLabel;

/* 更多问答按钮 */
@property (strong , nonatomic) GBLIRLButton *moreButton;
/* <#describe#> */
@property (nonatomic, assign) NSInteger section;

/* 星星 */
@property (strong , nonatomic) HCSStarRatingView *starView;

/* <#describe#> */
@property (nonatomic, strong) void(^moreButtonClickBlock)(NSInteger section);

@end
