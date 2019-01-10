//
//  GBTaijiebiCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBTaijiebiCell.h"
@interface GBTaijiebiCell ()

/* 类型标记 */
@property (nonatomic, strong) UIImageView *iconImageView;
/* 分割线 */
@property (nonatomic, strong) UIImageView *linView;

@end

@implementation GBTaijiebiCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceButton];
        [self.contentView addSubview:self.linView];
        
        [self p_addMasonry];
    }
    return self;
}

//- (void)applePayButtonAction {
//    !_payButtonClickBlock ? : _payButtonClickBlock(_indexPath);
//}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 类型标记
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    // 交易金额
    [self.priceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-GBMargin);
        make.centerY.mas_equalTo(self.titleLabel.centerY);
        make.height.mas_equalTo(self.contentView.height);
        make.left.mas_equalTo(GBMargin);
    }];
    
    // 分割线
    [self.linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-GBMargin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(@0.5);
        make.left.mas_equalTo(GBMargin);
    }];
}

#pragma mark - # Getters and Setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:GBImageNamed(@"icon_taijiebi")];
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithText:@"" font:Fit_Font(16) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _titleLabel;
}

- (UIButton *)priceButton {
    if (!_priceButton) {
        _priceButton = [[UIButton alloc] init];
        [_priceButton setTitleColor:[UIColor kYellowBgColor] forState:UIControlStateNormal];
        [_priceButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [_priceButton setBackgroundColor:[UIColor kBaseColor]];
//        [_priceButton addTarget:self action:@selector(applePayButtonAction) forControlEvents:UIControlEventTouchUpInside];

//        GBViewRadius(_priceButton, 15);
        
    }
    return _priceButton;
}

- (UIImageView *)linView {
    if (!_linView) {
        _linView = [[UIImageView alloc] init];
        _linView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _linView;
}

@end
