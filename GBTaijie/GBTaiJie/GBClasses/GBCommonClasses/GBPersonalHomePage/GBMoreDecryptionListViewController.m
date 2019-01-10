//
//  GBMoreDecryptionListViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/17.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBMoreDecryptionListViewController.h"
// Controllers
#import "GBPersonalServiceCell.h"
#import "GBServiceDetailsViewController.h"
// ViewModels


// Models
#import "GBPositionServiceModel.h"

// Views

static NSString *const kGBPersonalServiceCellID = @"GBPersonalServiceCell";

@interface GBMoreDecryptionListViewController ()<UITableViewDelegate,UITableViewDataSource>
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBPositionServiceModel *> *decryptionArray;
@end

@implementation GBMoreDecryptionListViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRequestPersonMoreDecrypt];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBPersonalServiceCell class] forCellReuseIdentifier:kGBPersonalServiceCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"解密列表"];
}


#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self loadRequestPersonMoreDecrypt];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self loadRequestPersonMoreDecrypt];
}

- (void)loadRequestPersonMoreDecrypt {
    GBFindPeopleViewModel *findVM = [[GBFindPeopleViewModel alloc] init];
    [findVM loadRequestPersonMoreDecrypt:page pageSize:10 targetUserId:self.targetUserId];
    [findVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBPositionServiceModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.decryptionArray = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.decryptionArray addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        
        if (self.decryptionArray.count) {
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
    return self.decryptionArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return [tableView fd_heightForCellWithIdentifier:kGBPersonalServiceCellID cacheByIndexPath:indexPath configuration:^(GBPersonalServiceCell *cell) {
            [self configureServiceCell:cell atIndexPath:indexPath];
        }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBPersonalServiceCell *serviceCell = [[GBPersonalServiceCell alloc] init];
    if (!serviceCell) {
        serviceCell = [[GBPersonalServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBPersonalServiceCellID];
    }
    
    [self configureServiceCell:serviceCell atIndexPath:indexPath];
    
    return serviceCell;
}

- (void)configureServiceCell:(GBPersonalServiceCell *)cell atIndexPath:(NSIndexPath *)indexPath {
        cell.decryptionModel = self.decryptionArray[indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GBServiceDetailsViewController *decryptionDetails = [[GBServiceDetailsViewController alloc] init];
    decryptionDetails.serviceDetailsType = ServiceDetailsTypeDecryption;
    decryptionDetails.serviceModel.incumbentDecryptId = self.decryptionArray[indexPath.row].incumbentDecryptId;
    decryptionDetails.serviceModel.publisherId = [self.targetUserId integerValue];
    
    [self.navigationController pushViewController:decryptionDetails animated:YES];
}

- (NSMutableArray *)decryptionArray {
    if (!_decryptionArray) {
        _decryptionArray = [[NSMutableArray alloc] init];
    }
    
    return _decryptionArray;
}

#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
