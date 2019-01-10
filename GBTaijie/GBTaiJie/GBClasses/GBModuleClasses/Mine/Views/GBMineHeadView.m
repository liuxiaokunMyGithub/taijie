//
//  GBMineHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMineHeadView.h"
/**   上图下字类型按钮   */
#import "GBUpDownButton.h"
/**   左文右图按钮   */
#import "GBLLRIButton.h"

@interface GBMineHeadView()
/* 头像 */
@property (nonatomic, strong) UIImageView *iconView;
/* 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;
/* 编辑 */
@property (nonatomic, strong) GBLLRIButton *homePageButton;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton *editButton;

@end

/**
    自定义个人中心，头部视图
 */
@implementation GBMineHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self setupSubViews];
    }
    
    return self;
}

- (void)setUserModel:(UserModel *)userModel {
    self.nameLabel.text = userModel.nickName;
    [self.iconView sd_setImageWithURL:GBImageURL(userModel.headImg) placeholderImage:PlaceholderHeadImage];
}

- (void)setupSubViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
//    [self addSubview:self.editButton];
    [self addSubview:self.homePageButton];

    [self addSubview:self.vFlagImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(GBMargin);
        make.bottom.mas_equalTo(self).offset(-GBMargin);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
    }];
    
    GBViewRadius(self.iconView, 40);
    
    [self.vFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.iconView).offset(-5);
        make.bottom.mas_equalTo(self.iconView).offset(-5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(GBMargin/2);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.iconView).offset(5);
    }];
    
    [self.homePageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(GBMargin/2);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(GBMargin/2);
    }];
}

#pragma mark - Target Methods

- (void)homePageButtonAction {
    !_homePageButton ? : _homePageButtonBlock();
}

#pragma mark - Getter Setter Methods

- (UIImageView *)vFlagImageView {
    if (!_vFlagImageView) {
        _vFlagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_certification_photo"]];
        _vFlagImageView.hidden = YES;
    }
    
    return _vFlagImageView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:PlaceholderHeadImage];
        
    }
    
    return _iconView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:GBImageNamed(@"mine_img_bg")];
    }
    
    return _bgImageView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = Fit_B_Font(28);
    }
    
    return _nameLabel;
}

- (GBLLRIButton *)homePageButton {
    if (!_homePageButton) {
        _homePageButton = [GBLLRIButton buttonWithType:UIButtonTypeCustom];
        [_homePageButton setTitleColor:[UIColor colorWithHexString:@"#B4A8F6"] forState:UIControlStateNormal];
        [_homePageButton setImage:GBImageNamed(@"icon_right_more_light") forState:UIControlStateNormal];
        [_homePageButton setTitle:@"查看个人主页" forState:UIControlStateNormal];;
        _homePageButton.titleLabel.font = Fit_Font(14);
        [_homePageButton addTarget:self action:@selector(homePageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _homePageButton;
}

@end
