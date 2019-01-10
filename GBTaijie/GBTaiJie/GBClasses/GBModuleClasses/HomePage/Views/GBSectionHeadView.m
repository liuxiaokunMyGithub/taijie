//
//  GBSectionHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBSectionHeadView.h"

@implementation GBSectionHeadView

#pragma mark - Intial
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor kImportantTitleTextColor];
    _titleLabel.font = Fit_M_Font(17);
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.textColor = [UIColor kAssistInfoTextColor];
    _subTitleLabel.font = Fit_L_Font(10);
    [self addSubview:_subTitleLabel];
    
    _moreButton = [[GBLIRLButton alloc] init];
    [_moreButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    [_moreButton setImage:GBImageNamed(@"icon_right_more_light") forState:UIControlStateNormal];
    _moreButton.titleLabel.font = Fit_Font(14);
    [_moreButton addTarget:self
                    action:@selector(moreButtonAction)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_moreButton];

}

- (void)moreButtonAction {
    !_moreButtonClickBlock ? : _moreButtonClickBlock(self.section);
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(GBMargin);
        make.top.equalTo(self).offset(GBMargin);
        make.bottom.equalTo(self.mas_bottom).offset(-16);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(GBMargin);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        make.height.equalTo(@14);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-GBMargin);
        if (self.subTitleLabel.hidden == YES) {
            make.bottom.equalTo(self.titleLabel);
        }else {
            make.centerY.equalTo(self.subTitleLabel);
        }
    }];
}

#pragma mark - Setter Getter Methods


@end
