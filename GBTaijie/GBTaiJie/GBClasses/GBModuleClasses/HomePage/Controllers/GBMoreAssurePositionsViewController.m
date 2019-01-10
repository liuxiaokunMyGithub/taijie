//
//  GBMoreAssurePositionsViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/15.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 更多保过职位
//  @discussion <#类的功能#>
//

#import "GBMoreAssurePositionsViewController.h"

// Controllers
#import "GBServiceDetailsViewController.h"

// ViewModels


// Models
#import "GBPositionModel.h"


// Views
#import "GBAssuredPositionCell.h"

@interface GBMoreAssurePositionsViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 职位 */
@property (nonatomic, strong) NSMutableArray <GBPositionModel *> *positions;


@end

static NSString *const kGBAssuredPositionCellID = @"GBAssuredPositionCell";

@implementation GBMoreAssurePositionsViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPositionList];
    [self setupSubView];
}

#pragma mark - # Setup Methods
- (void)setupSubView {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 150;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBAssuredPositionCell class] forCellReuseIdentifier:kGBAssuredPositionCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) title:@"更多保过职位"];
}

- (void)headerRereshing {
    [super headerRereshing];
    [self loadPositionList];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self loadPositionList];
}

- (void)loadPositionList {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestMorePositions:page pageSize:10];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBPositionModel mj_objectArrayWithKeyValuesArray:returnValue];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.positions = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.positions addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        
        if (self.positions.count) {
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
    return self.positions.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBAssuredPositionCell *assuredPosititionCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!assuredPosititionCell) {
        assuredPosititionCell = [[GBAssuredPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredPositionCellID];
    }
    assuredPosititionCell.positionModel = self.positions[indexPath.row];
    
    return assuredPosititionCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GBServiceDetailsViewController *serviceDetails = [[GBServiceDetailsViewController alloc] init];
        // 保过
        serviceDetails.serviceDetailsType = ServiceDetailsTypeAssured;
        serviceDetails.serviceModel.incumbentAssurePassId = self.positions[indexPath.row].incumbentAssurePassId;
        serviceDetails.serviceModel.publisherId = self.positions[indexPath.row].userId;
    [self.navigationController pushViewController:serviceDetails animated:YES];
}

- (NSMutableArray *)positions {
    if (!_positions) {
        _positions = [[NSMutableArray alloc] init];
    }
    
    return _positions;
}

#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
