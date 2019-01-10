//
//  GBRegisterViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/10.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBRegisterViewController.h"
#import "UIImage+GIF.h"
// Controllers
#import "GBLoginViewController.h"

// ViewModels
#import "GBLoginViewModel.h"

// Models


// Views
#import "GBVerificationCodeCell.h"
#import "LCHomeForgetPsdPhoneCell.h"
#import "GBLIRLButton.h"
#import "GBBigTitleHeadView.h"

@interface GBRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,GBVerificationCodeCellDelegate>
/* 布局表视图 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIButton *loginButton;
@property (nonatomic, weak) UIButton *registerButton;
@property (nonatomic, weak) UITextField *checkNumField;
@property (nonatomic, weak) UIButton *sendCheckNumBtn;

@property (nonatomic, strong) LCHomeForgetPsdPhoneCell *loginNameCell;
@property (nonatomic, strong) GBVerificationCodeCell *loginCodeCell;
@property (nonatomic, strong) LCHomeForgetPsdPhoneCell *loginPwdCell;


/* 标题 */
@property (nonatomic, strong) GBBigTitleHeadView *bigTitleHeadView;

/* 背景图 */
@property (nonatomic, strong) UIImageView *bgImageView;

/* 背景 */
@property (nonatomic, strong) UIImageView *whiteBGView;
/* 是否同意用户协议 */
@property (nonatomic, assign,getter = isAgreed) BOOL agreed;

@end

@implementation GBRegisterViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:LoginAnimationNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"注册";

//    [self.view addSubview:self.bgImageView];
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:0];
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self setupSubView];
    // 默认同意用户协议
    self.agreed = YES;
    
//    [GBNotificationCenter addObserver:self selector:@selector(showAnimation) name:LoginAnimationNotification object:nil];
}

- (void)setupUserName:(NSString *)userName {
    self.tempItem.userName = userName;
    if ([GBAppHelper isMobileNumber:self.tempItem.userName]) {
        [self.sendCheckNumBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    }else {
        [self.sendCheckNumBtn setTitleColor:[UIColor kPlaceHolderColor] forState:UIControlStateNormal];
    }
}

#pragma mark - # Setup Methods
- (void)setupSubView {
//    [self.view addSubview:self.whiteBGView];
    //  添加tableView
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 56;
        tableView.sectionFooterHeight = 0.00000001;
        tableView.sectionHeaderHeight = 0.00000001;
        tableView.backgroundColor = [[UIColor colorWithHexString:@"#F2F5FB"] colorWithAlphaComponent:0];
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(SafeAreaTopHeight);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_HEIGHT-SafeAreaTopHeight);
            make.left.equalTo(self.view).offset(0);
        }];
        
        tableView;
    });
    
//    self.tableView.tableHeaderView = [self customHeaderView];
    self.tableView.tableHeaderView = self.bigTitleHeadView;

    self.tableView.tableFooterView = [self customFooterView];
    self.tableView.scrollEnabled = NO;
}

- (void)showAnimation {
    // MARK: 动画
    [UIView animateWithDuration:.5 animations:^{
        // self.whiteBGView.top = ((iPhoneX ? Fit_W_H(300) : Fit_W_H(160)));
        self.whiteBGView.top = SCREEN_HEIGHT * 0.35;
        
        self.whiteBGView.alpha = 1;
        self.tableView.alpha = 1;
        
    }completion:^(BOOL finished) {
        [self.loginNameCell.textField becomeFirstResponder];
    }];
}

#pragma mark - # Event Response
/** MARK: 注册登录事件 */
- (void)loginButtonClick {
    
    if (!self.isAgreed) {
        return [UIView showHubWithTip:@"请勾选用户组协议"];
    }
    if (![GBAppHelper checkPassword:self.tempItem.passWord]){
        return [UIView showHubWithTip:@"请设置6-20位数字字母组合密码"];
    }
    
    [self.loginNameCell.textField resignFirstResponder];
    [self.loginPwdCell.textField resignFirstResponder];
    
    GBLoginViewModel *loginVM = [[GBLoginViewModel alloc] init];
    [loginVM loginRequestRegister:self.tempItem.userName password:self.tempItem.passWord smsCode:self.tempItem.checkNum];
    [loginVM setBlockWithReturnBlock:^(id returnValue) {
        GBPostNotification(LoginStateChangeNotification, @YES);
        // 统计注册事件
        [GBAppDelegate setupJAnalyticsRegisterEvent];
        // 推广注册渠道统计
        [ShareInstallSDK reportRegister];
        
    } WithErrorBlock:^(id errorCode) {
        NSLog(@"登录失败%@",errorCode);
    }];
}

- (void)agreedUserProtocolButtonAction:(UIButton *)agreedButton {
    agreedButton.selected = !agreedButton.selected;
    self.agreed = agreedButton.selected;
}

- (void)protocolBtnClick:(id)sender {
    GBBaseWebViewController *webView = [[GBBaseWebViewController alloc] initWithUrl:GBNSStringFormat(@"%@%@",URL_GB_HTML,HTML_User_Agreement)];
    webView.titleStr = @"台阶用户协议";
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - # Privater Methods
// MARK:头部视图
- (UIView *)customHeaderView{
    //    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,((iPhoneX ? Fit_W_H(330) : Fit_W_H(260))))];
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT * 0.45)];
    UIImageView *logoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
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
    
    CGFloat btnH = Fit_W_H(44);
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topMargin+btnH+titleTopMargin+titleheight+60)];
    
    UIButton *registeredButton = [[UIButton alloc] initWithFrame:CGRectMake(GBMargin, GBMargin, SCREEN_WIDTH - GBMargin*2, btnH)];
    [registeredButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [registeredButton setTitle:@"注 册" forState:UIControlStateNormal];
    registeredButton.titleLabel.font = Fit_Font(18);
    [registeredButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [registeredButton setBackgroundColor:[UIColor whiteColor]];
    [registeredButton setBackgroundImage:GBImageNamed(@"button_bg_long") forState:UIControlStateNormal];
    self.loginButton = registeredButton;
    [footView addSubview:registeredButton];
    
    CGSize userAgreementSize = [DCSpeedy dc_calculateTextSizeWithText:@"我已阅读并同意" WithTextFont:Fit_Font(13) WithMaxW:SCREEN_WIDTH/2];
    GBLIRLButton *userAgreementButton = [[GBLIRLButton alloc] initWithFrame:CGRectMake(GBMargin, registeredButton.bottom + 15, userAgreementSize.width+20, 20)];
    [userAgreementButton setImage:[UIImage imageNamed:@"userAgreement"] forState:UIControlStateNormal];
    [userAgreementButton setImage:[UIImage imageNamed:@"userAgreementSel"] forState:UIControlStateSelected];
    [userAgreementButton addTarget:self action:@selector(agreedUserProtocolButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    userAgreementButton.selected = YES;
    [userAgreementButton setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    userAgreementButton.titleLabel.font = Fit_Font(12);
    [userAgreementButton setTitleColor:[UIColor kNormoalInfoTextColor] forState:UIControlStateNormal];
    [footView addSubview:userAgreementButton];
    userAgreementButton.right = SCREEN_WIDTH/2;
    
    CGSize agreementSize = [DCSpeedy dc_calculateTextSizeWithText:@"《台阶用户协议》" WithTextFont:Fit_Font(13) WithMaxW:SCREEN_WIDTH/2];
    UIButton *agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userAgreementButton.frame), registeredButton.bottom + 15, agreementSize.width, 20)];
    [agreementButton setTitle:@"《台阶用户协议》" forState:UIControlStateNormal];
    [agreementButton addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    agreementButton.titleLabel.font = Fit_Font(12);
    [agreementButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    [footView addSubview:agreementButton];

    /** rac 设置是否能够点击*/
    RACSignal *comBineSignal = [RACSignal combineLatest:@[RACObserve(self, tempItem.userName),RACObserve(self, tempItem.checkNum),RACObserve(self, tempItem.passWord)] reduce:^id(NSString *userName,NSString *checkNum,NSString *userPsd){
        return @((userName && [GBAppHelper isMobileNumber:userName]) && (checkNum && checkNum.length > 0) && (userPsd && userPsd.length > 0));}];
    RAC(registeredButton,userInteractionEnabled) = comBineSignal;
    return footView;
}

#pragma mark - # Delegate

// MARK - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 ? 80 : 50;
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
        cellF.textField.placeholder = @"请输入手机号码";
        cellF.textField.margin = 1;
        cellF.textFieldMargin = GBMargin;
        // 手机号码textField改变值监听回调
        cellF.textValueChangedBlock = ^(NSString *valueStr) {
            weakSelf.tempItem.userName = valueStr;
            if ([GBAppHelper isMobileNumber:self.tempItem.userName] && (weakSelf.tempItem.checkNum && ![weakSelf.tempItem.passWord isEqualToString:@""])) {
                [weakSelf.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else {
                [weakSelf.loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            }
            
            // 正则验证手机号格式，设置获取验证码按钮的可操作性
            if ([GBAppHelper isMobileNumber:self.tempItem.userName]) {
                weakSelf.sendCheckNumBtn.enabled = YES;
                [weakSelf.sendCheckNumBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
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
    }else if (indexPath.section == 1) {
        GBVerificationCodeCell *cellF = [GBVerificationCodeCell cellForTableView:tableView];
        cellF.validationCodeView.codeBlock = ^(NSString *codeString) {
            NSLog(@"验证码:%@", codeString);
            weakSelf.tempItem.checkNum = codeString;
            if ([GBAppHelper isMobileNumber:self.tempItem.userName] && weakSelf.tempItem.checkNum.length > 0 && weakSelf.tempItem.passWord.length > 0) {
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
    }else {
        LCHomeForgetPsdPhoneCell *cellF = [LCHomeForgetPsdPhoneCell cellForTableView:tableView];
        cellF.textField.placeholder = @"字母和数字组合，6-20位字符";
        cellF.textField.margin = 1;
        cellF.showSecureTextButton = YES;
        cellF.textFieldMargin = GBMargin;
        
        // 手机号码textField改变值监听回调
        cellF.textValueChangedBlock = ^(NSString *valueStr) {
            weakSelf.tempItem.passWord = valueStr;
            if ([GBAppHelper isMobileNumber:self.tempItem.userName] && weakSelf.tempItem.checkNum.length > 0 && weakSelf.tempItem.passWord.length > 0) {
                [weakSelf.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else {
                [weakSelf.loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            }
            
            // 正则验证手机号格式，设置获取验证码按钮的可操作性
            if ([GBAppHelper isMobileNumber:self.tempItem.userName]) {
                weakSelf.sendCheckNumBtn.enabled = YES;
                [weakSelf.sendCheckNumBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
            }else {
                weakSelf.sendCheckNumBtn.enabled = NO;
                [weakSelf.sendCheckNumBtn setTitleColor:[UIColor kPlaceHolderColor] forState:UIControlStateNormal];
            }
        };
        
        cellF.editDidBeginBlock = ^(NSString *valueStr) {
            
        };
        
        // 手机号码结束编辑
        cellF.editDidEndBlock = ^(NSString *textStr){
            weakSelf.tempItem.passWord = textStr;
        };
        
        cellF.textField.text = weakSelf.tempItem.passWord;
        
        cell = cellF;
        self.loginPwdCell = cellF;
    }
    
    return cell;
}

- (void)GBVerificationCodeCellCheckBtnClick:(GBVerificationCodeCell *)cell {
    // 判断手机号码是否填写格式是否正确
    if ([GBAppHelper isMobileNumber:self.tempItem.userName]) {
        GBLoginViewModel *loginVM = [[GBLoginViewModel alloc] init];
        [loginVM chekLoginName:self.loginNameCell.textField.text];
        [loginVM setSuccessReturnBlock:^(id returnValue) {
            if (![returnValue[@"data"][@"code"] isEqualToString:@"NONEXSISTENCE"]) {
                [self AlertWithTitle:@"提示" message:returnValue[@"data"][@"info"] andOthers:@[@"取消",@"登录"] animated:YES action:^(NSInteger index) {
                    if (index == 1) {
                        // 登录
                        GBLoginViewController *loginVC = [[GBLoginViewController alloc] init];
                        loginVC.tempItem.userName = self.loginNameCell.textField.text;
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                }];
            }else {
                // 发送验证码
                self.sendCheckNumBtn.enabled = YES;
                GBLoginViewModel *loginVM = [[GBLoginViewModel alloc] init];
                [loginVM loadRequestCheckCode:self.tempItem.userName type:@"userRegister"];
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
- (GBRegisterTempItem *)tempItem{
    if (!_tempItem) {
        _tempItem = [GBRegisterTempItem new];
    }
    return _tempItem;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"loginBackGround" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImageView.image = image;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;

    }
    
    return _bgImageView;
}

- (UIImageView *)whiteBGView {
    if (!_whiteBGView) {
        _whiteBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.65)];
        _whiteBGView.image = GBImageNamed(@"CombinedShape");
        //        _whiteBGView.contentMode = UIViewContentModeScaleAspectFill;
        _whiteBGView.alpha = 0.35;
        _whiteBGView.contentMode = UIViewContentModeScaleAspectFill;

    }
    
    return _whiteBGView;
}

- (GBBigTitleHeadView *)bigTitleHeadView {
    if (!_bigTitleHeadView) {
        _bigTitleHeadView = [[GBBigTitleHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _bigTitleHeadView.titleLabel.text = @"注册";
    }
    
    return _bigTitleHeadView;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end


@implementation GBRegisterTempItem

@end
