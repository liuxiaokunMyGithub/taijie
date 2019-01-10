//
//  GBWithdrawalViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/25.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 提现
//  @discussion <#类的功能#>
//

#import "GBWithdrawalViewController.h"
#import "GBLLRIButton.h"
// Controllers
#import "GBModifyViewController.h"
#import "GBWithdrawalSuccessViewController.h"
// ViewModels


// Models


// Views
#import "XKTextField.h"
#import "YQPayKeyWordVC.h"

@interface GBWithdrawalViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 表头视图 */
@property (nonatomic, strong) UIView *tableHeadview;

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 箭头指示按钮 */
@property (strong , nonatomic) GBLLRIButton *indicateButton;

/* 收益 */
@property (nonatomic, strong) UILabel *moneyLabel;

/* 子标题 */
@property (nonatomic, strong) UILabel *subtitleLabel;

/* 支付方式 */
@property (nonatomic, strong) UIImageView *imageView;
/* 支付方式 */
@property (nonatomic, strong) UIImageView *alipayImageView;

/* 支付宝账号 */
@property (nonatomic, strong) UILabel *alipayContLabel;

/* 子标题 */
@property (nonatomic, strong) UILabel *subtitleLabel2;
/* 输入提现金额 */
@property (nonatomic, strong) XKTextField *textField;

/* 全部提现 */
@property (nonatomic, strong) UIButton *allButton;

/** 金额提示 */
@property (nonatomic, strong) UILabel *promptLabel;

/* <#describe#> */
@property (nonatomic, copy) NSString *alipayAccount;

/* <#describe#> */
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *placeHolderL;

/* 支付密码输入框 */
@property (nonatomic, strong) YQPayKeyWordVC *payPsdVC;


@end

@implementation GBWithdrawalViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"提现";
    
    [self headerRereshing];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 15;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"提现"];
    
    self.baseTableView.tableFooterView = [self setupTabeleBottomView];
    
    // 提现
    [self.view addSubview:[self setupBottomViewWithtitle:@"确认提现"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
        @GBStrongObj(self);
        if (self.textField.text.length <= 0) {
            return [UIView showHubWithTip:@"请输入提现金额"];
        }
        
        if ([self.textField.text integerValue] > self.balanceModel.currentTotalEarning) {
            return [UIView showHubWithTip:@"当前可提现收益不足"];
        }else {
            // 最低额度
            BOOL lessMinMoney = [self.textField.text integerValue] < 50;
            if (lessMinMoney) {
                return [UIView showHubWithTip:@"最低提现额度50元"];
            }
            
            // 最高额度
            BOOL moreMaxMoney = [self.textField.text integerValue] > 5000;
            if (moreMaxMoney) {
                return [UIView showHubWithTip:@"单笔提现额度最高为5000元"];
            }
        }
        //        self.payPsdVC = [[YQPayKeyWordVC alloc] init];
        //        [self.payPsdVC showInViewController:self];
        //        self.payPsdVC.keyWordView.priceLabel.text = [NSString stringWithFormat:@"%@台阶币",self.textField.text];
        //        @GBWeakObj(self);
        //        self.payPsdVC.payPassWordBlock = ^(NSString *passWord) {
        //            @GBStrongObj(self);
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestMineWithdrawDeposit:[self.textField.text integerValue] alipayAccount:self.alipayAccount];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            GBWithdrawalSuccessViewController *withdrawalSuccessVC = [[GBWithdrawalSuccessViewController alloc] init];
            [self.navigationController pushViewController:withdrawalSuccessVC animated:YES];
        }];
    };
}

#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self loadRequestMineUserAlipayAccount];
}

- (void)loadRequestMineUserAlipayAccount {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineUserAlipayAccount];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.alipayAccount = returnValue[@"alipayAccount"];
        if (ValidStr(self.alipayAccount)) {
            NSString *encryptAccount = [DCSpeedy dc_EncryptionDisplayMessageWith:self.alipayAccount WithFirstIndex:3 surplus:4];
            self.alipayContLabel.text = GBNSStringFormat(@"支付宝账号：%@",encryptAccount);
            [self.indicateButton setTitle:@"已有绑定" forState:UIControlStateNormal];
            [self.indicateButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        }else {
            self.alipayContLabel.text = @"暂时未绑定支付宝账号";
            [self.indicateButton setTitle:@"现在绑定" forState:UIControlStateNormal];
            [self.indicateButton setImage:GBImageNamed(@"ic_more_right") forState:UIControlStateNormal];
        }
    }];
}

- (UIView *)setupTabeleBottomView {
    [self.tableHeadview addSubview:self.titleLabel];
    [self.tableHeadview addSubview:self.moneyLabel];
    [self.tableHeadview addSubview:self.indicateButton];
    [self.tableHeadview addSubview:self.subtitleLabel];
    [self.tableHeadview addSubview:self.textField];
    [self.tableHeadview addSubview:self.allButton];
    [self.tableHeadview addSubview:self.subtitleLabel2];
    [self.tableHeadview addSubview:self.imageView];
    [self.tableHeadview addSubview:self.line];
    [self.tableHeadview addSubview:self.alipayContLabel];
    [self.tableHeadview addSubview:self.alipayImageView];
    [self.tableHeadview addSubview:self.placeHolderL];
    [self.tableHeadview addSubview:self.promptLabel];
    
    @GBWeakObj(self);
    [[self.textField rac_textSignal] subscribeNext:^(id x) {
        @GBStrongObj(self);
        NSString *str = (NSString *)x;
        if (str.length) {
            [self updatePrompt:[str integerValue]];
            self.placeHolderL.hidden = YES;
        }else {
            self.placeHolderL.hidden = NO;
        }
    }];
    
    [self p_addMasonry];
    
    return self.tableHeadview;
}

#pragma mark - # Event Response

- (void)modifyAlicountButtonAction {
    GBModifyViewController *modifyPhoneVC = [[GBModifyViewController alloc] init];
    modifyPhoneVC.modifyType = ModifyControllerTypeAliPayCount;
    [self.navigationController pushViewController:modifyPhoneVC animated:YES];
}

- (void)allButtonTouchUpInside:(UIButton *)sender {
    self.placeHolderL.hidden = YES;
    
    self.textField.text = GBNSStringFormat(@"%.f",self.balanceModel.currentTotalEarning);
    [self updatePrompt:self.balanceModel.currentTotalEarning];
}

#pragma mark - # Private Methods
// 更新提示
- (void)updatePrompt:(NSInteger )money {
    
    BOOL lessMinMoney = money < 50;
    BOOL moreMaxMoney = money > 5000;

    self.moneyLabel.hidden = (lessMinMoney || moreMaxMoney) ? YES : NO;
    self.promptLabel.text = lessMinMoney ? @"最低提现额度50元" : moreMaxMoney ? @"单笔提现额度最高为5000元" : @"";
}

- (void)p_addMasonry {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.alipayImageView);
        make.left.mas_equalTo(self.tableHeadview).mas_offset(GBMargin);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.alipayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableHeadview);
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(GBMargin/2);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alipayImageView.mas_right).mas_offset(4);
        make.top.mas_equalTo(self.tableHeadview);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self.tableHeadview)setOffset:-GBMargin];
        make.width.greaterThanOrEqualTo(@44);
        make.centerY.mas_equalTo(self.alipayImageView);
    }];
    
    // 子标题
    [self.alipayContLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alipayImageView.mas_right).mas_offset(4);
        make.bottom.equalTo(self.alipayImageView.mas_bottom);
//        make.right.equalTo(self.indicateButton.mas_left).offset(-GBMargin/2);
        make.height.mas_equalTo(20);
    }];
    
    [self.subtitleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alipayImageView.mas_bottom).offset(40); make.left.mas_equalTo(self.tableHeadview).mas_offset(GBMargin);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    
    // ￥
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textField.mas_bottom).offset(-5);
        make.left.equalTo(self.tableHeadview).offset(GBMargin);
        make.width.equalTo(@20);
    }];
    
    // 输入提现金额
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel2.mas_bottom).offset(GBMargin);
        make.left.equalTo(self.subtitleLabel.mas_right).offset(1);
        make.right.equalTo(self.tableHeadview).offset(-GBMargin);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableHeadview).offset(GBMargin);
        make.height.equalTo(@0.5);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(5);
        make.right.equalTo(self.tableHeadview).offset(-GBMargin);
    }];
    
    // 全部提现
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.tableHeadview).mas_offset(-5);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    // 收益
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableHeadview).mas_offset(24);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(15);
    }];
    
    // 提示
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableHeadview).mas_offset(24);
        make.centerY.mas_equalTo(self.allButton);
    }];
    
    [self.placeHolderL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField).offset(self.textField.margin);
        make.right.equalTo(self.textField);
        make.centerY.equalTo(self.subtitleLabel);
    }];
}

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - # Getters and Setters
- (UIView *)tableHeadview {
    if (!_tableHeadview) {
        _tableHeadview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _tableHeadview;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel.font = Fit_Font(15);
        _titleLabel.text = @"支付宝";
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = Fit_Font(15);
        _moneyLabel.textColor = [UIColor kAssistInfoTextColor];
        _moneyLabel.text = GBNSStringFormat(@"当前余额 %.f元",self.balanceModel.currentTotalEarning);
    }
    return _moneyLabel;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.font = Fit_Font(12);
        _promptLabel.textColor = [UIColor kPromptRedColor];
        
    }
    
    return _promptLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [UIColor kImportantTitleTextColor];
        _subtitleLabel.font = Fit_B_Font(24);
        _subtitleLabel.text = @"￥";
    }
    return _subtitleLabel;
}

- (XKTextField *)textField {
    if (!_textField) {
        _textField = [[XKTextField alloc] init];
        _textField.margin = 4;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.font = Fit_B_Font(36);
    }
    
    return _textField;
}

- (UIButton *)allButton {
    if (!_allButton) {
        _allButton = [[UIButton alloc] init];
        [_allButton addTarget:self action:@selector(allButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_allButton setTitle:@"全部提现" forState:UIControlStateNormal];
        [_allButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    }
    
    return _allButton;
}

- (UILabel *)alipayContLabel {
    if (!_alipayContLabel) {
        _alipayContLabel = [[UILabel alloc] init];
        _alipayContLabel.font = Fit_Font(14);
    }
    return _alipayContLabel;
}

- (UILabel *)subtitleLabel2 {
    if (!_subtitleLabel2) {
        _subtitleLabel2 = [[UILabel alloc] init];
        _subtitleLabel2.textColor = [UIColor kImportantTitleTextColor];
        _subtitleLabel2.font = Fit_Font(15);
        _subtitleLabel2.text = @"提现金额";
        
    }
    
    return _subtitleLabel2;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:GBImageNamed(@"userAgreementSel")];
    }
    
    return _imageView;
}

- (UIImageView *)alipayImageView {
    if (!_alipayImageView) {
        _alipayImageView = [[UIImageView alloc] initWithImage:GBImageNamed(@"icon_service_alipayImage")];
    }
    
    return _alipayImageView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _line;
}

- (UILabel *)placeHolderL {
    if (!_placeHolderL) {
        _placeHolderL = [UILabel new];
        _placeHolderL.font = Fit_Font(17);
        _placeHolderL.textColor = [UIColor kPlaceHolderColor];
        _placeHolderL.text = @"请输入提现金额";
    }
    return _placeHolderL;
}

- (GBLLRIButton *)indicateButton {
    if (!_indicateButton) {
        _indicateButton = [GBLLRIButton buttonWithType:UIButtonTypeCustom];
        [_indicateButton setImage:[UIImage imageNamed:@"ic_more_right"] forState:UIControlStateNormal];
        [_indicateButton addTarget:self action:@selector(modifyAlicountButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _indicateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_indicateButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        _indicateButton.titleLabel.font = Fit_Font(14);
    }
    
    return _indicateButton;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
