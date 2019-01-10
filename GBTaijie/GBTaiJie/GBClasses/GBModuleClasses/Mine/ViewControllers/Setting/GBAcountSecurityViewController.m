//
//  GBAcountSecurityViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 安全
//  @discussion <#类的功能#>
//

#import "GBAcountSecurityViewController.h"
#import "GBModifyViewController.h"
// Views
#import "GBSettingCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBAcountSecurityViewController () <UITableViewDataSource,UITableViewDelegate>

/* settingTableView数据源 */
@property (nonatomic, strong) NSArray <NSArray *>*settingListArray;

/* 支付宝账号 */
@property (nonatomic, copy) NSString *alipayAccount;
/** 支付宝账号加星 */
@property (nonatomic, copy) NSString *alipaySecuritAccount;


@end

@implementation GBAcountSecurityViewController


#pragma mark - # Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"账户安全";
    
    [self headerRereshing];
    
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
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"安全"];
}

#pragma mark - # Event Response
- (void)headerRereshing {
    [super headerRereshing];
    [self loadRequestMineUserAlipayAccount];
}

#pragma mark - # Private Methods
- (void)loadRequestMineUserAlipayAccount {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineUserAlipayAccount];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.alipayAccount = returnValue[@"alipayAccount"];
        
        if (ValidStr(self.alipayAccount)) {
            self.alipaySecuritAccount = [DCSpeedy dc_EncryptionDisplayMessageWith:self.alipayAccount WithFirstIndex:3 surplus:4];
        }else {
            self.alipaySecuritAccount = @"未绑定";
        }
        
        [self.baseTableView reloadData];
    }];
}
#pragma mark - # Delegate
/**  MARK: UITableViewDataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    
    settingCell.cellType = (indexPath.section == 0 && indexPath.row == 0) ? CellTypeDetailsLabel : (indexPath.section == 1 && indexPath.row == 0) ? CellTypeDetailsSwitch : CellTypeDetailsLabel;
    
    if (indexPath.row == 1) {
        settingCell.contentTextField.text = self.alipaySecuritAccount;
        settingCell.contentTextField.textAlignment = NSTextAlignmentRight;
    }
    
    settingCell.titleLabel.text = self.settingListArray[indexPath.section][indexPath.row];
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return settingCell;
}

/**  MARK: UITableViewDelegate  */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        GBModifyViewController *modifyPhoneVC = [[GBModifyViewController alloc] init];
        modifyPhoneVC.modifyType = indexPath.row == 0 ? ModifyControllerTypeLoginPassWord : indexPath.row == 1 ? ModifyControllerTypeAliPayCount : ModifyControllerTypePayPassWord;
        [self.navigationController pushViewController:modifyPhoneVC animated:YES];
}

#pragma mark - # Getters and Setters
- (NSArray *)settingListArray {
    if (!_settingListArray) {
        _settingListArray = @[@[@"设置登录密码",@"设置支付宝账户",@"设置支付密码"]];
        
    }
    return _settingListArray;
}

@end
