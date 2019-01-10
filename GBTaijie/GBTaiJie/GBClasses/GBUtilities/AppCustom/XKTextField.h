//
//  XKTextField.h
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2018/85.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKTextField : UITextField

@property (nonatomic, assign) CGFloat margin;

/** UITextField 文字与输入框的距离 */
- (CGRect)textRectForBounds:(CGRect)bounds margin:(CGFloat )margin;

/** 控制文本的位置 */
- (CGRect)editingRectForBounds:(CGRect)bounds margin:(CGFloat )margin;

@end
