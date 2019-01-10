//
//  SelectCityCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/814.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "SelectCityCell.h"

@implementation SelectCityCell


- (void)setCityArray:(NSArray *)cityArray {
    _cityArray = cityArray;
    
    for (UIView *vi in self.contentView.subviews) {
        [vi removeFromSuperview];
    }
    
    CGFloat ScreenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat btnW = (ScreenW - 85) * 0.25;
    CGFloat btnH = 27;
    
    for (NSInteger i = 0; i < cityArray.count; i++) {
        CityModel *city = [cityArray objectAtIndex:i];
        
        NSInteger row = i / 4;
        NSInteger column = i % 4;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + (btnW + 15) * column, row * (btnH + 15), btnW, btnH)];
        [btn setTitle:city.regionName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x383F42)  forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.cornerRadius = btnH * 0.5;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    
}

- (void)btnClick:(UIButton *)btn {
    CityModel *city = [self.cityArray objectAtIndex:btn.tag];
    self.cityBlock(city);
}

@end
