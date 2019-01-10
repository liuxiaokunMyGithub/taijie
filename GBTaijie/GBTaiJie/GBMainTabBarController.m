//
//  GBMainTabBarController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 框架类TabBar标签栏
//  @discussion 构建项目模块框架
//

#import "GBMainTabBarController.h"

// Controllers
#import "GBBaseNavigationController.h"

#import "GBHomePageViewController.h"

#import "GBTiebaPageViewController.h"
#import "GBMineViewController.h"
#import "GBFindViewController.h"

// ViewModels


// Models


// Views


@interface GBMainTabBarController () <UITabBarControllerDelegate>

@end

@implementation GBMainTabBarController


#pragma mark - LifeCyle -

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // MARK: 极光统计埋点 - 页面结束
    [GBAppDelegate stopLogPageView:@"MainTabBarController"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // MARK: 极光统计埋点 - 页面出现
    [GBAppDelegate startLogPageView:@"MainTabBarController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self initTabBarController];
}

#pragma mark - Initial Methods
- (void)initTabBarController {
    self.tabBar.tintColor = [UIColor kBaseColor];
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = [UIColor kImportantTitleTextColor];
    } else {
        // Fallback on earlier versions
    }
    self.delegate = self;
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.viewControllers = self.viewControllers;
}

#pragma mark - Target Methods


#pragma mark - Delegate


#pragma mark - Privater Methods


#pragma mark - Getter Setter Methods
/** 加载子控制器 */
- (NSArray *)viewControllers {
    // 首页
    GBBaseNavigationController *findNavigationController = [[GBBaseNavigationController alloc] initWithRootViewController:[[GBHomePageViewController alloc]init]];
    findNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[GBImageNamed(@"ic_FindPeople")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[GBImageNamed(@"ic_FindPeople_Selected")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 发现
    GBBaseNavigationController *positionNavigationController = [[GBBaseNavigationController alloc] initWithRootViewController:[[GBFindViewController alloc]init]];
    positionNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[[UIImage imageNamed:@"ic_Position"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_Position_Selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 吾聊
    GBTiebaPageViewController *tiebaPageVC = [[GBTiebaPageViewController alloc] init];
    GBBaseNavigationController *tiebaNavigationController = [[GBBaseNavigationController alloc] initWithRootViewController:tiebaPageVC];
    tiebaPageVC.pageController.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    [tiebaPageVC setPageMenuTitles:@[@"最新",@"最热"] pageControllerType:GBPageControllerTypeTieba];
    tiebaPageVC.title = @"吾聊";
    
    tiebaNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"吾聊" image:[[UIImage imageNamed:@"ic_Message"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_Message_Selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 我的
    GBBaseNavigationController *mineNavigationController = [[GBBaseNavigationController alloc] initWithRootViewController:[[GBMineViewController alloc]init]];
    mineNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"ic_Mine"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ic_Mine_Selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    NSArray *viewControllers = @[
                                 findNavigationController,
                                 positionNavigationController,
                                 tiebaNavigationController,
                                 mineNavigationController,
                                 ];
    return viewControllers;
}

// 当点击某个标签时,tabBar触发该方法
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"%lu",(unsigned long)tabBarController.selectedIndex)
    if (tabBarController.selectedIndex == 3) {
        if (!userManager.currentUser) {
              GBPostNotification(LoginStateChangeNotification, @NO);
            return [UIView showHubWithTip:@"当前操作需要您先注册登录" timeintevel:2.0];

        }
    }
}



// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
