//
//  GBColleaguesItemCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBColleaguesItemCell.h"
// Models
#import "GBPositionCommonModel.h"

@interface GBColleaguesItemCell ()

/* 属性 */
@property (strong , nonatomic)UILabel *natureLabel;

@end

@implementation GBColleaguesItemCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI {
    _backImageView = [[UIImageView alloc] init];
    [self addSubview:_backImageView];
    GBViewBorderRadius(_backImageView, 2, 0.5, [UIColor kSegmentateLineColor]);
    
    _goodsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_goodsImageView];
    _goodsImageView.image = GBImageNamed(@"ic_defaultHeadIcon");

    GBViewBorderRadius(_goodsImageView, 54/2, 2, [UIColor whiteColor]);
    
    _nickLabel = [[UILabel alloc] init];
    _nickLabel.font = Fit_Font(16);
    _nickLabel.textColor = [UIColor kImportantTitleTextColor];
    _nickLabel.textAlignment = NSTextAlignmentCenter;
    _nickLabel.numberOfLines = 1;
    [self.contentView addSubview:_nickLabel];
    
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.font = Fit_L_Font(12);
    _positionLabel.textColor = [UIColor kImportantTitleTextColor];
    _positionLabel.textAlignment = NSTextAlignmentCenter;
    _positionLabel.numberOfLines = 2;
    [self.contentView addSubview:_positionLabel];
    
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = Fit_Font(10);
    _scoreLabel.textColor = [UIColor kAssistInfoTextColor];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.numberOfLines = 0;
    [self.contentView addSubview:_scoreLabel];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self)setOffset:0];
        make.width.mas_equalTo(self).multipliedBy(1);
        make.height.mas_equalTo(166);
    }];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self)setOffset:GBMargin/2];
        make.height.width.mas_equalTo(54);
    }];
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self.goodsImageView.mas_bottom)setOffset:GBMargin/2];
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
    }];
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(GBMargin/2);
        make.right.equalTo(self.contentView).offset(-GBMargin/2);
    }];
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.positionLabel.mas_bottom).offset(4);
        make.left.right.equalTo(self.positionLabel);
    }];
}

#pragma mark - Setter Getter Methods
- (void)setColleaguesModel:(GBFindColleaguesModel *)colleaguesModel {
    _colleaguesModel = colleaguesModel;
    
    if (colleaguesModel.isMore) {
        // 查看更多
        self.goodsImageView.image = GBImageNamed(@"logo_Icon");
        self.nickLabel.text = colleaguesModel.nickName;
        self.scoreLabel.text = @"";
        return;
    }
    
    [self.goodsImageView sd_setImageWithURL:GBImageURL(colleaguesModel.headImg) placeholderImage:PlaceholderListImage];
    self.nickLabel.text = colleaguesModel.nickName;
    
    NSArray *tempArray = [colleaguesModel.adeptSkill componentsSeparatedByString:@","];
    NSMutableArray *skills = [NSMutableArray arrayWithArray:tempArray];
    if (tempArray.count > 2) {
        skills = [NSMutableArray arrayWithArray:@[tempArray[0],tempArray[1]]];
    }
    
    self.positionLabel.text = [skills componentsJoinedByString:@" | "];
    self.scoreLabel.text = GBNSStringFormat(@"%ld个好评",(long)colleaguesModel.fullStarEvaluateCount);
}

@end
