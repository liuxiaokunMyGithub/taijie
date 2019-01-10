//
//  GBEarningsSignificantlyViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/3.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 收益明显
//  @discussion <#类的功能#>
//

#import "GBEarningsSignificantlyViewController.h"

// Controllers


// ViewModels


// Models
#import "TransactionListModel.h"

// Views
#import "GBOrderRecodCell.h"

static NSString *const kGBOrderRecodCellID = @"GBOrderRecodCell";

@interface GBEarningsSignificantlyViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 记录列表 */
@property (nonatomic, strong) NSMutableArray <TransactionListModel *>*recordList;

@end

@implementation GBEarningsSignificantlyViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserMoneyRecordList];
    
    [self setupSubViews];
}


#pragma mark - # Setup Methods
- (void)setupSubViews {
    
    [self getUserMoneyRecordList];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 80;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBOrderRecodCell class] forCellReuseIdentifier:kGBOrderRecodCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"收益明细"];
}

#pragma mark - # Data
- (void)headerRereshing {
    [super headerRereshing];
    [self getUserMoneyRecordList];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getUserMoneyRecordList];
}

// MARK: 交易流水
- (void)getUserMoneyRecordList {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestUserMoneyRecordList:page pageSize:10 serviceType:@"" payDirection:@"IN"];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [TransactionListModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.recordList = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.recordList addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        if (self.recordList.count) {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBOrderRecodCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBOrderRecodCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGBOrderRecodCellID];
    }
    
    cell.recodeModel = self.recordList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - # Getters and Setters

- (NSMutableArray *)recordList {
    if (!_recordList) {
        _recordList = [[NSMutableArray alloc] initWithArray:@[]];
    }
    
    return _recordList;
}

#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
