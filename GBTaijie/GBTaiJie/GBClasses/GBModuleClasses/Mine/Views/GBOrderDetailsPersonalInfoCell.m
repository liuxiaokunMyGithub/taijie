//
//  GBOrderDetailsPersonalInfoCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/24.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBOrderDetailsPersonalInfoCell.h"

@interface GBOrderDetailsPersonalInfoCell ()
/* <#describe#> */
@property (nonatomic, strong) UIView *bgView;

@end

@implementation GBOrderDetailsPersonalInfoCell

#pragma mark - Intial
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
        [self addMasonry];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.subTitleLabel];
    [self.bgView addSubview:self.subTitleLabel1];
//    [self.bgView addSubview:self.starView];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.decryptionLabel];

    GBViewBorderRadius(self.bgView, 2, 1, [UIColor kSegmentateLineColor]);
}

- (void)addMasonry {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.subTitleLabel).offset(-5);
        make.right.mas_equalTo(self.bgView).offset(-16);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    GBViewRadius(self.iconImageView, 32);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(16);
        make.left.mas_equalTo(self.bgView).offset(16);
        make.right.mas_equalTo(self.iconImageView.mas_left).offset(-GBMargin/2);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.bgView).offset(16);
        make.right.mas_equalTo(self.iconImageView.mas_left).offset(-GBMargin/2);
    }];
    
//    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(5);
//        make.left.mas_equalTo(self.bgView).offset(16);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(16);
//    }];
    
    [self.subTitleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.bgView).offset(16);        make.right.mas_equalTo(self.iconImageView.mas_left).offset(GBMargin/2);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleLabel1.mas_bottom).offset(GBMargin/2);
        make.left.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.decryptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom).offset(GBMargin/2);
        make.left.mas_equalTo(self.bgView).offset(16);
        make.right.mas_equalTo(self.bgView).offset(-16);
        make.bottom.mas_equalTo(self.bgView).offset(-GBMargin/2);
    }];
   
}

#pragma mark - Setter Getter Methods

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    
    return _bgView;
}

- (HCSStarRatingView *)starView {
    if (!_starView) {
        _starView = [[HCSStarRatingView alloc] init];
        _starView.emptyStarColor = UIColorFromRGB(0xBFBFBF);
        _starView.emptyStarImage = [UIImage imageNamed:@"icon_star_empty"];
        _starView.filledStarImage = [UIImage imageNamed:@"icon_star_sel"];
        _starView.maximumValue = 5;
        _starView.minimumValue = 0;
        _starView.userInteractionEnabled = NO;
    }
    
    return _starView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_M_Font(17);
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
    }
    
    return _titleLabel;
}


- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = Fit_Font(12);
        _subTitleLabel.textColor = [UIColor kAssistInfoTextColor];
    }
    
    return _subTitleLabel;
}

- (UILabel *)subTitleLabel1 {
    if (!_subTitleLabel1) {
        _subTitleLabel1 = [[UILabel alloc] init];
        _subTitleLabel1.font = Fit_Font(12);
        _subTitleLabel1.textColor = [UIColor kAssistInfoTextColor];
    }
    
    return _subTitleLabel1;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _line;
}

- (UILabel *)decryptionLabel {
    if (!_decryptionLabel) {
        _decryptionLabel = [[UILabel alloc] init];
        _decryptionLabel.numberOfLines = 0;
        _decryptionLabel.font = Fit_Font(12);
        _decryptionLabel.textColor = [UIColor kImportantTitleTextColor];
    }
    
    return _decryptionLabel;
}

@end
