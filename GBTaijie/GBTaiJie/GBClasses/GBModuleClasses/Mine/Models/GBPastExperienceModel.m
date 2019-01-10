//
//  GBPastExperienceModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/7.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPastExperienceModel.h"

@interface GBPastExperienceModel ()

@property (assign, nonatomic)CGFloat tempHeight;

@end

@implementation GBPastExperienceModel
- (CGFloat)height {
    
    if (_tempHeight == 0) {
        
        NSDictionary * dict=[NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
        
        CGRect rect=[self.companyName boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*GBMargin, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        
        _tempHeight = rect.size.height + 50;;
    }
    
    return _tempHeight;
}

@end
