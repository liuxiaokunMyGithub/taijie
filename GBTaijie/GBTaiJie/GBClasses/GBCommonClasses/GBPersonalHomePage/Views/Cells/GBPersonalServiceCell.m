//
//  GBPersonalServiceCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPersonalServiceCell.h"
#import "GBAssureContentTagModel.h"

@interface GBPersonalServiceCell ()

/* 广告 */
@property (nonatomic, strong) UIImageView *adImageView;

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 价格 */
@property (nonatomic, strong) UILabel *priceLabel;

/* 原价 */
@property (nonatomic, copy) UILabel *originalPriceLabel;

/* 标题 */
@property (nonatomic, strong) UILabel *helpLabel;

/* 标题 */
@property (nonatomic, strong) UILabel *satisfactionLabel;

/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;

@end

@implementation GBPersonalServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.adImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.originalPriceLabel];
        [self.contentView addSubview:self.helpLabel];
        [self.contentView addSubview:self.satisfactionLabel];
        [self.contentView addSubview:self.lineView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GBViewRadius(self.adImageView, 2);
        [self setupTagView];
        
        [self addMansonry];
    }
    
    return self;
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


- (void)setDecryptionModel:(GBPositionServiceModel *)decryptionModel {
    _decryptionModel = decryptionModel;
    self.titleLabel.text = decryptionModel.title;
    self.titleLabel.text = GBNSStringFormat(@"解密：%@",decryptionModel.title);
//    if (ValidStr(decryptionModel.discountType)) {
        self.priceLabel.text = [decryptionModel.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",decryptionModel.price);
    
    if (ValidStr(decryptionModel.discountType)) {
        self.originalPriceLabel.attributedText = [DCSpeedy dc_setMiddleAcrossPartingLineWith:GBNSStringFormat(@"%zu币",decryptionModel.originalPrice) WithColor:[UIColor kImportantTitleTextColor]];
    }
//    }else {
//        self.priceLabel.text = GBNSStringFormat(@"%zu币",decryptionModel.originalPrice);
//    }
    
//    if ([decryptionModel.discountType isEqualToString:@"FREE"]) {
//        self.priceLabel.text = GBNSStringFormat(@"限免/次");
//    }else {
//        self.priceLabel.text = GBNSStringFormat(@"%zu币/次",decryptionModel.price);
//    }
//
    self.helpLabel.text = GBNSStringFormat(@"帮助过：%@人",decryptionModel.orderCount);
    self.satisfactionLabel.text = GBNSStringFormat(@"满意度：%@%@",decryptionModel.goodRate,@"%");
    
    if (ValidStr(decryptionModel.type)) {
        self.tagsView.tags = [decryptionModel.type componentsSeparatedByString:@","];
    }
    
    if (ValidArray(decryptionModel.types)) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSMutableArray *tempNormalBackgroundColors = [NSMutableArray array];
        NSMutableArray *coustomNormalTitleColors = [NSMutableArray array];
        for (NSDictionary *type in decryptionModel.types) {
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

- (void)setAssureModel:(GBPositionServiceModel *)assureModel {
    _assureModel = assureModel;
    if (!ValidStr(assureModel.minSalary) || !ValidStr(assureModel.maxSalary)) {
        self.titleLabel.text = GBNSStringFormat(@"保过：%@ | %@",assureModel.jobName,assureModel.publisherCompany);
    }else {
        self.titleLabel.text = GBNSStringFormat(@"保过：%@ | %@-%@ | %@",assureModel.jobName,assureModel.minSalary,assureModel.maxSalary,assureModel.publisherCompany);
    }
//    self.priceLabel.text = GBNSStringFormat(@"%zu币/次",assureModel.price);
//    if (ValidStr(assureModel.discountType)) {
        self.priceLabel.text = [assureModel.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",assureModel.price);
    if (ValidStr(assureModel.discountType)) {
        self.originalPriceLabel.attributedText = [DCSpeedy dc_setMiddleAcrossPartingLineWith:GBNSStringFormat(@"%zu币",assureModel.originalPrice) WithColor:[UIColor kImportantTitleTextColor]];
    }
//    }else {
//        self.priceLabel.text = GBNSStringFormat(@"%zu币",assureModel.price);
//    }
    
    self.helpLabel.text = GBNSStringFormat(@"帮助过：%zu人",assureModel.purchasedCount);
    self.satisfactionLabel.text = GBNSStringFormat(@"满意度：%@%@",assureModel.goodRate,@"%");
    
//    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    if (ValidStr(assureModel.experienceName)) {
//        [tempArray addObject:assureModel.experienceName];
//    }
//
//    if (ValidStr(assureModel.dilamorName)) {
//        [tempArray addObject:assureModel.dilamorName];
//    }
//
    NSMutableArray *tempTagArray = [NSMutableArray array];
    if (assureModel.labels.count) {
        NSMutableArray *tagArray = [GBAssureContentTagModel mj_objectArrayWithKeyValuesArray:assureModel.labels];
            for (GBAssureContentTagModel *tagModel in tagArray) {
                if (ValidStr(tagModel.labelName)) {
                    [tempTagArray addObject:tagModel.labelName];
                }
            }
    }
    
    if (tempTagArray.count > 0) {
        self.tagsView.tags = tempTagArray;
        [self.tagsView reloadData];
    }
}

- (void)addMansonry {
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin+2);
        make.height.width.mas_equalTo(4);
        make.top.equalTo(self.titleLabel).offset(10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adImageView.mas_right).offset(8);
        make.right.mas_equalTo(-GBMargin);
        make.top.equalTo(self.contentView).offset(8);
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GBMargin/2);
        make.height.greaterThanOrEqualTo(@20);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.height.mas_equalTo(25);
        make.top.equalTo(self.tagsView.mas_bottom).offset(8);
    }];
    
    [self.helpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.satisfactionLabel.mas_left).offset(-GBMargin);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [self.satisfactionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.mas_equalTo(@0.5);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - # Getters and Setters
- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.backgroundColor = [UIColor kImportantTitleTextColor];
    }
    
    return _adImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_Font(16);
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel.text = @"1V1帮你诊断简历，模拟面试，竞争力分析，信誉担保，员工内推，不入职不收费";
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = Fit_L_Font(12);
        _priceLabel.textColor = [UIColor kPromptRedColor];
    }
    return _priceLabel;
}

- (UILabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.font = Fit_L_Font(10);
        _originalPriceLabel.textColor = [UIColor kAssistInfoTextColor];
    }
    return _originalPriceLabel;
}

- (UILabel *)helpLabel {
    if (!_helpLabel) {
        _helpLabel = [[UILabel alloc] init];
        _helpLabel.font = Fit_L_Font(12);
        _helpLabel.textColor = [UIColor kAssistInfoTextColor];
    }
    return _helpLabel;
}

- (UILabel *)satisfactionLabel {
    if (!_satisfactionLabel) {
        _satisfactionLabel = [[UILabel alloc] init];
        _satisfactionLabel.font = Fit_L_Font(12);
        _satisfactionLabel.textColor = [UIColor kAssistInfoTextColor];
    }
    return _satisfactionLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _lineView;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] init];
        _tagsView.userInteractionEnabled = NO;
    }
    
    return _tagsView;
}

@end
