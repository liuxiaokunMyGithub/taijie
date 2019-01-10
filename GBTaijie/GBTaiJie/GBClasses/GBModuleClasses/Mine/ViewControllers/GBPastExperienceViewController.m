//
//  GBPastExperienceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/7.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 过往经验
//  @discussion <#类的功能#>
//

#import "GBPastExperienceViewController.h"

// Controllers
#import "GBAddPastExperienceViewController.h"

// ViewModels


// Models
#import "GBPastExperienceModel.h"


// Views
#import "GBPersonalSectionHeadView.h"
#import "GBPastExperienceCell.h"

static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBPastExperienceCellID = @"GBPastExperienceCell";

@interface GBPastExperienceViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 数据 */
@property (nonatomic, strong) NSMutableArray <GBPastExperienceModel *>*dataArray;

@end

@implementation GBPastExperienceViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NetDataServerInstance.forbidShowLoading = YES;
    [self headerRereshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 150;
    self.baseTableView.sectionHeaderHeight = 50;
    self.baseTableView.sectionFooterHeight = 15;
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBPastExperienceCell class] forCellReuseIdentifier:kGBPastExperienceCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"过往经验"];
    self.baseTableView.height = SCREEN_HEIGHT - SafeAreaTopHeight - BottomViewFitHeight(72);
    
    [self.view addSubview:[self setupBottomViewWithtitle:@"再来一杯过往"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
    @GBStrongObj(self);
        GBAddPastExperienceViewController *addPastExperienceVC = [[GBAddPastExperienceViewController alloc] init];
        addPastExperienceVC.addPastExperienceType = AddPastExperienceTypeNew;
        [self.navigationController pushViewController:addPastExperienceVC animated:YES];
    };
}


#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self loadRequestMineMicroExperienceList];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self loadRequestMineMicroExperienceList];
}

- (void)loadRequestMineMicroExperienceList {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineMicroExperienceList:nil];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBPastExperienceModel mj_objectArrayWithKeyValuesArray:returnValue];
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
// 编辑
- (void)editPassExperience:(UIButton *)button {
    GBAddPastExperienceViewController *addPastExperienceVC = [[GBAddPastExperienceViewController alloc] init];
    addPastExperienceVC.pastExperienceModel = self.dataArray[button.tag];
    addPastExperienceVC.addPastExperienceType = AddPastExperienceTypeEdit;
    [self.navigationController pushViewController:addPastExperienceVC animated:YES];
}

#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    
    [headerView.moreButton setImage:GBImageNamed(@"icon_compile") forState:UIControlStateNormal];
    headerView.moreButton.tag = section;
    [headerView.moreButton addTarget:self action:@selector(editPassExperience:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *shortLine = [[UIView alloc] init];
    shortLine.backgroundColor = [UIColor kBaseColor];
    [headerView addSubview:shortLine];
    [shortLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(GBMargin);
        make.centerY.equalTo(headerView);
        make.height.equalTo(@2);
        make.width.equalTo(@20);
    }];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:kGBPastExperienceCellID cacheByIndexPath:indexPath configuration:^(GBPastExperienceCell *cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBPastExperienceCell *pastExperienceCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!pastExperienceCell) {
        pastExperienceCell = [[GBPastExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBPastExperienceCellID];
    }
    
    [self configureCell:pastExperienceCell atIndexPath:indexPath];
    
    return pastExperienceCell;
}

- (void)configureCell:(GBPastExperienceCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.pastExperienceModel = self.dataArray[indexPath.section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
