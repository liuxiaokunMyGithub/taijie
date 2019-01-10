//
//  DCSpeedy.h
//  LiChi
//
//  Created by apple on 2017/3/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCSpeedy : NSObject

/**
 设置某一方向特定的圆角

 @param view 目标视图
 @param hasTop 仅设置TOP左右圆角
 @param hasBottom 仅设置BOTTOM左右圆角
 @param hasRound 设置四个圆角
 @return 视图
 */
+ (id)dc_setCornerWith:(UIView *)view hasTop:(BOOL)hasTop hasBottom:(BOOL )hasBottom hasRound:(BOOL)hasRound size:(CGSize)size;

/**
 设置按钮的圆角
 
 @param anyControl 控件
 @param radius 圆角度
 @param width 边宽度
 @param borderColor 边线颜色
 @param can 是否裁剪
 @return 控件
 */
+(id)dc_chageControlCircularWith:(id)anyControl AndSetCornerRadius:(NSInteger)radius SetBorderWidth:(NSInteger)width SetBorderColor:(UIColor *)borderColor canMasksToBounds:(BOOL)can;


/**
 选取部分数据变色（label）
 
 @param label label
 @param arrray 变色数组
 @param color 变色颜色
 @return label
 */
+(id)dc_setSomeOneChangeColor:(UILabel *)label SetSelectArray:(NSArray *)arrray SetChangeColor:(UIColor *)color;


/**
 选取部分数据变色变字体
 
 @param changeColor 颜色
 @param changeFont 字体
 @param totalString 整个字符串
 @param changeString 需要改变的字符
 @return 改变属性之后的多属性字符串
 */
+ (NSMutableAttributedString*)dc_setSomeOneChangeColor:(UIColor *)changeColor changeFont:(UIFont *)changeFont totalString:(NSString *)totalString changeString:(NSString *)changeString;

#pragma mark -  根据传入字体大小计算字体宽高
+ (CGSize)dc_calculateTextSizeWithText : (NSString *)text WithTextFont: (UIFont *)textFont WithMaxW : (CGFloat)maxW ;

/**
 上划线
 
 @param view 上划线
 */
+ (void)dc_setTopAcrossPartingLineWith:(UIView *)view WithColor:(UIColor *)color;

/**
 中划线
 
 @param 字符串 中划线
 */
+ (NSMutableAttributedString *)dc_setMiddleAcrossPartingLineWith:(NSString *)totalString WithColor:(UIColor *)color;

/**
 下划线
 
 @param view 下划线
 */
+ (void)dc_setUpAcrossPartingLineWith:(UIView *)view WithColor:(UIColor *)color margin:(NSInteger )margin;
/**
 竖线线
 
 @param view 竖线线
 */
+ (void)dc_setUpLongLineWith:(UIView *)view WithColor:(UIColor *)color WithHightRatio:(CGFloat)ratio offset:(CGFloat )offset;


/**
 利用贝塞尔曲线设置圆角

 @param control 按钮
 @param size 圆角尺寸
 */
+ (void)dc_setUpBezierPathCircularLayerWith:(id)control :(CGSize)size;


/**
 label首行缩进

 @param label label
 @param emptylen 缩进比
 */
+ (void)dc_setUpLabel:(UILabel *)label Content:(NSString *)content IndentationFortheFirstLineWith:(CGFloat)emptylen headIndent:(CGFloat)headIndent;


/**
 字符串加星处理

 @param content NSString字符串
 @param findex 第几位开始加星
 @param surplus 后面剩余几位
 @return 返回加星后的字符串
 */
+ (NSString *)dc_EncryptionDisplayMessageWith:(NSString *)content WithFirstIndex:(NSInteger)findex surplus:(NSInteger)surplus;


#pragma mark - 图片转base64编码
+ (NSString *)UIImageToBase64Str:(UIImage *) image;

#pragma mark - base64图片转编码
+ (UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;

@end
