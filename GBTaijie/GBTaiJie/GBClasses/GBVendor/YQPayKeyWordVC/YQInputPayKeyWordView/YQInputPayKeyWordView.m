//
//  YQInputPayKeyWordView.m
//  Youqun
//
//  Created by 王崇磊 on 16/6/1.
//  Copyright © 2016年 W_C__L. All rights reserved.
//

#import "YQInputPayKeyWordView.h"

@interface YQInputPayKeyWordView ()

@property (copy, nonatomic) void(^selectBlock)(void);

@end

@implementation YQInputPayKeyWordView


+ (instancetype)initFromNibSelectBlock:(void(^)(void))block {
    YQInputPayKeyWordView *input = [[[UINib nibWithNibName:@"YQInputPayKeyWordView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    input.selectBlock = block;
    return input;
}

- (IBAction)forgotPasswordAction:(UIButton *)sender {
   if (self.selectBlock) {
        self.selectBlock();
   }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
