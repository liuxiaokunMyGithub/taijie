//
//  SearchCompanyBottomView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/825.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "SearchCompanyBottomView.h"

@implementation SearchCompanyBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 240) * 0.5, 30, 240, 38)];
    [btn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [btn setTitleColor:UIColorFromRGB(0x96ABB5) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"iconfont-delete"] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    btn.layer.cornerRadius = 5.0f;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColorFromRGB(0x96ABB5) CGColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)btnClick {
    self.clearBlock();
}

@end
