//
//  XKSlideTabBar.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/20.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "XKSlideTabBar.h"

@interface XKSlideTabBar ()

@property (nonatomic, weak) HHTitleBtn *currentBtn;
@property (nonatomic, weak) UIView *underlineView;
@property (nonatomic, weak) UIScrollView *titleView;

@property (nonatomic, weak) UIScrollView *contentScroll;

@property (nonatomic, weak) UIView *placeHolderOne;

/* <#describe#> */
@property (nonatomic, strong) UIView *lineView;
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *underLineWidths;

@end

@implementation XKSlideTabBar
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleArray = titleArray;
    
        // 标题栏设置
        UIScrollView *titleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        self.titleView = titleView;
        [self setupSubView];

        [self.placeHolderOne addSubview:titleView];
        titleView.showsHorizontalScrollIndicator = NO;
        
        [self.placeHolderOne addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.placeHolderOne);
            make.height.equalTo(@0.5);
            make.left.equalTo(self.placeHolderOne);
            make.right.equalTo(self.placeHolderOne);
        }];
    }
    
    return self;
}

- (void)setupSubView {
    NSInteger btnCount = 5;

    UIView *placeHolderOne = [UIView new];
    self.placeHolderOne = placeHolderOne;
    
    [self addSubview:placeHolderOne];
    
    [placeHolderOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@40);
    }];
    
    self.titleView.contentSize = CGSizeMake(self.titleArray.count * ([UIScreen mainScreen].bounds.size.width)/btnCount, 40);
    // 标题个数
    NSInteger count  = self.titleArray.count;
    // 计算按钮的宽高
    CGFloat titleBtnW = ([UIScreen mainScreen].bounds.size.width)/btnCount;
    CGFloat titleBtnH = 40;
    // x y
    CGFloat titleBtnX = 0;
    CGFloat titleBtnY = 0;
    for (UIView *view in self.titleView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < count; ++i) {
        titleBtnX = titleBtnW * i;
        titleBtnY = 0;
        HHTitleBtn *btn = [[HHTitleBtn alloc] initWithFrame:CGRectMake(titleBtnX, titleBtnY, titleBtnW, titleBtnH)];
        btn.tag = i;
        [self.titleView addSubview:btn];
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        // 加到titlesView
        [self.titleView addSubview:btn];
        // 监听按钮点击
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat width =  [DCSpeedy dc_calculateTextSizeWithText:self.titleArray[i] WithTextFont:Fit_Font(18) WithMaxW:(SCREEN_WIDTH)/7].height;
        
        [self.underLineWidths addObject:[NSNumber numberWithFloat:width]];

    }
//    for (int i = 0; i < self.titleView.subviews.count; ++i) {
//    }
//    
    HHTitleBtn *btn = self.titleView.subviews.firstObject;
    // 设置按钮为选中状态
    [self titleBtnClick:btn];
    // 拿到按钮选中背景色
    UIColor *btnTextColor = [btn titleColorForState:UIControlStateSelected];
    // 下划线高度
    CGFloat titlesUnderlineViewHeight = 2.5;
    // 设置underView的背景色
    self.underlineView.backgroundColor = btnTextColor;
    CGFloat y = 40 - titlesUnderlineViewHeight;
    // 拿到btnLabel的宽度
    //    CGFloat width = [btn.currentTitle sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}].width;
    // 设置view的frame
    
    self.underlineView.frame = CGRectMake(0, y, [self.underLineWidths[0] floatValue], titlesUnderlineViewHeight);
    self.underlineView.centerX = btn.centerX;
}

- (void)titleBtnClick:(HHTitleBtn *)btn
{
    // 前一个按钮取消选中
    _currentBtn.selected = NO;
    // 选中当前按钮
    btn.selected = YES;
    // 当前按钮赋值给上个按钮
    _currentBtn = btn;
    
    NSUInteger index = [self.titleView.subviews indexOfObject:btn];
    CGFloat maxOffsetXT = self.titleView.contentSize.width - SCREEN_WIDTH;
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.placeHolderFour animated:YES];
    
    //    hud.dimBackground = YES;
    [UIView animateWithDuration:.25 animations:^{
        // 改变标题栏偏移
        self.titleView.contentOffset = CGPointMake(index*maxOffsetXT/9, 0);
        
        // 给按钮添加下划线
        [self addUnderlineViewForTitleBtn:btn];
    } completion:^(BOOL finished) {
        // 内容视图偏移
        self.contentScroll.contentOffset = CGPointMake(index*SCREEN_WIDTH, 0);
        !self.didSelectedItemBlock ? : self.didSelectedItemBlock(btn.tag);
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [MBProgressHUD hideHUDForView:self.placeHolderFour animated:YES];
        //        });
//        __weak typeof(self) weakSelf = self;
//        SPCBrandBottomControl *control = self.childViewControllers[index];
        // 控制器视图添加
//        UIView *view = control.view;
//        if (view.superview) {
//            [control reloadData];
//        }else{
//            [self.contentScroll addSubview:view];
//            [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.equalTo(weakSelf.contentScroll);
//                make.top.equalTo(weakSelf.contentScroll);
//                make.left.equalTo(weakSelf.contentScroll).offset(index*kScreenW);
//            }];
//        }
        
        
        
        
        
    }];
    
}

- (UIView *)underlineView
{
    if (_underlineView == nil) {
        UIView *underLine = [[UIView alloc] init];
        self.underlineView = underLine;
        // 添加到标题View
        [self.titleView addSubview:_underlineView];
    }
    return _underlineView;
}

- (void)addUnderlineViewForTitleBtn:(HHTitleBtn *)btn
{
    // 拿到按钮选中背景色
    UIColor *btnTextColor = [btn titleColorForState:UIControlStateSelected];
    // 设置underView的背景色
    self.underlineView.backgroundColor = btnTextColor;
//    CGFloat width =  [DCSpeedy dc_calculateTextSizeWithText:btn.titleLabel.text WithTextFont:Fit_Font(18) WithMaxW:(SCREEN_WIDTH)/7].height;
    // 设置view的frame
    _underlineView.width = [self.underLineWidths[btn.tag] floatValue];
    
    
    [UIView animateWithDuration:0.05 animations:^{
        self.underlineView.centerX = btn.centerX;
    } completion:^(BOOL finished) {
    
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //     最大的偏移量
    CGFloat maxOffsetXT = self.titleView.contentSize.width - SCREEN_WIDTH;
    CGPoint offset = CGPointMake(maxOffsetXT*scrollView.contentOffset.x/(9*SCREEN_WIDTH), 0);
    self.titleView.contentOffset = offset;
    if (scrollView.contentOffset.x >= 0) {
        // 相对偏移
        self.underlineView.x = (scrollView.contentOffset.x *((SCREEN_WIDTH)/7-maxOffsetXT/9)/SCREEN_WIDTH);
    }else{
        self.underlineView.x = 0;
    }
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    HHTitleBtn *btn = self.titleView.subviews[index];
    [self titleBtnClick:btn];
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSArray alloc] init];
    }
    
    return _titleArray;
}

- (NSMutableArray *)underLineWidths {
    if (!_underLineWidths) {
        _underLineWidths = [[NSMutableArray alloc] init];
    }
    
    return _underLineWidths;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _lineView;
}

@end

@implementation HHTitleBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 初始属性
        [self setTitleColor:[UIColor kImportantTitleTextColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor kBaseColor] forState:UIControlStateSelected];
        [self.titleLabel setFont:Fit_Font(15)];
    }
    return self;
}

// 无高亮
- (void)setHighlighted:(BOOL)highlighted
{
}

@end
