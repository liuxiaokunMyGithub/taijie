//
//  GBMoreCompanyViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/28.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBMoreCompanyViewController.h"

// Controllers
#import "GBCompanyHomeViewController.h"

// ViewModels


// Models
#import "CompanyModel.h"

// Views
#import "GBCompanyListCell.h"

static NSString *const kGBCompanyListCellID = @"GBCompanyListCell";

@interface GBMoreCompanyViewController ()<UITableViewDelegate,UITableViewDataSource>
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <CompanyModel *> *dataArray;

@end

@implementation GBMoreCompanyViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRequestMoreCompanies];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 104;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBCompanyListCell class] forCellReuseIdentifier:kGBCompanyListCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"更多公司"];
    
}


#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self loadRequestMoreCompanies];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self loadRequestMoreCompanies];
}

- (void)loadRequestMoreCompanies {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestMoreCompanies:page pageSize:10 companyName:self.companyName];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [CompanyModel mj_objectArrayWithKeyValuesArray:returnValue];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBCompanyListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBCompanyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBCompanyListCellID];
    }
    
    cell.companyModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GBCompanyHomeViewController *companyHM = [[GBCompanyHomeViewController alloc] init];
    companyHM.companyId = self.dataArray[indexPath.row].id;
    [self.navigationController pushViewController:companyHM animated:YES];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
