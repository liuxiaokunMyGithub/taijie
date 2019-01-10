//
//  GBPostArticleImageCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/9.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPostArticleImageCell.h"

@interface GBPostArticleImageCell ()


@end

@implementation GBPostArticleImageCell

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self.contentView addSubview:self.profilePhoto];
		[self.contentView addSubview:self.closeButton];
		[self p_addMasonry];
	}
	return self;
}

#pragma mark - # Event Response


#pragma mark - # Private Methods
- (void)p_addMasonry {
	// 图片
	[self.profilePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(0);
		make.right.mas_equalTo(0);
		make.top.mas_equalTo(0);
		make.bottom.mas_equalTo(0);
	}];
	// 移除按钮
	[self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(self.profilePhoto);
		make.top.mas_equalTo(self.profilePhoto);
		make.size.mas_equalTo(CGSizeMake(20,20));
	}];
}

#pragma mark - # Getters and Setters
- (UIImageView *)profilePhoto {
	if (!_profilePhoto) {
		_profilePhoto = [[UIImageView alloc] init];
	}
	return _profilePhoto;
}

- (UIButton *)closeButton {
	if (!_closeButton) {
		_closeButton = [[UIButton alloc] init];
        [_closeButton setImage:GBImageNamed(@"tieba_post_deleteImage") forState:UIControlStateNormal];
	}
	return _closeButton;
}

@end
