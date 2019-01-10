//
//  GBPositonDetailsViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/28.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 职位详情页
//  @discussion <#类的功能#>
//

#import "GBPositonDetailsViewController.h"
// Controllers
// 意向城市
#import "SelectCityViewController.h"
// 搜索公司
#import "GBSearchCompanyViewController.h"
// 公司主页
#import "GBCompanyHomeViewController.h"
// ViewMode

// Views

#import "GBSettingCell.h"
#import "GBPersonalSectionHeadView.h"
#import "GBPersonalHeadView.h"
#import "GBBigTitleHeadView.h"

// Model
// 意向id
#import "GBPersonalIncumbentModel.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

@interface GBPositonDetailsViewController () <
UITableViewDataSource,
UITableViewDelegate
>

/* tableView数据源 */
@property (nonatomic, strong) NSArray <NSString *> *sectionTitleListArray;
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *textListArray;

/* 意向模型 */
@property (nonatomic, strong) GBPersonalIncumbentModel *incumbentModel;

/* <#describe#> */
@property (nonatomic, strong) GBBigTitleHeadView *bigTitleHeadView;

@end

@implementation GBPositonDetailsViewController

#pragma mark - # Life Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"职位详情";
    
    // 职位详情
    [self headerRereshing];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self.baseTableView registerClass:[[GBSettingCell alloc] class] forCellReuseIdentifier:kGBSettingCellID];
    // 组头
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = self.bigTitleHeadView;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionFooterHeight = 0.000001;
    
}

#pragma mark - # Data
- (void)headerRereshing {
    [super headerRereshing];
    [self getIncumbent];
}

/** 获取职位详情 */
- (void)getIncumbent {
    GBPositionViewModel *positionPeopleVM = [[GBPositionViewModel alloc] init];
    [positionPeopleVM loadPositionsDeatail:GBNSStringFormat(@"%zu",self.positionModel.id)  region:self.positionModel.region];
    [positionPeopleVM setSuccessReturnBlock:^(id returnValue) {

        self.positionModel = [GBPositionCommonModel mj_objectWithKeyValues:returnValue];
        [self loadRequestWatchcPosition];

        [self.textListArray addObjectsFromArray:@[GBNSStringFormat(@"%@\n%zuk-%zuk",self.positionModel.positionName,self.positionModel.minSalary,self.positionModel.maxSalary),GBNSStringFormat(@"经验要求: %@\n学历要求: %@",self.positionModel.requiredExperienceName,self.positionModel.requiredEducationalName),GBNSStringFormat(@"%@\n%@.%@ · %@\n%@",self.positionModel.companyAbbreviatedName,self.positionModel.companyIndustry,self.positionModel.financingScale,self.positionModel.personnelScale,self.positionModel.workingPlaceTradingArea),self.positionModel.positionRemark,self.positionModel.sourceName]];
        
        [self setupNaviBar];
        
        [self.baseTableView reloadData];
    }];
}

// 关注职位
- (void)loadRequestWatchcPosition {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestWatchcPosition:GBNSStringFormat(@"%zu",self.positionModel.positionId)];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        
    }];
}

/** UI */
- (void)setupNaviBar {
    if (self.positionModel.isCollected) {
        // 已收藏
        [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_collect_sel")];
        @GBWeakObj(self);
        [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
            GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
            [positionVM loadRequestCollectCancel:GBNSStringFormat(@"%zu",self.positionModel.positionId)];
            [positionVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"取消收藏成功"];
                self.positionModel.isCollected = NO;
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
            [positionVM loadRequestCollect:GBNSStringFormat(@"%zu",self.positionModel.positionId)  type:@"COLLECTION_TYPE_POSITION"];
            [positionVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"收藏成功"];
                self.positionModel.isCollected = YES;
                [self setupNaviBar];
            }];
        }];
    }
    
}

#pragma mark - # Event Response

- (void)copyAction {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.positionModel.positionDetailUrl;
    
    if (pboard == nil) {
        [UIView showHubWithTip:@"职位链接复制失败"];
    }else {
        [UIView showHubWithTip:@"职位链接复制成功"];
    }
}

#pragma mark - # Private Methods

#pragma mark - # Delegate
/**  MARK: UITableViewDataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.textListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 1 : 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = [self.sectionTitleListArray objectAtIndex:section];
    headerView.moreButton.hidden = section == 2 ? NO : YES;
    [headerView.moreButton setTitle:@"详细信息" forState:UIControlStateNormal];
    [headerView.moreButton setImage:nil forState:UIControlStateNormal];
    headerView.moreButtonClickBlock = ^(NSInteger section) {
        GBCompanyHomeViewController *companyHM = [[GBCompanyHomeViewController alloc] init];
        companyHM.companyId = GBNSStringFormat(@"%ld",(long)self.positionModel.companyId);
        [self.navigationController pushViewController:companyHM animated:YES];
    };
    headerView.backgroundColor = [UIColor redColor];
    headerView.titleLabel.font = section == 0 ? Fit_B_Font(28) : Fit_M_Font(17);
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSettingCell *settingCell = [tableView dequeueReusableCellWithIdentifier:kGBSettingCellID];

    if (!settingCell) {
        settingCell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    [self configureCell:settingCell atIndexPath:indexPath];
    
    return settingCell;
}

- (void)configureCell:(GBSettingCell *)settingCell atIndexPath:(NSIndexPath *)indexPath {
    settingCell.line.hidden = YES;
    settingCell.titleLabel.text = self.textListArray[indexPath.section];
    settingCell.titleLabel.numberOfLines = 0;
    if (indexPath.section == 4) {
        settingCell.indicateButtonWidth = 50;
        settingCell.indicateButton.hidden = NO;
        [settingCell.indicateButton setTitle:@"复制链接" forState:UIControlStateNormal];
        settingCell.indicateButton.userInteractionEnabled = YES;
        [settingCell.indicateButton addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
        [settingCell.indicateButton setImage:GBImageNamed(@"icon_copy") forState:UIControlStateNormal];
    }else {
        settingCell.indicateButton.hidden = YES;
    }
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    settingCell.titleLabel.font = indexPath.section == 0 ? Fit_M_Font(20) : Fit_Font(14);
    settingCell.titleLabel.textColor = [UIColor kImportantTitleTextColor];

    if (indexPath.section == 0) {
        settingCell.titleLabel.attributedText = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kPromptRedColor] changeFont:Fit_M_Font(20) totalString:self.textListArray[indexPath.section] changeString:GBNSStringFormat(@"%zuk-%zuk",self.positionModel.minSalary,self.positionModel.maxSalary)];
    }
}

/**  MARK: UITableViewDelegate  */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - # Getters and Setters
- (NSArray *)sectionTitleListArray {
    if (!_sectionTitleListArray) {
        _sectionTitleListArray = @[@"",@"任职要求",@"公司信息",@"职位介绍",@"数据来源"];
    }
    return _sectionTitleListArray;
}

- (NSMutableArray *)textListArray {
    if (!_textListArray) {
        _textListArray = [[NSMutableArray alloc] init];;
    }
    return _textListArray;
}

- (GBBigTitleHeadView *)bigTitleHeadView {
    if (!_bigTitleHeadView) {
        _bigTitleHeadView = [[GBBigTitleHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _bigTitleHeadView.titleLabel.text = @"职位";
    }
    
    return _bigTitleHeadView;
}

- (GBPositionCommonModel *)positionModel {
    if (!_positionModel) {
        _positionModel = [[GBPositionCommonModel alloc] init];
    }
    
    return _positionModel;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}


@end
