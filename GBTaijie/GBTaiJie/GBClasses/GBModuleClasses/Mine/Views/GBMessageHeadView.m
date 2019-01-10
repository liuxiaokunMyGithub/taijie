//
//  GBMessageHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/13.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMessageHeadView.h"


@implementation GBMessageHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor whiteColor];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor kImportantTitleTextColor];
    _titleLabel.font = Fit_B_Font(28);
    _titleLabel.text = @"消息";
    [self addSubview:_titleLabel];
    
    _messageGridView = [[GBGridView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), SCREEN_WIDTH, 60) titles:@[@"同事消息",@"收付款消息",@"系统消息"] iconImages:@[@"icon_message_friend",@"icon_message_pay",@"icon_message_system"]];
    [self addSubview:_messageGridView];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor kSegmentateLineColor];
    [self addSubview:_line];
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(GBMargin);
        make.left.equalTo(self).offset(GBMargin);
        make.height.mas_equalTo(30);
    }];
    
    [_messageGridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GBMargin);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end
