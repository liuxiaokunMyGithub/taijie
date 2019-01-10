//
//  GBFindDecryptionCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBFindDecryptionCell.h"
#import "GBLIRLButton.h"
#import "HXTagsView.h"
#import "GBType.h"

@interface GBFindDecryptionCell ()
/*  */
@property (nonatomic, strong) UILabel *titleLabel;
/* 公司logo */
@property (nonatomic, strong) UIImageView *logoImageView;
/* 性别标识图 */
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UIImageView *vImageView;
/* 价格 */
@property (nonatomic, strong) UILabel *priceLabel;
/* <#describe#> */
@property (nonatomic, strong) UILabel *originalPriceLabel;
/* 职位 */
@property (nonatomic, strong) UILabel *positionLabel;

/*  */
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *segmentateLine;

/* 已购 */
@property (nonatomic, strong) GBLIRLButton *purchasedButton;

/* 好评率 */
@property (nonatomic, strong) GBLIRLButton *goodRateButton;

/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;
@property (nonatomic, strong) HXTagAttribute *tagAttribute;

@end

@implementation GBFindDecryptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.purchasedButton];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.originalPriceLabel];
        [self.contentView addSubview:self.sexImageView];
        [self.contentView addSubview:self.positionLabel];
        
        [self.contentView addSubview:self.vImageView];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.goodRateButton];
        [self.contentView addSubview:self.segmentateLine];
        [self setupTagView];
        [self addMasonry];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setConsultingDecryptsModel:(GBFindModel *)consultingDecryptsModel {
    _consultingDecryptsModel = consultingDecryptsModel;
    [self.logoImageView sd_setImageWithURL:GBImageURL(consultingDecryptsModel.headImg) placeholderImage:PlaceholderHeadImage];
    self.titleLabel.text = consultingDecryptsModel.title;
    self.positionLabel.text = GBNSStringFormat(@"%@ | %@",consultingDecryptsModel.nickName,consultingDecryptsModel.positionName);

        self.priceLabel.text = [consultingDecryptsModel.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",consultingDecryptsModel.price);
    if (ValidStr(consultingDecryptsModel.discountType)) {
        self.originalPriceLabel.attributedText = [DCSpeedy dc_setMiddleAcrossPartingLineWith:GBNSStringFormat(@"%zu币",consultingDecryptsModel.originalPrice) WithColor:[UIColor kImportantTitleTextColor]];
    }
    
    self.sexImageView.image = [consultingDecryptsModel.sex isEqualToString:@"MALE"] ? GBImageNamed(@"icon_men") : GBImageNamed(@"icon_women");
    [self.purchasedButton setTitle:GBNSStringFormat(@"%zu人已购买",consultingDecryptsModel.orderCount) forState:UIControlStateNormal];
    [self.goodRateButton setTitle:GBNSStringFormat(@"%zu%@ 好评率",consultingDecryptsModel.evaluateRate,@"%") forState:UIControlStateNormal];
    
        self.tagsView.tags = [consultingDecryptsModel.classifiedName componentsSeparatedByString:@","];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *tempNormalBackgroundColors = [NSMutableArray array];
    NSMutableArray *coustomNormalTitleColors = [NSMutableArray array];
    
    for (NSDictionary *type in consultingDecryptsModel.types) {
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

- (void)addMasonry {
//    [super layoutSubviews];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.width.height.equalTo(@54);
        make.left.equalTo(self.contentView).offset(GBMargin);
    }];
    
    GBViewRadius(self.logoImageView, 27);
    
    // V
    [self.vImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.logoImageView).offset(-5);
        make.bottom.equalTo(self.logoImageView).offset(-1);
        make.height.width.equalTo(@12);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.contentView).offset(16);
//        make.height.greaterThanOrEqualTo(@40);
        make.right.equalTo(self.contentView).offset(-GBMargin/2);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoImageView);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
    
    
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoImageView);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
    
    // 性别
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.centerY.equalTo(self.positionLabel);
        make.height.width.mas_equalTo(12);
    }];
    
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexImageView.mas_right).offset(3);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.positionLabel.mas_bottom).offset(GBMargin/2);
        make.height.greaterThanOrEqualTo(@20);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.purchasedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.line.mas_bottom).offset(8);
        make.right.equalTo(self.goodRateButton.mas_left).offset(-40);
    }];
    
    [self.goodRateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(8);
        make.left.equalTo(self.purchasedButton.mas_right).offset(40);
    }];
    
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(5);
        make.top.equalTo(self.tagsView.mas_bottom).offset(GBMargin/2);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.segmentateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.goodRateButton.mas_bottom).offset(16);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@5);
        make.right.equalTo(self.contentView);
    }];
    
}

- (void)setupTagView {
    self.tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
        NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
    };
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = Fit_Font(16);
        _titleLabel.text = @"我在腾讯面试了上百人，这些面试潜规则你想知道吗？";
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.textColor = [UIColor kImportantTitleTextColor];
        _positionLabel.font = Fit_L_Font(12);
    }
    return _positionLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor kPromptRedColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = Fit_M_Font(14);
    }
    return _priceLabel;
}

- (UILabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.textColor = [UIColor kAssistInfoTextColor];
        _originalPriceLabel.textAlignment = NSTextAlignmentCenter;
        _originalPriceLabel.font = Fit_Font(10);
    }
    return _originalPriceLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _line;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = PlaceholderListImage;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _logoImageView;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] init];
        _sexImageView.image = GBImageNamed(@"icon_women");
    }
    return _sexImageView;
}

- (UIImageView *)vImageView {
    if (!_vImageView) {
        _vImageView = [[UIImageView alloc] init];
        _vImageView.image = GBImageNamed(@"icon_certification_photo");
    }
    
    return _vImageView;
}

- (GBLIRLButton *)goodRateButton {
    if (!_goodRateButton) {
        _goodRateButton = [[GBLIRLButton alloc] init];
        [_goodRateButton setImage:GBImageNamed(@"icon_rate2") forState:UIControlStateNormal];
        [_goodRateButton setTitle:@"1111" forState:UIControlStateNormal];
        _goodRateButton.titleLabel.font = Fit_Font(12);
        [_goodRateButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        _goodRateButton.userInteractionEnabled = NO;
    }
    
    return _goodRateButton;
}


- (GBLIRLButton *)purchasedButton {
    if (!_purchasedButton) {
        _purchasedButton = [[GBLIRLButton alloc] init];
        [_purchasedButton setImage:GBImageNamed(@"icon_successful2") forState:UIControlStateNormal];
        [_purchasedButton setTitle:@"1111" forState:UIControlStateNormal];
        _purchasedButton.titleLabel.font = Fit_Font(12);
        [_purchasedButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        _purchasedButton.userInteractionEnabled = NO;
    }
    
    return _purchasedButton;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] init];
        _tagsView.userInteractionEnabled = NO;
    }
    
    return _tagsView;
}

- (UIView *)segmentateLine {
    if (!_segmentateLine) {
        _segmentateLine = [[UIView alloc] init];
        _segmentateLine.backgroundColor = [UIColor kTitleColorBG];
    }
    
    return _segmentateLine;
}

@end

