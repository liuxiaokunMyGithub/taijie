//
//  GBMoreCommentListCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/25.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMoreCommentListCell.h"

@interface GBMoreCommentListCell ()

/* 背景视图 */
@property (nonatomic, strong) UIView *bgView;

/* 逗号标识图 */
@property (nonatomic, strong) UIImageView *flagImageView;

/* 头像 */
@property (nonatomic, strong) UIImageView *headImageView;

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;

/* 时间 */
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation GBMoreCommentListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUpUI];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)setUpUI {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.headImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.timeLabel];
    
    [self p_addMasonry];
}

- (void)setCommentModel:(GBPersonalCommentModel *)commentModel {
    _commentModel = commentModel;
    [self.headImageView sd_setImageWithURL:GBImageURL(commentModel.publisherHeadImg) placeholderImage:PlaceholderHeadImage];
    self.titleLabel.text = commentModel.content;
    self.nameLabel.text = commentModel.publisher;
    self.timeLabel.text = commentModel.publishTime;
}

#pragma mark - # Event Response
- (void)payLookButtonTouchUpInside:(UIButton *)sender {
    
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 背景视图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    // 头像
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.height.width.mas_equalTo(36);
        make.top.mas_equalTo(8);
    }];
    
    GBViewRadius(self.headImageView, 16);
    
    // 姓名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.top.equalTo(self.headImageView);
    }];
    
    // 时间
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.bottom.equalTo(self.headImageView);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.right.equalTo(self.bgView).offset(-GBMargin);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
        make.bottom.equalTo(self.bgView).offset(-8);
    }];
}

#pragma mark - # Getters and Setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_L_Font(14);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor kImportantTitleTextColor];
        _nameLabel.font = Fit_Font(14);
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor kAssistInfoTextColor];
        _timeLabel.font = Fit_Font(12);
    }
    return _timeLabel;
}

@end
