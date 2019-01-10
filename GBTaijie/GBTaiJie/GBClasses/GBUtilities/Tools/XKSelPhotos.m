//
//  XKSelPhotos.m
//  mac
//
//  Created by 刘小坤 on 2017/6/9.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import "XKSelPhotos.h"

@interface XKSelPhotos ()

@property (nonatomic , strong) NSMutableArray *selectedPhotos;
@property (nonatomic , strong) NSMutableArray *selectedAssets;

@end

@implementation XKSelPhotos

+ (instancetype)selPhotos {
    return [[self alloc] init];
}

#pragma mark - TZImagePickerController
- (void)pushImagePickerControllerWithImagesCount : (NSInteger)imagesCount
                                WithColumnNumber : (NSInteger)columnNumber
                                       didFinish : (void(^)(TZImagePickerController *imagePickerVc))complete {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:imagesCount columnNumber:columnNumber delegate:nil];
    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 内部拍照按钮
    // 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    // 允许裁剪的时候原图选择无效
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    // 设置竖屏下的裁剪尺寸
    NSInteger widthHeight = SCREEN_WIDTH - 2;
    NSInteger top = (SCREEN_HEIGHT - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(1, top, widthHeight, widthHeight);
    // 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.barItemTextColor = [UIColor kImportantTitleTextColor];
    
    !complete ? : complete(imagePickerVc);
}

#pragma mark - 照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/headImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

#pragma mark - 已选择的图片
- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

@end
