//
//  GBPersonalHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPersonalHeadView.h"

@interface GBPersonalHeadView ()

/* 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;

/* 职位 */
@property (nonatomic, strong) UILabel *positionLabel;

/* 公司 */
@property (nonatomic, strong) UILabel *companyLabel;

/* 头像 */
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation GBPersonalHeadView

- (id)initWithFrame:(CGRect)frame
               name:(NSString *)name
           position:(NSString *)position
            company:(NSString *)company
          headImage:(NSString *)headImage
{
	if (self = [super initWithFrame:frame]) {
		[self addSubview:self.nameLabel];
		[self addSubview:self.positionLabel];
		[self addSubview:self.companyLabel];
		[self addSubview:self.headImageView];
        
        self.nameLabel.text = name;
        self.positionLabel.text = position;
        self.companyLabel.text = company;
        [self.headImageView sd_setImageWithURL:GBImageURL(headImage) placeholderImage:PlaceholderHeadImage];
	}
    
	return self;
}

#pragma mark - # Private Methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.isShowBigTitle) {
        [self addSubview:self.titleLabel];
        // 标题
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(16);
            make.left.equalTo(self).offset(GBMargin);
            make.height.mas_equalTo(30);
        }];
        
        self.nameLabel.font = Fit_Font(17);
    }
    
    // 姓名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        if (self.isShowBigTitle) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(GBMargin);
        }else {
            make.top.mas_equalTo(28);
        }
        
        make.right.mas_equalTo(self.headImageView.mas_left).offset(-GBMargin/2);
    }];
    
	// 职位
	[self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(24);
        make.right.mas_equalTo(self.headImageView.mas_left).offset(-GBMargin/2);
		make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(5);
		make.height.mas_equalTo(16);
	}];
	// 公司
	[self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(24);
        make.right.mas_equalTo(self.headImageView.mas_left).offset(-GBMargin/2);
	make.top.mas_equalTo(self.positionLabel.mas_bottom).mas_offset(5);
		make.height.mas_equalTo(16);
	}];
	// 头像
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(-24);
		make.top.mas_equalTo(self.nameLabel);
		make.size.mas_equalTo(CGSizeMake(72,72));
	}];
    
    // 设置圆角
    GBViewRadius(self.headImageView, 36);
    
}

#pragma mark - # Getters and Setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel.font = Fit_B_Font(28);
        [self addSubview:_titleLabel];    }
    
    return _titleLabel;
}

- (UILabel *)nameLabel {
	if (!_nameLabel) {
		_nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor kImportantTitleTextColor];
        _nameLabel.numberOfLines = 2;
		_nameLabel.font = Fit_M_Font(28);
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

- (UILabel *)companyLabel {
	if (!_companyLabel) {
		_companyLabel = [[UILabel alloc] init];
        _companyLabel.font = Fit_Font(12);
        _companyLabel.textColor = [UIColor kAssistInfoTextColor];
	}
	return _companyLabel;
}

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
        _headImageView.image = PlaceholderHeadImage;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
	}
    
	return _headImageView;
}

@end
