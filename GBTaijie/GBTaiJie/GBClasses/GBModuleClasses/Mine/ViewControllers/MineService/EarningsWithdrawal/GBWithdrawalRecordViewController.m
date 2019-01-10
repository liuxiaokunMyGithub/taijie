//
//  GBWithdrawalRecordViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/6.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBWithdrawalRecordViewController.h"

// Controllers


// ViewModels


// Models
#import "GBWithdrawalRecordModel.h"

// Views
#import "GBWithdrawalRecordCell.h"

static NSString *const kGBWithdrawalRecordCellID = @"GBWithdrawalRecordCell";

@interface GBWithdrawalRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
/* <#describe#> */
@property (nonatomic, strong) NSArray *titles;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBWithdrawalRecordModel *>*dataArray;

@end

@implementation GBWithdrawalRecordViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getWithdrawalRecord];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 184;
    self.baseTableView.sectionHeaderHeight = 0.00000001;
    self.baseTableView.sectionFooterHeight = 15;
    [self.baseTableView registerClass:[GBWithdrawalRecordCell class] forCellReuseIdentifier:kGBWithdrawalRecordCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"提现记录"];
}

#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self getWithdrawalRecord];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getWithdrawalRecord];
}

- (void)getWithdrawalRecord {
 GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineWithdrawDepositList:page pageSize:10];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBWithdrawalRecordModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.dataArray = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.dataArray addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        
        if (self.dataArray.count) {
            [self removeNoDataImage];
        }else {
            [self showNoDataImage];
        }
    }];
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
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
    GBWithdrawalRecordCell *settingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCell) {
        settingCell = [[GBWithdrawalRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBWithdrawalRecordCellID];
    }
    
    [self configureCell:settingCell atIndexPath:indexPath];
    
    return settingCell;
}

- (void)configureCell:(GBWithdrawalRecordCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell setupTitleStr:self.titles];
    cell.withdrawalRecordModel = self.dataArray[indexPath.section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - # Getters and Setters
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"提交时间",@"审核时间",@"提现金额",@"审批状态",@"打款方式",@"账 户"];
    }
    
    return _titles;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end

