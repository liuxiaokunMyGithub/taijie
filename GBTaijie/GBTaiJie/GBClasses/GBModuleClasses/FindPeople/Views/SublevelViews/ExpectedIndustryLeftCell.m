//
//  ExpectedIndustryLeftCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/829.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "ExpectedIndustryLeftCell.h"

@implementation ExpectedIndustryLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.nameL.textColor = selected ? [UIColor kBaseColor] : [UIColor kNormoalInfoTextColor];
    
    self.backgroundColor = selected ? [[UIColor kBaseColor] colorWithAlphaComponent:.05] : UIColorFromRGB(0xF2F5FA);
}

@end
