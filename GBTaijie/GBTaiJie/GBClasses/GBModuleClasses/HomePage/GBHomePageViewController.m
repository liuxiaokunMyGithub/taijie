//
//  GBHomePageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 首页
//  @discussion <#类的功能#>
//

#import "GBHomePageViewController.h"

// Controllers
#import "GBMoreAssurePositionsViewController.h"
#import "GBMoreMastersViewController.h"
#import "GBMoreNewsViewController.h"
#import "GBMoreMastersViewController.h"

#import "GBServiceDetailsViewController.h"
#import "GBHomePageSearchViewController.h"
#import "GBHomeSearchResultViewController.h"
#import "GBCommonPersonalHomePageViewController.h"
#import "GBMoreConsultingListViewController.h"

// ViewModels


// Models
#import "GBBannerModel.h"
#import "GBRankModel.h"
#import "GBNewsModel.h"
#import "GBAssureMasterModel.h"
#import "GBPositionModel.h"
#import "GBConsultingDecryptsModel.h"
#import "GBCompanyFiltrateModel.h"
#import "GBFindModel.h"

// Views
#import "GBNavSearchBarView.h"
#import "GBHomePageHeadView.h"
#import "GBSectionHeadView.h"
#import "GBPersonalSectionHeadView.h"
/** 第一组图文 */
#import "GBImageTitleCell.h"
#import "GBAssuredMasterTableViewCell.h"
#import "GBAssuredPositionCell.h"
#import "GBConsultingCell.h"
#import "GBRankingTableViewCell.h"
#import "GBNewsOnePicCell.h"

#import "GBRedPacketsView.h"
#import "MXRGuideMaskView.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2+GBMargin)
#define IMAGE_HEIGHT 150
#define NAV_HEIGHT 64

static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBSectionHeadViewID = @"GBSectionHeadView";

static NSString *const kGBImageTitleCellID = @"GBImageTitleCell";
static NSString *const kGBAssuredMasterTableViewCellID = @"GBAssuredMasterTableViewCell";
static NSString *const kGBAssuredPositionCellID = @"GBAssuredPositionCell";
static NSString *const kGBConsultingCellID = @"GBConsultingCell";
static NSString *const kGBRankingTableViewCellID = @"GBRankingTableViewCell";
static NSString *const kGBNewsOnePicCellID = @"GBNewsOnePicCell";

@interface GBHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,PYSearchViewControllerDelegate>
/* 头图 */
@property (nonatomic, strong) GBHomePageHeadView *headView;
/* <#describe#> */
@property (nonatomic, strong) GBNavSearchBarView *searchBarView;
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
@property (nonatomic, strong) NSMutableArray <GBPositionModel *> *positions;
/** 咨询老师机解密 */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *consultingDecrypts;

/** 软文 */
@property (nonatomic, strong) NSMutableArray <GBNewsModel *> *news;

/* 帮助 */
@property (nonatomic, copy) NSString *orderCount;
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *bannerImages;
/* 认证员工 */
@property (nonatomic, copy) NSString *incumbentCount;
/* <#describe#> */
@property (nonatomic, strong) GBHomePageSearchViewController *searchViewController;
/* <#describe#> */
@property (nonatomic, strong) GBHomeSearchResultViewController *searchResultVC;
/* <#describe#> */
@property (nonatomic, copy) NSString *searchText;

@end

@implementation GBHomePageViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:HomePage_H5_RankingClickNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"首页";
    
    [self loadHomePageList];
    
    [self setupNavBar];
    [self setupSubView];
    
    @GBWeakObj(self);
    self.headView.searchBar.serchBarDidClickBlock = ^{
        @GBStrongObj(self);
        // 头视图的搜索
        [self searchClickAction];
    };
    
    self.searchBarView.serchBarDidClickBlock = ^{
        @GBStrongObj(self);
        // 导航栏的搜索
        [self searchClickAction];
    };
    
    // 排行榜个人主页
    [GBNotificationCenter addObserver:self selector:@selector(h5_RankingClickNotification:) name:HomePage_H5_RankingClickNotification object:nil];
    
    if (!ValidStr([GBUserDefaults stringForKey:UDK_Gird_Finish_HomePage])) {
        // 引导页
        [self guidPageView];
    }else {
        if (ValidStr([GBUserDefaults stringForKey:UDK_Login_First])) {
            if (ValidStr([GBUserDefaults stringForKey:UDK_UserId])) {
                // 已经登录过一次 判断接口是否打开红包
                GBCommonViewModel *commonVM = [[GBCommonViewModel alloc] init];
                [commonVM loadRequestCheckRedPacketOpened];
                [commonVM setSuccessReturnBlock:^(id returnValue) {
                    BOOL hasOpend = [returnValue boolValue];
                    if (!hasOpend) {
                        // 未领取 - 显示红包
                        [GBRedPacketsView showRedPacketJoinView:KEYWINDOW margin:0];
                    }
                }];
            }
        }else {
            // 红包
            [GBRedPacketsView showRedPacketJoinView:KEYWINDOW margin:0];
        }
    }
}

- (void)guidPageView {
    NSArray * imageArr = @[@"newbie_guide01",@"newbie_guide02"];
    CGRect rect0 = self.baseTableView.frame;
    CGRect rect1 = self.baseTableView.frame;
    NSArray * imgFrameArr = @[[NSValue valueWithCGRect:CGRectMake(rect0.origin.x+GBMargin, Fit_W_H(IMAGE_HEIGHT)+10, 239, 406)],
                              [NSValue valueWithCGRect:CGRectMake(rect1.origin.x + GBMargin/2,Fit_W_H(IMAGE_HEIGHT)/2+3
                                                                  , SCREEN_WIDTH-GBMargin, 225)],
                              ];
    
    NSArray * transparentRectArr = @[[NSValue valueWithCGRect:rect0],[NSValue valueWithCGRect:rect1]];
    
    NSArray * orderArr = @[@1,@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    [maskView addImages:imageArr imageFrame:imgFrameArr TransparentRect:transparentRectArr orderArr:orderArr];
    maskView.didDismissMaskViewBlock = ^{
        [GBUserDefaults setObject:@"Gird_Finish_HomePage" forKey:UDK_Gird_Finish_HomePage];
        [GBUserDefaults synchronize];
        
        // 红包
        [GBRedPacketsView showRedPacketJoinView:KEYWINDOW margin:0];
    };
    [maskView showMaskViewInView:KEYWINDOW];
}

#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self loadHomePageList];
}

// MARK:  Data
- (void)loadHomePageList {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestHomePageList];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        self.orderCount = returnValue[@"orderCount"];
        self.incumbentCount = returnValue[@"incumbentCount"];
        self.headView.numberTitleLabel.text = GBNSStringFormat(@"%@位认证员工，已帮助%@人加入理想公司",self.incumbentCount,self.orderCount );
        self.banners = [NSMutableArray arrayWithArray:[GBBannerModel mj_objectArrayWithKeyValuesArray:returnValue[@"advertisements"]]];
        
        for (GBBannerModel *model in self.banners) {
            self.bannerImages = [NSMutableArray arrayWithObject:GBImageURL(model.advertisementImg)];
        }
        
        self.ranks = [NSMutableArray arrayWithArray:[GBRankModel mj_objectArrayWithKeyValuesArray:returnValue[@"ranks"]]];
        
        self.assureMasters = [NSMutableArray arrayWithArray:[GBAssureMasterModel mj_objectArrayWithKeyValuesArray:returnValue[@"incumbents"]]];
        
        self.positions = [NSMutableArray arrayWithArray:[GBPositionModel mj_objectArrayWithKeyValuesArray:returnValue[@"positions"]]];
        
        self.consultingDecrypts = [NSMutableArray arrayWithArray:[GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"decrypts"]]];
        
        self.news = [NSMutableArray arrayWithArray:[GBNewsModel mj_objectArrayWithKeyValuesArray:returnValue[@"essays"]]];
        
        [self.baseTableView reloadData];
        
        if (self.loadingStyle == LoadingDataRefresh) {
            [self.baseTableView.mj_header endRefreshing];
        }
    }];
}

- (void)setupNavBar {
    //    self.StatusBarStyle = UIStatusBarStyleLightContent;
    
    if (@available(iOS 11.0, *)) {
        self.baseTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.customNavBar.barBackgroundColor = [UIColor clearColor];
    [self.customNavBar wr_setBackgroundAlpha:0];
    self.customNavBar.titleLabelColor = [UIColor clearColor];
}

- (void)setupSubView {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 60;
    self.baseTableView.sectionFooterHeight = 0.00001;
    
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBSectionHeadViewID];
    
    [self.baseTableView registerClass:[GBImageTitleCell class] forCellReuseIdentifier:kGBImageTitleCellID];
    [self.baseTableView registerClass:[GBAssuredMasterTableViewCell class] forCellReuseIdentifier:kGBAssuredMasterTableViewCellID];
    [self.baseTableView registerClass:[GBAssuredPositionCell class] forCellReuseIdentifier:kGBAssuredPositionCellID];
    [self.baseTableView registerClass:[GBConsultingCell class] forCellReuseIdentifier:kGBConsultingCellID];
    [self.baseTableView registerClass:[GBRankingTableViewCell class] forCellReuseIdentifier:kGBRankingTableViewCellID];
    [self.baseTableView registerClass:[GBNewsOnePicCell class] forCellReuseIdentifier:kGBNewsOnePicCellID];
    
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = self.headView;
    self.customNavBar = [[WRCustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    [self.view insertSubview:self.customNavBar aboveSubview:self.baseTableView];
    // 设置导航栏显示图片
    //    self.customNavBar.backgroundColor = [UIColor clearColor];
    
    self.customNavBar.barBackgroundImage = GBImageNamed(@"Home_Head_img_background");
    [self.customNavBar addSubview:self.searchBarView];
    self.searchBarView.alpha = 0;
    self.searchBarView.centerY = self.customNavBar.centerY+StatusBarHeight/2;
    // 设置初始导航栏透明度
    [self.customNavBar wr_setBackgroundAlpha:0];
    self.customNavBar.alpha = 0;
}

#pragma mark - # Event Response
- (void)h5_RankingClickNotification:(NSNotification *)notification {
    NSString *targetUserId = [notification.object    stringByReplacingOccurrencesOfString:@"'" withString:@""];
    GBCommonPersonalHomePageViewController *homePageVC = [[GBCommonPersonalHomePageViewController alloc] init];
    homePageVC.targetUsrid = targetUserId;
    [self.navigationController pushViewController:homePageVC animated:YES];
}

/** 搜索 */
- (void)searchClickAction {
    GBHomePageSearchViewController *searchViewController = [GBHomePageSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入名称" didSearchBlock:nil];
    
    searchViewController.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    searchViewController.delegate = self;
    searchViewController.searchResultController = self.searchResultVC;
    searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
    [self.navigationController pushViewController:searchViewController animated:YES];
    self.searchViewController = searchViewController;
    // 筛选
    @GBWeakObj(self);
    self.searchViewController.filtrateBlock = ^(GBFiltrateModel *filtrateModel) {
        @GBStrongObj(self);
        [self.searchResultVC loadRequestPositionSearch:self.searchText filtrateModel:self.searchViewController.filtrateModel];
    };
}

- (void)sectionHeadViewMoreButtonAction:(NSInteger )section {
    switch (section) {
        case 1:
        {
            GBMoreMastersViewController *moreMastersVC = [[GBMoreMastersViewController alloc] init];
            [self.navigationController pushViewController:moreMastersVC animated:YES];
        }
            break;
        case 2:
        {
            GBMoreAssurePositionsViewController *moreAssurePositionVC = [[GBMoreAssurePositionsViewController alloc] init];
            [self.navigationController pushViewController:moreAssurePositionVC animated:YES];
            
        }
            break;
        case 3:
        {
            //            GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
            //            [homePageVM loadRequestRandDecrypts];
            //            [homePageVM setSuccessReturnBlock:^(id returnValue) {
            //                self.consultingDecrypts = [NSMutableArray arrayWithArray:[GBFindModel mj_objectArrayWithKeyValuesArray:returnValue]];
            //                [self.baseTableView reloadData];
            //
            //            }];
            GBMoreConsultingListViewController *moreConsulVC = [[GBMoreConsultingListViewController alloc] init];
            [self.navigationController pushViewController:moreConsulVC animated:YES];
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

#pragma mark - Setter Getter Methods


#pragma mark - # Privater Methods
///**  MARK: scrollViewDidScroll-更新导航栏  */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT){
        //        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self.customNavBar wr_setBackgroundAlpha:1];
        self.searchBarView.alpha = 1;
        self.customNavBar.alpha = 1;
    }else{
        [self.customNavBar wr_setBackgroundAlpha:0];
        self.searchBarView.alpha = 0;
        self.customNavBar.alpha = 0;
    }
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {
    NSLog(@"搜索searchText:%@",searchText);
    if (searchText.length) {
        self.searchText = searchText;
        self.searchViewController.tagsView.hidden = NO;
        self.searchViewController.baseSearchTableView.backgroundColor = [UIColor clearColor];
        self.searchViewController.baseSearchTableView.alpha = 0;
        
        if (self.searchViewController.searchType == SearchTypeCompany) {
            // 公司搜索
            self.searchResultVC.searchType = SearchTypeCompany;
            
            [self.searchResultVC loadRequestCompanySearch:searchText companyFiltrateModel:self.searchViewController.companyFitrateModel];
        }else {
            // 职位搜索
            self.searchResultVC.searchType = SearchTypePosition;
            
            [self.searchResultVC loadRequestPositionSearch:searchText filtrateModel:self.searchViewController.filtrateModel];
        }
    }
}

- (void)searchViewController:(PYSearchViewController *)searchViewController
         searchTextDidChange:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {
    NSLog(@"实时搜索searchText:%@",searchText);
    if (searchText.length) {
        if (self.searchViewController.searchType == SearchTypeCompany) {
            GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
            [homePageVM loadRequestCompanyNamesSearch:searchText];
            [homePageVM setSuccessReturnBlock:^(id returnValue) {
                NSMutableArray *searchSuggestionsM = [NSMutableArray array];
                NSMutableArray <GBCompanyFiltrateModel *>*tempArray = [GBCompanyFiltrateModel mj_objectArrayWithKeyValuesArray:returnValue];
                for (GBCompanyFiltrateModel *companyFiltrateModel in tempArray) {
                    [searchSuggestionsM addObject:companyFiltrateModel.companyFullName];
                }
                searchViewController.searchSuggestions = searchSuggestionsM;
            }];
        }
    }
}

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.positions.count;
    }
    
    if (section == 3) {
        return self.consultingDecrypts.count;
    }
    
    if (section == 5) {
        return self.news.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:kGBImageTitleCellID cacheByIndexPath:indexPath configuration:^(GBImageTitleCell *cell) {
            [self configureImageTitleCell:cell atIndexPath:indexPath];
        }];
    }
    
    if (indexPath.section == 1) {
        return 176;
    }
    
    if (indexPath.section == 2) {
        return 150;
    }
    
    if (indexPath.section == 3) {
        return [tableView fd_heightForCellWithIdentifier:kGBConsultingCellID cacheByIndexPath:indexPath configuration:^(GBConsultingCell *cell) {
            [self configureConsultingCell:cell atIndexPath:indexPath];
        }];
        
    }
    
    if (indexPath.section == 4) {
        return 180;
    }
    return 116;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBSectionHeadView alloc] initWithReuseIdentifier:kGBSectionHeadViewID];
    }
    headerView.section = section;
    [headerView.moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [headerView.moreButton setImage:nil forState:UIControlStateNormal];
    headerView.moreButton.titleLabel.font = Fit_Font(12);
    //    if (section == 3) {
    //        [headerView.moreButton setTitle:@"换一批" forState:UIControlStateNormal];
    //        [headerView.moreButton setImage:GBImageNamed(@"icon_update") forState:UIControlStateNormal];
    //    }
    //
    headerView.titleLabel.text = [self.sectionTitleListArray objectAtIndex:section];
    headerView.subTitleLabel.text = [self.sectionSubTitleListArray objectAtIndex:section];
    
    headerView.titleLabel.font = section == 0 ? Fit_Font(14) : Fit_M_Font(18);
    headerView.moreButton.hidden = section == 0 || section == 4 ? YES : NO;
    
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
    if (indexPath.section == 0) {
        GBImageTitleCell *imageTitleCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!imageTitleCell) {
            imageTitleCell = [[GBImageTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBImageTitleCellID];
        }
        [self configureImageTitleCell:imageTitleCell atIndexPath:indexPath];
        return imageTitleCell;
    }
    
    if (indexPath.section == 1) {
        GBAssuredMasterTableViewCell *assuredMasterCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!assuredMasterCell) {
            assuredMasterCell = [[GBAssuredMasterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredMasterTableViewCellID];
        }
        [self configureIAssuredMasterCell:assuredMasterCell atIndexPath:indexPath];
        return assuredMasterCell;
    }
    
    if (indexPath.section == 2) {
        GBAssuredPositionCell *assuredPosititionCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!assuredPosititionCell) {
            assuredPosititionCell = [[GBAssuredPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredPositionCellID];
        }
        
        [self configureAssuredPositionCell:assuredPosititionCell atIndexPath:indexPath];
        
        return assuredPosititionCell;
    }
    
    if (indexPath.section == 3) {
        GBConsultingCell *consultingCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!consultingCell) {
            consultingCell = [[GBConsultingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBConsultingCellID];
        }
        [self configureConsultingCell:consultingCell atIndexPath:indexPath];
        return consultingCell;
    }
    
    if (indexPath.section == 4) {
        GBRankingTableViewCell *rankingCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!rankingCell) {
            rankingCell = [[GBRankingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBRankingTableViewCellID];
        }
        [self configureRankingTableViewCell:rankingCell atIndexPath:indexPath];
        return rankingCell;
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
    cell.cycleScrollView.imageURLStringsGroup = self.bannerImages;
}

// 第2组保过大师cell
- (void)configureIAssuredMasterCell:(GBAssuredMasterTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.assureMasters = self.assureMasters;
}

// 第3组保过职位cell
- (void)configureAssuredPositionCell:(GBAssuredPositionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.positionModel = self.positions[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 2:
        case 3:
        {
            GBServiceDetailsViewController *decryptionDetails = [[GBServiceDetailsViewController alloc] init];
            if (indexPath.section == 2) {
                decryptionDetails.serviceDetailsType = ServiceDetailsTypeAssured;
                decryptionDetails.serviceModel.incumbentAssurePassId = self.positions[indexPath.row].incumbentAssurePassId;
                decryptionDetails.serviceModel.publisherId = [self.positions objectAtIndex:indexPath.row].userId;
                
            }else if (indexPath.section == 3) {
                decryptionDetails.serviceDetailsType = ServiceDetailsTypeDecryption;
                decryptionDetails.serviceModel.incumbentDecryptId = self.consultingDecrypts[indexPath.row].incumbentDecryptId;
                decryptionDetails.serviceModel.publisherId = [self.consultingDecrypts objectAtIndex:indexPath.row].userId;
                
            }
            
            
            [self.navigationController pushViewController:decryptionDetails animated:YES];
        }
            break;
        case 5:
        {
            GBBaseWebViewController *webView = [[GBBaseWebViewController alloc] initWithUrl:GBNSStringFormat(@"%@",self.news[indexPath.row].link)];
            webView.titleStr = @"为你推荐";
            [self.navigationController pushViewController:webView animated:YES];
            
        }
            break;
        default:
            break;
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
    if (!_sectionTitleListArray) {
        _sectionTitleListArray = [NSMutableArray arrayWithArray:@[@"尊重每一次职业选择",@"保过大师",@"最新保过职位",@"咨询老司机",@"本地排行榜",@"为你推荐"]];
    }
    
    return _sectionTitleListArray;
}

- (NSMutableArray *)sectionSubTitleListArray {
    if (!_sectionSubTitleListArray) {
        _sectionSubTitleListArray = [NSMutableArray arrayWithArray:@[@"",@"1V1式管家带路/内推保过/不入职不收费",@"面经分享/简历诊断/模拟面试/竞争力分析/公司包打听",@"公司包打听、求职技巧、技能、职场生存法则",@"",@"四顾北望，感知阅读的力量"]];
    }
    
    return _sectionSubTitleListArray;
}

- (GBNavSearchBarView *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[GBNavSearchBarView alloc] initWithFrame:CGRectMake(GBMargin, GBMargin/2, SCREEN_WIDTH - GBMargin*2, 40)];
        _searchBarView.backgroundColor = [UIColor whiteColor];
    }
    
    return _searchBarView;
}

- (NSMutableArray *)banners {
    if (!_banners) {
        _banners = [[NSMutableArray alloc] init];
    }
    
    return _banners;
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

- (NSMutableArray *)positions {
    if (!_positions) {
        _positions = [[NSMutableArray alloc] init];
    }
    
    return _positions;
}

- (NSMutableArray *)consultingDecrypts {
    if (!_consultingDecrypts) {
        _consultingDecrypts = [[NSMutableArray alloc] init];
    }
    
    return _consultingDecrypts;
}

- (NSMutableArray *)ranks {
    if (!_ranks) {
        _ranks = [[NSMutableArray alloc] init];
    }
    
    return _ranks;
}

- (NSMutableArray *)bannerImages {
    if (!_bannerImages) {
        _bannerImages = [[NSMutableArray alloc] init];
    }
    
    return _bannerImages;
}
// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
