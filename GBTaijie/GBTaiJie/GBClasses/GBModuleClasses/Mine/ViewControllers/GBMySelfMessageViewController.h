//
//  GBMySelfMessageViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MySelfInfoChangeType) {
    // 性别
    MySelfInfoChangeTypeSex,
    // 生日
    MySelfInfoChangeTypeBirthday,
    // 城市
    MySelfInfoChangeTypeCity,
};

@interface GBMySelfMessageViewController : GBBaseViewController

/* 修改个人信息类型 */
@property (nonatomic, assign) MySelfInfoChangeType changeInfoType;

@end
