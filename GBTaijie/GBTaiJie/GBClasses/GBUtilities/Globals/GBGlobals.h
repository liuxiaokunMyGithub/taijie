//
//  GBGlobals.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

/** !!!: 常量（宏定义/static const）
 *  若仅仅作用于某个.m文件则以k开头，
 *  若需要外部其他类访问则加上类前缀。
 */

@interface GBGlobals : NSObject
//*------------------
// MARK: 全局常量
//-------------------*
/** 边距 */
extern CGFloat const GBMargin;

// 用户token
extern NSString *const UDK_UserToken;
// 用户id
extern NSString *const UDK_UserId;
// 当前用户数据
extern NSString *const UDK_CurrentUser;
// 当前用户IM头像
extern NSString *const UDK_CurrentUserImAvatar;
// 当前用户IM未读消息数
extern NSString *const UDK_CurrentUserImBadge;
/** 推送状态 */
extern NSString *const UDK_Push_Switch_State;

/** 第一次登录 */
extern NSString *const UDK_Login_First;

/** 首页导航完成 */
extern NSString *const UDK_Gird_Finish_HomePage;
/** 搜索导航完成 */
extern NSString *const UDK_Gird_Finish_Search;
/** 我的导航完成 */
extern NSString *const UDK_Gird_Finish_Mine;

//*------------------
// MARK: Block
//-------------------*
/** 定义返回请求数据的block类型 */
typedef void (^SuccessReturnValueBlock) (id returnValue);//请求成功获取数据回传
typedef void (^ErrorCodeBlock) (id errorCode);//请求报错回传
typedef void (^NetWorkBlock)(BOOL netConnetState);//网络可达性检测

//*------------------
// MARK: 枚举
//-------------------*
// 订单状态
typedef NS_ENUM (NSInteger , G_OrderDetailsType) {
    /** 解密订单 */
    OrderDetailsTypeDecrypt  =  0,
    /** 保过订单 */
    OrderDetailsTypeAssurePass
};

// 身份角色状态
typedef NS_ENUM (NSInteger , G_RoleOrderType) {
    /** 购买者（已购订单） */
    RoleOrderTypeBuyersPurchased  =  0,
    /** 卖者（提供服务） */
    RoleOrderTypeSellerService
};

// 首页搜索类型
typedef NS_ENUM (NSInteger , SearchType) {
    /** 搜索公司 */
    SearchTypeCompany = 0,
    /** 搜索职位 */
    SearchTypePosition,
};

// 首页保过大师cell类型
typedef NS_ENUM (NSInteger , MasterCardCellType) {
    /** 首页 */
    MasterCardCellTypeHomePage  =  0,
    /** 公司搜索 */
    MasterCardCellTypeCompanySearch
};

// 服务类型
typedef NS_ENUM(NSInteger,ServiceType) {
    // 新建解密服务
    ServiceTypeNewDecryption = 0,
    // 编辑解密服务
    ServiceTypeEditDecryption,
    // 新建保过服务
    ServiceTypeNewAssured,
    // 编辑保过服务
    ServiceTypeEditAssured,
};

// 加载服务类型枚举
typedef NS_ENUM(NSInteger,ServiceDetailsType) {
    // 解密服务详情
    ServiceDetailsTypeDecryption = 0,
    // 保过服务详情
    ServiceDetailsTypeAssured
};

//*----------------------
// MARK: 通知相关的字符串
//-----------------------*

// 登录状态改变通知
extern NSString *const LoginStateChangeNotification;
// 网络状态改变通知
extern NSString *const NetWorkStateChangeNotification;
/** 订单筛选通知 */
extern NSString *const OrderFiltrateNotification;
/** 登录动画通知 */
extern NSString *const LoginAnimationNotification;

/** banner页通知 */
extern NSString *const BannerBackToPersonalHomeNotification;

/** 当前用户新增订单数 */
extern NSString *const OrderNewStatusNotification;

/** 首页排行榜进入个人主页通知 */
extern NSString *const HomePage_H5_RankingClickNotification;

/** 吾聊刷新通知 */
extern NSString *const TiebaDataRefreshNotification;

/** 系统消息刷新通知 */
extern NSString *const SystemMessageRefreshNotification;
/** 我的消息提示刷新通知 */
extern NSString *const MineMessageBadgeRefreshNotification;
/** 教育经历刷新通知 */
extern NSString *const EducationExperienceRefreshNotification;

// MARK: 台阶币充值相关通知
extern NSString *const kProductsLoadedNotification;
extern NSString *const kProductPurchasedSuccessNotification;
extern NSString *const kProductPurchaseFailedNotification;
extern NSString *const kProductRePurchaseFailedNotification;
//*---------------------
// MARK: 第三方SDK相关key
//---------------------*

// 友盟APP_KEY
extern NSString *const UMeng_APP_KEY;

/** 微信平台 */
extern NSString *const WX_APP_ID;
extern NSString *const WX_APP_Secret;

/** QQ平台 */
extern NSString *const QQ_APP_ID;
extern NSString *const QQ_APP_Secret;

/** 极光 */
extern NSString *const JGuang_APP_KEY;
extern NSString *const IM_APP_CertName;


@end
