//
//  GBMineServiceHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMineServiceHeadView.h"

@implementation GBMineServiceHeadView

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
    
    _bgImageView = [[UIImageView alloc] initWithImage:GBImageNamed(@"icon_mine_service_head_bg")];
    [self addSubview:_bgImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor kImportantTitleTextColor];
    _titleLabel.font = Fit_B_Font(28);
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.text = @"我的收益";
    _subTitleLabel.textColor = [UIColor colorWithHexString:@"#ECD6B4"];
    _subTitleLabel.font = Fit_M_Font(14);
    [self addSubview:_subTitleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor kImportantTitleTextColor];
    _priceLabel.font = Fit_B_Font(30);
    [self addSubview:_priceLabel];
    
    _bottomSubTitleLabel = [[UILabel alloc] init];
    _bottomSubTitleLabel.textColor = [UIColor kAssistInfoTextColor];
    _bottomSubTitleLabel.font = Fit_Font(14);
    [self addSubview:_bottomSubTitleLabel];
    
    _rightButton = [[GBLLRIButton alloc] init];
    [_rightButton setTitle:@"            " forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithHexString:@"#ECD6B4"] forState:UIControlStateNormal];
    [_rightButton setImage:GBImageNamed(@"icon_rightMore_gold") forState:UIControlStateNormal];
    _rightButton.titleLabel.font = Fit_Font(14);
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
        make.top.equalTo(self).offset(16);
        make.left.equalTo(self).offset(GBMargin);
        make.height.mas_equalTo(30);
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.equalTo(self).offset(GBMargin);
        make.right.equalTo(self).offset(-GBMargin);
        make.height.mas_equalTo(120);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView);
        make.left.equalTo(self.bgImageView).offset(16);
        make.height.mas_equalTo(40);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.bgImageView).offset(16);
        make.height.mas_equalTo(40);
    }];
    
    [_bottomSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
        make.left.equalTo(self.bgImageView).offset(16);
        make.height.mas_equalTo(16);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView);
        make.right.equalTo(self.bgImageView).offset(-5);
        make.height.equalTo(@40);
        make.width.equalTo(@80);

    }];
}

@end
