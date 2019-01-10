//
//  GBPersonalHomePageStoryHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBFindPeopleModel.h"

@interface GBPersonalHomePageStoryHeadView : UIView
/* <#describe#> */
@property (nonatomic, strong) GBFindPeopleModel *personalInfoModel;

/*  */
@property (nonatomic, strong) dispatch_block_t exchangeBlock;

@end
