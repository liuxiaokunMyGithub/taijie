//
//  GBCompanyHomeViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/28.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBCompanyHomeViewController.h"

// Controllers
#import "GBPositonDetailsViewController.h"
#import "GBCompanyPositionViewController.h"

// ViewModels
#import "GBHomePageViewModel.h"

// Models
#import "CompanyModel.h"
#import "GBPositionModel.h"
#import "GBAssureMasterModel.h"

// Views
#import "GBPersonalSectionHeadView.h"
#import "GBSettingCell.h"
#import "GBAssuredPositionCell.h"
#import "GBPersonalHeadView.h"
#import "GBAssureMasterCardCell.h"
#import "GBAssuredMasterTableViewCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";
static NSString *const kGBAssuredPositionCellID = @"GBAssuredPositionCell";
static NSString *const kGBSectionHeadViewID = @"GBSectionHeadView";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBAssureMasterCardCellID = @"GBAssureMasterCardCell";
static NSString *const kGBAssuredMasterTableViewCellID = @"GBAssuredMasterTableViewCell";

@interface GBCompanyHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 职位 */
@property (nonatomic, strong) NSMutableArray <GBPositionModel *> *positions;
/** 大师 */
@property (nonatomic, strong) NSMutableArray <GBAssureMasterModel *> *assureMasters;
@property (nonatomic, strong)  NSMutableArray <CompanyModel*> *companysModels;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *sectionTitleArray;

/* 头视图 */
@property (nonatomic, strong) GBPersonalHeadView *personalHeadView;
/* <#describe#> */
@property (nonatomic, copy) NSString *incumbentsCount;
/* <#describe#> */
@property (nonatomic, copy) NSString *positionCount;

@end

@implementation GBCompanyHomeViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCompanyInfoData];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 50;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.baseTableView registerClass:[GBAssuredPositionCell class] forCellReuseIdentifier:kGBAssuredPositionCellID];
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBAssuredMasterTableViewCell class] forCellReuseIdentifier:kGBAssuredMasterTableViewCellID];

    [self.view addSubview:self.baseTableView];
}


#pragma mark - # Setup Methods
- (void)getCompanyInfoData {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestCompanyMainPage:self.companyId];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
       self.companysModels = [CompanyModel mj_objectArrayWithKeyValuesArray:returnValue[@"companys"]];
        self.incumbentsCount = returnValue[@"incumbentsCount"];
        self.positionCount = returnValue[@"positionCount"];
        
        self.baseTableView.tableHeaderView = [self personalHeadView:self.companysModels[0]];
        
        self.positions = [NSMutableArray arrayWithArray:[GBPositionModel mj_objectArrayWithKeyValuesArray:returnValue[@"positions"]]];
        self.assureMasters = [NSMutableArray arrayWithArray:[GBAssureMasterModel mj_objectArrayWithKeyValuesArray:returnValue[@"incumbents"]]];
      
        [self setupNaviBar];

        [self.baseTableView reloadData];
    }];
}

/** UI */
- (void)setupNaviBar {
    if (self.companysModels[0].collected) {
        // 已收藏
        [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_collect_sel")];
        @GBWeakObj(self);
        [self.customNavBar setOnClickRightButton:^{
            @GBStrongObj(self);
            GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
            [positionVM loadRequestCollectCancel:self.companysModels[0].id];
            [positionVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"取消收藏成功"];
                self.companysModels[0].collected = NO;
                [self setupNaviBar];
            }];
        }];
    }else {
        // 未收藏
        [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_collect")];
        @GBWeakObj(self);
        [self.customNavBar setOnClickRightButton:^{
            @GBStrongObj(self);
            GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
            [positionVM loadRequestCollect:self.companysModels[0].id  type:@"COLLECTION_TYPE_COMPANY"];
            [positionVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"收藏成功"];
                self.companysModels[0].collected = YES;
                [self setupNaviBar];
            }];
        }];
    }
    
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return self.positions.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 ? 104 : indexPath.section == 0 ?[tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }]+5 : 170*self.assureMasters.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = self.sectionTitleArray[section];
    [headerView.moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [headerView.moreButton setImage:nil forState:UIControlStateNormal];
    headerView.moreButton.titleLabel.font = Fit_Font(12);
    headerView.moreButton.hidden = section == 0 ? YES : NO;
    if (section == 1) {
        headerView.subTitleLabel.text = GBNSStringFormat(@"在招职位%@个",self.positionCount);
    }else {
        headerView.subTitleLabel.text = @"";
    }
    
    headerView.moreButtonClickBlock = ^(NSInteger section) {
        if (section == 0) {
//            GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
//            [homePageVM loadRequestCompanyPositionChanging:self.companyId];
//            [homePageVM setSuccessReturnBlock:^(id returnValue) {
//                self.positions = [NSMutableArray arrayWithArray:[GBPositionModel mj_objectArrayWithKeyValuesArray:returnValue]];
//                [self.baseTableView reloadData];
//            }];

            // 进入更多
//            GBMorePositionViewController *morePositionVC = [[GBMorePositionViewController alloc] init];
////            morePositionVC.searchJobName = self.searchText;
////            morePositionVC.param = param;
//            [self.navigationController pushViewController:morePositionVC animated:YES];
            GBCompanyPositionViewController *companyPostionVC = [[GBCompanyPositionViewController alloc] init];
            companyPostionVC.companyModel = self.companysModels[0];
            [self.navigationController pushViewController:companyPostionVC animated:YES];
        }else {
            GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
            [homePageVM loadRequestCompanyIncumbentsChanging:self.companyId];
            [homePageVM setSuccessReturnBlock:^(id returnValue) {
                self.assureMasters = [NSMutableArray arrayWithArray:[GBAssureMasterModel mj_objectArrayWithKeyValuesArray:returnValue]];
                [self.baseTableView reloadData];
            }];
        }
        
    };
    
    // 点击事件
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
        }
        cell.cellType = CellTypeDetailsLabel;
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        GBAssuredPositionCell *assuredPosititionCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!assuredPosititionCell) {
            assuredPosititionCell = [[GBAssuredPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredPositionCellID];
        }
        assuredPosititionCell.positionCellType = PositionCellTypeCompanyHome;
        
        [self configureAssuredPositionCell:assuredPosititionCell atIndexPath:indexPath];
        
        return assuredPosititionCell;
    }
    
    GBAssuredMasterTableViewCell *assuredMasterCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!assuredMasterCell) {
        assuredMasterCell = [[GBAssuredMasterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredMasterTableViewCellID];
    }
    
    assuredMasterCell.assureMasters = self.assureMasters;
    assuredMasterCell.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    assuredMasterCell.collectionView.scrollEnabled = NO;

    return assuredMasterCell;
}

- (void)configureCell:(GBSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.line.hidden = YES;
    cell.titleLabel.text = self.companysModels[0].introduction;
    cell.titleLabel.numberOfLines = 0;
    
    cell.indicateButton.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.font =  Fit_Font(14);
}

- (void)configureAssuredPositionCell:(GBAssuredPositionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.positionModel = self.positions[indexPath.row];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        GBPositonDetailsViewController *positionDetailVC = [[GBPositonDetailsViewController alloc] init];
        positionDetailVC.positionModel.id = [self.positions objectAtIndex:indexPath.row].id;
        [self.navigationController pushViewController:positionDetailVC animated:YES];
    }
}

#pragma mark - # Getters and Setters
- (NSMutableArray *)sectionTitleArray {
        _sectionTitleArray = [NSMutableArray arrayWithArray:@[@"公司介绍",@"在招职位",@"在职同事"]];

    return _sectionTitleArray;
}

- (NSMutableArray *)companysModels {
    if (!_companysModels) {
        _companysModels = [[NSMutableArray alloc] init];
    }
    
    return _companysModels;
}

- (NSMutableArray *)positions {
    if (!_positions) {
        _positions = [[NSMutableArray alloc] init];
    }
    
    return _positions;
}

- (NSMutableArray *)assureMasters {
    if (!_assureMasters) {
        _assureMasters = [[NSMutableArray alloc] init];
    }
    
    return _assureMasters;
}

- (GBPersonalHeadView *)personalHeadView:(CompanyModel *)positionModel {
    if (!_personalHeadView) {
        _personalHeadView = [[GBPersonalHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Fit_W_H(150)) name:positionModel.companyFullName position:GBNSStringFormat(@"%@ · %@",positionModel.financingScaleName,positionModel.personelScaleName) company:GBNSStringFormat(@"%@ · 已有%@名员工认证",positionModel.regionName,self.incumbentsCount) headImage:positionModel.companyLogo];
    }
    
    return _personalHeadView;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
