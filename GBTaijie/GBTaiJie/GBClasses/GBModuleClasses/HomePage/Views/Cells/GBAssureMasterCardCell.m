//
//  GBAssureMasterCardCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBAssureMasterCardCell.h"

@interface GBAssureMasterCardCell ()

/* 背景视图 */
@property (nonatomic, strong) UIImageView *bgView;

/* 性别标识图 */
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UIImageView *vImageView;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UIImageView *emailImageView;
@property (nonatomic, strong) UIImageView *zimaImageView;
@property (nonatomic, strong) UIImageView *promptImageView;

@property (nonatomic, strong) UIImageView *helpIcon;
@property (nonatomic, strong) UIImageView *collectionIcon;
@property (nonatomic, strong) UIImageView *goodRateIcon;

@property (nonatomic, strong) UILabel *helpLabel;
@property (nonatomic, strong) UILabel *collectionLabel;
@property (nonatomic, strong) UILabel *goodRateLabel;

/* 头像 */
@property (nonatomic, strong) UIImageView *headImageView;

/* 公司logo */
@property (nonatomic, strong) UIImageView *companyLogoImageView;
/* 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;
/* 职位 */
@property (nonatomic, strong) UILabel *positionLabel;
/* 公司 */
@property (nonatomic, strong) UILabel *companyLabel;

/* <#describe#> */
@property (nonatomic, strong) UIView *assurePositionView;
/* <#describe#> */
@property (nonatomic, strong) UILabel *assurePositionLabel;
/* <#describe#> */
@property (nonatomic, strong) UILabel *priceLacel;
@end

@implementation GBAssureMasterCardCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.headImageView];
        [self.bgView addSubview:self.nameLabel];
        [self.bgView addSubview:self.positionLabel];
        [self.bgView addSubview:self.companyLabel];
        [self.bgView addSubview:self.companyLogoImageView];
        [self.bgView addSubview:self.promptImageView];
        [self.bgView addSubview:self.sexImageView];
        
        [self.bgView addSubview:self.vImageView];
        [self.bgView addSubview:self.cardImageView];
        [self.bgView addSubview:self.emailImageView];
        [self.bgView addSubview:self.zimaImageView];
        [self.bgView addSubview:self.helpIcon];
        [self.bgView addSubview:self.collectionIcon];
        [self.bgView addSubview:self.goodRateIcon];
        [self.bgView addSubview:self.helpLabel];
        [self.bgView addSubview:self.collectionLabel];
        [self.bgView addSubview:self.goodRateLabel];        
    }
    return self;
}

#pragma mark - # Event Response
- (void)payLookButtonTouchUpInside:(UIButton *)sender {
    
}

- (void)setAssureMasterModel:(GBAssureMasterModel *)assureMasterModel {
    _assureMasterModel = assureMasterModel;
    [self.headImageView sd_setImageWithURL:GBImageURL(assureMasterModel.headImg) placeholderImage:PlaceholderHeadImage];
    self.nameLabel.text = assureMasterModel.nickName;
    self.positionLabel.text = assureMasterModel.positionName;
    self.companyLabel.text = assureMasterModel.companyName;
    [self.companyLogoImageView sd_setImageWithURL:GBImageURL(assureMasterModel.companyLogo) placeholderImage:PlaceholderListImage];
    
    self.sexImageView.image = [assureMasterModel.sex isEqualToString:@"MALE"] ? GBImageNamed(@"icon_men") : GBImageNamed(@"icon_women");
    
    NSString *helpStr = [NSString stringWithFormat:@"%zu人 已成功入职",assureMasterModel.assureHelpCount];
     self.helpLabel.attributedText = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kAssistInfoTextColor] changeFont:Fit_L_Font(10) totalString:helpStr changeString:@"已成功入职"];
    NSString *collectionStr = [NSString stringWithFormat:@"%@%@ 保过率",assureMasterModel.assureSuccessRate,@"%"];

     self.collectionLabel.attributedText = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kAssistInfoTextColor] changeFont:Fit_L_Font(10) totalString:collectionStr changeString:@"保过率"];
    NSString *goodRateStr = [NSString stringWithFormat:@"%@%@ 好评率",assureMasterModel.evaluateRate,@"%"];
    
     self.goodRateLabel.attributedText = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kAssistInfoTextColor] changeFont:Fit_L_Font(10) totalString:goodRateStr changeString:@"好评率"];
    
    self.cardImageView.image = assureMasterModel.badgeAuth || assureMasterModel.laborContractAuth ? GBImageNamed(@"icon_card_yellow_1") : GBImageNamed(@"icon_card_1");
    self.emailImageView.image = assureMasterModel.companyEmailAuth ? GBImageNamed(@"icon_email_1") : GBImageNamed(@"icon_email_orange_1");
}

#pragma mark - # Private Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    // 背景视图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.contentView);
    }];
   

    GBViewBorderRadius(self.bgView, 2, 0.5, [UIColor kSegmentateLineColor]);
    //添加四个边阴影
    self.bgView.layer.shadowColor = [UIColor colorWithHexString:@"#949497"].CGColor;//阴影颜色
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);//偏移距离
    self.bgView.layer.shadowOpacity = 1;//不透明度
    self.bgView.layer.shadowRadius = 2.0;//半径
    self.bgView.layer.masksToBounds = NO;
    
    // 头像
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(10);
        make.left.mas_equalTo(self.bgView).offset(10);
        make.height.width.mas_equalTo(54);
    }];
    
    GBViewRadius(self.headImageView, 27);
    
    // 姓名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.height.greaterThanOrEqualTo(@20);
        make.top.equalTo(self.headImageView);
    }];
    
    // 性别
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(3);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    
    // 职位
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
    }];
    
    // V
    [self.vImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.positionLabel.mas_right).offset(3);
        make.centerY.equalTo(self.positionLabel);
        make.height.width.equalTo(@14);
    }];
    // card
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vImageView.mas_right).offset(3);
        make.centerY.equalTo(self.positionLabel);
        make.height.width.equalTo(@14);
    }];
    // email
    [self.emailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImageView.mas_right).offset(3);
        make.centerY.equalTo(self.positionLabel);
        make.height.width.equalTo(@14);
    }];
    // zima
    [self.zimaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emailImageView.mas_right).offset(3);
        make.centerY.equalTo(self.positionLabel);
        make.height.width.equalTo(@14);
    }];
    
    // 公司
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.top.equalTo(self.positionLabel.mas_bottom).offset(3);
    }];
    
    // 帮助
    [self.helpIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.top.equalTo(self.companyLabel.mas_bottom).offset(28);
        make.width.height.mas_equalTo(9);
    }];
    
    //
    [self.helpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.helpIcon.mas_right).offset(4);
        make.centerY.equalTo(self.helpIcon);
        make.height.mas_equalTo(14);
    }];
    
    // 收藏
    [self.collectionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.top.equalTo(self.helpIcon.mas_bottom).offset(3);
        make.width.height.mas_equalTo(9);
    }];
    
    //
    [self.collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionIcon.mas_right).offset(4);
        make.centerY.equalTo(self.collectionIcon);
        make.height.mas_equalTo(14);
    }];
    
    // 好评率
    [self.goodRateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.top.equalTo(self.collectionIcon.mas_bottom).offset(3);
        make.width.height.mas_equalTo(9);
    }];
    
    //
    [self.goodRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodRateIcon.mas_right).offset(4);
        make.centerY.equalTo(self.goodRateIcon);
        make.height.mas_equalTo(14);
    }];
    
    [self.companyLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-16);
        make.bottom.equalTo(self.goodRateLabel);
        make.width.height.mas_equalTo(37);
    }];
    
    [self.promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.width.height.mas_equalTo(19);
    }];
    
//    if (self.masterCardCellType == MasterCardCellTypeCompanySearch) {
//        // 公司搜索
//        [self.assurePositionView addSubview:self.assurePositionLabel];
//        [self.assurePositionView addSubview:self.priceLacel];
//        [self.contentView addSubview:self.assurePositionView];
//
//        [self.assurePositionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView).offset(-32);
//            make.left.equalTo(self.contentView).offset(32);
//            make.top.equalTo(self.bgView.mas_bottom);
//            make.height.mas_equalTo(32);
//        }];
//
//        [self.assurePositionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.priceLacel.mas_left).offset(-GBMargin/2);
//            make.left.equalTo(self.contentView).offset(8);
//            make.top.equalTo(self.assurePositionView);
//            make.height.mas_equalTo(32);
//        }];
//
//
//        [self.priceLacel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.assurePositionView.mas_left).offset(-8);
//            make.top.equalTo(self.assurePositionView);
//            make.height.mas_equalTo(32);
//        }];
//
//        GBViewRadius(self.assurePositionView, 2);
//    }
}

#pragma mark - # Getters and Setters
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = GBImageNamed(@"img_white");
    }
    
    return _bgView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = PlaceholderHeadImage;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _headImageView;
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
        _vImageView.image = GBImageNamed(@"icon_certification_green");
    }
    return _vImageView;
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] init];
        _cardImageView.image = GBImageNamed(@"icon_card_1");
        _cardImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _cardImageView;
}

- (UIImageView *)emailImageView {
    if (!_emailImageView) {
        _emailImageView = [[UIImageView alloc] init];
        _emailImageView.image = GBImageNamed(@"icon_email_1");
    }
    return _emailImageView;
}

- (UIImageView *)zimaImageView {
    if (!_zimaImageView) {
        _zimaImageView = [[UIImageView alloc] init];
        _zimaImageView.image = GBImageNamed(@"icon_credit_green_1");
    }
    return _zimaImageView;
}

- (UIImageView *)promptImageView {
    if (!_promptImageView) {
        _promptImageView = [[UIImageView alloc] init];
    }
    return _promptImageView;
}

- (UIImageView *)companyLogoImageView {
    if (!_companyLogoImageView) {
        _companyLogoImageView = [[UIImageView alloc] init];
        _companyLogoImageView.image = PlaceholderListImage;
        _companyLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _companyLogoImageView;
}

- (UIImageView *)helpIcon {
    if (!_helpIcon) {
        _helpIcon = [[UIImageView alloc] init];
        _helpIcon.image = GBImageNamed(@"icon_successful");
    }
    return _helpIcon;
}

- (UIImageView *)collectionIcon {
    if (!_collectionIcon) {
        _collectionIcon = [[UIImageView alloc] init];
        _collectionIcon.image = GBImageNamed(@"icon_assured");
    }
    return _collectionIcon;
}

- (UIImageView *)goodRateIcon {
    if (!_goodRateIcon) {
        _goodRateIcon = [[UIImageView alloc] init];
        _goodRateIcon.image = GBImageNamed(@"icon_rate");
    }
    return _goodRateIcon;
}

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.font = Fit_L_Font(10);
        _positionLabel.numberOfLines = 3;
        _positionLabel.textColor = [UIColor kNormoalInfoTextColor];
        _positionLabel.text = @"iOS开发";
    }
    return _positionLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor kImportantTitleTextColor];
        _nameLabel.font = Fit_Font(16);
        _nameLabel.text = @"悟空又调皮";
    }
    
    return _nameLabel;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.textColor = [UIColor kAssistInfoTextColor];
        _companyLabel.text = @"隔壁科技";
        _companyLabel.font = Fit_L_Font(12);
    }
    return _companyLabel;
}

- (UILabel *)helpLabel {
    if (!_helpLabel) {
        _helpLabel = [[UILabel alloc] init];
        _helpLabel.font = Fit_L_Font(10);
        _helpLabel.textColor = [UIColor kPromptRedColor];
        
    }
    return _helpLabel;
}

- (UILabel *)collectionLabel {
    if (!_collectionLabel) {
        _collectionLabel = [[UILabel alloc] init];
        _collectionLabel.font = Fit_L_Font(10);
        _collectionLabel.textColor = [UIColor kPromptRedColor];
        
    }
    return _collectionLabel;
}

- (UILabel *)goodRateLabel {
    if (!_goodRateLabel) {
        _goodRateLabel = [[UILabel alloc] init];
        _goodRateLabel.font = Fit_L_Font(10);
        _goodRateLabel.textColor = [UIColor kPromptRedColor];
        
    }
    return _goodRateLabel;
}

- (UIView *)assurePositionView {
    if (!_assurePositionView) {
        _assurePositionView = [[UIView alloc] init];
        _assurePositionView.backgroundColor = [UIColor colorWithHexString:@"#ECECF8"];
    }
    
    return _assurePositionView;
}

- (UILabel *)assurePositionLabel {
    if (!_assurePositionLabel) {
        _assurePositionLabel = [[UILabel alloc] init];
        _assurePositionLabel.textColor = [UIColor kImportantTitleTextColor];
        _assurePositionLabel.font = Fit_Font(12);
    }
    
    return _assurePositionLabel;
}

- (UILabel *)priceLacel {
    if (!_priceLacel) {
        _priceLacel = [[UILabel alloc] init];
        _priceLacel.textColor = [UIColor kPromptRedColor];
        _priceLacel.font = Fit_M_Font(12);
    }
    
    return _priceLacel;
}


@end
