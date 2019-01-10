//
//  GBRegisterViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/10.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GBRegisterTempItem : NSObject

// 用户名
@property (nonatomic, copy) NSString *userName;
// 验证码
@property (nonatomic, copy) NSString *checkNum;
// 密码
@property (nonatomic, copy) NSString *passWord;

@end

@interface GBRegisterViewController : GBBaseViewController

@property (nonatomic, strong) GBRegisterTempItem *tempItem;
- (void)setupUserName:(NSString *)userName;

@end
