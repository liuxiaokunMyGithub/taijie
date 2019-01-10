//
//  GBRankingItemCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBRankingItemCell.h"

@interface GBRankingItemCell ()

@end

@implementation GBRankingItemCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self p_addMasonry];
        
        GBViewRadius(self.bgView, 2);

    }
    return self;
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 背景视图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
}

#pragma mark - # Getters and Setters
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = GBImageNamed(@"card_bg");
        _bgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _bgView;
}

@end
