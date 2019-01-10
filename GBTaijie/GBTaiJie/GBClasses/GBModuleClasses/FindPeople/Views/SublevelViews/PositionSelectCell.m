//
//  PositionSelectCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/820.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "PositionSelectCell.h"

@implementation PositionSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCenterNameLHidden:(BOOL)centerNameLHidden {
    if (centerNameLHidden) {
        self.centerNameL.hidden = YES;
        self.nameL.hidden = NO;
        self.bottomLine.hidden = NO;
    } else {
        self.centerNameL.hidden = NO;
        self.nameL.hidden = YES;
        self.bottomLine.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.nameL.textColor = selected ? [UIColor kBaseColor] : RGBA(56, 63, 66, 1);
    self.centerNameL.textColor = selected ? [UIColor kBaseColor] : RGBA(56, 63, 66, 1);
}

@end
