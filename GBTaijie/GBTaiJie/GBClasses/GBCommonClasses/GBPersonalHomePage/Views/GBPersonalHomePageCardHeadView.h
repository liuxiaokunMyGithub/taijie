//
//  GBPersonalHomePageCardHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/20.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBFindPeopleModel.h"

@interface GBPersonalHomePageCardHeadView : UIView
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *tags;

/* <#describe#> */
@property (nonatomic, strong) GBFindPeopleModel *personalInfoModel;

/*  */
@property (nonatomic, strong) dispatch_block_t exchangeBlock;
- (void)reloadTags;

@end
