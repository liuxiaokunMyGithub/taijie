//
//  GBMoreButtonFooterView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/29.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMoreButtonFooterView.h"

@implementation GBMoreButtonFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setUpUI {
    _moreButton = [[GBLLRIButton alloc] init];
    [_moreButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    [_moreButton setImage:GBImageNamed(@"icon_moreDown") forState:UIControlStateNormal];
    _moreButton.titleLabel.font = Fit_Font(14);
    [_moreButton addTarget:self
                    action:@selector(moreButtonAction)
          forControlEvents:UIControlEventTouchUpInside];
    [_moreButton setTitle:@"选填" forState:UIControlStateNormal];
    [self addSubview:_moreButton];
}

- (void)moreButtonAction {
    !_moreButtonActionBlock ? : _moreButtonActionBlock();
    !_buttonActionBlock ? : _buttonActionBlock(self.moreButton);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

@end
