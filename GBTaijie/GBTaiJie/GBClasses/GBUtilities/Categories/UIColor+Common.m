//
//  UIColor+Common.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

+ (UIColor*)colorWithHexString:(NSString*)hex {
    return [self colorWithHexString:hex withAlpha:1.0f];
}

+ (UIColor*)colorWithHexString:(NSString*)hex withAlpha:(CGFloat)alpha {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor clearColor];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor clearColor];
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
            
                           green:((float) g / 255.0f)
            
                            blue:((float) b / 255.0f)
            
                           alpha:alpha];
}

/** tabbar顶部线条颜色 */
+ (UIColor *)kTabBarTopLineColor {
    return [UIColor lightGrayColor];
}

// 基色
+ (UIColor *)kBaseColor {
    return [UIColor colorWithHexString:@"#5940DE"];
}

// 基背景
+ (UIColor *)kBaseBackgroundColor {
    return [UIColor colorWithHexString:@"#F5F7FB"];
}

// 功能模块背景
+ (UIColor *)kFunctionBackgroundColor {
    return [UIColor colorWithHexString:@"#F7F7F7"];
    
}

// 不可点击
+ (UIColor *)kNotUserInteractionEnabledColor {
    return [UIColor colorWithHexString:@"#C6C6C9"];
}


// star、突出强调
+ (UIColor *)kStarEspecialColor {
    return [UIColor colorWithHexString:@"#D4B483"];
}

// 重要文字标题
+ (UIColor *)kImportantTitleTextColor {
    return [UIColor colorWithHexString:@"#2A2A30"];
}

// 普通信息(小标题、正文)
+ (UIColor *)kNormoalInfoTextColor {
    return [UIColor colorWithHexString:@"#2A2A30"];
}

// 辅助信息 时间日期等
+ (UIColor *)kAssistInfoTextColor {
    return [UIColor colorWithHexString:@"#949497"];
}

// 提示占位提示信息
+ (UIColor *)kPlaceHolderColor {
//    return [self colorWithHexString:@"#B3B5D2"];
    return [self colorWithHexString:@"#C6C6C9"];
}

// 提示红色
+ (UIColor *)kPromptRedColor {
    return [UIColor colorWithHexString:@"#FA513B"];
}

// 标题栏背景色
+ (UIColor *)kTitleColorBG {
    return [UIColor colorWithHexString:@"#F7F7F7"];
}

// 线条
+ (UIColor *)kSegmentateLineColor {
    return [UIColor colorWithHexString:@"#E3E3F6"];
}

// 组分割线
+ (UIColor *)kSectionDividingLineColor {
    return [UIColor colorWithHexString:@"#F7F7F7"];
}

// 黄色
+ (UIColor *)kYellowBgColor {
    return [UIColor colorWithHexString:@"#FF8238"];
}

// 金色
+ (UIColor *)kGoldTintColor {
    return [UIColor colorWithHexString:@"#ECD6B4"];
}

@end
