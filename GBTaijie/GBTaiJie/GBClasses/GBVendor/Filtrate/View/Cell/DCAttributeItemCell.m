//
//  DCAttributeItemCell.m
//  LiChi
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import "DCAttributeItemCell.h"

// Controllers

// Models
#import "DCFiltrateItem.h"
#import "DCContentItem.h"
// Views

// Vendors
// Categories

// Others
@interface DCAttributeItemCell ()
/* item按钮 */
@property (strong , nonatomic)UIButton *contentButton;

@end

@implementation DCAttributeItemCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _contentButton.enabled = NO;
    [self addSubview:_contentButton];
    _contentButton.titleLabel.font = Fit_Font(12);
    [_contentButton setTitleColor:[UIColor kNormoalInfoTextColor] forState:0];
    _contentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    if (self.contentItem.isSelect) {
//        [_contentButton setImage:[UIImage imageNamed:@"icon_check"] forState:0];
        [_contentButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        self.backgroundColor = [[UIColor kBaseColor] colorWithAlphaComponent:.05];
        
        [DCSpeedy dc_chageControlCircularWith:self AndSetCornerRadius:3 SetBorderWidth:1 SetBorderColor:[UIColor kBaseColor] canMasksToBounds:YES];
    }else{
        
        [_contentButton setImage:nil forState:0];
        [_contentButton setTitleColor:[UIColor kNormoalInfoTextColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
        
        [DCSpeedy dc_chageControlCircularWith:self AndSetCornerRadius:3 SetBorderWidth:1 SetBorderColor:[UIColor kSegmentateLineColor] canMasksToBounds:YES];
    }

}


#pragma mark - Setter Getter Methods
- (void)setContentItem:(DCContentItem *)contentItem
{
    _contentItem = contentItem;
    [_contentButton setTitle:contentItem.content forState:0];
    
    
}


@end
