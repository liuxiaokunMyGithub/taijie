//
//  GBUniversitiesDomesticItemCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//  国内院校

#import "GBUniversitiesDomesticItemCell.h"

@implementation GBUniversitiesDomesticItemCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.titleLabel1];
        [self.contentView addSubview:self.titleLabel2];
        [self.contentView addSubview:self.titleLabel3];
        [self.contentView addSubview:self.lineView];
        
        [self.contentView addSubview:self.valueLabel1];
        [self.contentView addSubview:self.valueLabel2];
        [self.contentView addSubview:self.valueLabel3];

        [self.contentView addSubview:self.arrowButton];
    }
    
    return self;
}

- (void)arrowButtonAction {
    
}

-  (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.height.equalTo(@56);
        make.top.equalTo(self.contentView);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-GBMargin);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.height.equalTo(@38);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.height.equalTo(@38);
        make.top.equalTo(self.titleLabel1.mas_bottom);
    }];
    
    [self.titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.height.equalTo(@38);
        make.top.equalTo(self.titleLabel2.mas_bottom);
    }];
    
    [self.valueLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@38);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    
    [self.valueLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@38);
        make.top.equalTo(self.valueLabel1.mas_bottom);
    }];
    
    [self.valueLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@38);
        make.top.equalTo(self.valueLabel2.mas_bottom);
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _lineView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithText:@"院校与专业" font:Fit_Font(16) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _titleLabel;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [UILabel createLabelWithText:@"省份/直辖市" font:Fit_Font(14) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _titleLabel1;
}

- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [UILabel createLabelWithText:@"院校" font:Fit_Font(14) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _titleLabel2;
}

- (UILabel *)titleLabel3 {
    if (!_titleLabel3) {
        _titleLabel3 = [UILabel createLabelWithText:@"专业" font:Fit_Font(14) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _titleLabel3;
}

- (UILabel *)valueLabel1 {
    if (!_valueLabel1) {
        _valueLabel1 = [UILabel createLabelWithText:@"" font:Fit_Font(14) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _valueLabel1;
}

- (UILabel *)valueLabel2 {
    if (!_valueLabel2) {
        _valueLabel2 = [UILabel createLabelWithText:@"" font:Fit_Font(14) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _valueLabel2;
}

- (UILabel *)valueLabel3 {
    if (!_valueLabel3) {
        _valueLabel3 = [UILabel createLabelWithText:@"" font:Fit_Font(14) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _valueLabel3;
}

- (UIButton *)arrowButton {
    if (!_arrowButton) {
        _arrowButton = [UIButton createButtonWihtImage:GBImageNamed(@"icon_right_more_light") target:self action:nil];
        _arrowButton.userInteractionEnabled = NO;
    }
    
    return _arrowButton;
}

@end
