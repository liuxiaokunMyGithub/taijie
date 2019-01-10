//
//  GBUpdateCertificationInfoHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBUpdateCertificationInfoHeadView.h"

@implementation GBUpdateCertificationInfoHeadView

- (id)initWithFrame:(CGRect)frame
               name:(NSString *)name
           position:(NSString *)position
          headImage:(NSString *)headImage
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bigTitleLabel];
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.positionLabel];
        [self addSubview:self.edictButton];
        [self addSubview:self.flagLabel];
        
        [self p_addMasonry];
        
        self.nameLabel.text = name;
        self.positionLabel.text = position;
        [self.headImageView sd_setImageWithURL:GBImageURL(headImage) placeholderImage:PlaceholderHeadImage];
    }
    
    return self;
}

- (void)headerEditButtonClick {
    !_didClickEdictBlock ? : _didClickEdictBlock();
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 大标题
    [self.bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(16);
        make.height.mas_equalTo(30);
    }];
    
    // 头像
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.top.mas_equalTo(self.flagLabel.mas_bottom).offset(32);
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];
    
    // 设置圆角
    GBViewRadius(self.headImageView, 20);
    
    
    // 姓名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(GBMargin/2);
        make.top.mas_equalTo(self.headImageView);
        make.height.mas_equalTo(20);
    }];
    
    // 编辑
    [self.edictButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-GBMargin);
        make.top.mas_equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(44,44));
    }];
    
    // 职位
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(GBMargin/2);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.edictButton.mas_left).offset(5);
    }];
    
    // 提示
    [self.flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.equalTo(self.bigTitleLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(180,16));
    }];
}

#pragma mark - # Getters and Setters
- (UILabel *)bigTitleLabel {
    if (!_bigTitleLabel) {
        _bigTitleLabel = [[UILabel alloc] init];
        _bigTitleLabel.textColor = [UIColor kImportantTitleTextColor];
        _bigTitleLabel.font = Fit_B_Font(28);
        _bigTitleLabel.text = @"选择任一资料认证";
    }
    
    return _bigTitleLabel;
}

- (UIButton *)edictButton {
    if (!_edictButton) {
        _edictButton = [[UIButton alloc] init];
        [_edictButton setImage:GBImageNamed(@"icon_update_edict") forState:UIControlStateNormal];
        [_edictButton addTarget:self action:@selector(headerEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _edictButton;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = PlaceholderHeadImage;
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor kImportantTitleTextColor];
        _nameLabel.font = Fit_Font(14);
    }
    return _nameLabel;
}

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.font = Fit_Font(12);
        _positionLabel.textColor = [UIColor kAssistInfoTextColor];
    }
    return _positionLabel;
}

- (UILabel *)flagLabel {
    if (!_flagLabel) {
        _flagLabel = [[UILabel alloc] init];
        _flagLabel.text = @"认证资料越多可信度越高哦！";
        _flagLabel.font = Fit_Font(12);
        _flagLabel.textColor = [UIColor kBaseColor];
    }
    return _flagLabel;
}

@end
