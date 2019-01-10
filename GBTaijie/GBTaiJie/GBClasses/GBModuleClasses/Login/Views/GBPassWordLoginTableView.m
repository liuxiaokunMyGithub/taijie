//
//  GBPassWordLoginTableView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/10.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPassWordLoginTableView.h"
#import "GBRegisterViewController.h"
 

// Views

#import "GBLIRLButton.h"

#import "GBLoginViewModel.h"

// 验证码登录
static NSInteger const kSMSCodeLoginButtonTag = 102;


@interface GBPassWordLoginTableView ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, weak) UIButton *loginButton;
@property (nonatomic, weak) UIButton *registerButton;
/* 密码登录 */
@property (nonatomic, strong) UIButton *passwordLoginButton;
/* 是否同意用户协议 */
@property (nonatomic, assign,getter = isAgreed) BOOL agreed;

@end

@implementation GBPassWordLoginTableView
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        //设置代理对象
        self.dataSource = self;
        self.delegate = self;
        
        //设置高度
        self.rowHeight = Fit_W_H(50);
        self.sectionFooterHeight = 0.00000001;
        self.sectionHeaderHeight = GBMargin;
        self.tableFooterView = [self customFooterView];
        self.backgroundColor = [UIColor clearColor];
        self.agreed = YES;
    }
    
    return self;
}

#pragma mark - # Privater Methods
- (void)setupLoginName:(NSString *)loginName {
    if (ValidStr(loginName)) {
        self.tempItem.userName = loginName;
        [self reloadData];
    }
}

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

- (void)exchangeButtonAction {
    !self.exchangeButtonActionBlock ? : _exchangeButtonActionBlock(self.passwordLoginButton);
}

//尾部视图
- (UIView *)customFooterView {
    CGFloat topMargin = 95*0.5;
    CGFloat titleTopMargin = 48*0.5;
    CGFloat titleheight = 60*0.5;
    
    CGFloat btnH = Fit_W_H(44);
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topMargin+btnH+titleTopMargin+titleheight+60)];
    
//    CGSize userAgreementSize = [DCSpeedy dc_calculateTextSizeWithText:@"我已阅读并同意" WithTextFont:Fit_Font(13) WithMaxW:SCREEN_WIDTH/2];
//    GBLIRLButton *userAgreementButton = [[GBLIRLButton alloc] initWithFrame:CGRectMake(40, 15, userAgreementSize.width+20, 20)];
//    [userAgreementButton setImage:[UIImage imageNamed:@"userAgreement"] forState:UIControlStateNormal];
//    [userAgreementButton setImage:[UIImage imageNamed:@"userAgreementSel"] forState:UIControlStateSelected];
//    [userAgreementButton addTarget:self action:@selector(agreedUserProtocolButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    userAgreementButton.selected = YES;
//    [userAgreementButton setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
//    userAgreementButton.titleLabel.font = Fit_Font(12);
//    [userAgreementButton setTitleColor:[UIColor kNormoalInfoTextColor] forState:UIControlStateNormal];
//    [footView addSubview:userAgreementButton];
//    userAgreementButton.right = SCREEN_WIDTH/2;
//
//    CGSize agreementSize = [DCSpeedy dc_calculateTextSizeWithText:@"《台阶用户协议》" WithTextFont:Fit_Font(13) WithMaxW:SCREEN_WIDTH/2];
//    UIButton *agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userAgreementButton.frame), 15, agreementSize.width, 20)];
//    [agreementButton setTitle:@"《台阶用户协议》" forState:UIControlStateNormal];
//    [agreementButton addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    agreementButton.titleLabel.font = Fit_Font(12);
//    [agreementButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
//    [footView addSubview:agreementButton];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(GBMargin, 44, SCREEN_WIDTH - GBMargin*2, btnH)];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = Fit_Font(18);
    [loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:GBImageNamed(@"button_bg_long") forState:UIControlStateNormal];
    self.loginButton.alpha = 0.85;
    self.loginButton = loginButton;
    [footView addSubview:loginButton];
    
    /** rac 设置是否能够点击*/
    RACSignal *comBineSignal = [RACSignal combineLatest:@[RACObserve(self, tempItem.userName),RACObserve(self, tempItem.password),] reduce:^id(NSString *userName,NSString *userPsd){
        return @((userName && [GBAppHelper isMobileNumber:userName]) && (userPsd && userPsd.length > 0));}];
    RAC(loginButton,userInteractionEnabled) = comBineSignal;
    
    UIButton *loginExchangeButton = [[UIButton alloc] init];
    [loginExchangeButton addTarget:self action:@selector(exchangeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [loginExchangeButton setTitle:@"免密登录" forState:UIControlStateNormal];
    loginExchangeButton.tag = kSMSCodeLoginButtonTag;
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
            cellF.placeHolderL.hidden = YES;
        }
        cellF.textField.margin = 1;
        //        GBViewBorderRadius(cellF.textField, Fit_W_H(25), 1, [UIColor kSegmentateLineColor]);
        // 手机号码textField改变值监听回调
        cellF.textValueChangedBlock = ^(NSString *valueStr) {
            weakSelf.tempItem.userName = valueStr;
            if ([GBAppHelper isMobileNumber:self.tempItem.userName] && (weakSelf.tempItem.password.length > 0)) {
                [weakSelf.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.loginButton.alpha = 1;

            }else {
                [weakSelf.loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
                self.loginButton.alpha = 0.85;

            }
            
            // 正则验证手机号格式，设置获取验证码按钮的可操作性
            if ([GBAppHelper isMobileNumber:self.tempItem.userName]) {
                [self.loginPasswordCell.textField becomeFirstResponder];
            }else {
            }
        };
        
        cellF.editDidBeginBlock = ^(NSString *valueStr) {
            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        };
        
        // 手机号码结束编辑
        cellF.editDidEndBlock = ^(NSString *textStr) {
            weakSelf.tempItem.userName = textStr;
            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        };
        
        cellF.textField.text = weakSelf.tempItem.userName;
        
        cell = cellF;
        self.loginNameCell = cellF;
        cellF.textFieldMargin = 24;
//        cellF.line.hidden = YES;
    }else {
        LCHomeForgetPsdPhoneCell *cellF = [LCHomeForgetPsdPhoneCell cellForTableView:tableView];
        [cellF setPlaceholder:@"密码" value:nil];
        cellF.showSecureTextButton = YES;
        cellF.textField.margin = 1;
        // 手机号码textField改变值监听回调
        cellF.textValueChangedBlock = ^(NSString *valueStr) {
            weakSelf.tempItem.password = valueStr;
            if ([GBAppHelper isMobileNumber:self.tempItem.userName] && weakSelf.tempItem.password.length > 0) {
                [weakSelf.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.loginButton.alpha = 1;
            }else {
                [weakSelf.loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
                self.loginButton.alpha = 0.85;
            }
        };
        
        cellF.editDidBeginBlock = ^(NSString *valueStr) {
            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        };
        
        // 手机号码结束编辑
        cellF.editDidEndBlock = ^(NSString *textStr){
            weakSelf.tempItem.password = textStr;
            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        };
        
        cellF.textField.text = weakSelf.tempItem.password;
        
        cell = cellF;
        self.loginPasswordCell = cellF;
        cellF.textFieldMargin = 24;
//        cellF.line.hidden = YES;
    }
    
    return cell;
}

/** MARK:登录事件 */
- (void)loginButtonClick {
    if (!self.isAgreed) {
        return [UIView showHubWithTip:@"请勾选用户组协议"];
    }
    
    [self.loginNameCell.textField resignFirstResponder];
    [self.loginPasswordCell.textField resignFirstResponder];
    GBLoginViewModel *loginVM = [[GBLoginViewModel alloc] init];
    [loginVM chekLoginName:self.loginNameCell.textField.text];
    [loginVM setSuccessReturnBlock:^(id returnValue) {
        if ([returnValue[@"data"][@"code"] isEqualToString:@"NONEXSISTENCE"]) {
            [GBRootViewController AlertWithTitle:@"提示" message:returnValue[@"data"][@"info"] andOthers:@[@"取消",@"注册"] animated:YES action:^(NSInteger index) {
                if (index == 1) {
                    // 注册
                    GBRegisterViewController *registerVC = [[GBRegisterViewController alloc] init];
                    registerVC.tempItem.userName = self.loginNameCell.textField.text;
                    [[GBAppHelper currentViewController].navigationController pushViewController:registerVC animated:YES];
                }
            }];
        }else {
            // 登录
            GBLoginViewModel *loginVM = [[GBLoginViewModel alloc] init];
            [loginVM loginRequestLoginName:self.tempItem.userName password:self.tempItem.password];
            [loginVM setBlockWithReturnBlock:^(id returnValue) {
                GBPostNotification(LoginStateChangeNotification, @YES);
            } WithErrorBlock:^(id errorCode) {
                NSLog(@"登录失败%@",errorCode);
            }];
        }
    }];
    
}

- (void)agreedUserProtocolButtonAction:(UIButton *)agreedButton {
    agreedButton.selected = !agreedButton.selected;
    self.agreed = agreedButton.selected;
}

- (void)protocolBtnClick:(id)sender {
    GBBaseWebViewController *webView = [[GBBaseWebViewController alloc] initWithUrl:GBNSStringFormat(@"%@%@",URL_GB_HTML,HTML_User_Agreement)];
    webView.titleStr = @"台阶用户协议";
    [[GBAppHelper getViewcontrollerView:self].navigationController pushViewController:webView animated:YES];
}

- (GBPwdLoginControlTempItem *)tempItem {
    if (!_tempItem) {
        _tempItem = [[GBPwdLoginControlTempItem alloc] init];
    }
    
    return _tempItem;
}

@end

@implementation GBPwdLoginControlTempItem

@end
