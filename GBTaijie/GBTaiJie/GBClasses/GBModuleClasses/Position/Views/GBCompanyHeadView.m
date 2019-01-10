//
//  GBCompanyHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/15.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBCompanyHeadView.h"
#import "GBPositionCertificationViewController.h"
#import "AuthenticationStateModel.h"
#import "GBLIRLButton.h"

@interface GBCompanyHeadView ()
/* 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;

/* 职位 */
@property (nonatomic, strong) UILabel *positionLabel;

/* 公司 */
@property (nonatomic, strong) UILabel *companyLabel;

/* <#describe#> */
@property (nonatomic, strong) UIButton *addressButton;

@property (nonatomic, strong) UIButton *vButton;

/* <#describe#> */
@property (nonatomic, strong) AuthenticationStateModel *authenticationModel;

@end

@implementation GBCompanyHeadView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.positionLabel];
        [self addSubview:self.companyLabel];
        [self addSubview:self.vButton];
        [self addSubview:self.addressButton];
    }
    
    return self;
}

- (void)setCompanyModel:(CompanyModel *)companyModel {
    _companyModel = companyModel;
    self.titleLabel.text = companyModel.companyFullName;
    self.nameLabel.text = GBNSStringFormat(@"%@ | %@ | %@",companyModel.industryName,companyModel.financingScaleName,companyModel.personelScaleName);
    self.positionLabel.text = GBNSStringFormat(@"已有%@名认证员工 | %@",companyModel.companyIncumbentsCount,companyModel.regionName);
    [self.addressButton setTitle:companyModel.companyAddress forState:UIControlStateNormal];
}

#pragma mark - # Private Methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(GBMargin/2);
        make.left.equalTo(self).offset(GBMargin);
        make.right.equalTo(self).offset(-GBMargin);
    }];
    
    // 姓名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(GBMargin);
        make.right.equalTo(self).offset(-GBMargin);        make.top.equalTo(self.titleLabel.mas_bottom).offset(GBMargin/2);
        make.right.equalTo(self).offset(-GBMargin/2);
    }];
    
    // 职位
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(GBMargin);
        make.right.equalTo(self).offset(-GBMargin);        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(GBMargin);
        make.right.equalTo(self).offset(-GBMargin);
  make.top.equalTo(self.positionLabel.mas_bottom).offset(GBMargin/2);
        make.height.equalTo(@(16));
    }];
    
    [self.vButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(GBMargin);
        make.top.equalTo(self.addressButton.mas_bottom).offset(GBMargin/2);
        make.height.equalTo(@26);
        make.width.equalTo(@66);
    }];
    
    // 公司
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(GBMargin);
        make.right.equalTo(self).offset(-GBMargin);   make.top.equalTo(self.vButton.mas_bottom).offset(GBMargin/2);
    }];
}

- (void)vButtonAction {
    // 获取认证状态
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineIncumbentAuthenticationState];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.authenticationModel = [AuthenticationStateModel mj_objectWithKeyValues:returnValue];
        
        [self dealUserAuthenticationState];
    }];
}

/** MARK: 处理认证状态 */
- (void)dealUserAuthenticationState {
    if (self.authenticationModel.status) {
        /** 认证 */
        GBPositionCertificationViewController *positionCertificationVC =  [[GBPositionCertificationViewController alloc] init];
        positionCertificationVC.authenModel.companyName = self.companyModel.companyName;
        positionCertificationVC.authenModel.companyId = self.companyModel.id;
        [[GBAppHelper getPushNavigationContr] pushViewController:positionCertificationVC animated:YES];
    }else {
        
        if ([self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_SUCCESS"]) {
            return [UIView showHubWithTip:@"您已认证，一个月之内不可再次认证"];
        }
        
        /** 认证 */
        GBPositionCertificationViewController *positionCertificationVC =  [[GBPositionCertificationViewController alloc] init];
        positionCertificationVC.authenModel.companyName = self.companyModel.companyName;
        positionCertificationVC.authenModel.companyId = self.companyModel.id;
        [[GBAppHelper getPushNavigationContr] pushViewController:positionCertificationVC animated:YES];
    }
}

#pragma mark - # Getters and Setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = Fit_B_Font(28);
        [self addSubview:_titleLabel];    }
    
    return _titleLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor kAssistInfoTextColor];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = Fit_M_Font(14);
    }
    return _nameLabel;
}

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.font = Fit_Font(14);
        _positionLabel.textColor = [UIColor kAssistInfoTextColor];
    }
    return _positionLabel;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.font = Fit_M_Font(18);
        _companyLabel.textColor = [UIColor kImportantTitleTextColor];
        _companyLabel.text = @"公司简介";
    }
    return _companyLabel;
}

- (UIButton *)vButton {
    if (!_vButton) {
        _vButton = [[UIButton alloc] init];
        [_vButton setTitle:@"申请认证" forState:UIControlStateNormal];
        [_vButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _vButton.titleLabel.font = Fit_Font(10);
        [_vButton setBackgroundImage:GBImageNamed(@"button_bg_short") forState:UIControlStateNormal];
        [_vButton addTarget:self action:@selector(vButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _vButton;
}

- (UIButton *)addressButton {
    if (!_addressButton) {
        _addressButton = [[UIButton alloc] init];
        [_addressButton setImage:GBImageNamed(@"icon_locationg") forState:UIControlStateNormal];
        _addressButton.titleLabel.font = Fit_Font(14);
        [_addressButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
    }
    
    return _addressButton;
}

@end

