//
//  GBTiebaOnePicTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/7.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBTiebaOnePicTableViewCell.h"
#import "GBLIRLButton.h"
#import "YBImageBrowseCellData.h"
#import "YBImageBrowser.h"

@interface GBTiebaOnePicTableViewCell ()

/* 帖子 */
@property (nonatomic, strong) UILabel *articleTitleLabel;

/* 图片 */
@property (nonatomic, strong) UIImageView *contentImageView;

/* 时间 */
@property (nonatomic, strong) UILabel *timeLabel;

/* 评论数 */
@property (nonatomic, strong) GBLIRLButton *commentButton;

/* 点赞数 */
@property (nonatomic, strong) GBLIRLButton *likeButton;

@end

@implementation GBTiebaOnePicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.articleTitleLabel];
        [self.contentView addSubview:self.contentImageView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.commentButton];
        [self.contentView addSubview:self.likeButton];
        [self.contentView addSubview:self.line];
        [self p_addMasonry];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(A_showWithTouchIndexPath)];
        [self.contentImageView addGestureRecognizer:tap];
        self.contentImageView.userInteractionEnabled = YES;
        
        GBViewRadius(self.contentImageView, 2);
    }
    
    return self;
}

- (void)setTiebaModel:(GBTiebaModel *)tiebaModel {
    _tiebaModel = tiebaModel;
    self.articleTitleLabel.text = tiebaModel.content;
    
    if (tiebaModel.picture.length > 0) {
        [self.contentImageView sd_setImageWithURL:GBImageURL(tiebaModel.picture) placeholderImage:PlaceholderBannerImage];
    }else {
        self.contentImageView.image = nil;
    }
    
    self.timeLabel.text = [NSString compareCurrentTime:tiebaModel.createTime ];
    [self.commentButton setTitle:GBNSStringFormat(@"%zu",tiebaModel.commentsCount) forState:UIControlStateNormal];
    [self.likeButton setTitle:GBNSStringFormat(@"%zu",tiebaModel.likesCount) forState:UIControlStateNormal];
    [self.likeButton setImage: (tiebaModel.like ? GBImageNamed(@"tieba_like_sel")  :  GBImageNamed(@"tieba_like")) forState:UIControlStateNormal];
}

#pragma mark - # Event Response
- (void)commentButtonTouchUpInside:(UIButton *)sender {
	
}

- (void)likebButtonTouchUpInside:(UIButton *)sender {
    GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
    if (self.tiebaModel.like) {
        [tiebaVM loadRequestCanceLikeTieba:self.tiebaModel.gossipId];
        [tiebaVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"取消点赞" timeintevel:1.5];
            [sender setImage:GBImageNamed(@"tieba_like") forState:UIControlStateNormal];
            self.tiebaModel.like = NO;
            self.tiebaModel.likesCount -= 1;
            [self.likeButton setTitle:GBNSStringFormat(@"%zu",self.tiebaModel.likesCount) forState:UIControlStateNormal];
        }];
    }else {
        [tiebaVM loadRequestLikeTieba:self.tiebaModel.gossipId];
        [tiebaVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"已赞" timeintevel:1.5];
            [sender setImage:  GBImageNamed(@"tieba_like_sel") forState:UIControlStateNormal];
            self.tiebaModel.like = YES;
            self.tiebaModel.likesCount += 1;
            [self.likeButton setTitle:GBNSStringFormat(@"%zu",self.tiebaModel.likesCount) forState:UIControlStateNormal];
        }];
    }
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 帖子
    [self.articleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.top.equalTo(self.contentView).offset(16);
        make.height.greaterThanOrEqualTo(@15);
    }];
    
    // 图片
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.width.mas_equalTo(120);
        make.height.greaterThanOrEqualTo(@0);
        make.height.lessThanOrEqualTo(@120);
        make.top.equalTo(self.articleTitleLabel.mas_bottom).offset(10);
    }];
    
    // 时间
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.contentImageView.mas_bottom).offset(GBMargin);
        make.height.greaterThanOrEqualTo(@15);
    }];
    
    // 点赞数
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.bottom.equalTo(self.timeLabel.mas_bottom);
    }];
    
    // 评论数
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeButton.mas_left).offset(-GBMargin/2);
        make.bottom.equalTo(self.timeLabel.mas_bottom);
        make.width.greaterThanOrEqualTo(@60);
    }];
    
    // 分割线
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0);
    }];
}

- (void)A_showWithTouchIndexPath {
    //配置数据源（图片浏览器每一张图片对应一个 YBImageBrowserModel 实例）
    NSMutableArray *tempArr = [NSMutableArray array];
        YBImageBrowseCellData *model = [YBImageBrowseCellData new];
    model.url = GBImageURL(self.tiebaModel.picture);
        model.sourceObject = self.contentImageView;
        [tempArr addObject:model];
    
    //创建图片浏览器（注意：更多功能请看 YBImageBrowser.h 文件或者 github readme）
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = tempArr;
//    browser.copywriter.isScaleImageText = @"";
    //展示
    [browser show];
}

#pragma mark - # Getters and Setters
- (UILabel *)articleTitleLabel {
	if (!_articleTitleLabel) {
		_articleTitleLabel = [[UILabel alloc] init];
        _articleTitleLabel.numberOfLines = 0;
        _articleTitleLabel.textColor = [UIColor kImportantTitleTextColor];
        _articleTitleLabel.font = Fit_Font(17);
	}
	return _articleTitleLabel;
}

- (UIImageView *)contentImageView {
	if (!_contentImageView) {
		_contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
	}
	return _contentImageView;
}

- (UILabel *)timeLabel {
	if (!_timeLabel) {
		_timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor kAssistInfoTextColor];
        _timeLabel.font = Fit_Font(12);
	}
	return _timeLabel;
}

- (GBLIRLButton *)commentButton {
	if (!_commentButton) {
		_commentButton = [[GBLIRLButton alloc] init];
		[_commentButton addTarget:self action:@selector(commentButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_commentButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        [_commentButton setImage:GBImageNamed(@"tieba_comment_count") forState:UIControlStateNormal];
        _commentButton.titleLabel.font = Fit_Font(14);
	}
    
	return _commentButton;
}

- (GBLIRLButton *)likeButton {
	if (!_likeButton) {
		_likeButton = [[GBLIRLButton alloc] init];
		[_likeButton addTarget:self action:@selector(likebButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_likeButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        _likeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _likeButton.titleLabel.font = Fit_Font(14);

	}
	return _likeButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _line;
}

@end
