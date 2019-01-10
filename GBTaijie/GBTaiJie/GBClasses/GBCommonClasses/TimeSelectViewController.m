//
//  TimeSelectViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/825.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "TimeSelectViewController.h"

@interface TimeSelectViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *oneArray;
@property (nonatomic, strong) NSMutableArray *twoArray;

@end

@implementation TimeSelectViewController {
    NSString *_minTime;
    NSString *_maxTime;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置默认选中状态
    _minTime = [self.oneArray objectAtIndex:0];
    _maxTime = [self.twoArray objectAtIndex:0];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    UILabel *selectL = (UILabel *)[self.pickerView viewForRow:0 forComponent:0];
    
    //    selectL.textColor = UIColorFromRGB(0x00BCCC);
    selectL.textColor = [UIColor kImportantTitleTextColor];
    
    selectL.font = Fit_Font(17);
    
    UILabel *selectL1 = (UILabel *)[self.pickerView viewForRow:0 forComponent:2];
    //    selectL1.textColor = UIColorFromRGB(0x00BCCC);
    selectL1.textColor = [UIColor kImportantTitleTextColor];
    
    selectL1.font = Fit_Font(17);
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"在职时间";
    [UIView animateWithDuration:1 animations:^{
        [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    }];
    [self initSubViews];
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
    [cancelBtn setTitleColor:[UIColor kImportantTitleTextColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Fit_Font(14);
    //    [cancelBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:cancelBtn];
    
    UIButton *OKBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44 - GBMargin, 0, 44, 44)];
    [OKBtn setTitle:@"保存" forState:UIControlStateNormal];
    [OKBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    OKBtn.titleLabel.font = Fit_Font(14);
    //    [OKBtn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(OKBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:OKBtn];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleL.text = @"在职时间";
    titleL.font = Fit_Font(16);
    titleL.textColor = [UIColor kImportantTitleTextColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    [backV addSubview:titleL];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 184)];
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
    if (_minTime && _maxTime) {
        self.timeSelectBlock(_minTime, _maxTime);
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0]];
            [self dismissViewControllerAnimated:NO completion:nil];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView showHubWithTip:@"请选择开始时间和结束时间"];
    }
    
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.oneArray.count;
    } else if (component == 1) {
        return 1;
    } else {
        return self.twoArray.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 44)];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.textColor = UIColorFromRGB(0x9DB1BA);
//    pickerLabel.textColor = [UIColor kBaseColor];
    pickerLabel.font = Fit_Font(14);
    
    if (component == 0) {
        pickerLabel.text = [self.oneArray objectAtIndex:row];
    } else if (component == 1) {
        pickerLabel.text = @"至";
    } else if (component == 2){
        pickerLabel.text = [self.twoArray objectAtIndex:row];
    }
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UILabel *selectL = (UILabel *)[pickerView viewForRow:row forComponent:component];
//    selectL.textColor = UIColorFromRGB(0x00BCCC);
    selectL.textColor = [UIColor kImportantTitleTextColor];
    selectL.font = Fit_Font(16);
    if (component == 0) {
        _minTime = [self.oneArray objectAtIndex:row];
    } else if (component == 1) {
        selectL.textColor = UIColorFromRGB(0x9DB1BA);
        selectL.font = Fit_Font(14);
    } else if (component == 2) {
        _maxTime = [self.twoArray objectAtIndex:row];
    }
}

- (NSMutableArray *)oneArray {
    if (!_oneArray) {
        _oneArray = [NSMutableArray arrayWithArray: @[@"2018",@"2017",@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",@"2006",@"2005",@"2004",@"2003",@"2002",@"2001",@"2000"]];
    }
    return _oneArray;
}

- (NSMutableArray *)twoArray {
    if (!_twoArray) {
        _twoArray = [NSMutableArray arrayWithArray: @[@"至今"]];

    }
    return _twoArray;
}

@end
