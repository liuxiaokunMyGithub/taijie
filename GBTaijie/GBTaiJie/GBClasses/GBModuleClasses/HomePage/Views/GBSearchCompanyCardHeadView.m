//
//  GBSearchCompanyCardHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBSearchCompanyCardHeadView.h"
#import "GBLLRIButton.h"
#import "GBMoreCompanyViewController.h"
#import "GBCompanyInfoViewController.h"
#import "GBPositionCertificationViewController.h"
#import "AuthenticationStateModel.h"

@interface GBSearchCompanyCardHeadView ()
/* <#describe#> */
@property (nonatomic, strong) UILabel *titleLabel;
/* <#describe#> */
@property (nonatomic, strong) UILabel *titleLabel1;
/* <#describe#> */
@property (nonatomic, strong) UILabel *titleLabel2;
/* 公司logo */
@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) GBLLRIButton *moreButton;

@property (nonatomic, strong) UIButton *arrowButton;
/* <#describe#> */
@property (nonatomic, strong) CompanyModel *companyModel;

@property (strong, nonatomic) AuthenticationStateModel *authenticationModel;

@end

@implementation GBSearchCompanyCardHeadView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.titleLabel1];
        [self.bgView addSubview:self.titleLabel2];
        [self.bgView addSubview:self.logoImageView];
        [self.bgView addSubview:self.arrowButton];

        [self addSubview:self.moreButton];

        GBViewBorderRadius(self.bgView, 2, 0.5, [UIColor kSegmentateLineColor]);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowButtonAction)];
        
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)reloadHeadView:(CompanyModel *)companyModel {
    self.companyModel = companyModel;
    [self.logoImageView sd_setImageWithURL:GBImageURL(companyModel.companyLogo) placeholderImage:PlaceholderListImage];
    self.titleLabel.text = companyModel.companyFullName;
    self.titleLabel1.text = GBNSStringFormat(@"%@ | %@ | %@",companyModel.industryName,companyModel.financingScaleName,companyModel.personelScaleName);
    self.titleLabel2.text = GBNSStringFormat(@"%@ | %@ ",companyModel.regionName,companyModel.companyAddress);
}

- (void)moreButtonAction {
    GBMoreCompanyViewController *moreCompanyVC = [[GBMoreCompanyViewController alloc] init];
    moreCompanyVC.companyName = self.companyModel.companyName;
    [[GBAppHelper getPushNavigationContr] pushViewController:moreCompanyVC animated:YES];
}

- (void)arrowButtonAction {
    GBCompanyInfoViewController *companyHM = [[GBCompanyInfoViewController alloc] init];
//    companyHM.companyIntroduction = self.companyModel.introduction;
    companyHM.companyModel = self.companyModel;
    [[GBAppHelper getPushNavigationContr] pushViewController:companyHM animated:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(GBMargin);
        make.top.equalTo(@(16));
        make.height.equalTo(@120);
        make.right.equalTo(self).offset(-GBMargin);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(16);
        make.centerY.equalTo(self.bgView);
        make.height.width.equalTo(@80);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.logoImageView);
        make.right.equalTo(self.arrowButton).offset(-GBMargin/2);
    }];
    
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        make.right.equalTo(self.titleLabel);
    }];
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.titleLabel1.mas_bottom).offset(3);
        make.right.equalTo(self.titleLabel);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-GBMargin);
        make.top.equalTo(self.bgView.mas_bottom);
        make.height.equalTo(@44);
        make.width.equalTo(@120);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.centerY.equalTo(self.bgView);
        make.height.width.equalTo(@12);
    }];
    
}

- (UIButton *)arrowButton {
    if (!_arrowButton) {
        _arrowButton = [[GBLLRIButton alloc] init];
        [_arrowButton setImage:GBImageNamed(@"icon_right_more_light") forState:UIControlStateNormal];
        [_arrowButton addTarget:self action:@selector(arrowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _arrowButton;
}


- (GBLLRIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[GBLLRIButton alloc] init];
        _moreButton.textMargin = 3;
        [_moreButton setTitle:@"不是想要的，试试这些" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        _moreButton.titleLabel.font = Fit_Font(10);
        [_moreButton setImage:GBImageNamed(@"ic_more_right") forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _moreButton;
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor kFunctionBackgroundColor];
    }
    
    return _bgView;
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
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = Fit_Font(16);
    }
    
    return _titleLabel;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel1.font = Fit_L_Font(12);
    }
    
    return _titleLabel1;
}

- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel2.font = Fit_L_Font(12);
    }
    
    return _titleLabel2;
}

- (CompanyModel *)companyModel {
    if (!_companyModel) {
        _companyModel = [[CompanyModel alloc] init];
    }
    
    return _companyModel;
}

@end
