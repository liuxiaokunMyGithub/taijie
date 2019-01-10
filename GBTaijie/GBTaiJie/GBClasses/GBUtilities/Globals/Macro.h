//
//  Macro.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/831.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//*------------------
// MARK: 日志输出宏定义
//-------------------*
#ifdef DEBUG
//调试状态
#define MyString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define NSLog(...) printf("%s: %s 第%d行: %s\n\n",[[GBAppHelper getCurrentDate] UTF8String], [MyString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
//发布状态
#define NSLog(...)
#endif

/****进入置顶通知****/
#define kHomeGoTopNotification               @"Home_Go_Top"
/****离开置顶通知****/
#define kHomeLeaveTopNotification            @"Home_Leave_Top"

//*------------------
// MARK: 全局对象
//-------------------*

/** 主窗口 */
#define KEYWINDOW  [UIApplication sharedApplication].keyWindow
/** 窗口根控制器 */
#define GBRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
/** App代理对象 */
#define GBAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))
/** 本地偏好设置存储 */
#define GBUserDefaults [NSUserDefaults standardUserDefaults]
/** 通知中心 */
#define GBNotificationCenter [NSNotificationCenter defaultCenter]
/** 弱引用对象 */
#define GBWeakObj(o) autoreleasepool{} __weak typeof(o) sjWeak##o = o;
/** 强引用对象 */
#define GBStrongObj(o) autoreleasepool{} __strong typeof(o) o = sjWeak##o;
/** 项目辅助工具方法集 */
#define GBAppHelper [GBHelperTools sharedGBHelperTools]


//*------------------
// MARK: UI相关
//-------------------*
/** 屏幕宽 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
/** 屏幕高 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define Screen_Bounds [UIScreen mainScreen].bounds

/** 以iPhone6设计稿宽为基准比例适配 */
// 倍率
#define MULTIPLE (SCREEN_WIDTH / 375)
// 宽高
#define Fit_W_H(_WH_) (_WH_ * MULTIPLE)
// 轻字体
#define Fit_L_Font(_S_) [UIFont fontWithName:@"PingFangSC-Regular" size:_S_ * MULTIPLE]
// 常规字体
#define Fit_Font(_S_) [UIFont fontWithName:@"PingFangSC-Regular" size:_S_ * MULTIPLE]
// 中体
#define Fit_M_Font(_M_) [UIFont fontWithName:@"PingFangSC-Medium" size:_M_ * MULTIPLE]
// 粗体
#define Fit_B_Font(_B_) [UIFont fontWithName:@"PingFangSC-Semibold" size:_B_ * MULTIPLE]

/** 适配iPhoneX 安全区域 */
// 头部宏
#define SafeAreaTopHeight (StatusBarHeight + NavBarHeight)
// 底部宏
#define SafeAreaBottomHeight (iPhoneX ? 34 : 0)
// 自定义底部视图适配高度
#define BottomViewFitHeight(height) (height + SafeAreaBottomHeight)
// 状态栏高度
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
// 自定义导航栏高度
#define GBNaviHeight NavBarHeight + StatusBarHeight
// 导航栏高度
#define NavBarHeight 44.0
// 底部安全tabbarHeight
#define SafeTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)


#define iphone6p (SCREEN_HEIGHT == 763)
#define iphone6 (SCREEN_HEIGHT == 667)
#define iphone5 (SCREEN_HEIGHT == 568)
#define iphone4 (SCREEN_HEIGHT == 480)
// 留海屏iPhoneX系列
#define iPhoneX [GBAppHelper isHairHead]
//#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/**   RGB配色   */
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1.0f]

//十六进制颜色
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//View 圆角和加边框
#define GBViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define GBViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//*------------------
// MARK: 系统相关
//-------------------*

/** 当前系统的版本 */
#ifndef kSystemVersion
#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

/** 大于等于8.0的ios版本 */
#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

/** 大于等于9.0的ios版本 */
#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

/** 大于等于10.0的ios版本 */
#ifndef kiOS10Later
#define kiOS10Later (kSystemVersion >= 10)
#endif

/** 大于等于11.0的ios版本 */
#ifndef kiOS11Later
#define kiOS11Later (kSystemVersion >= 11)
#endif

//*------------------
// MARK: 便捷工具宏
//-------------------*

/** 网络图片地址URL拼接 */
#define GBImageURL(urlStr) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL_IMAGE_QINIUYUN,urlStr]]

/** 主线程 */
#define GB_MAIN_THREAD(block) dispatch_async(dispatch_get_main_queue(), block)

/** 数据验证 */
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""] && ![f isEqualToString:@"null"] && ![f isEqualToString:@"<null>"])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDic(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

// 发送通知
#define GBPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
// 拼接字符串
#define GBNSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

// 定义UIImage对象
#define GBImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define GBImageNamed(name) [UIImage imageNamed:name]

// 占位图片
#define PlaceholderBannerImage GBImageNamed(@"img_banner_placeholder")
#define PlaceholderNodataImage GBImageNamed(@"img_nothing")
#define PlaceholderListImage GBImageNamed(@"img_list_placeholder")
#define PlaceholderHeadImage GBImageNamed(@"photo_placeholder")

/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}

/** 单例模式宏抽取 */
// 宏声明
#define InterfaceSingleton(Name) +(instancetype)shared##Name
// 宏实现
#define ImplementationSingleton(Name) \
+ (instancetype)shared##Name \
{ \
Name *instance = [[self alloc] init]; \
return instance; \
} \
static Name *_instance = nil; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[super allocWithZone:zone] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

// !!!:搜索相关key
#define ASAIdentifierStr [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#define kSearchCityHistoryList [NSString stringWithFormat:@"SearchCityHistoryList_%@",([userManager currentUser] == nil ? ASAIdentifierStr : [NSString stringWithFormat:@"%@", [[userManager currentUser] token]])]
#define kSearchCompanyHistoryList [NSString stringWithFormat:@"SearchCompanyHistoryList_%@",([userManager currentUser] == nil ? ASAIdentifierStr : [NSString stringWithFormat:@"%@", [[userManager currentUser] token]])]
#define kSearchCityHistoryList [NSString stringWithFormat:@"SearchCityHistoryList_%@",([userManager currentUser] == nil ? ASAIdentifierStr : [NSString stringWithFormat:@"%@", [[userManager currentUser] token]])]

#endif /* Macro_h */
