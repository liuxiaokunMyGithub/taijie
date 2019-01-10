//
//  GBGridView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/4.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBGridView.h"
/**   上图下字类型按钮   */
#import "GBUpDownButton.h"

@interface GBGridView()

/* 九宫格标题数组 */
@property (nonatomic, strong) NSArray <NSString *> *titles;
/* 九宫格图标数组 */
@property (nonatomic, strong) NSArray <NSString *> *iconImages;

@end

@implementation GBGridView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                   iconImages:(NSArray *)iconImages
{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        self.iconImages = iconImages;
        
        [self loadGridViewButton];
    }
    
    return self;
}

/**   九宫格按钮   */
- (void)loadGridViewButton {
    if (self.titles.count && self.iconImages.count) {
        CGFloat buttonWidth = self.width / 3;
        CGFloat buttonHeight = self.height;
        for (int i = 0; i < self.titles.count; i++) {
            CGFloat buttonX = buttonWidth * i;
            GBUpDownButton *gridButton = [[GBUpDownButton alloc] initWithFrame:CGRectMake(buttonX,0,buttonWidth,buttonHeight)];
            gridButton.titleLabel.font = Fit_Font(12);
            gridButton.tag = i;
            [gridButton setTitle:self.titles[i] forState:UIControlStateNormal];
            [gridButton setTitleColor:[UIColor kImportantTitleTextColor] forState:UIControlStateNormal];
            [gridButton setImage:[UIImage imageNamed:self.iconImages[i]] forState:UIControlStateNormal];
            [gridButton addTarget:self action:@selector(gridButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:gridButton];
        }
    }
}

// 按钮事件
- (void)gridButtonClick:(UIButton *)button {
    !_didClickBlock ? : _didClickBlock(button.tag);
}

@end
