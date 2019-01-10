//
//  GBHomeSearchResultViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 职位、公司搜索
//  @discussion <#类的功能#>
//

#import "GBHomeSearchResultViewController.h"

#import "GBHomePageViewController.h"
#import "GBPositonDetailsViewController.h"

// Controllers
#import "GBMoreAssurePositionsViewController.h"
#import "GBMoreMastersViewController.h"
#import "GBMoreNewsViewController.h"

#import "GBServiceDetailsViewController.h"
#import "GBHomePageSearchViewController.h"
#import "GBHomeSearchResultViewController.h"
#import "GBMorePositionViewController.h"
#import "GBCompanyPositionViewController.h"

// ViewModels


// Models
#import "GBBannerModel.h"
#import "GBRankModel.h"
#import "GBNewsModel.h"
#import "GBAssureMasterModel.h"
#import "GBPositionModel.h"
#import "GBConsultingDecryptsModel.h"
#import "CompanyModel.h"
#import "GBPositionCommonModel.h"

// Views
#import "GBNavSearchBarView.h"
#import "GBHomePageHeadView.h"
//#import "GBPersonalSectionHeadView.h"
#import "GBPersonalSectionHeadView.h"
#import "GBSearchCompanyCardHeadView.h"

/** 第一组图文 */
#import "GBImageTitleCell.h"
#import "GBAssuredMasterTableViewCell.h"
#import "GBAssuredPositionCell.h"
#import "GBConsultingCell.h"
#import "GBRankingTableViewCell.h"
#import "GBNewsOnePicCell.h"
#import "GBPositionTableViewCell.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 150
#define NAV_HEIGHT 64

static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
//static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

static NSString *const kGBImageTitleCellID = @"GBImageTitleCell";
static NSString *const kGBAssuredMasterTableViewCellID = @"GBAssuredMasterTableViewCell";
static NSString *const kGBAssuredPositionCellID = @"GBAssuredPositionCell";
static NSString *const kGBConsultingCellID = @"GBConsultingCell";
static NSString *const kGBRankingTableViewCellID = @"GBRankingTableViewCell";
static NSString *const kGBNewsOnePicCellID = @"GBNewsOnePicCell";
static NSString *const kGBPositionTableViewCellID = @"GBPositionTableViewCell";

@interface GBHomeSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,PYSearchViewControllerDelegate>
/* 头图 */
@property (nonatomic, strong) GBHomePageHeadView *headView;
/* <#describe#> */
@property (nonatomic, strong) GBNavSearchBarView *searchBar;
/* 组标题 */
@property (nonatomic, strong) NSMutableArray *sectionTitleListArray;
@property (nonatomic, strong) NSMutableArray *sectionSubTitleListArray;

/* 广告 */
@property (nonatomic, strong) NSMutableArray <GBBannerModel *> *banners;
/** 排行 */
@property (nonatomic, strong) NSMutableArray <GBRankModel *> *ranks;
/** 大师 */
@property (nonatomic, strong) NSMutableArray <GBAssureMasterModel *> *assureMasters;
/** 职位 */
@property (nonatomic, strong) NSMutableArray <GBPositionModel *> *assurePositions;
/** 咨询老师机解密 */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *consultingDecrypts;
/** 软文 */
@property (nonatomic, strong) NSMutableArray <GBNewsModel *> *news;

/**
 *  推荐职位模型数组
 */
@property (nonatomic, strong) NSMutableArray <GBPositionCommonModel *> *positionModelArray;

/* 帮助 */
@property (nonatomic, copy) NSString *orderCount;

/* 认证员工 */
@property (nonatomic, copy) NSString *incumbentCount;
/* <#describe#> */
@property (nonatomic, strong) GBHomeSearchResultViewController *searchResultVC;
/* <#describe#> */
@property (nonatomic, copy) NSString *searchText;
/* <#describe#> */
@property (nonatomic, strong) GBSearchCompanyCardHeadView *searchCompanyCardHeadView;

/* <#describe#> */
@property (nonatomic, strong) GBFiltrateModel *positionFiltrateModel;

/* <#describe#> */
@property (nonatomic, strong) CompanyModel *companyModel;

/* <#describe#> */
@property (nonatomic, copy) NSString *positionCount;
/* <#describe#> */
//@property (nonatomic, copy) NSString *companyId;

@end

@implementation GBHomeSearchResultViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, SafeAreaTopHeight+(60), SCREEN_WIDTH, SCREEN_HEIGHT - (SafeAreaTopHeight+(60)));
    self.baseTableView.height = SCREEN_HEIGHT - (SafeAreaTopHeight+(60))-SafeAreaBottomHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"首页搜索";
    
    [self setupSubView];
    
    page = 1;
}

#pragma mark - # Setup Methods
/** 公司搜索 */
- (void)loadRequestCompanySearch:(NSString *)searchText companyFiltrateModel:(GBCompanyFiltrateModel *)companyFiltrateModel {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    page = 1;
    
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestCompanySearch:searchText personelScaleCode:companyFiltrateModel.companyScaleCode industryId:companyFiltrateModel.industryId companyId:companyFiltrateModel.id];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray <CompanyModel*>*tempCompanys = [CompanyModel mj_objectArrayWithKeyValuesArray:returnValue[@"companys"]];
        
        [self.searchCompanyCardHeadView reloadHeadView:[tempCompanys lastObject]];
        
        self.companyModel = [tempCompanys lastObject];
        
        self.baseTableView.tableHeaderView = self.searchCompanyCardHeadView;
        
        self.assureMasters = [NSMutableArray arrayWithArray:[GBAssureMasterModel mj_objectArrayWithKeyValuesArray:returnValue[@"incumbents"]]];
        
        self.assurePositions = [NSMutableArray arrayWithArray:[GBPositionModel mj_objectArrayWithKeyValuesArray:returnValue[@"positions"]]];
        
        self.consultingDecrypts = [NSMutableArray arrayWithArray:[GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"decrypts"]]];
        
        self.positionCount = returnValue[@"positionCount"];
        
        [self.baseTableView reloadData];
        
        if (tempCompanys.count) {
            [self removeNoDataImage];
        }else {
            [self showNoDataImage];
        }
    }];
}

/** 职位搜索 */
- (void)loadRequestPositionSearch:(NSString *)searchText filtrateModel:(GBFiltrateModel *)filtrateModel {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    page = 1;

    self.positionFiltrateModel = filtrateModel;
    
    self.searchText = searchText;
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestPositionSearch:page pageSize:3 jobName:searchText minSalary:filtrateModel.minSalary maxSalary:filtrateModel.maxSalary experienceCode:filtrateModel.experienceCode];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        self.baseTableView.tableHeaderView = nil;
        
        self.assureMasters = [NSMutableArray arrayWithArray:[GBAssureMasterModel mj_objectArrayWithKeyValuesArray:returnValue[@"incumbents"]]];
        
        self.assurePositions = [NSMutableArray arrayWithArray:[GBPositionModel mj_objectArrayWithKeyValuesArray:returnValue[@"assurePositions"]]];
        self.positionModelArray = [NSMutableArray arrayWithArray:[GBPositionCommonModel mj_objectArrayWithKeyValuesArray:returnValue[@"positions"]]];

        self.consultingDecrypts = [NSMutableArray arrayWithArray:[GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"decrypts"]]];
        
        [self.baseTableView reloadData];
        
        if (self.assureMasters.count || self.assurePositions.count || self.positionModelArray.count || self.consultingDecrypts.count) {
            [self removeNoDataImage];
        }else {
            [self showNoDataImage];
        }
    }];
    
}

- (void)setupNavBar {
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    
    if (@available(iOS 11.0, *)) {
        self.baseTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.customNavBar.barBackgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0];
    [self.customNavBar wr_setBackgroundAlpha:0];
    self.customNavBar.titleLabelColor = [UIColor clearColor];
}

- (void)setupSubView {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.sectionFooterHeight = 0.00001;
    
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    
    [self.baseTableView registerClass:[GBImageTitleCell class] forCellReuseIdentifier:kGBImageTitleCellID];
    [self.baseTableView registerClass:[GBAssuredMasterTableViewCell class] forCellReuseIdentifier:kGBAssuredMasterTableViewCellID];
    [self.baseTableView registerClass:[GBAssuredPositionCell class] forCellReuseIdentifier:kGBAssuredPositionCellID];
    [self.baseTableView registerClass:[GBConsultingCell class] forCellReuseIdentifier:kGBConsultingCellID];
    [self.baseTableView registerClass:[GBRankingTableViewCell class] forCellReuseIdentifier:kGBRankingTableViewCellID];
    [self.baseTableView registerClass:[GBNewsOnePicCell class] forCellReuseIdentifier:kGBNewsOnePicCellID];
    [self.baseTableView registerClass:[GBPositionTableViewCell class] forCellReuseIdentifier:kGBPositionTableViewCellID];
    
    [self.view addSubview:self.baseTableView];
    self.baseTableView.top = 0;
    
    [self.view bringSubviewToFront:self.baseTableView];
}


#pragma mark - # Event Response
- (void)footerRereshing {
    [super footerRereshing];
    if (self.searchType == SearchTypePosition) {
        [self loadRequestMorePositionRelatedDecrypts];
    }else {
        [self loadRequestMoreCompanyDecrypts];
    }
}

- (void)loadRequestMorePositionRelatedDecrypts {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestMorePositionRelatedDecrypts:page pageSize:10 jobName:self.searchText];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
        // 加载更多
        [self.consultingDecrypts addObjectsFromArray:returnDataArray];
        
        [self.baseTableView reloadData];
        if (returnDataArray.count < 10) {
            [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.baseTableView.mj_footer endRefreshing];
        }
    }];
}

- (void)loadRequestMoreCompanyDecrypts {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestMoreCompanyDecrypts:page pageSize:10 companyId:self.companyModel.id];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
        // 加载更多
        [self.consultingDecrypts addObjectsFromArray:returnDataArray];
        
        [self.baseTableView reloadData];
        if (returnDataArray.count < 10) {
            [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.baseTableView.mj_footer endRefreshing];
        }
    }];
}

- (void)searchClickNotification:(NSNotification *)notification {
    GBHomePageSearchViewController *searchViewController = [GBHomePageSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入名称" didSearchBlock:nil];
    
    searchViewController.hotSearchStyle = PYHotSearchStyleDefault;
    
    searchViewController.delegate = self;
    searchViewController.searchResultController = self.searchResultVC;
    
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

// MARK: 更多
- (void)sectionHeadViewMoreButtonAction:(NSInteger )section {
    if (self.searchType == SearchTypePosition) {
        switch (section) {
            case 0:
            {
                GBMoreAssurePositionsViewController *moreAssurePositionVC = [[GBMoreAssurePositionsViewController alloc] init];
                [self.navigationController pushViewController:moreAssurePositionVC animated:YES];
            }
                break;
            case 1:
            {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                if (ValidStr(self.positionFiltrateModel.minSalary)) {
                    [param setObject:self.positionFiltrateModel.minSalary forKey:@"minSalary"];
                }
                if (ValidStr(self.positionFiltrateModel.maxSalary)) {
                    [param setObject:self.positionFiltrateModel.maxSalary forKey:@"maxSalary"];
                }
                if (ValidStr(self.positionFiltrateModel.experienceCode)) {
                    [param setObject:self.positionFiltrateModel.experienceCode forKey:@"experienceCode"];
                }
                
                // 进入更多
                GBMorePositionViewController *morePositionVC = [[GBMorePositionViewController alloc] init];
                morePositionVC.searchJobName = self.searchText;
                morePositionVC.param = param;
                [self.navigationController pushViewController:morePositionVC animated:YES];
            }
                break;
            case 3:
            {
                GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
                [homePageVM loadRequestRandDecrypts];
                [homePageVM setSuccessReturnBlock:^(id returnValue) {
                    self.consultingDecrypts = [NSMutableArray arrayWithArray:[GBConsultingDecryptsModel mj_objectArrayWithKeyValuesArray:returnValue]];
                    [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                    
                }];
            }
                break;
            case 4:
            {
                
            }
                break;
            case 5:
            {
                GBMoreNewsViewController *moreNewsVC = [[GBMoreNewsViewController alloc] init];
                [self.navigationController pushViewController:moreNewsVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else {
        switch (section) {
            case 0:
            {
                GBCompanyPositionViewController *companyPostionVC = [[GBCompanyPositionViewController alloc] init];
                companyPostionVC.companyModel = self.companyModel;
                [self.navigationController pushViewController:companyPostionVC animated:YES];
            }
                break;
            case 1:
            {
                GBMoreMastersViewController *moreMastersVC = [[GBMoreMastersViewController alloc] init];
                [self.navigationController pushViewController:moreMastersVC animated:YES];
            }
                break;
            case 3:
            {
                GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
                [homePageVM loadRequestRandDecrypts];
                [homePageVM setSuccessReturnBlock:^(id returnValue) {
                    self.consultingDecrypts = [NSMutableArray arrayWithArray:[GBConsultingDecryptsModel mj_objectArrayWithKeyValuesArray:returnValue]];
                    [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                    
                }];
            }
                break;
            case 4:
            {
                
            }
                break;
            case 5:
            {
                GBMoreNewsViewController *moreNewsVC = [[GBMoreNewsViewController alloc] init];
                [self.navigationController pushViewController:moreNewsVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Setter Getter Methods


#pragma mark - # Privater Methods

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.searchType == SearchTypeCompany ? self.assurePositions.count : self.assurePositions.count;
    }
    
    if (section == 1) {
        return 1;
    }
    
    return self.consultingDecrypts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
      return self.searchType == SearchTypeCompany ? 105 : 150;
    }
   
    return  indexPath.section == 1 ? self.searchType == SearchTypeCompany ? ( self.assureMasters.count ? 176 : 8): ( self.positionModelArray.count ? 176 : 8) : [tableView fd_heightForCellWithIdentifier:kGBConsultingCellID cacheByIndexPath:indexPath configuration:^(GBConsultingCell *cell) {
        [self configureConsultingCell:cell atIndexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    
    headerView.section = section;
    [headerView.moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [headerView.moreButton setImage:nil forState:UIControlStateNormal];
    headerView.moreButton.titleLabel.font = Fit_Font(12);
    
    headerView.titleLabel.text = [self.sectionTitleListArray objectAtIndex:section];
    if (self.searchType == SearchTypeCompany) {
        headerView.moreButton.hidden = section == 2 ? YES : NO;
        headerView.subTitleLabel.hidden = YES;
        [headerView.moreButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        
        BOOL hasAssurePositions = self.assurePositions.count ? YES : NO;
        if (section == 0 && !hasAssurePositions) {
            headerView.moreButton.hidden = hasAssurePositions;
            [headerView.moreButton setTitle:@"暂无数据" forState:UIControlStateNormal];
            [headerView.moreButton setTitleColor:hasAssurePositions ? [UIColor kBaseColor] : [UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        }
        
        BOOL hasAssureMaster = self.assureMasters.count ? YES : NO;
        if (section == 1 && !hasAssureMaster) {
            headerView.moreButton.hidden = hasAssureMaster;
            [headerView.moreButton setTitle:@"暂无数据" forState:UIControlStateNormal];
            [headerView.moreButton setTitleColor:hasAssureMaster ? [UIColor kBaseColor] : [UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        }
        
        BOOL hasConsultingDecrypts = self.consultingDecrypts.count ? YES : NO;
        if (section == 2 && !hasConsultingDecrypts) {
            headerView.moreButton.hidden = hasConsultingDecrypts;
            [headerView.moreButton setTitle:@"暂无数据" forState:UIControlStateNormal];
            [headerView.moreButton setTitleColor:hasConsultingDecrypts ? [UIColor kBaseColor] : [UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        }
        
    }else {
//        headerView.moreButton.hidden = section == 2 ? YES : NO;
        headerView.subTitleLabel.hidden = YES;
        [headerView.moreButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];

        BOOL hasAssurePositions = self.assurePositions.count ? YES : NO;
        if (section == 0 && !hasAssurePositions) {
            headerView.moreButton.hidden = hasAssurePositions;
            [headerView.moreButton setTitle:@"暂无数据" forState:UIControlStateNormal];
            [headerView.moreButton setTitleColor:hasAssurePositions ? [UIColor kBaseColor] : [UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        }
        
        BOOL hasPosition = self.positionModelArray.count ? YES : NO;
        if (section == 1 && !hasPosition) {
            headerView.moreButton.hidden = hasPosition;
            [headerView.moreButton setTitle:@"暂无数据" forState:UIControlStateNormal];
            [headerView.moreButton setTitleColor:hasPosition ? [UIColor kBaseColor] : [UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        }
        
        BOOL hasConsultingDecrypts = self.consultingDecrypts.count ? YES : NO;
        if (section == 2 && !hasConsultingDecrypts) {
            headerView.moreButton.hidden = hasConsultingDecrypts;
            [headerView.moreButton setTitle:@"暂无数据" forState:UIControlStateNormal];
            [headerView.moreButton setTitleColor:hasConsultingDecrypts ? [UIColor kBaseColor] : [UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        }
    }
    
   
    // 点击事件
    headerView.moreButtonClickBlock = ^(NSInteger section) {
        [self sectionHeadViewMoreButtonAction:section];
    };
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    if (self.searchType == SearchTypePosition) {
        if (indexPath.section == 0) {
            GBAssuredPositionCell *assuredPosititionCell = [tableView cellForRowAtIndexPath:indexPath];
            if (!assuredPosititionCell) {
                assuredPosititionCell = [[GBAssuredPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredPositionCellID];
            }
            
            [self configureAssuredPositionCell:assuredPosititionCell atIndexPath:indexPath];
            
            return assuredPosititionCell;
        }
        
        if (indexPath.section == 1) {
            GBPositionTableViewCell *positionCell = [tableView cellForRowAtIndexPath:indexPath];
            if (!positionCell) {
                positionCell = [[GBPositionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBPositionTableViewCellID];
            }
            [self configurePositionCell:positionCell atIndexPath:indexPath];
            return positionCell;
        }
        
        if (indexPath.section == 2) {
            GBConsultingCell *consultingCell = [tableView cellForRowAtIndexPath:indexPath];
            if (!consultingCell) {
                consultingCell = [[GBConsultingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBConsultingCellID];
            }
            [self configureConsultingCell:consultingCell atIndexPath:indexPath];
            return consultingCell;
        }
    }
    
    if (self.searchType == SearchTypeCompany) {
        if (indexPath.section == 0) {
            GBAssuredPositionCell *assuredPosititionCell = [tableView cellForRowAtIndexPath:indexPath];
            if (!assuredPosititionCell) {
                assuredPosititionCell = [[GBAssuredPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredPositionCellID];
            }
            assuredPosititionCell.positionCellType = PositionCellTypeCompanySearch;

            [self configureAssuredPositionCell:assuredPosititionCell atIndexPath:indexPath];
            
            return assuredPosititionCell;
        }
        
        if (indexPath.section == 1) {
            GBAssuredMasterTableViewCell *assuredMasterCell = [tableView cellForRowAtIndexPath:indexPath];
            if (!assuredMasterCell) {
                assuredMasterCell = [[GBAssuredMasterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredMasterTableViewCellID];
            }
            assuredMasterCell.masterCardCellType = MasterCardCellTypeCompanySearch;
            [self configureIAssuredMasterCell:assuredMasterCell atIndexPath:indexPath];
            return assuredMasterCell;
        }
        
        if (indexPath.section == 2) {
            GBConsultingCell *consultingCell = [tableView cellForRowAtIndexPath:indexPath];
            if (!consultingCell) {
                consultingCell = [[GBConsultingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBConsultingCellID];
            }
            
            [self configureConsultingCell:consultingCell atIndexPath:indexPath];
            return consultingCell;
        }
    }
    
    GBNewsOnePicCell *newsOnePicCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!newsOnePicCell) {
        newsOnePicCell = [[GBNewsOnePicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBNewsOnePicCellID];
    }
    [self configureNewsOnePicCell:newsOnePicCell atIndexPath:indexPath];
    return newsOnePicCell;
}

// 第1组图文cell
- (void)configureImageTitleCell:(GBImageTitleCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.banner = self.banners[indexPath.row];
}

// 第2组保过大师cell
- (void)configureIAssuredMasterCell:(GBAssuredMasterTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.assureMasters = self.assureMasters;
    
}

// 第3组保过职位cell
- (void)configureAssuredPositionCell:(GBAssuredPositionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.positionModel = self.assurePositions[indexPath.row];
    
}
// 第4组咨询cell
- (void)configureConsultingCell:(GBConsultingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.consultingDecryptsModel = self.consultingDecrypts[indexPath.row];
    
}
// 第5组排行榜cell
- (void)configureRankingTableViewCell:(GBRankingTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.ranks = self.ranks;
    
}
// 第6组推荐cell
- (void)configureNewsOnePicCell:(GBNewsOnePicCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.newsModel = self.news[indexPath.row];
}

// 推荐职位cell
- (void)configurePositionCell:(GBPositionTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.positionModelArray = self.positionModelArray;
    
    [cell.collectionView reloadData];
    
    cell.didselectMoreBlock = ^{
        // 进入更多
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        if (ValidStr(self.positionFiltrateModel.minSalary)) {
            [param setObject:self.positionFiltrateModel.minSalary forKey:@"minSalary"];
        }
        if (ValidStr(self.positionFiltrateModel.maxSalary)) {
            [param setObject:self.positionFiltrateModel.maxSalary forKey:@"maxSalary"];
        }
        if (ValidStr(self.positionFiltrateModel.experienceCode)) {
            [param setObject:self.positionFiltrateModel.experienceCode forKey:@"experienceCode"];
        }
        // 进入更多
        GBMorePositionViewController *morePositionVC = [[GBMorePositionViewController alloc] init];
        morePositionVC.searchJobName = self.searchText;
        morePositionVC.param = param;
        [self.navigationController pushViewController:morePositionVC animated:YES];
    };
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.searchType == SearchTypePosition) {
        
        switch (indexPath.section) {
            case 0:
            case 2:
            {
                GBServiceDetailsViewController *decryptionDetails = [[GBServiceDetailsViewController alloc] init];
                if (indexPath.section == 0) {
                    // 保过
                    decryptionDetails.serviceDetailsType = ServiceDetailsTypeAssured;
                    decryptionDetails.serviceModel.incumbentAssurePassId = self.assurePositions[indexPath.row].incumbentAssurePassId;
                    decryptionDetails.serviceModel.publisherId = self.assurePositions[indexPath.row].userId;

                }else if (indexPath.section == 2) {
                    // 解密
                    decryptionDetails.serviceDetailsType = ServiceDetailsTypeDecryption;
                    decryptionDetails.serviceModel.incumbentDecryptId = self.consultingDecrypts[indexPath.row].incumbentDecryptId;
                    decryptionDetails.serviceModel.publisherId = self.consultingDecrypts[indexPath.row].userId;
                }
                
                
                
                [self.navigationController pushViewController:decryptionDetails animated:YES];
                
            }
                break;
            case 3:
            {
                
                GBServiceDetailsViewController *decryptionDetails = [[GBServiceDetailsViewController alloc] init];
                decryptionDetails.serviceDetailsType = ServiceDetailsTypeDecryption;
                decryptionDetails.serviceModel.incumbentDecryptId = [self.consultingDecrypts objectAtIndex:indexPath.row].incumbentDecryptId;
                [self.navigationController pushViewController:decryptionDetails animated:YES];
            }
                break;
            case 4:
            {
                
            }
                break;
            case 5:
            {
                GBMoreNewsViewController *moreNewsVC = [[GBMoreNewsViewController alloc] init];
                [self.navigationController pushViewController:moreNewsVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (self.searchType == SearchTypeCompany) {
        switch (indexPath.section) {
            case 0:
                {
                    GBPositonDetailsViewController *positionDetailVC = [[GBPositonDetailsViewController alloc] init];
                    positionDetailVC.positionModel.id = [self.assurePositions objectAtIndex:indexPath.row].id;
                    [[GBAppHelper getPushNavigationContr] pushViewController:positionDetailVC animated:YES];
                }
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - # Getters and Setters
- (GBHomeSearchResultViewController*)searchResultVC {
    if (!_searchResultVC) {
        _searchResultVC = [[GBHomeSearchResultViewController alloc] init];
    }
    
    return _searchResultVC;
}

- (GBHomePageHeadView *)headView {
    if (!_headView) {
        _headView = [[GBHomePageHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Fit_W_H(IMAGE_HEIGHT))];
    }
    
    return _headView;
}

- (NSMutableArray *)sectionTitleListArray {
        if (self.searchType == SearchTypePosition) {
            _sectionTitleListArray = [NSMutableArray arrayWithArray:@[@"保过职位",@"更多职位",@"相关解密"]];
        }else {
            _sectionTitleListArray = [NSMutableArray arrayWithArray:@[@"在招职位",@"认证同事",@"相关解密"]];
    }
    
    return _sectionTitleListArray;
}

- (NSMutableArray *)sectionSubTitleListArray {
    if (!_sectionSubTitleListArray) {
        _sectionSubTitleListArray = [NSMutableArray arrayWithArray:@[@"",@"1V1式管家带路/内推保过/不入职不收费",@"面经分享/简历诊断/模拟面试/竞争力分析/公司包打听",@"公司包打听、求职技巧、技能、职场生存法则",@"",@"热门热门热门热门"]];
    }
    
    return _sectionSubTitleListArray;
}


// 公司头
- (GBSearchCompanyCardHeadView *)searchCompanyCardHeadView {
    if (!_searchCompanyCardHeadView) {
        _searchCompanyCardHeadView = [[GBSearchCompanyCardHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    }
    
    return _searchCompanyCardHeadView;
}

- (GBNavSearchBarView *)searchBar {
    if (!_searchBar) {
        _searchBar = [[GBNavSearchBarView alloc] initWithFrame:CGRectMake(GBMargin, GBMargin/2, SCREEN_WIDTH - GBMargin*2, 40)];
        //        _searchBar.typeBtn.titleLabel.font = Fit_Font(14);
        //        _searchBar.placeholdLabel.font = Fit_Font(14);
        _searchBar.backgroundColor = [UIColor whiteColor];
    }
    
    return _searchBar;
}

- (NSMutableArray *)banners {
    if (!_banners) {
        _banners = [[NSMutableArray alloc] init];
    }
    
    return _banners;
}

- (NSMutableArray *)ranks {
    if (!_ranks) {
        _ranks = [[NSMutableArray alloc] init];
    }
    
    return _ranks;
}

- (NSMutableArray *)news {
    if (!_news) {
        _news = [[NSMutableArray alloc] init];
    }
    
    return _news;
}

- (NSMutableArray *)assureMasters {
    if (!_assureMasters) {
        _assureMasters = [[NSMutableArray alloc] init];
    }
    
    return _assureMasters;
}

- (NSMutableArray *)assurePositions {
    if (!_assurePositions) {
        _assurePositions = [[NSMutableArray alloc] init];
    }
    
    return _assurePositions;
}

- (NSMutableArray *)consultingDecrypts {
    if (!_consultingDecrypts) {
        _consultingDecrypts = [[NSMutableArray alloc] init];
    }
    
    return _consultingDecrypts;
}

- (NSMutableArray *)positionModelArray {
    if (!_positionModelArray) {
        _positionModelArray = [[NSMutableArray alloc] init];
    }
    
    return _positionModelArray;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
