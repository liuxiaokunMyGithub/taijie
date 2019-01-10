//
//  GBReportTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/11.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBReportTableViewCell.h"
#import "DCContentItem.h"
#import "GBLIRLButton.h"
@interface GBReportTableViewCell ()
/* item按钮 */
@property (strong , nonatomic)GBLIRLButton *contentButton;

@end

@implementation GBReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        
    }
    
    return self;
}

#pragma mark - UI
- (void)setUpUI {
    _contentButton = [GBLIRLButton buttonWithType:UIButtonTypeCustom];
    _contentButton.enabled = NO;
    [self addSubview:_contentButton];
    _contentButton.titleLabel.font = Fit_Font(14);
    [_contentButton setTitleColor:[UIColor kNormoalInfoTextColor] forState:0];
    _contentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(GBMargin);
        make.right.equalTo(self).offset(-GBMargin);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-8);
    }];
    
    if (self.contentItem.isSelect) {
        [_contentButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        _contentButton.backgroundColor = [[UIColor kBaseColor] colorWithAlphaComponent:.05];
        
        [DCSpeedy dc_chageControlCircularWith:_contentButton AndSetCornerRadius:3 SetBorderWidth:1 SetBorderColor:[UIColor kBaseColor] canMasksToBounds:YES];
    }else{
        
        [_contentButton setImage:nil forState:0];
        [_contentButton setTitleColor:[UIColor kNormoalInfoTextColor] forState:UIControlStateNormal];
        _contentButton.backgroundColor = [UIColor whiteColor];
        
        [DCSpeedy dc_chageControlCircularWith:_contentButton AndSetCornerRadius:3 SetBorderWidth:1 SetBorderColor:[UIColor kSegmentateLineColor] canMasksToBounds:YES];
    }
    
}


#pragma mark - Setter Getter Methods
- (void)setContentItem:(DCContentItem *)contentItem
{
    _contentItem = contentItem;
    [_contentButton setTitle:contentItem.content forState:0];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
