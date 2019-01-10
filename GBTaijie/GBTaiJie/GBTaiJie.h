//
//  GBTaiJie.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#ifndef GBTaiJie_h
#define GBTaiJie_h

//*------------------
// !!!: 项目头文件
//-------------------*

/**
 * 描述：全局、实用程序、工具集
 * 包含：
 * [ 网络请求、全局变量、
 *   宏定义、类别、
 *   APP自定义相关 ]
 *
 */
#import "GBUtilities.h"
/**   手动导入的第三方辅助类库   */
#import "GBVendor.h"

/** 基类导航控制器 */
#import "GBBaseNavigationController.h"
/**   基类控制器   */
#import "GBBaseViewController.h"
/** 基类page控制器 */
#import "GBBasePageViewSuperController.h"
/** 基类网页视图 */
#import "GBBaseWebViewController.h"

/**   基类ViewModel   */
#import "GBBassViewModel.h"
/** 基类model */
#import "GBBaseModel.h"
/** App业务层管理类 */
#import "AppManager.h"
/** 用户管理类 */
#import "UserManager.h"
/** IM管理 */
#import "IMManager.h"
/** 分享管理 */
#import "ShareManager.h"

/** ViewModel */
#import "GBHomePageViewModel.h"
#import "GBFindPeopleViewModel.h"
#import "GBPositionViewModel.h"
#import "GBMineViewModel.h"
#import "GBTiebaViewModel.h"
#import "GBCommonViewModel.h"
#import "GBFindViewModel.h"

/** 第三方SDK实现分类，减轻AppDelegate入口代码压力 */
// 分享
#import "AppDelegate+ShareService.h"
// 推送、统计
#import "AppDelegate+JPushAnalyticsService.h"
// IM
#import "AppDelegate+IMService.h"

#endif /* GBTaiJie_h */
