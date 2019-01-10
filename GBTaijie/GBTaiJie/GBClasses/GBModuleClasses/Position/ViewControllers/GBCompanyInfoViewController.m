//
//  GBCompanyInfoViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/5.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBCompanyInfoViewController.h"
//#import "GBPersonalHeadView.h"
#import "GBCompanyHeadView.h"

#import "GBSettingCell.h"
#import "CompanyModel.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBCompanyInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
/* <#describe#> */
@property (nonatomic, strong) GBCompanyHeadView *companyHeadView;

@end

@implementation GBCompanyInfoViewController

#pragma mark - # Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.customNavBar.title = @"公司信息";
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    
    [self.view addSubview:self.baseTableView];
    
    [self setupNaviBar];

    self.companyHeadView.companyModel = self.companyModel;
    self.baseTableView.tableHeaderView = self.companyHeadView;
    
    if (ValidStr(self.companyModel.introduction)) {
        [self removeNoDataImage];
    }else {
        [self showNoDataImage];
    }
}

/** UI */
- (void)setupNaviBar {
    if (self.companyModel.collected) {
        // 已收藏
        [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_collect_sel")];
        @GBWeakObj(self);
        [self.customNavBar setOnClickRightButton:^{
            @GBStrongObj(self);
            GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
            [positionVM loadRequestCollectCancel:self.companyModel.id];
            [positionVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"取消收藏成功"];
                self.companyModel.collected = NO;
                [self setupNaviBar];
            }];
        }];
    }else {
        // 未收藏
        [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_collect")];
        @GBWeakObj(self);
        [self.customNavBar setOnClickRightButton:^{
            @GBStrongObj(self);
            GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
            [positionVM loadRequestCollect:self.companyModel.id  type:@"COLLECTION_TYPE_COMPANY"];
            [positionVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"收藏成功"];
                self.companyModel.collected = YES;
                [self setupNaviBar];
            }];
        }];
    }
}

#pragma mark - # Data

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
    }]+5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    cell.cellType = CellTypeDetailsLabel;
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(GBSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.line.hidden = YES;
    cell.titleLabel.text = self.companyModel.introduction;
    cell.titleLabel.numberOfLines = 0;
    
    cell.indicateButton.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.font =  Fit_Font(14);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - # Private Methods
#pragma mark - # Getters and Setters
- (CompanyModel *)companyModel {
    if (!_companyModel) {
        _companyModel = [[CompanyModel alloc] init];
    }
    
    return _companyModel;
}

- (GBCompanyHeadView *)companyHeadView {
    if (!_companyHeadView) {
        _companyHeadView = [[GBCompanyHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Fit_W_H(250))];
    }
    
    return _companyHeadView;
}
//- (GBPersonalHeadView *)personalHeadView:(CompanyModel *)positionModel {
//    if (!_personalHeadView) {
//        _personalHeadView = [[GBPersonalHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Fit_W_H(150)) name:positionModel.companyFullName position:GBNSStringFormat(@"%@ · %@",positionModel.financingScaleName,positionModel.personelScaleName) company:GBNSStringFormat(@"%@ · 已有%@名员工认证",positionModel.regionName,@"") headImage:positionModel.companyLogo];
//    }
//
//    return _personalHeadView;
//}

@end
