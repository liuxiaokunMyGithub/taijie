//
//  GBPersonalSectionHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBPersonalSectionHeadView.h"

// Controllers

// Models

// Views
// Categories

// Others

@interface GBPersonalSectionHeadView ()

@end

@implementation GBPersonalSectionHeadView

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
    [self.contentView addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.textColor = [UIColor kAssistInfoTextColor];
    _subTitleLabel.font = Fit_L_Font(12);
    //    _subTitleLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_subTitleLabel];
    
    _moreButton = [[GBLIRLButton alloc] init];
    [_moreButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    [_moreButton setImage:GBImageNamed(@"icon_right_more_light") forState:UIControlStateNormal];
    _moreButton.titleLabel.font = Fit_Font(14);
    [_moreButton addTarget:self
                    action:@selector(moreButtonAction)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_moreButton];
    
    _starView = [[HCSStarRatingView alloc] init];
    self.starView.emptyStarColor = UIColorFromRGB(0xBFBFBF);
    self.starView.emptyStarImage = [UIImage imageNamed:@"icon_star_empty"];
    self.starView.filledStarImage = [UIImage imageNamed:@"icon_star_sel"];
    self.starView.maximumValue = 5;
    self.starView.minimumValue = 0;
    self.starView.userInteractionEnabled = NO;
    self.starView.hidden = YES;
    [self.contentView addSubview:_starView];
}


#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
        
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.contentView).offset(GBMargin);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(3);
        make.centerY.equalTo(self.titleLabel).offset(3);
        make.width.equalTo(@180);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreButton.mas_left).offset(-5);
        make.width.equalTo(@80);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@16);
    }];
}

- (void)moreButtonAction {
    !_moreButtonClickBlock ? : _moreButtonClickBlock(self.section);
}

#pragma mark - Setter Getter Methods


@end
