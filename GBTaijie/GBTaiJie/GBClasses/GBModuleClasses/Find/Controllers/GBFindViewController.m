//
//  GBFindViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 发现
//  @discussion <#类的功能#>
//

#import "GBFindViewController.h"

// Controllers
#import "GBServiceDetailsViewController.h"
#import "GBFindMoreListViewController.h"

// ViewModels
#import "GBFindViewModel.h"


// Models
#import "GBFindColleaguesModel.h"
#import "GBFindModel.h"

// Views
#import "GBFindDecryptionCell.h"
#import "GBSectionHeadView.h"
#import "GBFindColleaguesTableViewCell.h"
#import "XKSlideTabBar.h"
#import "GBPersonalSectionHeadView.h"

static NSString *const kGBSectionHeadViewID = @"GBSectionHeadView";
static NSString *const kGBFindDecryptionCellID = @"GBFindDecryptionCell";
static NSString *const kGBFindColleaguesTableViewCellID = @"GBFindColleaguesTableViewCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

@interface GBFindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) XKSlideTabBar *slideTabBarView;

/* <#describe#> */
@property (nonatomic, strong) NSArray *sectionTitleArray;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBFindColleaguesModel *> *colleaguesModels;

@property (nonatomic, strong) NSMutableArray <GBFindModel *> *freeModels;
/* 公司包打听 */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *companyPryingModels;
/* 求职技巧 */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *jobSkillsModels;
/* 职场生存 */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *careerSurvivalModels;
/* 专业技能 */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *skillsModels;
/* 职业规划 */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *careerPlanningModels;
/* 其他 */
@property (nonatomic, strong) NSMutableArray <GBFindModel *> *otherModels;
/* <#describe#> */
@property (nonatomic, strong) NSArray *labelCodes;
@end

@implementation GBFindViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFindList];
    [self setupSlideTabBarView];

    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 50;
    self.baseTableView.sectionFooterHeight = 0.00001;
    
    [self.baseTableView registerClass:[GBSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBSectionHeadViewID];
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];

    [self.baseTableView registerClass:[GBFindDecryptionCell class] forCellReuseIdentifier:kGBFindDecryptionCellID];
    [self.view addSubview:self.baseTableView];
    
    [self.view addSubview:[self setupBigTitleHeadViewWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 40) title:@"发现"]];
    [self setupBigTitleTopMargin:1];
    
    [self.view addSubview:self.slideTabBarView];
    self.baseTableView.top = self.slideTabBarView.bottom;
    self.baseTableView.height = SCREEN_HEIGHT - CGRectGetMaxY(self.slideTabBarView.frame) - SafeTabBarHeight;
}


#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self loadFindList];
}

- (void)loadFindList {
    GBFindViewModel *findVM = [[GBFindViewModel alloc] init];
    [findVM loadRequestFindSearch];
    [findVM setSuccessReturnBlock:^(id returnValue) {
        self.colleaguesModels = [GBFindColleaguesModel mj_objectArrayWithKeyValuesArray:returnValue[@"incumbents"]];
        self.freeModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"free"]];
        self.jobSkillsModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"DECRYPT_QZJQ"]];
        self.careerPlanningModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"DECRYPT_ZYGH"]];
        self.companyPryingModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"DECRYPT_GSBDT"]];
        self.careerSurvivalModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"DECRYPT_ZCSC"]];
        self.skillsModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"DECRYPT_ZYJN"]];
        self.otherModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue[@"CUSTOMIZED"]];

        [self.baseTableView reloadData];
        [self.baseTableView.mj_header endRefreshing];
    }];
}

- (void)setupSlideTabBarView {
    _slideTabBarView = [[XKSlideTabBar alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight + 56, SCREEN_WIDTH, 48) titleArray:@[@"全部",@"包打听",@"求职技巧",@"职场生存",@"专业技能",@"职业规划",@"其他"]];
    [self.view addSubview:_slideTabBarView];
    @GBWeakObj(self);
    // 点击标题头
    self.slideTabBarView.didSelectedItemBlock = ^(NSInteger index) {
    @GBStrongObj(self);
        //获取到需要跳转位置的行数
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
       
        /** sectionHeader 的rect */
        CGRect headFrame = [self.baseTableView rectForHeaderInSection:index];
        /** 让指定区域滚动到可视区域，如果已经在可视区域 则该方法无效 */
        //滚动到其相应的位置
//        [self.baseTableView scrollToRowAtIndexPath:scrollIndexPath
//                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
//        CGRect rowFrame = [self.baseTableView rectForRowAtIndexPath:scrollIndexPath];

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.25];
        [self.baseTableView setContentOffset:CGPointMake(headFrame.origin.x, headFrame.origin.y)];
        [UIView commitAnimations];


//        });
    };
    
}

#pragma mark - # Event Response
//- (void)reloadDecryptsSectionData:(BOOL )isFree labelCode:(NSString *)labelCode section:(NSInteger )section {
//    if (section == 1) {
//        GBFindViewModel *findVM = [[GBFindViewModel alloc] init];
//        [findVM loadRequestChangingWarmIncumbents];
//        [findVM setSuccessReturnBlock:^(id returnValue) {
//            self.colleaguesModels = [GBFindColleaguesModel mj_objectArrayWithKeyValuesArray:returnValue];
//            [self.baseTableView reloadData];
//        }];
//
//        return;
//    }
//
//    GBFindViewModel *findVM = [[GBFindViewModel alloc] init];
//    [findVM loadRequestChangingDecrypts:YES labelCode:labelCode specialFree:isFree];
//    [findVM setSuccessReturnBlock:^(id returnValue) {
//        switch (section) {
//            case 0:
//            {
//                self.freeModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
//            }
//                break;
//            case 2:
//            {
//                self.companyPryingModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
//
//            }
//                break;
//            case 3:
//            {
//                self.jobSkillsModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
//
//            }
//                break;
//            case 4:
//            {
//                self.careerSurvivalModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
//
//            }
//                break;
//            case 5:
//            {
//                self.skillsModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
//
//            }
//                break;
//            case 6:
//            {
//                self.careerPlanningModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
//
//            }
//                break;
//            case 7:
//            {
//                self.otherModels = [GBFindModel mj_objectArrayWithKeyValuesArray:returnValue];
//
//            }
//                break;
//            default:
//                break;
//        }
//
////        [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//        [self.baseTableView reloadData];
//    }];
//}

#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 1;
    switch (section) {
        case 0:
        {
            rows = self.freeModels.count;
        }
            break;
        case 1:
        {
            rows = self.companyPryingModels.count;
            
        }
            break;
        case 2:
        {
            rows = self.jobSkillsModels.count;
            
        }
            break;
        case 3:
        {
            rows = self.careerSurvivalModels.count;
            
        }
            break;
        case 4:
        {
            rows = self.skillsModels.count;
            
        }
            break;
        case 5:
        {
            rows = self.careerPlanningModels.count;
            
        }
            break;
        case 6:
        {
            rows = self.otherModels.count;
            
        }
            break;
        default:
            break;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 ? 180 : [tableView fd_heightForCellWithIdentifier:kGBFindDecryptionCellID cacheByIndexPath:indexPath configuration:^(GBFindDecryptionCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }

    headerView.section = section;
    headerView.moreButton.titleLabel.font = Fit_Font(12);
    [headerView.moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [headerView.moreButton setImage:nil forState:UIControlStateNormal];
    
    headerView.titleLabel.text = [self.sectionTitleArray objectAtIndex:section];
    
    // 点击事件
    headerView.moreButtonClickBlock = ^(NSInteger section) {
//        [self reloadDecryptsSectionData:section == 0 ? YES : NO labelCode:self.labelCodes[section] section:section];
        GBFindMoreListViewController *findMoreListVC = [[GBFindMoreListViewController alloc] init];
        findMoreListVC.section = section;
        [self.navigationController pushViewController:findMoreListVC animated:YES];
    };
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1) {
//        GBFindColleaguesTableViewCell *findColleaguesTableViewCell = [tableView cellForRowAtIndexPath:indexPath];
//        if (!findColleaguesTableViewCell) {
//            findColleaguesTableViewCell = [[GBFindColleaguesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBFindColleaguesTableViewCellID];
//        }
//
//        [self configureFindColleaguesTableViewCell:findColleaguesTableViewCell atIndexPath:indexPath];
//
//        return findColleaguesTableViewCell;
//    }
//
    GBFindDecryptionCell *settingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCell) {
        settingCell = [[GBFindDecryptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBFindDecryptionCellID];
    }
    
    [self configureCell:settingCell atIndexPath:indexPath];
    
    return settingCell;
}

- (void)configureCell:(GBFindDecryptionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            {
                cell.consultingDecryptsModel = self.freeModels[indexPath.row];
            }
            break;
        case 1:
        {
            cell.consultingDecryptsModel = self.companyPryingModels[indexPath.row];

        }
            break;
        case 2:
        {
            cell.consultingDecryptsModel = self.jobSkillsModels[indexPath.row];

        }
            break;
        case 3:
        {
            cell.consultingDecryptsModel = self.careerSurvivalModels[indexPath.row];

        }
            break;
        case 4:
        {
            cell.consultingDecryptsModel = self.skillsModels[indexPath.row];

        }
            break;
        case 5:
        {
            cell.consultingDecryptsModel = self.careerPlanningModels[indexPath.row];

        }
            break;
        case 6:
        {
            cell.consultingDecryptsModel = self.otherModels[indexPath.row];
            
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureFindColleaguesTableViewCell:(GBFindColleaguesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.colleaguesModels = self.colleaguesModels;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section == 1) {
//
//    }
    
    GBFindModel *colleaguesModels = nil;
    switch (indexPath.section) {
        case 0:
        {
            colleaguesModels = self.freeModels[indexPath.row];
        }
            break;
        case 1:
        {
            colleaguesModels = self.companyPryingModels[indexPath.row];
            
        }
            break;
        case 2:
        {
            colleaguesModels = self.jobSkillsModels[indexPath.row];
            
        }
            break;
        case 3:
        {
            colleaguesModels = self.careerSurvivalModels[indexPath.row];
            
        }
            break;
        case 4:
        {
            colleaguesModels = self.skillsModels[indexPath.row];
            
        }
            break;
        case 5:
        {
            colleaguesModels = self.careerPlanningModels[indexPath.row];
            
        }
            break;
        case 6:
        {
           colleaguesModels = self.otherModels[indexPath.row];
            
        }
            break;
        default:
            break;
    }
    
    GBServiceDetailsViewController *decryptionDetails = [[GBServiceDetailsViewController alloc] init];
    decryptionDetails.serviceDetailsType = ServiceDetailsTypeDecryption;
    decryptionDetails.serviceModel.incumbentDecryptId = colleaguesModels.incumbentDecryptId;
    decryptionDetails.serviceModel.publisherId = colleaguesModels.userId;
    
    [self.navigationController pushViewController:decryptionDetails animated:YES];
    
}

#pragma mark - # Getters and Setters

- (NSArray *)sectionTitleArray {
    if (!_sectionTitleArray) {
        _sectionTitleArray = @[@"特价免费",@"公司包打听",@"求职技巧",@"职场生存",@"专业技能",@"职业规划",@"其他"];
    }
    
    return _sectionTitleArray;
}

- (NSMutableArray *)freeModels {
    if (!_freeModels) {
        _freeModels = [[NSMutableArray alloc] init];
    }
    
    return _freeModels;
}

- (NSMutableArray *)companyPryingModels {
    if (!_companyPryingModels) {
        _companyPryingModels = [[NSMutableArray alloc] init];
    }
    
    return _companyPryingModels;
}

- (NSMutableArray *)jobSkillsModels {
    if (!_jobSkillsModels) {
        _jobSkillsModels = [[NSMutableArray alloc] init];
    }
    
    return _jobSkillsModels;
}

- (NSMutableArray *)careerSurvivalModels {
    if (!_careerSurvivalModels) {
        _careerSurvivalModels = [[NSMutableArray alloc] init];
    }
    
    return _careerSurvivalModels;
}

- (NSMutableArray *)skillsModels {
    if (!_skillsModels) {
        _skillsModels = [[NSMutableArray alloc] init];
    }
    
    return _skillsModels;
}

- (NSMutableArray *)careerPlanningModels {
    if (!_careerPlanningModels) {
        _careerPlanningModels = [[NSMutableArray alloc] init];
    }
    
    return _careerPlanningModels;
}

- (NSMutableArray *)otherModels {
    if (!_otherModels) {
        _otherModels = [[NSMutableArray alloc] init];
    }
    
    return _otherModels;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
