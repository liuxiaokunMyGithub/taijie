//
//  YQPayKeyWordVC.h
//  Youqun
//
//  Created by 王崇磊 on 16/6/1.
//  Copyright © 2016年 W_C__L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQInputPayKeyWordView.h"

@interface YQPayKeyWordVC : UIViewController

- (void)showInViewController:(UIViewController *)vc;

@property (strong, nonatomic) YQInputPayKeyWordView *keyWordView;

/* 密码 */
@property (nonatomic, copy) void(^payPassWordBlock) (NSString *passWord);

- (void)disMissKeyWordView;

@end
