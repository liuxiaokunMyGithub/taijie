//
//  GBLoginViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/21.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GBLoginControlTempItem : NSObject

// 用户名
@property (nonatomic, copy) NSString *userName;
// 验证码
@property (nonatomic, copy) NSString *checkNum;

@end

@interface GBLoginViewController : GBBaseViewController

@property (nonatomic, strong) GBLoginControlTempItem *tempItem;

@end
