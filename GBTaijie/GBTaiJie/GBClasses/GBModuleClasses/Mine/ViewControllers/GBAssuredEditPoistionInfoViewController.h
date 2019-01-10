//
//  GBAssuredEditPoistionInfoViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/18.
//Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseViewController.h"
#import "GBServiceEditModel.h"

@interface GBAssuredEditPoistionInfoViewController : GBBaseViewController

/* 临时模型 */
@property (nonatomic, strong) GBServiceEditModel *tempModel;

/* 保存回调 */
@property (nonatomic, copy) void(^didClickSaveButtonBlock)(GBServiceEditModel *editPoistionTempModel);


@end
