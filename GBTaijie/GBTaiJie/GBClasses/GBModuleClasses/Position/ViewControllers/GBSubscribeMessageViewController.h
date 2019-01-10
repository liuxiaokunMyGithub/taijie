//
//  GBSubscribeMessageViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/22.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"

// 输入类型枚举
typedef NS_ENUM(NSInteger,InputShowType) {
    // 保过预约留言
    InputShowTypeSubscribeMessage = 0,
    // 保过服务内容
    InputShowTypeAssuredContent
};

@interface GBSubscribeMessageViewController : GBBaseViewController

/* 输入类型 */
@property (nonatomic, assign) InputShowType inputShowType;

/* 保存回调 */
@property (nonatomic, copy) void(^saveButtonClickBlock)(NSString *valueStr);

@end
