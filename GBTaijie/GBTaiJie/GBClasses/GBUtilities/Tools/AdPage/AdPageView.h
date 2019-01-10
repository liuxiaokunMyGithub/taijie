//
//  AdPageView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 启动广告页面
 */

static NSString *const adImageName = @"startApp";
static NSString *const adUrl = @"adUrl";

typedef void(^TapBlock)(void);

@interface AdPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTapBlock:(TapBlock)tapBlock;

/** 显示广告页面方法*/
- (void)show;

/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;

@end
