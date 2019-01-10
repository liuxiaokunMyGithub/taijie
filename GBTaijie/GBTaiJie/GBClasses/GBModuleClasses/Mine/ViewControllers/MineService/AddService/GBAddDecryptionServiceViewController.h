//
//  GBAddDecryptionServiceViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/20.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"
#import "GBPositionServiceModel.h"
#import "GBAssureContentTagModel.h"

@interface GBAddDecryptionServiceViewController : GBBaseViewController
/** 服务模型 */
@property (nonatomic, strong) GBPositionServiceModel *serviceModel;
/* 服务类型 */
@property (nonatomic, assign) ServiceType serviceType;

@end
