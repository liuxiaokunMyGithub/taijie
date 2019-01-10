//
//  CurrentStatusPopView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/821.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "CurrentStatusPopView.h"

@interface CurrentStatusPopView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) NSArray *status;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation CurrentStatusPopView

- (instancetype)initWithStatusArray:(NSArray *)status andSelectedStatus:(NSString *)selectedStatus {
    if (self = [super init]) {
        self.status = status;
        self.selectedStatus = selectedStatus;
        self.selectIndex = 0;
    }
    return self;
}


- (void)show {
    // 1.获取最上面的窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.window = window;
    
    // 2.添加蒙版
    UIView *backGroundView = [[UIView alloc] initWithFrame:window.bounds];
    backGroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.backGroundView = backGroundView;
    [window addSubview:backGroundView];
    UITapGestureRecognizer *tgr= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [backGroundView addGestureRecognizer:tgr];
    
    // 3.添加自己到蒙版上
    [backGroundView addSubview:self];
    
    // 4.设置尺寸
    self.frame = window.bounds;
    
    // 5.初始化子控件
    [self setupControls];
    
    // 6.设置默认选中
    if (self.selectedStatus) {
        for (NSInteger i = 0; i < self.status.count; i++) {
            if (self.selectedStatus == [self.status objectAtIndex:i]) {
                self.selectIndex = i;
                [self.pickerView selectRow:i inComponent:0 animated:NO];
                UILabel *selectL = (UILabel *)[self.pickerView viewForRow:i forComponent:0];
                selectL.textColor = [UIColor kImportantTitleTextColor];
                selectL.font = Fit_Font(15);
                break;
            }
        }
    }
    
    backGroundView.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        backGroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.alpha = 1;
    }];
}


- (void)setupControls {
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 237, SCREEN_WIDTH, 237)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleLabel.text = self.titleStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Fit_Font(16) ;
    titleLabel.textColor = [UIColor kImportantTitleTextColor];
    [self.backView addSubview:titleLabel];
    // 取消按钮
    UIButton *cancelB = [[UIButton alloc] initWithFrame:CGRectMake(GBMargin, 0, 44, 44)];
//    [cancelB setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [cancelB setTitle:@"取消" forState:UIControlStateNormal];
    [cancelB setTitleColor:[UIColor kImportantTitleTextColor] forState:UIControlStateNormal];
    cancelB.titleLabel.font = Fit_Font(14);

    [cancelB addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:cancelB];
    
    // 确定按钮
    UIButton *okB = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44- GBMargin, 0, 44, 44)];
//    [okB setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
    [okB setTitle:@"保存" forState:UIControlStateNormal];
    okB.titleLabel.font = Fit_Font(14);
    [okB setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    [okB addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:okB];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 196)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.pickerView = pickerView;
    [self.backView addSubview:pickerView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 0.5)];
    [lineView setBackgroundColor:UIColorFromRGB(0XF4F5FA)];
    [self.backView addSubview:lineView];
    
    GBViewRadius(self.backView, 5);
}

- (void)cancelBtnClick {
    [self dismiss];
}

- (void)okBtnClick {
    self.selectBlock(self.selectedStatus);
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.backGroundView.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
        [self.backView removeFromSuperview];
        [self.backGroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.status.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 38.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.textColor = UIColorFromRGB(0x96ABB5);
    pickerLabel.font = Fit_Font(14);
    pickerLabel.text = [self.status objectAtIndex:row];
    
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UILabel *selectL = (UILabel *)[pickerView viewForRow:row forComponent:component];
    selectL.textColor = [UIColor kImportantTitleTextColor];
    selectL.font = Fit_Font(16);
    
    self.selectedStatus = [self.status objectAtIndex:row];
    self.selectIndex = row;
}

@end
