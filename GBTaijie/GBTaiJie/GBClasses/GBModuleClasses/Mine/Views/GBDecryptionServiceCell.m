//
//  GBDecryptionServiceCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBDecryptionServiceCell.h"

@interface GBDecryptionServiceCell ()
/* 背景视图 */
@property (nonatomic, strong) UIView *lineView;
/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 子标题 */
@property (nonatomic, strong) UILabel *subTitleLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 折扣价格 */
@property (nonatomic, strong) UILabel *discountLabel;

/* 点 */
@property (nonatomic, strong) UIImageView *iconImageView;
/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;

@end

@implementation GBDecryptionServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.discountLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.iconImageView];
        
        [self setupTagView];
        
        [self p_addMasonry];
        
        GBViewRadius(self.iconImageView, 2);
    }
    return self;
}


- (void)setModel:(GBPositionServiceModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.details;
   self.priceLabel.text = [model.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",model.price);
    
    if (ValidStr(model.discountType)) {
        self.discountLabel.attributedText = [DCSpeedy dc_setMiddleAcrossPartingLineWith:GBNSStringFormat(@"%zu币",model.originalPrice) WithColor:[UIColor kImportantTitleTextColor]];
    }
    
    if (ValidStr(model.type)) {
        self.tagsView.tags = [model.type componentsSeparatedByString:@","];
    }
    
    if (ValidArray(model.types)) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSMutableArray *tempNormalBackgroundColors = [NSMutableArray array];
        NSMutableArray *coustomNormalTitleColors = [NSMutableArray array];
        for (NSDictionary *type in model.types) {
            [tempArray addObject:type[@"name"]];
            if ([type[@"isCustomized"] integerValue] == 1) {
                [tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#EDF8EC"]];
                
                [coustomNormalTitleColors addObject:[UIColor colorWithHexString:@"#28B261"]];
                
            }else {
                [tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#ECECF8"]];
                [coustomNormalTitleColors addObject:[UIColor kBaseColor]];
            }
        }
        
        if (tempArray.count > 0) {
            self.tagsView.tags = tempArray;
        }
        
        self.tagsView.coustomNormalBackgroundColors = tempNormalBackgroundColors;
        self.tagsView.coustomNormalTitleColors = coustomNormalTitleColors;
        
        [self.tagsView reloadData];
    }
}

- (void)setupTagView {
    self.tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.tagsView.layout.itemSize = CGSizeMake(100, 20);
    HXTagAttribute *model = [[HXTagAttribute alloc]init];
    model.borderWidth  = 0;
    model.cornerRadius  = 2;
    model.titleSize  = 12;
    model.textColor  = [UIColor kBaseColor];
    model.normalBackgroundColor  = [UIColor colorWithHexString:@"#ECECF8"];
    model.tagSpace  = 15;
    
    self.tagsView.tagAttribute = model;
    [self.tagsView reloadData];
    
    [self.contentView addSubview:self.tagsView];
    
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 点
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GBMargin);
        make.left.mas_equalTo(GBMargin);
        make.size.mas_equalTo(CGSizeMake(4,4));
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(-GBMargin);
        make.top.mas_equalTo(16);
    }];
    
    //
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-GBMargin);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(GBMargin/2);
        make.height.greaterThanOrEqualTo(@20);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    // 价格
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
         make.top.equalTo(self.tagsView.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
    }];
    
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(6);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    // 分割线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
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
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.textColor = [UIColor kAssistInfoTextColor];
        _subTitleLabel.font = Fit_Font(12);
    }
    return _subTitleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor kYellowBgColor];
        _priceLabel.font = Fit_Font(16);
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


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor kImportantTitleTextColor];
    }
    
    return _iconImageView;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] init];
        _tagsView.userInteractionEnabled = NO;
    }
    
    return _tagsView;
}

@end
