//
//  GBLoginFirstPageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/12.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBLoginFirstPageViewController.h"
// Controllers
#import "GBRegisterViewController.h"
#import "GBLoginViewController.h"

// ViewModels
#import "GBLoginViewModel.h"


// Models


// Views
#import "YFGIFImageView.h"

#import "LCHomeForgetPsdPhoneCell.h"
#import "GBSettingCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBLoginFirstPageViewController ()<UITableViewDelegate,UITableViewDataSource>
/* 背景图 */
@property (nonatomic, strong) YFGIFImageView *bgImageView;
/* 背景 */
@property (nonatomic, strong) UIImageView *whiteBGView;
@property (nonatomic, strong) LCHomeForgetPsdPhoneCell *loginNameCell;
@property (nonatomic, weak) UIButton *loginButton;

@end

@implementation GBLoginFirstPageViewController

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
    
    [self.view addSubview:self.bgImageView];
    
    // 设置表视图
    [self setupSubView];
    
    [GBNotificationCenter addObserver:self selector:@selector(showAnimation) name:LoginAnimationNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.customNavBar.barBackgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0];
    [self.customNavBar wr_setBackgroundAlpha:0];
    self.customNavBar.titleLabelColor = [UIColor clearColor];
    
    [self.view bringSubviewToFront:self.customNavBar];

    [self.customNavBar wr_setLeftButtonWithImage:GBImageNamed(@"icon_back_white")];
    
    [self.customNavBar setOnClickLeftButton:^{
        GBAppDelegate.mainTabBarController = [GBMainTabBarController new];
        GBAppDelegate.window.rootViewController = GBAppDelegate.mainTabBarController;
    }];
    
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
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    self.baseTableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.baseTableView];
  
    self.baseTableView.tableHeaderView = [self customHeaderView];
    self.baseTableView.tableFooterView = [self customFooterView];
    self.baseTableView.scrollEnabled = NO;
    self.baseTableView.alpha = 0.55;
}

#pragma mark - RightBarButtonItem Action
- (void)showAnimation {
    // MARK: 动画
    @GBWeakObj(self);
    [UIView animateWithDuration:.5 animations:^{
        @GBStrongObj(self);
        self.whiteBGView.top = Fit_W_H(SCREEN_HEIGHT * 0.35);
        self.whiteBGView.alpha = 1;
        self.baseTableView.alpha = 1;
        self.loginButton.alpha = 0.85;
    }completion:^(BOOL finished) {
        [self.loginNameCell.textField becomeFirstResponder];
    }];
}

#pragma mark - # Event Response
/** MARK: 继续 */
- (void)loginButtonClick {
    [self.loginNameCell.textField resignFirstResponder];
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
            // 登录
            GBLoginViewController *loginVC = [[GBLoginViewController alloc] init];
            loginVC.tempItem.userName = self.loginNameCell.textField.text;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }];
}

#pragma mark - # Privater Methods
// MARK: 头部视图
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

    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(40,  44, SCREEN_WIDTH - 80, btnH)];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"继 续" forState:UIControlStateNormal];
    loginButton.titleLabel.font = Fit_M_Font(20);
    [loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:GBImageNamed(@"button_bg_long") forState:UIControlStateNormal];
    loginButton.alpha = 0;
    self.loginButton = loginButton;
    [footView addSubview:loginButton];
    
    /** rac 设置是否能够点击*/
    RACSignal *comBineSignal = [RACSignal combineLatest:@[RACObserve(self, self.loginNameCell.textField.text)] reduce:^id(NSString *phone){
        return @([GBAppHelper isMobileNumber:phone]);
    }];
    
    RAC(loginButton,userInteractionEnabled) = comBineSignal;
    
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
    return indexPath.section == 0 ? 80 : 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGBSettingCellID];
        }
        
        cell.line.hidden = YES;
        cell.indicateButton.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    LCHomeForgetPsdPhoneCell *cellF = [LCHomeForgetPsdPhoneCell cellForTableView:tableView];
        cellF.textField.keyboardType = UIKeyboardTypePhonePad;
    cellF.textField.placeholder = @"请输入您的手机号码";
        cellF.textField.margin = 24;
    cellF.textField.font = Fit_Font(16);
    cellF.textField.textAlignment = NSTextAlignmentCenter;
    cellF.textField.backgroundColor = [UIColor clearColor];
    cellF.backgroundColor = [UIColor clearColor];

        // 手机号码textField改变值监听回调
        cellF.textValueChangedBlock = ^(NSString *valueStr) {
            if ([GBAppHelper isMobileNumber:valueStr]) {
                [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.loginButton.alpha = 1;

            }else {
                [self.loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
                self.loginButton.alpha = 0.85;
            }
        };
        self.loginNameCell = cellF;
        cellF.textFieldMargin = 24;
    
        return cellF;
}

#pragma mark - # Getters and Setters
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
        _whiteBGView.image = GBImageNamed(@"img_white_login");
        _whiteBGView.alpha = 0.35;
        _whiteBGView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _whiteBGView;
}


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end

