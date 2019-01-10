//
//  GBCompanyListCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/28.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBCompanyListCell.h"

@interface GBCompanyListCell ()
/* <#describe#> */
@property (nonatomic, strong) UILabel *titleLabel;
/* <#describe#> */
@property (nonatomic, strong) UILabel *titleLabel1;
/* <#describe#> */
@property (nonatomic, strong) UILabel *titleLabel2;
/* 公司logo */
@property (nonatomic, strong) UIImageView *logoImageView;
/* <#describe#> */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation GBCompanyListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.titleLabel1];
        [self.contentView addSubview:self.titleLabel2];
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.lineView];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}

- (void)setCompanyModel:(CompanyModel *)companyModel {
    [self.logoImageView sd_setImageWithURL:GBImageURL(companyModel.companyLogo) placeholderImage:PlaceholderListImage];
    self.titleLabel.text = companyModel.companyFullName;
    self.titleLabel1.text = GBNSStringFormat(@"%@ | %@ | %@",companyModel.industryName,companyModel.financingScaleName,companyModel.personelScaleName);
    self.titleLabel2.text = GBNSStringFormat(@"%@ | %@ ",companyModel.regionName,companyModel.companyAddress);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(@80);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.logoImageView);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.titleLabel1.mas_bottom).offset(3);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-GBMargin);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
        make.left.equalTo(@(GBMargin));
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _lineView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
//        _titleLabel.numberOfLines = 1;
        _titleLabel.font = Fit_Font(16);
    }
    
    return _titleLabel;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.textColor = [UIColor kAssistInfoTextColor];
        _titleLabel1.font = Fit_L_Font(14);
    }
    
    return _titleLabel1;
}

- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.textColor = [UIColor kAssistInfoTextColor];
        _titleLabel2.font = Fit_L_Font(14);
    }
    
    return _titleLabel2;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
