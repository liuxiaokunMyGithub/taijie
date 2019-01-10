//
//  GBPraiseItemCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPraiseItemCell.h"

@interface GBPraiseItemCell ()

@end

@implementation GBPraiseItemCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.titleLabel1];
        [self.bgView addSubview:self.lineView];

        GBViewRadius(self.bgView, 2);
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 背景视图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
    
    //
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(GBMargin/2);
        make.right.equalTo(self.bgView).offset(-GBMargin/2);
        make.height.equalTo(@26);
        make.top.equalTo(self.bgView).offset(GBMargin/2);
    }];
    
    // 背景视图
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(GBMargin/2);
        make.right.equalTo(self.bgView).offset(-GBMargin/2);
        make.height.equalTo(@26);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
    }];
    
    // 背景视图
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(GBMargin/2);
        make.width.equalTo(@20);
        make.height.equalTo(@2);
        make.top.equalTo(self.titleLabel1.mas_bottom).offset(1);
    }];
}

#pragma mark - # Getters and Setters

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
    }
    
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_B_Font(18);
    }
    
    return _titleLabel;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.font = Fit_L_Font(14);
    }
    
    return _titleLabel1;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    
    return _lineView;
}

@end
