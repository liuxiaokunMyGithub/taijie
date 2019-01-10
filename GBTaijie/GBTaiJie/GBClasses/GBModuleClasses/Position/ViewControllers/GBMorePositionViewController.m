//
//  GBMorePositionViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 更多职位
//  @discussion <#类的功能#>
//

#import "GBMorePositionViewController.h"

// Controllers
#import "GBPositonDetailsViewController.h"

// ViewModels
#import "GBPositionViewModel.h"

// Models
#import "GBPositionModel.h"

// Views
#import "GBPositionListCell.h"

static NSString *const kGBPositionListCellID = @"GBPositionListCell";

@interface GBMorePositionViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  推荐职位模型数组
 */
@property (nonatomic, strong) NSMutableArray <GBPositionModel *> *positionModelArray;

@end

@implementation GBMorePositionViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.customNavBar.title = @"更多职位匹配";

    [self getPostionList];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 130;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBPositionListCell class] forCellReuseIdentifier:kGBPositionListCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"更多职位匹配"];
}


#pragma mark - # Setup Methods
/** MARK: Data */

- (void)headerRereshing {
    [super headerRereshing];
    [self getPostionList];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getPostionList];
}

// MARK: 匹配职位
- (void)getPostionList {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestCpositions:self.searchJobName param:self.param pageNo:page pageSize:10];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBPositionModel mj_objectArrayWithKeyValuesArray:returnValue];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.positionModelArray = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.positionModelArray addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
    }];
    
    if (self.positionModelArray.count) {
        [self removeNoDataImage];
    }else {
        [self showNoDataImage];
    }
        [self.baseCollectionView reloadData];
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.positionModelArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBPositionListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBPositionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBPositionListCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.positionModel = self.positionModelArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GBPositonDetailsViewController *positionDetailVC = [[GBPositonDetailsViewController alloc] init];
    positionDetailVC.positionModel.id = [self.positionModelArray objectAtIndex:indexPath.row].id;
    [self.navigationController pushViewController:positionDetailVC animated:YES];
}

#pragma mark - # Getters and Setters
- (NSMutableArray *)positionModelArray {
    if (!_positionModelArray) {
        _positionModelArray = [[NSMutableArray alloc] init];
    }
    
    return _positionModelArray;
}

- (NSDictionary *)param {
    if (!_param) {
        _param = [[NSDictionary alloc] init];
    }
    
    return _param;
}


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
