//
//  SalarySelectViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "SalarySelectViewController.h"
#import "UIPickerView+XKPicker.h"

@interface SalarySelectViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *oneArray;
@property (nonatomic, strong) NSMutableArray *twoArray;

/* 最低 */
@property (nonatomic, copy) NSString *minSalary;
/** 最高 */
@property (nonatomic, copy) NSString *maxSalary;

@end

@implementation SalarySelectViewController {
    NSInteger _leftIndex;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i = 0; i < 200; i++) {
        NSString *salaryLeft = [NSString stringWithFormat:@"%zd", i + 1];
        [self.oneArray addObject:salaryLeft];
    }
    _leftIndex = 3;
    for (NSInteger j = _leftIndex + 1; j <= (_leftIndex + 1) * 3; j++) {
        NSString *salaryRight = [NSString stringWithFormat:@"%zd", j];
        [self.twoArray addObject:salaryRight];
    }
    
    self.navigationItem.title = @"薪资选择";
    
    [UIView animateWithDuration:1 animations:^{
        [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    }];
    [self initSubViews];
    
    @GBWeakObj(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    @GBStrongObj(self);
        [self.pickerView selectRow:4 inComponent:0 animated:NO];
        [self.pickerView selectRow:1 inComponent:1 animated:NO];
        
        UILabel *selectL = (UILabel *)[self.pickerView viewForRow:3 forComponent:0];
        selectL.textColor = [UIColor kImportantTitleTextColor];
        selectL.font = Fit_Font(16);
        
        UILabel *selectR = (UILabel *)[self.pickerView viewForRow:0 forComponent:1];
        selectR.textColor = [UIColor kImportantTitleTextColor];
        selectR.font = Fit_Font(16);
        
        self.minSalary = [self.oneArray objectAtIndex:4];
        self.maxSalary = [self.twoArray objectAtIndex:1];
    });
}

- (void)topClick {
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0]];
        [self dismissViewControllerAnimated:NO completion:nil];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)initSubViews {
    
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backV];
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@224);
    }];
    
    UIButton *top = [[UIButton alloc] init];
    [top addTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
    [top setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:top];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(backV.mas_top);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(GBMargin, 0, 44, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Fit_Font(14);
//    [cancelBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor kImportantTitleTextColor] forState:UIControlStateNormal];

    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:cancelBtn];
    
    UIButton *OKBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44-GBMargin, 0, 44, 44)];
    [OKBtn setTitle:@"保存" forState:UIControlStateNormal];
    [OKBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    OKBtn.titleLabel.font = Fit_Font(14);
//    [OKBtn setImage:[UIImage imageNamed:@"ic_Jobcompletion"] forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(OKBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:OKBtn];
    
    NSString *title = @"薪资要求 月薪单位：千元";
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleL.font = Fit_Font(16);
    titleL.textColor = [UIColor kImportantTitleTextColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    [backV addSubview:titleL];
   titleL.attributedText = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kAssistInfoTextColor] changeFont:Fit_Font(10) totalString:title changeString:@"月薪单位：千元"];
    
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 184)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.pickerView = pickerView;
    [backV addSubview:pickerView];
    
    GBViewRadius(backV, 5);

}

- (void)cancelBtnClick {
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0]];
        [self dismissViewControllerAnimated:NO completion:nil];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)OKBtnClick {
    self.selectBlock(_minSalary, _maxSalary);
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0]];
        [self dismissViewControllerAnimated:NO completion:nil];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.oneArray.count;
    } else {
        return self.twoArray.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.textColor = UIColorFromRGB(0x96ABB5);
    pickerLabel.font = Fit_Font(14);
    
    if (component == 0) {
        pickerLabel.text = [self.oneArray objectAtIndex:row];
    } else {
        pickerLabel.text = [self.twoArray objectAtIndex:row];
    }
    
    [pickerView clearSpearatorLine];

    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 120;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UILabel *selectL = (UILabel *)[pickerView viewForRow:row forComponent:component];
    selectL.textColor = [UIColor kImportantTitleTextColor];
    selectL.font = Fit_Font(16);
    if (component == 0) {
        _minSalary = [self.oneArray objectAtIndex:row];
        
        _leftIndex = row;
        [self reloadRightComponent];
    }else {
        _maxSalary = [self.twoArray objectAtIndex:row];
    }
}

- (void)reloadRightComponent {
    [self.twoArray removeAllObjects];
    for (NSInteger j = _leftIndex + 1; j <= (_leftIndex + 1) * 3; j++) {
        NSString *salaryRight = [NSString stringWithFormat:@"%zd", j];
        [self.twoArray addObject:salaryRight];
    }
    _maxSalary = [self.twoArray objectAtIndex:0];
    
    
    [self.pickerView reloadComponent:1];
    UILabel *selectR = (UILabel *)[self.pickerView viewForRow:0 forComponent:1];
    selectR.textColor = [UIColor kImportantTitleTextColor];
    selectR.font = Fit_Font(16);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.pickerView selectRow:4 inComponent:0 animated:NO];
    [self.pickerView selectRow:1 inComponent:1 animated:NO];
    
    UILabel *selectL = (UILabel *)[self.pickerView viewForRow:4 forComponent:0];
    selectL.textColor = [UIColor kImportantTitleTextColor];
    selectL.font = Fit_Font(16);
    
    UILabel *selectR = (UILabel *)[self.pickerView viewForRow:1 forComponent:1];
    selectR.textColor = [UIColor kImportantTitleTextColor];
    selectR.font = Fit_Font(16);
    
    _minSalary = [self.oneArray objectAtIndex:4];
    _maxSalary = [self.twoArray objectAtIndex:1];
}
    
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (NSMutableArray *)oneArray {
    if (!_oneArray) {
        _oneArray = [[NSMutableArray alloc] init];
    }
    return _oneArray;
}

- (NSMutableArray *)twoArray {
    if (!_twoArray) {
        _twoArray = [[NSMutableArray alloc] init];
    }
    return _twoArray;
}

@end
