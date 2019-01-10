//
//  GBPassWordLoginTableView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/10.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCHomeCheckNumCell.h"
#import "LCHomeForgetPsdPhoneCell.h"

@interface GBPwdLoginControlTempItem : NSObject

// 用户名
@property (nonatomic, copy) NSString *userName;
// 验证码
@property (nonatomic, copy) NSString *password;

@end

@interface GBPassWordLoginTableView : UITableView

@property (nonatomic, strong) GBPwdLoginControlTempItem *tempItem;

@property (nonatomic, strong) LCHomeForgetPsdPhoneCell *loginNameCell;

@property (nonatomic, strong) LCHomeForgetPsdPhoneCell *loginPasswordCell;

- (void)setupLoginName:(NSString *)loginName;

/* <#describe#> */
@property (nonatomic, strong) void(^exchangeButtonActionBlock)(UIButton *exchangeButton);

@end
