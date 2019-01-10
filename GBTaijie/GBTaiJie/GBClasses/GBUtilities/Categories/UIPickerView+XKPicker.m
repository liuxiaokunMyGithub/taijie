//
//  UIPickerView+XKPicker.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/22.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "UIPickerView+XKPicker.h"

@implementation UIPickerView (XKPicker)

- (void)clearSpearatorLine {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.frame.size.height < 1)
        {
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
}

@end
