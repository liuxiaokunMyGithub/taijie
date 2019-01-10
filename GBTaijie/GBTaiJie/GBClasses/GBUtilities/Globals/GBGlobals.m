//
//  GBGlobals.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBGlobals.h"

@implementation GBGlobals

#pragma mark - 全局常量
CGFloat const GBMargin = 24;

/** MARK: 本地保存字符常量key UDK代表UserDefaults Key */
// 用户token
NSString *const UDK_UserToken = @"token";
// 用户id
NSString *const UDK_UserId = @"userId";
// 当前用户数据
NSString *const UDK_CurrentUser = @"currentUser";
// 当前用户IM头像
NSString *const UDK_CurrentUserImAvatar = @"ImAvatar";
// 当前用户IM未读消息数
NSString *const UDK_CurrentUserImBadge = @"badge";
/** 推送状态 */
NSString *const UDK_Push_Switch_State = @"pushState";

/** 第一次登录 */
NSString *const UDK_Login_First = @"Login_First";

/** 首页导航完成 */
NSString *const UDK_Gird_Finish_HomePage = @"Gird_Finish_HomePage";
/** 搜索导航完成 */
NSString *const UDK_Gird_Finish_Search = @"Gird_Finish_Search";
/** 我的导航完成 */
NSString *const UDK_Gird_Finish_Mine = @"Gird_Finish_Mine";

#pragma mark - 通知相关的字符串
/** 网络 */
NSString *const NetWorkStateChangeNotification = @"NetWorkStateChangeNotification";
/** 登录 */
NSString *const LoginStateChangeNotification = @"LoginStateChangeNotification";
/** 登录动画 */
NSString *const LoginAnimationNotification = @"LoginAnimationNotification";

/** 订单筛选通知 */
NSString *const OrderFiltrateNotification = @"OrderFiltrateNotification";

/** banner页通知 */
NSString *const BannerBackToPersonalHomeNotification = @"BannerBackToPersonalHomeNotification";

/** 当前用户新增订单数 */
NSString *const OrderNewStatusNotification = @"orderNewStatusNotification";

/** 吾聊刷新通知 */
NSString *const TiebaDataRefreshNotification = @"tiebaDataRefreshNotification";

/** 系统消息刷新通知 */
NSString *const SystemMessageRefreshNotification = @"SystemMessageRefreshNotification";
/** 我的消息提示刷新通知 */
NSString *const MineMessageBadgeRefreshNotification = @"MineMessageBadgeRefreshNotification";

/** 教育经历刷新通知 */
NSString *const EducationExperienceRefreshNotification = @"EducationExperienceRefreshNotification";

/** MARK: 首页 */
/** 首页排行榜进入个人主页通知 */
NSString *const HomePage_H5_RankingClickNotification = @"HomePage_H5_RankingClickNotification";

// MARK: 台阶币充值相关通知
NSString *const kProductsLoadedNotification     =    @"ProductsLoaded";
NSString *const kProductPurchasedSuccessNotification    =   @"ProductPurchasedSuccess";
NSString *const kProductPurchaseFailedNotification = @"ProductPurchaseFailed";
NSString *const kProductRePurchaseFailedNotification = @"ReProductPurchaseFailed";

#pragma mark - 第三方sdk相关key
NSString *const UMeng_APP_KEY = @"5b1e46a38f4a9d150a000042";

/** 微信平台 */
NSString *const WX_APP_ID = @"wx2dc2c049af37ca74";
NSString *const WX_APP_Secret = @"61ea2dd9cbb1856a698d353b118c8fa7";

/** QQ平台 */
NSString *const QQ_APP_ID = @"100371282";
NSString *const QQ_APP_Secret = @"aed9b0303e3ed1e27bae87c33761161d";

/** 极光 */
NSString *const JGuang_APP_KEY = @"b924a5232d2171a548934fdc";
NSString *const IM_APP_CertName = @"chat_taijie_dev";

@end
