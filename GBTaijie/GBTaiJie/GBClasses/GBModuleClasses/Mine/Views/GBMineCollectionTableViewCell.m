//
//  GBMineCollectionTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMineCollectionTableViewCell.h"

@interface GBMineCollectionTableViewCell ()
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 子标题
@property (nonatomic, strong) UILabel *subTitleLabel;
// 子标题1
@property (nonatomic, strong) UILabel *subTitleLabel1;

/* 图标 */
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation GBMineCollectionTableViewCell

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
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.subTitleLabel1];
}

- (void)setCollectionModel:(GBCollectionModel *)collectionModel {
    _collectionModel = collectionModel;
    if ([collectionModel.type isEqualToString:@"COLLECTION_TYPE_USER"]) {
        // 朋友
        self.titleLabel.text = collectionModel.details.nickName;
        self.subTitleLabel.text = collectionModel.details.positionName;
        self.subTitleLabel1.text = collectionModel.details.companyName;
        [self.iconImageView sd_setImageWithURL:GBImageURL(collectionModel.details.headImg) placeholderImage:PlaceholderListImage];
    }else if ([collectionModel.type isEqualToString:@"COLLECTION_TYPE_POSITION"]) {
        // 职位
        self.titleLabel.text = collectionModel.details.positionName;
        self.subTitleLabel.text = GBNSStringFormat(@"%zuk-%zuk",collectionModel.details.minSalary,collectionModel.details.maxSalary);
        self.subTitleLabel1.text = GBNSStringFormat(@"%@ · %@",collectionModel.details.workingPlace,collectionModel.details.companyAbbreviatedName);
        [self.iconImageView sd_setImageWithURL:GBImageURL(collectionModel.details.companyLogo) placeholderImage:PlaceholderListImage];

    }else if ([collectionModel.type isEqualToString:@"COLLECTION_TYPE_COMPANY"]) {
        // 公司
        self.titleLabel.text = collectionModel.details.companyAbbreviatedName;
        self.subTitleLabel.text = collectionModel.details.industryName;
        self.subTitleLabel1.text = GBNSStringFormat(@"%@ · 认证同事%@",collectionModel.details.regionName,collectionModel.details.personnelScaleName);
        [self.iconImageView sd_setImageWithURL:GBImageURL(collectionModel.details.companyLogo) placeholderImage:PlaceholderListImage];

    }
}

- (void)addMasonry {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    GBViewRadius(self.iconImageView, 32);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(16);
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.right.mas_equalTo(self.iconImageView.mas_left).offset(-GBMargin/2);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.right.mas_equalTo(self.iconImageView.mas_left).offset(-GBMargin/2);
    }];
    
    [self.subTitleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.right.mas_equalTo(self.iconImageView.mas_left).offset(-GBMargin/2);
    }];
}

#pragma mark - Setter Getter Methods
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
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
        _subTitleLabel.textColor = [UIColor kNormoalInfoTextColor];
    }
    
    return _subTitleLabel;
}

- (UILabel *)subTitleLabel1 {
    if (!_subTitleLabel1) {
        _subTitleLabel1 = [[UILabel alloc] init];
        _subTitleLabel1.font = Fit_Font(12);
        _subTitleLabel1.textColor = [UIColor kNormoalInfoTextColor];
    }
    
    return _subTitleLabel1;
}

@end
