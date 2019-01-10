//
//  GBBalanceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 我的余额
//  @discussion <#类的功能#>
//

#import "GBBalanceViewController.h"

// Controllers


// ViewModels


// Models
#import "GBBalanceModel.h"
#import "TransactionListModel.h"

// Views
#import "GBOrderRecodCell.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 160
#define NAV_HEIGHT 64

static NSString *const kGBOrderRecodCellID = @"GBOrderRecodCell";

@interface GBBalanceViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 记录列表 */
@property (nonatomic, strong) NSMutableArray <TransactionListModel *>*recordList;

/* 表头视图 */
@property (nonatomic, strong) UIView *blanceHeadView;
@property (nonatomic, strong) UIImageView *headBgView;
@property (nonatomic, strong) UILabel *headTitleLabel;
@property (nonatomic, strong) UILabel *promptleLabel;

/* 余额模型 */
@property (nonatomic, strong) GBBalanceModel *balanceModel;

@end

@implementation GBBalanceViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"余额";
    [self getMineBalanceData];
    [self getUserMoneyRecordList];
    
    // 设置子视图
    [self setupSubViews];
    // 设置导航条
    [self setUpNavigationBar];
}

#pragma mark - # Setup Methods
// MARK: 设置头部
- (void)setupSubViews {
    [self getUserMoneyRecordList];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 80;
    self.baseTableView.sectionHeaderHeight = GBMargin/2;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBOrderRecodCell class] forCellReuseIdentifier:kGBOrderRecodCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = self.blanceHeadView;
}

- (void)setUpNavigationBar {
    [self.customNavBar wr_setLeftButtonWithImage:GBImageNamed(@"icon_back_gold")];
    
    [self.customNavBar setBarBackgroundColor:[[UIColor colorWithHexString:@"#1F1F24"] colorWithAlphaComponent:0.95]];
    self.customNavBar.titleLabelColor = [UIColor kGoldTintColor];
    
    self.StatusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - # Data
- (void)headerRereshing {
    [super headerRereshing];
    [self getUserMoneyRecordList];
    [self getMineBalanceData];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getUserMoneyRecordList];
}

// MARK: 加载余额信息
- (void)getMineBalanceData {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestBalance];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.balanceModel = [GBBalanceModel mj_objectWithKeyValues:returnValue];
        self.headTitleLabel.text = GBNSStringFormat(@"%zu币",self.balanceModel.leftToken);
    }];
}

// MARK: 交易流水
- (void)getUserMoneyRecordList {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestUserMoneyRecordList:page pageSize:10 serviceType:@"" payDirection:@"OUT"];
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
        
        self.noDataView.backgroundColor = [UIColor clearColor];
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
- (UIView *)blanceHeadView {
    if (!_blanceHeadView) {
        _blanceHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IMAGE_HEIGHT)];
        [_blanceHeadView addSubview:self.headBgView];
        [_blanceHeadView addSubview:self.headTitleLabel];
        [_blanceHeadView addSubview:self.promptleLabel];
    }
    
    return _blanceHeadView;
}

- (UIImageView *)headBgView {
    if (!_headBgView) {
        _headBgView = [[UIImageView alloc] initWithFrame:CGRectMake(-GBMargin, -10, SCREEN_WIDTH+GBMargin*2, IMAGE_HEIGHT+10)];
        _headBgView.image = GBImageNamed(@"glob_head_bg_icon");
        _headBgView.contentMode =  UIViewContentModeScaleToFill;
        
    }
    
    return _headBgView;
}

- (UILabel *)headTitleLabel {
    if (!_headTitleLabel) {
        CGRect frame = CGRectMake(GBMargin, IMAGE_HEIGHT/2-30, SCREEN_WIDTH-GBMargin*2, 30);
        _headTitleLabel = [UILabel createLabelWithFrame:frame
                                                   text:@"0币"
                                                   font:Fit_B_Font(38)
                                              textColor:[UIColor kImportantTitleTextColor]
                                          textAlignment:NSTextAlignmentCenter];
    }
    
    return _headTitleLabel;
}

- (UILabel *)promptleLabel {
    if (!_promptleLabel) {
        CGRect frame = CGRectMake(GBMargin, CGRectGetMaxY(self.headTitleLabel.frame)+GBMargin/2, SCREEN_WIDTH-GBMargin*2, 16);
        _promptleLabel = [UILabel createLabelWithFrame:frame
                                                  text:@"可在台阶消费，不可提现"
                                                  font:Fit_B_Font(11)
                                             textColor:[[UIColor colorWithHexString:@"#453B31"]colorWithAlphaComponent:0.5]                                         textAlignment:NSTextAlignmentCenter];
    }
    
    return _promptleLabel;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
