//
//  GBFindMoreListViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBFindMoreListViewController.h"
// Controllers
#import "GBServiceDetailsViewController.h"

// ViewModels


// Models
#import "GBFindModel.h"


// Views
#import "GBFindDecryptionCell.h"

static NSString *const kGBFindDecryptionCellID = @"GBFindDecryptionCell";

@interface GBFindMoreListViewController ()<UITableViewDelegate,UITableViewDataSource>
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *consultingDecryptsModels;
/* <#describe#> */
@property (nonatomic, strong) NSArray *labelCodes;

/* <#describe#> */
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation GBFindMoreListViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadConsultingDecrypts];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBFindDecryptionCell class] forCellReuseIdentifier:kGBFindDecryptionCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:self.titleArray[self.section]];
}

- (void)headerRereshing {
    [super headerRereshing];
    [self loadConsultingDecrypts];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self loadConsultingDecrypts];
}

#pragma mark - # Setup Methods
- (void)loadConsultingDecrypts {
    GBFindViewModel *findVM = [[GBFindViewModel alloc] init];
    [findVM loadRequestFindMoreDecrypts:self.section == 0 ? YES : NO labelCode:self.labelCodes[self.section] pageNo:page pageSize:10];
    [findVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.consultingDecryptsModels = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.consultingDecryptsModels addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        if (self.consultingDecryptsModels.count) {
            [self removeNoDataImage];
        }else {
            [self showNoDataImage];
        }
    }];
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate


#pragma mark - # Getters and Setters
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.consultingDecryptsModels.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kGBFindDecryptionCellID cacheByIndexPath:indexPath configuration:^(GBFindDecryptionCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBFindDecryptionCell *settingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCell) {
        settingCell = [[GBFindDecryptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBFindDecryptionCellID];
    }
    
    [self configureCell:settingCell atIndexPath:indexPath];
    
    return settingCell;
}

- (void)configureCell:(GBFindDecryptionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.consultingDecryptsModel = self.consultingDecryptsModels[indexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GBServiceDetailsViewController *decryptionDetails = [[GBServiceDetailsViewController alloc] init];
    decryptionDetails.serviceDetailsType = ServiceDetailsTypeDecryption;
    decryptionDetails.serviceModel.incumbentDecryptId = self.consultingDecryptsModels[indexPath.row].incumbentDecryptId;
    decryptionDetails.serviceModel.publisherId = self.consultingDecryptsModels[indexPath.row].userId;
    
    [self.navigationController pushViewController:decryptionDetails animated:YES];
}

- (NSMutableArray *)consultingDecryptsModels {
    if (!_consultingDecryptsModels) {
        _consultingDecryptsModels = [[NSMutableArray alloc] init];
    }
    
    return _consultingDecryptsModels;
}

- (NSArray *)labelCodes {
    if (!_labelCodes) {
        _labelCodes = @[@"",@"DECRYPT_GSBDT",@"DECRYPT_QZJQ",@"DECRYPT_ZCSC",@"DECRYPT_ZYJN",@"DECRYPT_ZYGH",@"CUSTOMIZED"];
    }
    
    return _labelCodes;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"特价免费",@"公司包打听",@"求职技巧",@"职场生存",@"专业技能",@"职业规划",@"其他"];
    }
    
    return _titleArray;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
