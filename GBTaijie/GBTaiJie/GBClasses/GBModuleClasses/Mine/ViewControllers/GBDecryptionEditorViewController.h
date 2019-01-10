//
//  GBDecryptionEditorViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/18.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GBPositionServiceModel.h"

//// 服务类型
//typedef NS_ENUM(NSInteger,ServiceType) {
//    // 新建解密服务
//    ServiceTypeNewDecryption = 0,
//    // 编辑解密服务
//    ServiceTypeEditDecryption,
//    // 新建保过服务
//    ServiceTypeNewAssured,
//    // 编辑保过服务
//    ServiceTypeEditAssured,
//};

@interface GBDecryptionEditorViewController : GBBaseViewController
/* 解密 */
@property (nonatomic, strong) GBPositionServiceModel *serviceModel;

/* 服务类型 */
@property (nonatomic, assign) ServiceType serviceType;

@end
