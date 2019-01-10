//
//  AppDelegate.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/831.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
// 主标签视图
#import "GBMainTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) GBMainTabBarController *mainTabBarController;

@end

