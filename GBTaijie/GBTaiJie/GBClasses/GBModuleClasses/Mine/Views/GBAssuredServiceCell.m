//
//  GBAssuredServiceCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBAssuredServiceCell.h"

@interface GBAssuredServiceCell ()
/* 分割线 */
@property (nonatomic, strong) UIView *lineView;
/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 子标题 */
@property (nonatomic, strong) UILabel *subTitleLabel;
/* 子标题 */
@property (nonatomic, strong) UILabel *subTitleLabel1;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 折扣价格 */
@property (nonatomic, strong) UILabel *discountLabel;

@end

@implementation GBAssuredServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.subTitleLabel1];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.discountLabel];
        [self.contentView addSubview:self.lineView];

        [self p_addMasonry];
    }
    return self;
}


- (void)setModel:(GBPositionServiceModel *)model {
    _model = model;
    self.titleLabel.text = model.jobName;
    self.subTitleLabel.text = GBNSStringFormat(@"%@ · %@",model.regionName,model.publisherCompany);
    self.subTitleLabel1.text = GBNSStringFormat(@"%@ · %@",model.experienceName,model.dilamorName);
    self.priceLabel.text = [model.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",model.price);
    
    if (ValidStr(model.discountType)) {
        self.discountLabel.attributedText = [DCSpeedy dc_setMiddleAcrossPartingLineWith:GBNSStringFormat(@"%zu币",model.originalPrice) WithColor:[UIColor kImportantTitleTextColor]];
    }
}

#pragma mark - # Private Methods
- (void)p_addMasonry {

    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin/2);
        make.top.mas_equalTo(16);
    }];
    // 偷看人数
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);

        make.right.mas_equalTo(-GBMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
    }];
    
    // 时间
    [self.subTitleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        
        make.right.mas_equalTo(-GBMargin);       make.top.equalTo(self.subTitleLabel.mas_bottom);
    }];
    
    // 价格
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.subTitleLabel1.mas_bottom).offset(8);
    }];
    
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(6);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    // 分割线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(16);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@0.5);
    }];
}

#pragma mark - # Getters and Setters
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.layer.borderWidth = 1;
        _lineView.layer.borderColor = [UIColor kSegmentateLineColor].CGColor;
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_M_Font(14);
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor kNormoalInfoTextColor];
        
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor kAssistInfoTextColor];
        _subTitleLabel.font = Fit_Font(12);
    }
    return _subTitleLabel;
}

- (UILabel *)subTitleLabel1 {
    if (!_subTitleLabel1) {
        _subTitleLabel1 = [[UILabel alloc] init];
        _subTitleLabel1.textColor = [UIColor kAssistInfoTextColor];
        _subTitleLabel1.font = Fit_Font(12);
    }
    return _subTitleLabel1;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor kYellowBgColor];
        _priceLabel.font = Fit_Font(14);
    }
    return _priceLabel;
}

- (UILabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.textColor = [UIColor kAssistInfoTextColor];
        _discountLabel.font = Fit_Font(14);
    }
    return _discountLabel;
}

@end
