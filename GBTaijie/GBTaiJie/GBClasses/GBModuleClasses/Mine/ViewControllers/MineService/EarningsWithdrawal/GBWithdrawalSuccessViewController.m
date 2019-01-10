//
//  GBWithdrawalSuccessViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/6.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 提现成功
//  @discussion <#类的功能#>
//

#import "GBWithdrawalSuccessViewController.h"

// Controllers


// ViewModels


// Models


// Views
#import "GBPersonalSectionHeadView.h"
#import "GBSettingCell.h"

static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBWithdrawalSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation GBWithdrawalSuccessViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 60;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"提现成功"];
    [self.view addSubview:[self setupBottomViewWithtitle:@"知道了"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
        @GBStrongObj(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}


#pragma mark - # Setup Methods


#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = @"恭喜您申请提现成功";
    headerView.titleLabel.font = Fit_M_Font(18);
    headerView.moreButton.hidden = YES;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSettingCell *settingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCell) {
        settingCell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    [self configureCell:settingCell atIndexPath:indexPath];
    
    return settingCell;
}

- (void)configureCell:(GBSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.line.hidden = YES;
    cell.indicateButton.hidden = YES;
    cell.titleLabel.text = @"工作人员将在3-5个工作日内审核完毕您的提现申请。审核成功后，系统将自动把您申请的款项转账到您的支付宝账户中。";
    cell.titleLabel.numberOfLines = 0;
    cell.titleLabel.textColor = [UIColor kAssistInfoTextColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
