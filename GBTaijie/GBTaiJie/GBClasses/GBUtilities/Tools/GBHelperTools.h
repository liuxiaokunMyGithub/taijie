//
//  GBHelperTools.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/6.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBHelperTools : NSObject

/** 创建单例对象 */
InterfaceSingleton(GBHelperTools);
// 是否是留海屏
- (BOOL)isHairHead;
//网址正则
- (BOOL)isUrlValidation:(NSString *)string;

// 正则匹配手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum;
/** 验证邮箱 */
- (BOOL)validationEmail:(NSString *)email;
// 正则匹配用户密码6-18位数字和字母组合
- (BOOL)checkPassword:(NSString *)password;

/** 校验除字母及数字以外的特殊字符 */
- (BOOL)chekSpecialCharacter:(NSString *)str;

// 颜色转换:（以#开头）十六进制的颜色转换为UIColor(RGB)
- (UIColor *)colorWithHexString: (NSString *)color;

//比较两个数组中是否有不同元素
- (BOOL)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2;

//比较两个数组中是否相等
- (BOOL)filterEquleArr:(NSArray *)arr1 andArr2:(NSArray *)arr2;

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount;

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView;

// 打印系统字体
- (void)printSystemFont;

/**
 * 验证纳税人识别码/统一社会信用代码
 * 号码格式：
 * ①验证纳税人识别码：6位行政区划码（纯数字）+ 9位组织机构代码（数字或大写字母）
 * ②统一社会信用代码（18位）：第1位（登记管理部门代码，数字或字母）、第2位（机构类别代码，数字或字母）
 *                             第3—8位（登记管理机关行政区划码，数字）、第9—17位（主体标识码，数字或字母）
 *                             第18位（校验码，数字或字母）
 */
- (BOOL)validateTaxpayerNumber:(NSString*)TaxpayerNumber;


/*s*
 *  获取path路径下文件夹的大小
 *
 *  @param path 要获取的文件夹 路径
 *
 *  @return 返回path路径下文件夹的大小
 */
- (NSString *)getCacheSizeWithFilePath:(NSString *)path;

/**
 *  清除path路径下文件夹的缓存
 *
 *  @param path  要清除缓存的文件夹 路径
 *
 *  @return 是否清除成功
 */
- (BOOL)clearCacheWithFilePath:(NSString *)path;

/** 导航 */
- (UINavigationController *)getPushNavigationContr;
/** 视图 导航 */
- (UIViewController *)getViewcontrollerView:(UIView*)view;
//获取Window当前显示的ViewController
- (UIViewController*)currentViewController;
/** 获取当前时间 */
- (NSString *)getCurrentDate;

// 绘制虚线边框
- (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

// 屏幕截图
- (UIImage *)captureScreen;

// 获取UUID
- (NSString *)stringWithUUID;

/**   对象安全检查   */
- (id)objectSafeCheck:(id)object;

// 设置未登录模态视图
- (void)setNoLoginModalView:(BOOL )isPresent;

@end
