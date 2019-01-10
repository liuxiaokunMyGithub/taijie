//
//  GBBigTitleHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/27.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBigTitleHeadView.h"

@implementation GBBigTitleHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor whiteColor];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor kImportantTitleTextColor];
    _titleLabel.font = Fit_B_Font(28);
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.textColor = [UIColor kAssistInfoTextColor];
    _subTitleLabel.font = Fit_Font(14);
    [self addSubview:_subTitleLabel];
    
    _bottomSubTitleLabel = [[UILabel alloc] init];
    _bottomSubTitleLabel.textColor = [UIColor kAssistInfoTextColor];
    _bottomSubTitleLabel.font = Fit_Font(14);
    [self addSubview:_bottomSubTitleLabel];
    
    _rightButton = [[UIButton alloc] init];
    [_rightButton addTarget:self
                      action:@selector(rightButtonAction)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
}

// 右侧按钮
- (void)rightButtonAction {
    !_rightButtonClickBlock ? : _rightButtonClickBlock();
}


#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.topMargin ? self.topMargin : 16);
        make.left.equalTo(self).offset(GBMargin);
        make.height.mas_equalTo(30);
    }];
    
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel).offset(5);
        make.left.equalTo(self.titleLabel.mas_right).offset(3);
        make.height.mas_equalTo(30);
    }];

    [_bottomSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self).offset(GBMargin);
        make.height.mas_equalTo(20);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self).offset(-GBMargin);
        make.height.with.equalTo(@48);
        
    }];
}

@end
