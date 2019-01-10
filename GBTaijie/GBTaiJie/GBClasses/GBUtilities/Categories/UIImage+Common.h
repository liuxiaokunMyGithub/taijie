//
//  UIImage+Common.h
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2017/1/16.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

// 设置圆形头像
- (instancetype)setCircleImage;

+ (UIImage *)imageWithColor:(UIColor *)aColor;

// 获取网络图片
+(UIImage *)getImageURL:(id)imageURL;
// 获取网络图片data
+ (NSData *)getImageDataURL:(id)imageURL;

+ (CGSize)getImageSizeWithURL:(id)imageURL;

+ (UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//旋转图片
- (UIImage *)fixOrientation:(UIImage *)aImage;
/** 缩放图片 */
+ (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size;

@end
