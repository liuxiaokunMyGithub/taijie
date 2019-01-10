//
//  GBTiebaNoPicTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/7.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBTiebaNoPicTableViewCell.h"

@interface GBTiebaNoPicTableViewCell ()

/* 帖子 */
@property (nonatomic, strong) UILabel *articleTitleLabel;

/* 时间 */
@property (nonatomic, strong) UILabel *timeLabel;

/* 评论数 */
@property (nonatomic, strong) UIButton *commentButton;

/* 点赞数 */
@property (nonatomic, strong) UIButton *likebButton;

@end

@implementation GBTiebaNoPicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self.contentView addSubview:self.articleTitleLabel];
		[self.contentView addSubview:self.timeLabel];
		[self.contentView addSubview:self.commentButton];
		[self.contentView addSubview:self.likebButton];
		[self p_addMasonry];
	}
	return self;
}

#pragma mark - # Event Response
- (void)commentButtonTouchUpInside:(UIButton *)sender {
	
}

- (void)likebButtonTouchUpInside:(UIButton *)sender {
	
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
	// 帖子
	[self.articleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(24);
		make.right.mas_equalTo(-24);
		make.top.mas_equalTo(16);
	}];
	// 时间
	[self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(24);
		make.top.mas_equalTo(self.articleTitleLabel).mas_offset(16);
		make.bottom.mas_equalTo(-16);
	}];
	// 评论数
	[self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.timeLabel.mas_left).mas_offset(-5);
		make.top.mas_equalTo(self.timeLabel);
	}];
	// 点赞数
	[self.likebButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(-24);
		make.top.mas_equalTo(self.timeLabel);
	}];
}

#pragma mark - # Getters and Setters
- (UILabel *)articleTitleLabel {
	if (!_articleTitleLabel) {
		_articleTitleLabel = [[UILabel alloc] init];
	}
	return _articleTitleLabel;
}

- (UILabel *)timeLabel {
	if (!_timeLabel) {
		_timeLabel = [[UILabel alloc] init];
	}
	return _timeLabel;
}

- (UIButton *)commentButton {
	if (!_commentButton) {
		_commentButton = [[UIButton alloc] init];
		[_commentButton addTarget:self action:@selector(commentButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _commentButton;
}

- (UIButton *)likebButton {
	if (!_likebButton) {
		_likebButton = [[UIButton alloc] init];
		[_likebButton addTarget:self action:@selector(likebButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _likebButton;
}

@end
