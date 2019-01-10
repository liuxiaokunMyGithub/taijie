//
//  GBAddSkillTagView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/23.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBAddSkillTagView.h"

@interface GBAddSkillTagView ()
@property (nonatomic, strong) NSString *titleStr;
@end

@implementation GBAddSkillTagView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        
        self.titleStr = title;
        
        self.backgroundColor = [UIColor colorWithHexString:@"#EDF8EC"];
        
        GBViewBorderRadius(self, frame.size.height/2, 0.5, [UIColor colorWithHexString:@"#28B261"]);
        
        [self initSubViewsWithFrame:frame];
    }
    return self;
}

- (void)initSubViewsWithFrame:(CGRect)frame {
    CGFloat labelW = [DCSpeedy dc_calculateTextSizeWithText:self.titleStr WithTextFont:Fit_Font(14) WithMaxW:SCREEN_WIDTH].width;
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, labelW, frame.size.height)];
    contentL.text = self.titleStr;
    contentL.font = Fit_Font(14);
    contentL.textAlignment = NSTextAlignmentCenter;
    contentL.textColor = [UIColor colorWithHexString:@"#28B261"];
    [self addSubview:contentL];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentL.frame), 0, 28, contentL.height)];
    [deleteBtn setImage:[UIImage imageNamed:@"icon_close_green"] forState:UIControlStateNormal];
    self.deleteBtn = deleteBtn;
    [self addSubview:deleteBtn];
}

@end
