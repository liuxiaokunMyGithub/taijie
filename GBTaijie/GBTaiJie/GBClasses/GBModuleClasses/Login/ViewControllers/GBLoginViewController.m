//
//  GBLoginViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBLoginViewController.h"
#import "YFGIFImageView.h"
#import "UIImage+GIF.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

// Controllers
#import "GBRegisterViewController.h"
// ViewModels

#import "GBLoginViewModel.h"

// Models


// Views
#import "LCHomeCheckNumCell.h"
#import "LCHomeForgetPsdPhoneCell.h"
#import "GBLIRLButton.h"
#import "GBPassWordLoginTableView.h"
#import "GBVerificationCodeCell.h"

// 密码登录
static NSInteger const kPasswordLoginButtonTag = 101;

static NSString *const kGBVerificationCodeCellID = @"GBVerificationCodeCell";

@interface GBLoginViewController ()<UITableViewDelegate,UITableViewDataSource,GBVerificationCodeCellDelegate>
/* 布局表视图 */
//@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, weak) UIButton *loginButton;
@property (nonatomic, weak) UIButton *registerButton;
/* 底部工具条 */
@property (nonatomic, strong) UIView *bottomToolView;
/* 密码登录 */
@property (nonatomic, strong) UIButton *passwordLoginButton;
@property (nonatomic, weak) UITextField *checkNumField;
@property (nonatomic, weak) UIButton *sendCheckNumBtn;

@property (nonatomic, strong) LCHomeForgetPsdPhoneCell *loginNameCell;
@property (nonatomic, strong) LCHomeCheckNumCell *loginCodeCell;

/* 背景图 */
@property (nonatomic, strong) YFGIFImageView *bgImageView;

/* 背景 */
@property (nonatomic, strong) UIImageView *whiteBGView;
/* 是否同意用户协议 */
@property (nonatomic, assign,getter = isAgreed) BOOL agreed;

/* 密码登录表视图 */
@property (nonatomic, strong) GBPassWordLoginTableView *passwordLoginTableView;
@end

@implementation GBLoginViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:LoginAnimationNotification object:nil];
    [self.bgImageView removeFromSuperview];

    self.bgImageView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:LoginAnimationNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"登录";
    
    // 设置表视图
    [self setupSubView];
    
   
}


#pragma mark - # Setup Methods
- (void)setupSubView {
    [self.view addSubview:self.whiteBGView];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    self.baseTableView.rowHeight = Fit_W_H(50);
    self.baseTableView.alpha = 0;
    [self.baseTableView registerClass:[GBVerificationCodeCell class] forCellReuseIdentifier:kGBVerificationCodeCellID];
    
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"免密登录"];
    self.baseTableView.tableFooterView = [self customFooterView];
    self.baseTableView.scrollEnabled = NO;
    self.baseTableView.top = SCREEN_HEIGHT;
    
    self.passwordLoginTableView.tempItem.userName = self.tempItem.userName;
    
    [self.view addSubview:self.passwordLoginTableView];
    @GBWeakObj(self);
    self.passwordLoginTableView.exchangeButtonActionBlock = ^(UIButton *exchangeButton) {
    @GBStrongObj(self);
        [self rightBarButtonItemAction:exchangeButton];
    };
}

#pragma mark - RightBarButtonItem Action
- (void)rightBarButtonItemAction:(UIButton *)button
{
    // MARK: 动画
    if (button.tag == kPasswordLoginButtonTag) {
         [self.passwordLoginTableView setupLoginName:self.loginNameCell.textField.text];
        
        [UIView animateWithDuration:.35 animations:^{
            self.passwordLoginTableView.top = SafeAreaTopHeight;
            self.passwordLoginTableView.alpha = 1;
            
            self.baseTableView.top = SCREEN_HEIGHT;
            self.baseTableView.alpha = 0;
            
        }completion:^(BOOL finished) {
        }];
    }else {
        if (ValidStr(self.passwordLoginTableView.loginNameCell.textField.text)) {
            self.tempItem.userName = self.passwordLoginTableView.loginNameCell.textField.text;
            
            [self.baseTableView reloadData];

        }
       
        [UIView animateWithDuration:.35 animations:^{
            self.passwordLoginTableView.top = - SCREEN_HEIGHT;
            self.passwordLoginTableView.alpha = 0;
            
            self.baseTableView.top = SafeAreaTopHeight;
            self.baseTableView.alpha = 1;
        }completion:^(BOOL finished) {
//            [self.passwordLoginButton setTitle:@"密码登录" forState:UIControlStateNormal];
//            self.passwordLoginButton.tag = kPasswordLoginButtonTag;
        }];
    }
}

- (void)showAnimation {
    // MARK: 动画
    @GBWeakObj(self);
    [UIView animateWithDuration:.35 animations:^{
    @GBStrongObj(self);
        self.whiteBGView.top = Fit_W_H(SCREEN_HEIGHT * 0.35);
        self.whiteBGView.alpha = 1;
        self.baseTableView.alpha = 1;
        
    }completion:^(BOOL finished) {
//        [self.loginNameCell.textField becomeFirstResponder];
    }];
}

#pragma mark - # Event Response
/** MARK:登录事件 */
- (void)loginButtonClick {
    [self.loginNameCell.textField resignFirstResponder];
    [self.loginCodeCell.textField resignFirstResponder];
    
    GBLoginViewModel *loginVM = [[GBLoginViewModel alloc] init];
    [loginVM loginRequestLoginName:self.tempItem.userName smsCode:self.tempItem.checkNum];
    [loginVM setBlockWithReturnBlock:^(id returnValue) {
        GBPostNotification(LoginStateChangeNotification, @YES);
    } WithErrorBlock:^(id errorCode) {
        NSLog(@"登录失败%@",errorCode);
    }];
    
}

#pragma mark - # Privater Methods
// MARK:头部视图
- (UIView *)customHeaderView {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,Fit_W_H(SCREEN_HEIGHT * 0.45))];
    UIImageView *logoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Fit_W_H(120), Fit_W_H(120))];
    logoImageV.image = GBImageNamed(@"logo_Icon");
    [headerV addSubview:logoImageV];

    headerV.backgroundColor = [UIColor clearColor];
    logoImageV.center = headerV.center;
    return headerV;
}

//尾部视图
- (UIView *)customFooterView {
    CGFloat topMargin = 95*0.5;
    CGFloat titleTopMargin = 48*0.5;
    CGFloat titleheight = 60*0.5;
    
    CGFloat btnH = Fit_W_H(44) ;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topMargin+btnH+titleTopMargin+titleheight+60)];

    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(GBMargin, GBMargin, SCREEN_WIDTH - GBMargin*2, btnH)];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = Fit_Font(18);
    [loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    [loginButton setBackgroundImage:GBImageNamed(@"button_bg_long") forState:UIControlStateNormal];

    self.loginButton = loginButton;
    self.loginButton.alpha = 0.85;

    [footView addSubview:loginButton];
    
    /** rac 设置是否能够点击*/
    RACSignal *comBineSignal = [RACSignal combineLatest:@[RACObserve(self, tempItem.userName),RACObserve(self, tempItem.checkNum),] reduce:^id(NSString *userName,NSString *userPsd){
        return @((userName && [GBAppHelper isMobileNumber:userName]) && (userPsd && userPsd.length > 0));}];
    RAC(loginButton,userInteractionEnabled) = comBineSignal;
    
    UIButton *loginExchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(GBMargin, loginButton.bottom + 10, 80, 20)];
    loginExchangeButton.tag = kPasswordLoginButtonTag;
    [loginExchangeButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginExchangeButton setTitle:@"密码登录" forState:UIControlStateNormal];
    loginExchangeButton.titleLabel.font = Fit_M_Font(14);
    [loginExchangeButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    self.passwordLoginButton = loginExchangeButton;
    [footView addSubview:loginExchangeButton];
    
    [loginExchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(GBMargin);
        make.height.equalTo(@20);
        make.top.equalTo(loginButton.mas_bottom).offset(GBMargin/2);
    }];
    
    return footView;
}

#pragma mark - # Delegate

// MARK - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 50 : 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    __weak typeof(self) weakSelf = self;
    if(indexPath.section == 0) {
        LCHomeForgetPsdPhoneCell *cellF = [LCHomeForgetPsdPhoneCell cellForTableView:tableView];
        cellF.textField.keyboardType = UIKeyboardTypePhonePad;
        
        if (!ValidStr(self.tempItem.userName)) {
            cellF.placeHolderL.hidden = NO;
            [cellF setPlaceholder:@"手机号码" value:nil];
        }else {
            cellF.placeHolderL.hidden = YES;;
        }
        cellF.textField.margin = 1;
        // 手机号码textField改变值监听回调
        cellF.textValueChangedBlock = ^(NSString *valueStr) {
            weakSelf.tempItem.userName = valueStr;
            if ([GBAppHelper isMobileNumber:self.tempItem.userName] && (weakSelf.tempItem.checkNum && ![weakSelf.tempItem.checkNum isEqualToString:@""])) {
                [weakSelf.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.loginButton.alpha = 1;

            }else {
                [weakSelf.loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
                self.loginButton.alpha = 0.85;
            }

            // 正则验证手机号格式，设置获取验证码按钮的可操作性
            if ([GBAppHelper isMobileNumber:self.tempItem.userName]) {
                weakSelf.sendCheckNumBtn.enabled = YES;
                [weakSelf.sendCheckNumBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
                [self.loginCodeCell.textField becomeFirstResponder];
            }else {
                weakSelf.sendCheckNumBtn.enabled = NO;
                [weakSelf.sendCheckNumBtn setTitleColor:[UIColor kPlaceHolderColor] forState:UIControlStateNormal];
            }
        };

        cellF.editDidBeginBlock = ^(NSString *valueStr) {

        };

        // 手机号码结束编辑
        cellF.editDidEndBlock = ^(NSString *textStr){
            weakSelf.tempItem.userName = textStr;
        };

        cellF.textField.text = weakSelf.tempItem.userName;

        cell = cellF;
        self.loginNameCell = cellF;
        cellF.textFieldMargin = 24;
    }else {
        GBVerificationCodeCell *cellF = [GBVerificationCodeCell cellForTableView:tableView];
        cellF.validationCodeView.codeBlock = ^(NSString *codeString) {
            NSLog(@"验证码:%@", codeString);
            weakSelf.tempItem.checkNum = codeString;
            if ([GBAppHelper isMobileNumber:self.tempItem.userName] && weakSelf.tempItem.checkNum.length > 0) {
                [weakSelf.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.loginButton.alpha = 1;
                
            }else {
                [weakSelf.loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
                self.loginButton.alpha = 0.85;
                
            }
        };

        cellF.delegate = self;
        if ([GBAppHelper isMobileNumber:self.tempItem.userName]) {
            [cellF.sendCheckNumBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
            cellF.sendCheckNumBtn.enabled = YES;
        }else {
            [cellF.sendCheckNumBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
            cellF.sendCheckNumBtn.enabled = NO;
        }
        
        self.sendCheckNumBtn = cellF.sendCheckNumBtn;
        
        cellF.line.hidden = YES;
        cell = cellF;
    }

    return cell;
}

- (void)GBVerificationCodeCellCheckBtnClick:(GBVerificationCodeCell *)cell {
    // 判断手机号码是否填写格式是否正确
    if ([GBAppHelper isMobileNumber:self.tempItem.userName]) {
        GBLoginViewModel *loginVM = [[GBLoginViewModel alloc] init];
        [loginVM chekLoginName:self.loginNameCell.textField.text];
        [loginVM setSuccessReturnBlock:^(id returnValue) {
            if ([returnValue[@"data"][@"code"] isEqualToString:@"NONEXSISTENCE"]) {
                [self AlertWithTitle:@"提示" message:returnValue[@"data"][@"info"] andOthers:@[@"取消",@"注册"] animated:YES action:^(NSInteger index) {
                    if (index == 1) {
                        // 注册
                        GBRegisterViewController *registerVC = [[GBRegisterViewController alloc] init];
                        registerVC.tempItem.userName = self.loginNameCell.textField.text;
                        [self.navigationController pushViewController:registerVC animated:YES];
                    }
                }];
            }else {
                // 发送验证码
                self.sendCheckNumBtn.enabled = YES;
                GBLoginViewModel *loginVM = [[GBLoginViewModel alloc] init];
                [loginVM loadRequestCheckCode:self.tempItem.userName type:@"login"];
                [loginVM  setSuccessReturnBlock:^(id returnValue) {
                    // 倒计时
                    [cell updateSendCodeButton];
                    // 验证码输入框获取焦点
                    [self.checkNumField becomeFirstResponder];
                }];
            }
        }];
    }else {
        [UIView showHubWithTip:@"请输入正确的手机号"];
    }
}

#pragma mark - # Getters and Setters
- (GBLoginControlTempItem *)tempItem{
    if (!_tempItem) {
        _tempItem = [GBLoginControlTempItem new];
    }
    return _tempItem;
}

- (YFGIFImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loginBackGround.gif" ofType:nil]];
        _bgImageView.gifData = gifData;
        [_bgImageView startGIF];
    }
    
    return _bgImageView;
}



- (UIImageView *)whiteBGView {
    if (!_whiteBGView) {
        _whiteBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - Fit_W_H(SCREEN_HEIGHT*0.35))];
        _whiteBGView.image = GBImageNamed(@"CombinedShape");
        _whiteBGView.alpha = 0.35;
        _whiteBGView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _whiteBGView;
}

- (GBPassWordLoginTableView *)passwordLoginTableView {
    if (!_passwordLoginTableView) {
        _passwordLoginTableView = [[GBPassWordLoginTableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _passwordLoginTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"密码登录"];
    }
    
    return _passwordLoginTableView;
}
// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end


@implementation GBLoginControlTempItem

@end
