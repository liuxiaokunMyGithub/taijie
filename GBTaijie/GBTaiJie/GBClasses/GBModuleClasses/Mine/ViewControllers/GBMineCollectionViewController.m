//
//  GBMineCollectionViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 我的收藏
//  @discussion 收藏朋友、职位、企业
//

#import "GBMineCollectionViewController.h"

// Controllers
/** 职位详情 */
#import "GBPositonDetailsViewController.h"
/** 个人主页 */
#import "GBCommonPersonalHomePageViewController.h"
#import "GBCompanyHomeViewController.h"
// ViewModels


// Models
#import "GBCollectionModel.h"

// Views
#import "GBMineCollectionTableViewCell.h"
#import "GBPersonalHeadView.h"

static NSString *const kGBMineCollectionTableViewCellID = @"GBMineCollectionTableViewCell";

@interface GBMineCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
/* 收藏数据 */
@property (nonatomic, strong) NSMutableArray <GBCollectionModel *>*dataArray;
// 类型
@property (copy, nonatomic)  NSString *type;

/* 跟人主页 */
@property (nonatomic, strong) GBPersonalHeadView *personalHeadView;

@end

@implementation GBMineCollectionViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"我的收藏";

    if (self.collectionType == MineCollectionTypeFriend) {
        // 朋友
        self.type = @"COLLECTION_TYPE_USER";
    }else if (self.collectionType == MineCollectionTypePosition) {
        // 职位
        self.type = @"COLLECTION_TYPE_POSITION";
    }else if (self.collectionType == MineCollectionTypeCompany) {
        // 企业
        self.type = @"COLLECTION_TYPE_COMPANY";
    }
    
    // 加载数据
    [self getCollectionData];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 96;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBMineCollectionTableViewCell class] forCellReuseIdentifier:kGBMineCollectionTableViewCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.top = 0;
    self.baseTableView.height = (SCREEN_HEIGHT- SafeAreaTopHeight - 44 - 80 - SafeAreaBottomHeight);

}


#pragma mark - # Setup Methods
/** MARK: Data */
- (void)headerRereshing {
    [super headerRereshing];
    [self getCollectionData];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getCollectionData];
}

- (void)getCollectionData {
    GBMineViewModel *mineVC = [[GBMineViewModel alloc] init];
    [mineVC loadRequestMineCollectionList:page pageSize:10 type:self.type];
    [mineVC setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBCollectionModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
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
        
        [self reloadNoDataView];
    }];
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods
- (void)reloadNoDataView {
    if (self.dataArray.count) {
        [self removeNoDataImage];
    }else {
        self.noDataViewTopMargin = Fit_W_H(120);
        [self showNoDataImage];
    }
}

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
    GBMineCollectionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBMineCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBMineCollectionTableViewCellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.collectionModel = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.collectionType == MineCollectionTypeFriend) {
        GBCommonPersonalHomePageViewController *homePageVC = [[GBCommonPersonalHomePageViewController alloc] init];
        homePageVC.targetUsrid = GBNSStringFormat(@"%ld",(long)self.dataArray[indexPath.row].details.userId);
        [[GBAppHelper getPushNavigationContr] pushViewController:homePageVC animated:YES];
    }else if (self.collectionType == MineCollectionTypePosition) {
        GBPositonDetailsViewController *positionDetailVC = [[GBPositonDetailsViewController alloc] init];
        positionDetailVC.positionModel.id = self.dataArray[indexPath.row].details.positionId;
        positionDetailVC.positionModel.region = self.dataArray[indexPath.row].details.region;

        [[GBAppHelper getPushNavigationContr] pushViewController:positionDetailVC animated:YES];
    
    }else if (self.collectionType == MineCollectionTypeCompany) {
        GBCompanyHomeViewController *companyHM = [[GBCompanyHomeViewController alloc] init];
        companyHM.companyId = GBNSStringFormat(@"%zu",self.dataArray[indexPath.row].details.companyId);
        [[GBAppHelper getPushNavigationContr] pushViewController:companyHM animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//添加两个按钮（编辑按钮和删除按钮）
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self AlertWithTitle:@"删除所选?" message:nil andOthers:@[@"取消",@"删除"] animated:YES action:^(NSInteger index) {
            if (index == 1) {
                NSString *targetId = nil;
                if (self.collectionType == MineCollectionTypeFriend) {
                    // 朋友
                    targetId = GBNSStringFormat(@"%zu",self.dataArray[indexPath.row].details.userId);
                }else if (self.collectionType == MineCollectionTypePosition) {
                    // 职位
                    targetId = GBNSStringFormat(@"%zu",self.dataArray[indexPath.row].details.positionId);
                }else if (self.collectionType == MineCollectionTypeCompany) {
                    // 企业
                    targetId = GBNSStringFormat(@"%zu",self.dataArray[indexPath.row].details.companyId);
                }
                
                GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
                [positionVM loadRequestCollectCancel:targetId];
                [positionVM setSuccessReturnBlock:^(id returnValue) {
                    [UIView showHubWithTip:@"取消收藏成功"];
                    [self.dataArray removeObjectAtIndex:indexPath.row];
                    
                    [self.baseTableView reloadData];
                    
                    [self reloadNoDataView];

                }];
            }
        }];
    }];
    
    return  @[deleteRow];
}

#pragma mark - # Getters and Setters
- (GBPersonalHeadView *)personalHeadView:(GBCollectionModel *)peopleModel {
    if (!_personalHeadView) {
        if (self.collectionType == MineCollectionTypeFriend) {
            _personalHeadView = [[GBPersonalHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) name:peopleModel.details.nickName position:GBNSStringFormat(@"%@",peopleModel.details.companyAbbreviatedName) company:GBNSStringFormat(@"%@ · %@",peopleModel.details.regionName,peopleModel.details.companyName) headImage:peopleModel.details.headImg];
        }else if (self.collectionType == MineCollectionTypeCompany) {
            _personalHeadView = [[GBPersonalHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Fit_W_H(150)) name:peopleModel.details.companyAbbreviatedName position:GBNSStringFormat(@"%@.%@ · %@\n%@",peopleModel.details.industryName,peopleModel.details.financingScaleName,peopleModel.details.personnelScaleName,peopleModel.details.personnelScaleName) company:GBNSStringFormat(@"已有%@认证",peopleModel.details.personnelScaleName) headImage:peopleModel.details.companyLogo];
        }
    }
    
    
    return _personalHeadView;
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
