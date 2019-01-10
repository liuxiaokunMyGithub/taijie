//
//  GBCertificationCollectionViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBCertificationCollectionViewCell.h"

@interface GBCertificationCollectionViewCell ()

/* 背景 */
@property (nonatomic, strong) UIView *bgView;

@end

@implementation GBCertificationCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImageView];

        [self p_addMasonry];
    }
    return self;
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 背景视图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // icon标识
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(self).mas_offset(24);
        make.centerX.mas_equalTo(self);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(8);
    }];
}

#pragma mark - # Getters and Setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = [UIColor kSegmentateLineColor].CGColor;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_Font(12);
        _titleLabel.textColor = [UIColor kNormoalInfoTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        
    }
    return _iconImageView;
}

@end
