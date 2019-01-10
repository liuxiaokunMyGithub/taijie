//
//  GBModifyViewControllerr.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ModifyControllerType) {
    // 修改手机号
    ModifyControllerTypePhone = 0,
    // 登录密码
    ModifyControllerTypeLoginPassWord,
    // 支付密码
    ModifyControllerTypePayPassWord,
    // 支付宝账号
    ModifyControllerTypeAliPayCount,
};

@interface GBModifyPhoneTempModel : NSObject

// 验证码
@property (nonatomic, copy) NSString *checkNum;

// 修改手机号所需
@property (nonatomic, copy) NSString *phone;

// 设置支付密码所需
@property (nonatomic, copy) NSString *passWord;

@property (nonatomic, copy) NSString *validationPassWord;

// 设置支付宝账户所需
@property (nonatomic, copy) NSString *aliPayCount;

@property (nonatomic, copy) NSString *validationAliPayCount;

@end


@interface GBModifyViewController : GBBaseViewController
/* 修改类型 */
@property (nonatomic, assign) ModifyControllerType modifyType;

@end
