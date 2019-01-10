//
//  XKTextField.m
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2018/85.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import "XKTextField.h"

@implementation XKTextField

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds margin:(CGFloat )margin {
    self.margin = margin;
    return [self textRectForBounds:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds,self.margin == 0 ? 30 : self.margin, 0);

}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds margin:(CGFloat )margin {
    self.margin = margin;
    return CGRectInset(bounds, margin, 0);
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds,self.margin == 0?30:self.margin, 0);
}

// 右视图frame
- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= GBMargin/2;
   
    return textRect;
}

@end
