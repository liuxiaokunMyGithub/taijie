//
//  GBSettingViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/6.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBSettingViewController.h"
#import "GBModifyViewController.h"
#import "GBAcountSecurityViewController.h"

// Views
#import "GBSettingCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBSettingViewController () <UITableViewDataSource,UITableViewDelegate>

/* settingTableView数据源 */
@property (nonatomic, strong) NSArray <NSArray *>*settingListArray;

/* 退出登录 */
@property (nonatomic, strong) UIButton *logoutButton;
/* <#describe#> */
@property (nonatomic, strong) UILabel *versionLabel;
/* 推送开关 */
@property (nonatomic, strong) UISwitch *pushSwith;

/* 提示框 */
@property (nonatomic, strong)  SCLAlertView *alert;

@end

@implementation GBSettingViewController

#pragma mark - # Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"设置";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 56;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) title:@"设置"];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.logoutButton];
    
    [self p_addMasonry];
}

#pragma mark - # Event Response
// MARK: 退出登录
- (void)logoutButtonTouchUpInside:(UIButton *)sender {
    _alert = [[SCLAlertView alloc] init];
    [_alert setHorizontalButtons:YES];
    
    [_alert addButton:@"取消" actionBlock:nil];
    [_alert addButton:@"确定" actionBlock:^{
        // 退出登录
        [userManager logout:nil];
    }];
    _alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromBottom;
    _alert.customViewColor = [UIColor kBaseColor];
    [_alert showQuestion:self title:@"是否需要退出登录" subTitle:nil closeButtonTitle:nil duration:0.0f];
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 退出登录
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight-GBMargin);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.bottom.equalTo(self.logoutButton.mas_top).offset(-16);
    }];
}

//是否开启推送通知
- (void)switchOnOrOff:(BOOL )isOpen {
    if (isOpen) {
        if (![userManager isAllowedNotification]) {
            [UIView showHubWithTip:@"请在系统设置中打开通知"];
            self.pushSwith.on = NO;
        }else {
            [GBUserDefaults setValue:@"on" forKey:UDK_Push_Switch_State];
            [GBUserDefaults synchronize];
        }
    }else {
        [GBUserDefaults setValue:@"off" forKey:UDK_Push_Switch_State];
        [GBUserDefaults synchronize];
    }
}

#pragma mark - # Delegate
/**  MARK: UITableViewDataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingListArray[section].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSettingCell *settingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCell) {
        settingCell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    settingCell.cellType = indexPath.row == 0 ? CellTypeDetailsLabel : indexPath.row == 3 ? CellTypeDetailsSwitch : CellTypeDetailsLabel;
    
    if (indexPath.row == 0) {
        settingCell.contentTextField.text = [DCSpeedy dc_EncryptionDisplayMessageWith:userManager.currentUser.mobile WithFirstIndex:4 surplus:4];
        settingCell.contentTextField.textAlignment = NSTextAlignmentRight;
    }
    
    if (indexPath.row == 3) {
        // 消息接收设置
        self.pushSwith = settingCell.setSwitch;
        settingCell.setSwitch.on = [userManager isAllowedNotification];
        settingCell.switchChangedBlock = ^(BOOL isOpen) {
            // swith事件
            [self switchOnOrOff:isOpen];
        };
    }
    
    settingCell.indicateButton.hidden = indexPath.row == 3 ? YES : NO;
    
    settingCell.titleLabel.text = self.settingListArray[indexPath.section][indexPath.row];
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return settingCell;
}

/**  MARK: UITableViewDelegate  */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            GBModifyViewController *modifyPhoneVC = [[GBModifyViewController alloc] init];
            modifyPhoneVC.modifyType = ModifyControllerTypePhone;
            [self.navigationController pushViewController:modifyPhoneVC animated:YES];
        }
            break;
        case 1:
        {
            GBAcountSecurityViewController *acountSecurityVC = [[GBAcountSecurityViewController alloc] init];
            [self.navigationController pushViewController:acountSecurityVC animated:YES];
        }
            break;
        case 2:
        {
            GBBaseWebViewController *webView = [[GBBaseWebViewController alloc] initWithUrl:GBNSStringFormat(@"%@%@",URL_GB_HTML,HTML_User_Agreement)];
            webView.titleStr = @"服务条款";
            [self.navigationController pushViewController:webView animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - # Getters and Setters
- (NSArray *)settingListArray {
    if (!_settingListArray) {
        _settingListArray = @[@[@"修改手机号",@"安全",@"服务条款",@"新消息通知"]];
        
    }
    
    return _settingListArray;
}


- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [[UIButton alloc] init];
        [_logoutButton addTarget:self action:@selector(logoutButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _logoutButton.titleLabel.font = Fit_M_Font(17);
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        GBViewBorderRadius(_logoutButton, 2, 0.5, [UIColor kSegmentateLineColor]);
    }
    
    return _logoutButton;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = [UIColor kAssistInfoTextColor];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = Fit_Font(12);
        _versionLabel.text = @"v1.1.6";
    }
    
    return _versionLabel;
}

@end
