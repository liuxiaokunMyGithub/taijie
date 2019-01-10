//
//  GBSectionHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBLIRLButton.h"

@interface GBSectionHeadView : UITableViewHeaderFooterView
/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/* 子标题 */
@property (strong , nonatomic)UILabel *subTitleLabel;
/* <#describe#> */
@property (nonatomic, assign) NSInteger section;

/* 更多问答按钮 */
@property (strong , nonatomic) GBLIRLButton *moreButton;
/* <#describe#> */
@property (nonatomic, strong) void(^moreButtonClickBlock)(NSInteger section);

@end
