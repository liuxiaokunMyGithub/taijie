//
//  GBAssuredServiceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 入职保过
//  @discussion 我的保过服务
//

#import "GBAssuredServiceViewController.h"

// Controllers
#import "GBDecryptionEditorViewController.h"
#import "GBAddAssureServiceViewController.h"
// ViewModels


// Models
#import "GBPositionServiceModel.h"

// Views
#import "GBAssuredServiceCell.h"

static NSString *const kGBAssuredServiceCellID = @"GBAssuredServiceCell";

@interface GBAssuredServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView数据源 */
@property (nonatomic, strong) NSMutableArray <GBPositionServiceModel *>*dataArray;

@end

@implementation GBAssuredServiceViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NetDataServerInstance.forbidShowLoading = YES;
    [self getAssuredServiceDataList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBAssuredServiceCell class] forCellReuseIdentifier:kGBAssuredServiceCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.height = (SCREEN_HEIGHT- SafeAreaTopHeight*2 - 44 - 120 - SafeAreaBottomHeight);
    self.baseTableView.top = 0;
}

#pragma mark - # Setup Methods
/** MARK: Data */
- (void)headerRereshing {
    [super headerRereshing];
    [self getAssuredServiceDataList];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getAssuredServiceDataList];
}

- (void)getAssuredServiceDataList {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineAssurePasstServiceList:page pageSize:10];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBPositionServiceModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
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
            self.noDataViewTopMargin = Fit_W_H(120);
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
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kGBAssuredServiceCellID cacheByIndexPath:indexPath configuration:^(GBAssuredServiceCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBAssuredServiceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBAssuredServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredServiceCellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(GBAssuredServiceCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.model = self.dataArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GBAddAssureServiceViewController *addAssureServiceVC = [[GBAddAssureServiceViewController alloc] init];
    addAssureServiceVC.serviceType = ServiceTypeEditAssured;
    addAssureServiceVC.serviceModel = self.dataArray[indexPath.row];
    [[GBAppHelper getPushNavigationContr] pushViewController:addAssureServiceVC animated:YES];
}

#pragma mark - # Getters and Setters
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
