//
//  AppManager.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "AppManager.h"
// 广告页
#import "AdPageView.h"
// 容错
#import "AvoidCrash.h"

 

@implementation AppManager

ImplementationSingleton(AppManager);

//*------------------
// MARK: 崩溃容错
//-------------------*
/** 开启容错 */
- (void)openAvoidCrash {
    [AvoidCrash makeAllEffective];
    NSArray *noneSelClassStrings = @[
                                     @"NSNull",
                                     @"NSNumber",
                                     @"NSString",
                                     @"NSDictionary",
                                     @"NSArray",
                                     @"GB",
                                     @"NS"
                                     ];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
}

// 异常拦截并且处理
- (void)dealwithCrashMessage:(NSNotification *)note {
    NSLog(@"日志:%@",[NSString stringWithFormat:@"【ErrorReason】%@ \n========【ErrorPlace】%@ \n========【DefaultToDo】%@ \n========【ErrorName】%@", note.userInfo[@"errorReason"], note.userInfo[@"errorPlace"], note.userInfo[@"defaultToDo"], note.userInfo[@"errorName"]]);
#ifdef DEBUG
//    [UIView showHubWithTip:@"bug出没,快通知小伙伴" timeintevel:2.5];
#endif
}

/** 管理系统导航栏
    当前项目为自定义导航栏
    该设置用于第三方库导航栏
    统一样式
 */
- (void)managerSystemNavBar {
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor kImportantTitleTextColor]];
}

#pragma mark ————— 键盘管理 —————
- (void)managerKeyboard {
    // 获取类库的单例变量
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 控制整个功能是否启用
    keyboardManager.enable = YES;
    // 控制点击背景是否收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
    // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    keyboardManager.toolbarDoneBarButtonItemText = @"完成";
    // 控制是否显示键盘上的工具条
    keyboardManager.enableAutoToolbar = YES;
    // 控制键盘上的工具条背景颜色
    keyboardManager.toolbarBarTintColor = [UIColor whiteColor];
    // 控制键盘上的工具条文字颜色
    keyboardManager.toolbarTintColor = [UIColor kBaseColor];
    // 设置占位文字的字体
    keyboardManager.placeholderFont = Fit_M_Font(14);
    // 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}



+ (AppDelegate *)shareAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (UIViewController *)getCurrentUIVC {
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}
@end
