//
//  GBDecryptionServiceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 私聊解密
//  @discussion 我的私聊解密服务
//

#import "GBDecryptionServiceViewController.h"

// Controllers
#import "GBDecryptionEditorViewController.h"
#import "GBAddDecryptionServiceViewController.h"

// ViewModels


// Models
#import "GBPositionServiceModel.h"

// Views
#import "GBDecryptionServiceCell.h"

static NSString *const kGBDecryptionServiceCellID = @"GBDecryptionServiceCell";

@interface GBDecryptionServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
/* tableView数据源 */
@property (nonatomic, strong) NSMutableArray <GBPositionServiceModel *> *decryptModelArray;

@end

@implementation GBDecryptionServiceViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     NetDataServerInstance.forbidShowLoading = YES;
    [self getDecryptionServiceDataList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"解密服务";
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBDecryptionServiceCell class] forCellReuseIdentifier:kGBDecryptionServiceCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.height = (SCREEN_HEIGHT- SafeAreaTopHeight*2 - 44 - 120 - SafeAreaBottomHeight);
    self.baseTableView.top = 0;
}


#pragma mark - # Setup Methods
/** MARK: Data */
- (void)headerRereshing {
    [super headerRereshing];
    [self getDecryptionServiceDataList];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getDecryptionServiceDataList];
}

- (void)getDecryptionServiceDataList {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineDecryptServiceList:page pageSize:10];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBPositionServiceModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.decryptModelArray = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.decryptModelArray addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        
        if (self.decryptModelArray.count) {
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
    return self.decryptModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kGBDecryptionServiceCellID cacheByIndexPath:indexPath configuration:^(GBDecryptionServiceCell *cell) {
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
    GBDecryptionServiceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBDecryptionServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBDecryptionServiceCellID];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configureCell:(GBDecryptionServiceCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.model = self.decryptModelArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GBAddDecryptionServiceViewController *decryptionEditorVC = [[GBAddDecryptionServiceViewController alloc] init];
    decryptionEditorVC.serviceType = ServiceTypeEditDecryption;
    decryptionEditorVC.serviceModel = self.decryptModelArray[indexPath.row];
    [[GBAppHelper getPushNavigationContr] pushViewController:decryptionEditorVC animated:YES];
}


#pragma mark - # Getters and Setters
- (NSMutableArray *)decryptModelArray {
    if (!_decryptModelArray) {
        _decryptModelArray = [[NSMutableArray alloc] init];
    }
    
    return _decryptModelArray;
}


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
