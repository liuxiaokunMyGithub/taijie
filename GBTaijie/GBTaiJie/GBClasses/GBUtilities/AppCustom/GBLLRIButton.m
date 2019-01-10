//
//  GBLLRIButton.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/4.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBLLRIButton.h"
/**
 自定义按钮 - 左文右图
 */

@implementation GBLLRIButton
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //设置lable
    self.titleLabel.x = self.textMargin ? self.textMargin : 0;
    self.titleLabel.centerY = self.height * 0.5;
    [self.titleLabel sizeToFit];
    
    //设置图片位置
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame)+3;
    self.imageView.centerY = self.height * 0.5;
    [self.imageView sizeToFit];
}


@end
