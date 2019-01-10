//
//  GBGridView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/4.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBGridView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                   iconImages:(NSArray *)iconImages;

/* 按钮点击事件 */
@property (nonatomic, copy) void(^didClickBlock)(NSInteger tag);

@end
