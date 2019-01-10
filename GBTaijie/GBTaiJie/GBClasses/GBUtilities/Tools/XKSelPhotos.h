//
//  XKSelPhotos.h
//  mac
//
//  Created by 刘小坤 on 2017/6/9.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


@interface XKSelPhotos : NSObject

/**
 初始化
 */
+ (instancetype)selPhotos;

/**
 跳转到选择照片控制器
 
 @param imagesCount  选择的照片张数
 @param columnNumber 选择界面每行显示几张照片
 @param complete     选择完成回调
 */
- (void)pushImagePickerControllerWithImagesCount : (NSInteger)imagesCount
                                WithColumnNumber : (NSInteger)columnNumber
                                       didFinish : (void(^)(TZImagePickerController *imagePickerVc))complete;



@end
