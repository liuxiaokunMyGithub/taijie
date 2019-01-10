//
//  GBMoreButtonFooterView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/29.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBLLRIButton.h"

@interface GBMoreButtonFooterView : UITableViewHeaderFooterView

/* 更多按钮 */
@property (strong , nonatomic) GBLLRIButton *moreButton;

/* <#describe#> */
@property (nonatomic, copy) dispatch_block_t moreButtonActionBlock;

/* <#describe#> */
@property (nonatomic, copy) void(^buttonActionBlock)(GBLLRIButton *button);

@end
