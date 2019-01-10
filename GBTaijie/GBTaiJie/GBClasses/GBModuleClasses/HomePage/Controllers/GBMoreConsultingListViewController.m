//
//  GBMoreConsultingListViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBMoreConsultingListViewController.h"
// Controllers
#import "GBServiceDetailsViewController.h"

// ViewModels


// Models
#import "GBFindModel.h"

// Views
#import "GBConsultingCell.h"

static NSString *const kGBConsultingCellID = @"GBConsultingCell";

@interface GBMoreConsultingListViewController ()<UITableViewDelegate,UITableViewDataSource>
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *consultingLists;
@end

@implementation GBMoreConsultingListViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getMoreConsultingList];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBConsultingCell class] forCellReuseIdentifier:kGBConsultingCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"咨询老司机"];
}


#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self getMoreConsultingList];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getMoreConsultingList];
}

- (void)getMoreConsultingList {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestMoreDecrypts:page pageSize:10];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.consultingLists = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.consultingLists addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        if (self.consultingLists.count) {
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
    return self.consultingLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return [tableView fd_heightForCellWithIdentifier:kGBConsultingCellID cacheByIndexPath:indexPath configuration:^(GBConsultingCell *cell) {
            [self configureConsultingCell:cell atIndexPath:indexPath];
        }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBConsultingCell *consultingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!consultingCell) {
        consultingCell = [[GBConsultingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBConsultingCellID];
    }
    [self configureConsultingCell:consultingCell atIndexPath:indexPath];
    return consultingCell;
}

- (void)configureConsultingCell:(GBConsultingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.consultingDecryptsModel = self.consultingLists[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GBServiceDetailsViewController *decryptionDetails = [[GBServiceDetailsViewController alloc] init];
    decryptionDetails.serviceDetailsType = ServiceDetailsTypeDecryption;
    decryptionDetails.serviceModel.incumbentDecryptId = self.consultingLists[indexPath.row].incumbentDecryptId;
    decryptionDetails.serviceModel.publisherId = [self.consultingLists objectAtIndex:indexPath.row].userId;
    
    [self.navigationController pushViewController:decryptionDetails animated:YES];
}

- (NSMutableArray *)consultingLists {
    if (!_consultingLists) {
        _consultingLists = [[NSMutableArray alloc] init];
    }
    
    return _consultingLists;
}

#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
