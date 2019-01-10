//
//  GBImageTitleCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBBannerModel.h"
#import "SDCycleScrollView.h"

@interface GBImageTitleCell : UITableViewCell
/* 广告 */
@property (nonatomic, strong) GBBannerModel *banner;
/* 轮播图 */
@property (strong , nonatomic) SDCycleScrollView *cycleScrollView;

@property (nonatomic, copy) void (^didClickedBlock)(NSInteger index);

@end
