//
// GBTiebaViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 帖子列表
//  @discussion 最新/最热的帖子
//

#import "GBTiebaViewController.h"

// Controllers
#import "GBTiebaDetailsViewController.h"

// ViewModels


// Models
#import "GBTiebaModel.h"

// Views
#import "GBTiebaNoPicTableViewCell.h"
#import "GBTiebaOnePicTableViewCell.h"

static NSString *const kGBTiebaNoPicTableViewCellID = @"GBTiebaNoPicTableViewCell";
static NSString *const kGBTiebaOnePicTableViewCellID = @"GBTiebaOnePicTableViewCell";

@interface GBTiebaViewController ()<UITableViewDelegate,UITableViewDataSource>
/* 帖子 */
@property (nonatomic, strong) NSMutableArray <GBTiebaModel *> *tiebaListModelArray;
@end

@implementation GBTiebaViewController


#pragma mark - LifeCyle -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:TiebaDataRefreshNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NetDataServerInstance.forbidShowLoading = YES;
    [self getTiebaListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self getTiebaListData];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.top = 0;
    self.baseTableView.height = SCREEN_HEIGHT - 60 - SafeAreaTopHeight - SafeTabBarHeight - 40;
    [self.baseTableView registerClass:[GBTiebaOnePicTableViewCell class] forCellReuseIdentifier:kGBTiebaOnePicTableViewCellID];
    [self.view addSubview:self.baseTableView];
    
    [GBNotificationCenter addObserver:self selector:@selector(getTiebaListData) name:TiebaDataRefreshNotification object:nil];
}


#pragma mark - Initial Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self getTiebaListData];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getTiebaListData];
}

- (void)getTiebaListData {
    GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
    [tiebaVM loadRequestTiebaList:page pageSize:10 orderType:self.orderType];
    [tiebaVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBTiebaModel mj_objectArrayWithKeyValuesArray:returnValue];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.tiebaListModelArray = returnDataArray;
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.tiebaListModelArray addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        
        if (self.tiebaListModelArray.count) {
            [self removeNoDataImage];
        }else {
            [self showNoDataImage];
        }
        
    }];
    
}

#pragma mark - Target Methods


#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tiebaListModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kGBTiebaOnePicTableViewCellID cacheByIndexPath:indexPath configuration:^(GBTiebaOnePicTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBTiebaOnePicTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBTiebaOnePicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBTiebaOnePicTableViewCellID];
    }

    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GBTiebaDetailsViewController *tiebaDetailsVC = [[GBTiebaDetailsViewController alloc] init];
    tiebaDetailsVC.tiebaModel = self.tiebaListModelArray[indexPath.row];
    [[GBAppHelper getPushNavigationContr] pushViewController:tiebaDetailsVC animated:YES];
}

#pragma mark - Privater Methods
- (void)configureCell:(GBTiebaOnePicTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tiebaModel = self.tiebaListModelArray[indexPath.row];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return [self.tiebaListModelArray[indexPath.row].publisherId isEqualToString:[GBUserDefaults stringForKey:UDK_UserId]] ? YES : NO;
//}
//
////添加两个按钮（编辑按钮和删除按钮）
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *deleteRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self AlertWithTitle:@"删除所选?" message:nil andOthers:@[@"取消",@"删除"] animated:YES action:^(NSInteger index) {
//            if (index == 1) {
//                GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
//                [tiebaVM  loadRequestCloseTieba:self.tiebaListModelArray[indexPath.row].gossipId];
//                [tiebaVM setSuccessReturnBlock:^(id returnValue) {
//                    [UIView showHubWithTip:@"删除成功"];
//                    [self.tiebaListModelArray removeObjectAtIndex:indexPath.row];
//                    [self.baseTableView reloadData];
//                }];
//            }
//        }];
//    }];
//    
//    return  @[deleteRow];
//}

#pragma mark - Getter Setter Methods

- (NSMutableArray *)tiebaListModelArray {
    if (!_tiebaListModelArray) {
        _tiebaListModelArray = [[NSMutableArray alloc] init];
    }
    
    return _tiebaListModelArray;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
