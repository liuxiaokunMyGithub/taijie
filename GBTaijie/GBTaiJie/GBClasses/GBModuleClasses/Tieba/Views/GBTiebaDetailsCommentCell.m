//
//  GBTiebaDetailsCommentCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/9.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBTiebaDetailsCommentCell.h"
#import "GBUpDownButton.h"

@interface GBTiebaDetailsCommentCell ()

/* 头像 */
@property (nonatomic, strong) UIImageView *headImageView;

/* 昵称 */
@property (nonatomic, strong) UILabel *nameLabel;

/* 日期 */
@property (nonatomic, strong) UILabel *timeLabel;

/* 点赞 */
@property (nonatomic, strong) UILabel *reportLabel;

/* 评论内容 */
@property (nonatomic, strong) UILabel *contentLabel;

/* 分割线 */
@property (nonatomic, strong) UIView *line;

@end

@implementation GBTiebaDetailsCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self.contentView addSubview:self.headImageView];
		[self.contentView addSubview:self.nameLabel];
		[self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.reportLabel];
		[self.contentView addSubview:self.contentLabel];
		[self.contentView addSubview:self.line];
        
        self.contentLabel.numberOfLines = 0;

		[self p_addMasonry];
	}
	return self;
}

- (void)setTiebaCommentModel:(GBTiebaDetailsCommentModel *)tiebaCommentModel {
    _tiebaCommentModel = tiebaCommentModel;
    [self.headImageView sd_setImageWithURL:GBImageURL(tiebaCommentModel.commentUserImg) placeholderImage:GBImageNamed(@"icon_anonymousHead")];
    self.nameLabel.text = tiebaCommentModel.commentUserNickName;
    self.timeLabel.text = tiebaCommentModel.createTime;
    self.contentLabel.text = tiebaCommentModel.content;
    self.reportLabel.text = tiebaCommentModel.reported ? @"已举报" : @"";
}

#pragma mark - # Event Response
- (void)likeButtonTouchUpInside:(UIButton *)sender {
	
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
	// 头像
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.top.mas_equalTo(self.contentView).offset(16);
		make.size.mas_equalTo(CGSizeMake(32,32));
	}];
    
    GBViewRadius(self.headImageView, 16);
    
	// 昵称
	[self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageView.mas_right).offset(12);
		make.top.mas_equalTo(self.headImageView);
		make.height.mas_equalTo(16);
	}];
	// 日期
	[self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(12);
		make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(3);
		make.height.mas_equalTo(16);
	}];
	
	// 评论内容
	[self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
        make.height.greaterThanOrEqualTo(@15);
		make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
	}];
    
     // 是否已举报
        [self.reportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-24);
            make.top.mas_equalTo(self.nameLabel);
        }];
    
	// 分割线
	[self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
		make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
		make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1);
		make.height.mas_equalTo(0.5);
	}];
}

#pragma mark - # Getters and Setters
- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
	}
	return _headImageView;
}

- (UILabel *)nameLabel {
	if (!_nameLabel) {
		_nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor kAssistInfoTextColor];
        _nameLabel.font = Fit_Font(12);
	}
	return _nameLabel;
}

- (UILabel *)timeLabel {
	if (!_timeLabel) {
		_timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor kAssistInfoTextColor];
        _timeLabel.font = Fit_Font(11);
	}
	return _timeLabel;
}

- (UILabel *)reportLabel {
	if (!_reportLabel) {
		_reportLabel = [[UILabel alloc] init];
        _reportLabel.textColor = [UIColor kAssistInfoTextColor];
        _reportLabel.font = Fit_Font(14);
	}
    
	return _reportLabel;
}

- (UILabel *)contentLabel {
	if (!_contentLabel) {
		_contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor kImportantTitleTextColor];
        _contentLabel.font = Fit_Font(14);
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin * 2 - 32 - 12;
	}
	return _contentLabel;
}

- (UIView *)line {
	if (!_line) {
		_line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor kSegmentateLineColor];
	}
	return _line;
}

@end
