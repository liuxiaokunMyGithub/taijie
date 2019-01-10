//
//  GBServiceDetailsViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/29.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GBPositionServiceModel.h"

@interface GBServiceDetailsViewController : GBBaseViewController
/* 服务详情类型 */
@property (nonatomic, assign) ServiceDetailsType serviceDetailsType;

/* 解密model */
@property (nonatomic, strong) GBPositionServiceModel *serviceModel;

@end
