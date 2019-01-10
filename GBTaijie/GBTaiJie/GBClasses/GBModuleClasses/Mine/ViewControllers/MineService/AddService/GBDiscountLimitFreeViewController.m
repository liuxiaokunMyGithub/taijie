//
//  GBDiscountLimitFreeViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBDiscountLimitFreeViewController.h"

// Controllers


// ViewModels


// Models


// Views


@interface GBDiscountLimitFreeViewController ()
/* <#describe#> */
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleLabel1;
@property (nonatomic, strong) UILabel *titleLabel2;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UITextField *textField;

/* <#describe#> */
@property (nonatomic, strong) UISwitch *openSwitch;

/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;//tagsView

@end

@implementation GBDiscountLimitFreeViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self setupBigTitleHeadViewWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 80) title:@"折扣与限免"]];
    [self.customNavBar wr_setRightButtonWithTitle:@"完成" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    self.customNavBar.onClickRightButton = ^{
        @GBStrongObj(self);
        if ([self.discountType isEqualToString:@"DISCOUNT"]) {
            if (!self.textField.text.length) {
                return [UIView showHubWithTip:@"请输入折扣价格"];
            }
        }
        
        !self.saveBlock ? : self.saveBlock(self.discountType,self.textField.text);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self setupSubView];
    
    if (ValidStr(self.discountType)) {
        self.textField.hidden = NO;
        self.tagsView.userInteractionEnabled = YES;
        
        if ([self.discountType isEqualToString:@"DISCOUNT"]) {
            self.textField.hidden = NO;
            self.moneyLabel.hidden = NO;
            self.tagsView.selectedTags = [NSMutableArray arrayWithArray:@[@"折扣"]];
            self.textField.text = self.originalPrice;
        }else {
            self.textField.hidden = YES;
            self.moneyLabel.hidden = YES;
            self.tagsView.selectedTags = [NSMutableArray arrayWithArray:@[@"免费"]];
        }
        
        self.openSwitch.on = YES;
    }else {
        self.textField.hidden = YES;
        self.moneyLabel.hidden = YES;
        self.tagsView.userInteractionEnabled = NO;
    }
}


#pragma mark - # Setup Methods
- (void)setupSubView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"刚刚开启服务的用户，我们建议您启用折扣或者限免，这样有助于快速成交，提升自己的好评度与保过率，随之提升的是更高的曝光度。";
    titleLabel.font = Fit_Font(14);
    titleLabel.textColor = [UIColor kImportantTitleTextColor];
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.text = @"是否开启折扣与限免";
    titleLabel1.font = Fit_M_Font(16);
    titleLabel1.textColor = [UIColor kImportantTitleTextColor];
    [self.view addSubview:titleLabel1];
    self.titleLabel1 = titleLabel1;

    UILabel *titleLabel2 = [[UILabel alloc] init];
    titleLabel2.numberOfLines = 0;
    titleLabel2.text = @"开启后，您的服务将显示折扣或者免费的价格，关闭后显示正常的定价。在免费或者折扣开启状态下发布服务，折扣或者限免将维持一周，一周后自动调回原价。服务发布后不可能改。";
    titleLabel2.font = Fit_Font(14);
    titleLabel2.textColor = [UIColor kImportantTitleTextColor];
    [self.view addSubview:titleLabel2];
    self.titleLabel2 = titleLabel2;

    [self.view addSubview:self.openSwitch];
    
    NSArray *titles = @[@"免费",@"折扣"];
    //多行不滚动多选
    HXTagCollectionViewFlowLayout *flowLayout = [[HXTagCollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-GBMargin*2)/3,30);
//    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, GBMargin, 10.0f, 10.0f);
    self.tagsView.layout = flowLayout;
    
    self.tagsView.isMultiSelect = NO;
    self.tagsView.tagAttribute.borderWidth = 0.5;
    self.tagsView.tagAttribute.cornerRadius = 15;
    self.tagsView.tagAttribute.tagSpace = GBMargin+GBMargin/2;
    self.tagsView.tagAttribute.titleSize = 14;
    self.tagsView.tagAttribute.normalBackgroundColor = [UIColor whiteColor];
    self.tagsView.tagAttribute.selectedBackgroundColor = [UIColor colorWithHexString:@"#F7F5FD"];
    self.tagsView.tagAttribute.textColor = [UIColor kAssistInfoTextColor];
    self.tagsView.tagAttribute.selectedTextColor = [UIColor kBaseColor];
    self.tagsView.tagAttribute.borderColor = [UIColor kSegmentateLineColor];
    self.tagsView.tagAttribute.selectBorderColor = [UIColor kBaseColor];
    self.tagsView.minSelectCount = 1;
    
    self.tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.tagsView.tags = titles;
    // 默认联系方式微信
    [self.view addSubview:self.tagsView];
    
    @GBWeakObj(self);
    self.tagsView.completion = ^(NSArray *selectTags, NSInteger currentIndex) {
        @GBStrongObj(self);
        NSLog(@"selectTags %@ currentIndex %zu",selectTags,currentIndex);
        self.discountType = currentIndex == 0 ? @"FREE" : @"DISCOUNT";
        if (currentIndex == 1) {
            self.textField.hidden = NO;
            self.moneyLabel.hidden = NO;
        }else {
            self.textField.hidden = YES;
            self.moneyLabel.hidden = YES;
        }
    };
    
    [self.tagsView reloadData];

    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(188, 374, 126, 16);
    textField.placeholder = @"请输入折扣后的价格";
    textField.font = Fit_Font(14);
    textField.textColor = [UIColor kAssistInfoTextColor];
    [self.view addSubview:textField];
    self.textField = textField;
    self.textField.hidden = YES;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;

    self.moneyLabel.text = GBNSStringFormat(@"原价：%@币",self.originalPrice);
    [self.view addSubview:self.moneyLabel];
    
    [self addMasonry];
    
}

#pragma mark - # Event Response
- (void)addMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(GBMargin));
        make.height.equalTo(@60);
        make.right.equalTo(self.view).offset(-GBMargin);
        make.top.equalTo(@(SafeAreaTopHeight + 80));
    }];
    
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(GBMargin));
        make.height.equalTo(@20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GBMargin);
    }];
    
    [self.openSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel1);
        make.right.equalTo(self.view).offset(-GBMargin);
    }];
    
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(GBMargin));
        make.height.equalTo(@80);
        make.right.equalTo(self.view).offset(-GBMargin);
        make.top.equalTo(self.titleLabel1.mas_bottom).offset(GBMargin/2);
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(GBMargin));
        make.height.equalTo(@40);
        make.width.equalTo(@150);
        make.top.equalTo(self.titleLabel2.mas_bottom).offset(GBMargin);
    }];
    
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(GBMargin);
        make.height.equalTo(@30);
        make.right.equalTo(self.moneyLabel.mas_left).offset(-GBMargin);
        make.top.equalTo(self.tagsView.mas_bottom).offset(GBMargin);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-GBMargin);
        make.centerY.equalTo(self.textField);
    }];
    
    [DCSpeedy dc_setUpAcrossPartingLineWith:self.textField WithColor:[UIColor kSegmentateLineColor] margin:0];
}

#pragma mark - # Privater Methods
- (void)switchAction:(UISwitch *)sender {
    NSLog(@"%@", sender.isOn ? @"ON" : @"OFF");
    if (sender.isOn) {
        self.textField.hidden = NO;
        self.tagsView.userInteractionEnabled = YES;
        
        if ([self.discountType isEqualToString:@"DISCOUNT"]) {
            self.textField.hidden = NO;
            self.moneyLabel.hidden = NO;
        }else {
            self.textField.hidden = YES;
            self.moneyLabel.hidden = YES;
        }
        
    }else {
        self.textField.hidden = YES;
        self.moneyLabel.hidden = YES;
        self.tagsView.userInteractionEnabled = NO;
    }
}


#pragma mark - # Delegate


#pragma mark - # Getters and Setters
- (UISwitch *)openSwitch {
    if (!_openSwitch) {
        _openSwitch = [[UISwitch alloc]init];
        [_openSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _openSwitch.onTintColor = [UIColor kBaseColor];
        // 设置关闭状态的颜色
        // 修改大小
        _openSwitch.transform = CGAffineTransformMakeScale( .75, .75);

        // 设置开关上左右滑动的小圆点的颜色
        //    _setSwitch.thumbTintColor = [UIColor whiteColor];
    }
    
    return _openSwitch;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] init];
        _tagsView.userInteractionEnabled = NO;
    }
    return _tagsView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = Fit_Font(14);
        _moneyLabel.textColor = [UIColor kPromptRedColor];
        _moneyLabel.hidden = YES;
    }
    
    return _moneyLabel;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
