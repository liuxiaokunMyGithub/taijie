//
//  ExpectIndustryDeleteView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/818.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "ExpectIndustryDeleteView.h"

@interface ExpectIndustryDeleteView()

@property (nonatomic, strong) NSString *titleStr;

@end

@implementation ExpectIndustryDeleteView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        
        self.titleStr = title;
        
        self.backgroundColor = [[UIColor kBaseColor] colorWithAlphaComponent:.05];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        [self initSubViewsWithFrame:frame];
    }
    return self;
}

- (void)initSubViewsWithFrame:(CGRect)frame {
    CGFloat labelW = [DCSpeedy dc_calculateTextSizeWithText:self.titleStr WithTextFont:Fit_Font(12) WithMaxW:SCREEN_WIDTH].width;
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, labelW, frame.size.height)];
    contentL.text = self.titleStr;
    contentL.font = Fit_Font(12);
    contentL.textColor = [UIColor kBaseColor];
    [self addSubview:contentL];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentL.frame), 0, 28, contentL.height)];
    [deleteBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    self.deleteBtn = deleteBtn;
    [self addSubview:deleteBtn];
}

@end
