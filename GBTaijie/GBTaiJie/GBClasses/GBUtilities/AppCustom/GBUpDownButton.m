//
//  GBUpDownButton.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/4.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBUpDownButton.h"

/**
    自定义按钮 - 上图下文
 */

@implementation GBUpDownButton

#pragma mark - Intial

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
    }
    
    return self;
}

- (void)setUpSubViews {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.titleLabel.font = Fit_Font(12);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.centerX = self.width * 0.5;
    self.imageView.centerY  =  self.height * 0.25;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.width * 0.5;
    self.titleLabel.y  =  self.imageView.bottom+3;
    [self.imageView sizeToFit];

}

@end
