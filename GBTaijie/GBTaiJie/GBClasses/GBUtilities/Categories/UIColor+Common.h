//
//  UIColor+Common.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

/** 十六进制转RGB */
+ (UIColor*)colorWithHexString:(NSString*)hex;
// 不可点击
+ (UIColor *)kNotUserInteractionEnabledColor;
/** tabbar顶部线条颜色 */
+ (UIColor *)kTabBarTopLineColor;
/** 分割线 */
+ (UIColor *)kSegmentateLineColor;
// 基色
+ (UIColor *)kBaseColor;
// 提示占位提示信息
+ (UIColor *)kPlaceHolderColor;
// 基背景
+ (UIColor *)kBaseBackgroundColor;
// 功能模块背景
+ (UIColor *)kFunctionBackgroundColor;
// 星、突出强调
+ (UIColor *)kStarEspecialColor;
// 重要文字标题正文
+ (UIColor *)kImportantTitleTextColor;
// 普通信息
+ (UIColor *)kNormoalInfoTextColor;
// 辅助信息 时间日期等
+ (UIColor *)kAssistInfoTextColor;
// 提示红色
+ (UIColor *)kPromptRedColor;
// 黄色背景
+ (UIColor *)kYellowBgColor;
// 组分割线
+ (UIColor *)kSectionDividingLineColor;
// 金色
+ (UIColor *)kGoldTintColor;
// 标题栏背景色
+ (UIColor *)kTitleColorBG;
@end
