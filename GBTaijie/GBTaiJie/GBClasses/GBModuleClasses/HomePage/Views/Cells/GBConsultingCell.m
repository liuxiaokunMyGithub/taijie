//
//  GBConsultingCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBConsultingCell.h"
#import "GBLIRLButton.h"
#import "HXTagsView.h"

@interface GBConsultingCell ()
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

/* 公司 */
@property (nonatomic, strong) UILabel *companyLabel;

/* 收藏 */
@property (nonatomic, strong) GBLIRLButton *collectionButton;

/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;
/* 标签视图高 */
@property (nonatomic, assign) CGFloat tagViewheight;

@end

@implementation GBConsultingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.originalPriceLabel];
        [self.contentView addSubview:self.sexImageView];
        [self.contentView addSubview:self.positionLabel];

        [self.contentView addSubview:self.vImageView];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.collectionButton];
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
    self.companyLabel.text = consultingDecryptsModel.companyFullName;
    [self.collectionButton setTitle:GBNSStringFormat(@"%zu",consultingDecryptsModel.likeCount) forState:UIControlStateNormal];
    self.priceLabel.text = [consultingDecryptsModel.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",consultingDecryptsModel.price);
    if (ValidStr(consultingDecryptsModel.discountType)) {
        self.originalPriceLabel.attributedText = [DCSpeedy dc_setMiddleAcrossPartingLineWith:GBNSStringFormat(@"%zu币",consultingDecryptsModel.originalPrice) WithColor:[UIColor kImportantTitleTextColor]];
    }
    
    self.sexImageView.image = [consultingDecryptsModel.sex isEqualToString:@"MALE"] ? GBImageNamed(@"icon_men") : GBImageNamed(@"icon_women");

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
    
    self.tagViewheight = [DCSpeedy dc_calculateTextSizeWithText:_consultingDecryptsModel.title WithTextFont:Fit_Font(16) WithMaxW:SCREEN_WIDTH - (54+GBMargin*2+8)].height;

    [self.tagsView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addMasonry];
}

- (void)addMasonry {
    [self.logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.width.height.equalTo(@54);
        make.left.equalTo(self.contentView).offset(GBMargin);
    }];
    GBViewRadius(self.logoImageView, 27);
    
    // V
    [self.vImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.logoImageView).offset(-5);
        make.bottom.equalTo(self.logoImageView).offset(-1);
        make.height.width.equalTo(@12);
    }];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.height.equalTo(@(20));
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
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
    [self.sexImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.centerY.equalTo(self.positionLabel);
        make.height.width.mas_equalTo(12);
    }];
    
    [self.positionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexImageView.mas_right).offset(3);
        make.top.equalTo(self.tagsView.mas_bottom).offset(20);
        make.height.equalTo(@24);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.companyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.positionLabel.mas_bottom).offset(3);
        make.right.equalTo(self).offset(-GBMargin*4);
    }];
    
    [self.collectionButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyLabel);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.companyLabel.mas_bottom).offset(16);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
}

- (void)setupTagView {
    self.tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
        NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
    };

    HXTagCollectionViewFlowLayout *flowLayout = [[HXTagCollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = CGSizeMake(100, 20);
    self.tagsView.layout = flowLayout;
    
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
        _titleLabel.font = Fit_Font(16);
        _titleLabel.text = @"我在腾讯面试了上百人，这些面试潜规则你想知道吗？";
        _titleLabel.numberOfLines = 2;
        _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - (54+GBMargin*2+8);
    }
    return _titleLabel;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.textColor = [UIColor kAssistInfoTextColor];
        _companyLabel.numberOfLines = 2;
        _companyLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - (54+GBMargin*6+8);
        _companyLabel.font = Fit_L_Font(12);
    }
    return _companyLabel;
}

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.textColor = [UIColor kImportantTitleTextColor];
        _positionLabel.font = Fit_L_Font(12);
        _positionLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - (54+GBMargin*2+8);

    }
    return _positionLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor kPromptRedColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = Fit_B_Font(14);
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

- (GBLIRLButton *)collectionButton {
    if (!_collectionButton) {
        _collectionButton = [[GBLIRLButton alloc] init];
        [_collectionButton setImage:GBImageNamed(@"icon_interesting") forState:UIControlStateNormal];
        _collectionButton.titleLabel.font = Fit_Font(12);
        [_collectionButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        _collectionButton.userInteractionEnabled = NO;
    }
    
    return _collectionButton;
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

