//
//  GBMoreListTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMoreListTableViewCell.h"
@interface GBMoreListTableViewCell ()

/* 图片 */
@property (strong , nonatomic) UIImageView *gridImageView;
/* 标题 */
@property (strong , nonatomic) UILabel *titleLabel;
/* 子标题 */
@property (strong , nonatomic) UILabel *subTitleLabel;
/* 子标题1 */
@property (strong , nonatomic) UILabel *subTitleLabel1;
/* 分割线 */
@property (strong , nonatomic) UIView *line;

@end

@implementation GBMoreListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.gridImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.subTitleLabel1];
        [self.contentView addSubview:self.line];

        GBViewBorderRadius(self.gridImageView, 28, 0.5, [UIColor kSegmentateLineColor]);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self.gridImageView.mas_right)setOffset:GBMargin];
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
        make.top.mas_equalTo(self.gridImageView);
        [make.right.mas_equalTo(self.contentView)setOffset:-GBMargin];
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
    }];
    
    
    [_subTitleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.mas_equalTo(0.5);
    }];
}

// MARK: 匹配职位
- (void)setPositionModel:(GBPositionCommonModel *)positionModel {
    _positionModel = positionModel;
    [self.gridImageView sd_setImageWithURL:GBImageURL(positionModel.companyLogo) placeholderImage:PlaceholderListImage];
    self.subTitleLabel.text = positionModel.workingPlace;
    self.titleLabel.text = positionModel.positionName;
    self.subTitleLabel1.text = GBNSStringFormat(@"%ld~%zuk",(long)positionModel.minSalary,positionModel.maxSalary);
}

// MARK: 匹配公司
- (void)setCompanyModel:(CompanyModel *)companyModel {
    _companyModel = companyModel;
    [self.gridImageView sd_setImageWithURL:GBImageURL(companyModel.companyLogo) placeholderImage:PlaceholderListImage];
    self.titleLabel.text = companyModel.companyAbbreviatedName;
    self.subTitleLabel.text = companyModel.industryName;
    self.subTitleLabel1.text = companyModel.regionName;
}

#pragma mark - # Getters and Setters
- (UIImageView *)gridImageView {
    if (!_gridImageView) {
        _gridImageView = [[UIImageView alloc] init];
    }
    return _gridImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_M_Font(14);
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = [UIColor kNormoalInfoTextColor];
        
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor kNormoalInfoTextColor];
        _subTitleLabel.font = Fit_Font(12);
    }
    return _subTitleLabel;
}

- (UILabel *)subTitleLabel1 {
    if (!_subTitleLabel1) {
        _subTitleLabel1 = [[UILabel alloc] init];
        _subTitleLabel1.textColor = [UIColor kBaseColor];
        _subTitleLabel1.font = Fit_Font(14);
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

@end
