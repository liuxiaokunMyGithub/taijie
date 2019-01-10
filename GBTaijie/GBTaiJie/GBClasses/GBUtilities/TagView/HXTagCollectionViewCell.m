//
//  HXTagCollectionViewCell.m
//  黄轩 https://github.com/huangxuan518
//
//  Created by 黄轩 on 16/1/13.
//  Copyright © 2015年 IT小子. All rights reserved.
//

#import "HXTagCollectionViewCell.h"

@implementation HXTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _tagButton = [[UIButton alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_tagButton];
        _tagButton.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tagButton.frame = self.bounds;
    
    if (self.tagButton.imageView.hidden) {
        [self.tagButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.tagButton);
        }];
    }else {
        [self.tagButton.titleLabel sizeToFit];
        
        self.tagButton.titleLabel.centerX = self.width * 0.5 + 5;
        self.tagButton.imageView.x = self.tagButton.titleLabel.x - self.tagButton.imageView.width;
        
        self.tagButton.titleLabel.centerY = self.height/2;
        self.tagButton.imageView.centerY = self.height/2;
    }
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.tagButton setTitle:@"" forState:UIControlStateNormal];
}

@end
