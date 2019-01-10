//
//  GBLIRLButton.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/4.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBLIRLButton.h"

/**
 自定义按钮 - 左图右文
 */

@implementation GBLIRLButton

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.width * 0.5 + 5;
    if (self.titleLabel.hidden) {
        self.imageView.x = 5;
    }else {
        self.imageView.x = (self.titleLabel.x - self.imageView.width - 3);
    }

    self.titleLabel.centerY = self.height/2;
    self.imageView.centerY = self.height/2;
}

@end
