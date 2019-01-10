//
//  AppManager.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


/**
 包含应用层的相关服务
 */
@interface AppManager : NSObject

InterfaceSingleton(AppManager);

//单例
+ (AppDelegate *)shareAppDelegate;

/** 开启容错 */
- (void)openAvoidCrash;

/** 管理系统导航栏
 当前项目为自定义导航栏
 该设置用于第三方库导航栏
 统一样式
 */
- (void)managerSystemNavBar;

/** 键盘管理 */
- (void)managerKeyboard;

/**
 当前顶层控制器
 */
- (UIViewController *)getCurrentVC;

- (UIViewController *)getCurrentUIVC;

@end
