//
//  ExpectedIndustryRightCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/829.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "ExpectedIndustryRightCell.h"

@implementation ExpectedIndustryRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsSelect:(NSInteger)isSelect {
    _isSelect = isSelect;
    
    self.nameL.textColor = isSelect == 1 ? [UIColor kBaseColor]  : UIColorFromRGB(0x59696D);
    self.selectImgV.hidden = isSelect == 1 ? NO : YES;
}


@end
