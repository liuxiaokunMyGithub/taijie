//
//  GBPositioinCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPositioinCell.h"

// Models
#import "GBPositionCommonModel.h"

@interface GBPositioinCell ()

/* 属性 */
@property (strong , nonatomic)UILabel *natureLabel;

@end

@implementation GBPositioinCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI {
    _backImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_backImageView];
    GBViewBorderRadius(_backImageView, 2, 0.5, [UIColor kSegmentateLineColor]);
    
    _goodsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_goodsImageView];
    _goodsImageView.image = GBImageNamed(@"ic_defaultHeadIcon");
    
    GBViewBorderRadius(_goodsImageView, 2, 0.5, [UIColor kSegmentateLineColor]);
    
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.font = Fit_Font(16);
    _positionLabel.textColor = [UIColor kImportantTitleTextColor];
    _positionLabel.textAlignment = NSTextAlignmentCenter;
    _positionLabel.numberOfLines = 1;
    _positionLabel.text = @"FaceBook";
    [self.contentView addSubview:_positionLabel];
    
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.font = Fit_L_Font(12);
    _companyLabel.textColor = [UIColor kImportantTitleTextColor];
    _companyLabel.textAlignment = NSTextAlignmentCenter;
    _companyLabel.numberOfLines = 1;
    _companyLabel.text = @"大连-高新区";
    [self.contentView addSubview:_companyLabel];

    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor kBaseColor];
    _priceLabel.font = Fit_M_Font(14);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_priceLabel];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        [make.top.mas_equalTo(self.contentView)setOffset:0];
        make.width.mas_equalTo(self.contentView).multipliedBy(1);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backImageView);
        [make.top.mas_equalTo(self.backImageView)setOffset:GBMargin/2];
        make.height.width.mas_equalTo(60);
    }];
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    [make.top.mas_equalTo(self.goodsImageView.mas_bottom)setOffset:GBMargin/2];
        make.left.mas_equalTo(self.backImageView).offset(5);
        make.right.mas_equalTo(self.backImageView).offset(-5);
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self.positionLabel.mas_bottom)setOffset:4];
        make.left.right.mas_equalTo(self.positionLabel);
    }];

    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self.companyLabel.mas_bottom)setOffset:8];
        make.left.right.mas_equalTo(self.backImageView);
    }];
}

#pragma mark - Setter Getter Methods
- (void)setPositionModel:(GBPositionCommonModel *)positionModel {
    _positionModel = positionModel;
    
    if (positionModel.isMore) {
        // 查看更多
        self.goodsImageView.image = GBImageNamed(@"logo_Icon");
        self.positionLabel.text = positionModel.companyAbbreviatedName;
        self.priceLabel.text = @"";
        return;
    }
    
    [self.goodsImageView sd_setImageWithURL:GBImageURL(positionModel.companyLogo) placeholderImage:PlaceholderListImage];
    self.positionLabel.text = positionModel.positionName;
    self.companyLabel.text = positionModel.companyFullName;
    self.priceLabel.text = GBNSStringFormat(@"%zu~%zuk",positionModel.minSalary,positionModel.maxSalary);
}

@end
