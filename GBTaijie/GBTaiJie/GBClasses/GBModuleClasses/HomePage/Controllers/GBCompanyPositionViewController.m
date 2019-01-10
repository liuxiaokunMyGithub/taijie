//
//  GBCompanyPositionViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/5.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBCompanyPositionViewController.h"

// Controllers
#import "GBPositonDetailsViewController.h"
#import "SalarySelectViewController.h"


// ViewModels


// Models
#import "GBFiltrateModel.h"

// Views
#import "GBAssuredPositionCell.h"
#import "GBPersonalHeadView.h"
#import "CurrentStatusPopView.h"

@interface GBCompanyPositionViewController ()<UITableViewDelegate,UITableViewDataSource>
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBPositionModel *> *positions;
/* <#describe#> */
@property (nonatomic, copy) NSString *count;

/* <#describe#> */
@property (nonatomic, strong) GBPersonalHeadView *personalHeadView;

/* 经验 */
@property (nonatomic, strong) NSArray *experienceList;
/* 经验Code */
@property (nonatomic, strong) NSArray *experienceCodeList;
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *tags;
/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;

/* <#describe#> */
@property (nonatomic, strong) GBFiltrateModel *filtrateModel;

@end

static NSString *const kGBAssuredPositionCellID = @"GBAssuredPositionCell";

@implementation GBCompanyPositionViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRequestMoreCompanyPositions];
    [self setupBaseTableView];
}


#pragma mark - # Setup Methods
- (void)setupBaseTableView {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 105;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBAssuredPositionCell class] forCellReuseIdentifier:kGBAssuredPositionCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) title:@"在招职位"];
    
    [self setupFiltrateButton];
}

// 筛选标签
- (void)setupFiltrateButton {
    
    @GBWeakObj(self);
    self.tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
        @GBStrongObj(self);
        NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
        switch (currentIndex) {
            case 0:
            {
                // 职位 - 薪资
                SalarySelectViewController *salary = [[SalarySelectViewController alloc] init];
                salary.selectBlock = ^(NSString *minSalary, NSString *maxSalary) {
                    self.filtrateModel.minSalary = minSalary;
                    self.filtrateModel.maxSalary = maxSalary;
                    
                    [self.tags replaceObjectAtIndex:0 withObject:GBNSStringFormat(@"%@k-%@k",minSalary,maxSalary)];
                    [self.tagsView reloadData];
                    
                    self.loadingStyle = LoadingDataRefresh;
                    [self loadRequestMoreCompanyPositions];
                };
                
                salary.customNavBar.alpha = 0;
                // 核心代码
                self.definesPresentationContext = YES;
                salary.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [GBRootViewController presentViewController:salary animated:NO completion:nil];
            }
                break;
            case 1:
            {
                // 职位 - 经验
                CurrentStatusPopView *statusV = [[CurrentStatusPopView alloc] initWithStatusArray:self.experienceList andSelectedStatus:self.filtrateModel.experienceName];
                statusV.titleStr = @"经验";
                [statusV setSelectBlock:^(NSString *experienceName) {
                    self.filtrateModel.experienceName = experienceName;
                    for (NSInteger i = 0; i < self.experienceCodeList.count; i++) {
                        if ([self.experienceList[i] isEqualToString:experienceName]) {
                            self.filtrateModel.experienceCode = self.experienceCodeList[i];
                            break;
                        }
                    }
                    
                    [self.tags replaceObjectAtIndex:1 withObject:self.filtrateModel.experienceName];
                    [self.tagsView reloadData];
                    
                    self.loadingStyle = LoadingDataRefresh;
                    [self loadRequestMoreCompanyPositions];
                }];
                [statusV show];
            }
                break;
            default:
                break;
        }
    };
    
    self.tagsView.tags = self.tags;
    HXTagAttribute *model = [[HXTagAttribute alloc]init];
    model.borderWidth  = 0.5;
    model.borderColor  = [UIColor kBaseColor];
    model.cornerRadius  = 10;
    model.titleSize  = 12;
    model.textColor  = [UIColor kBaseColor];
    model.selectedTextColor = [UIColor kBaseColor];
    model.normalBackgroundColor  = [UIColor clearColor];
    model.selectedBackgroundColor  = [UIColor clearColor];
    
    model.tagSpace  = GBMargin;
    
    self.tagsView.tagAttribute = model;
    
    HXTagCollectionViewFlowLayout *flowLayout = [[HXTagCollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100,20);
    flowLayout.sectionInset = UIEdgeInsetsZero;
    self.tagsView.layout = flowLayout;
    
    [self.bigBassTitleHeadView addSubview:self.tagsView];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customNavBar).offset(GBMargin);
        make.bottom.equalTo(self.bigBassTitleHeadView).offset(-GBMargin/2);
        make.right.equalTo(self.bigBassTitleHeadView).offset(-GBMargin);
        make.height.equalTo(@20);
    }];
    
    [self.tagsView reloadData];
}

- (void)headerRereshing {
    [super headerRereshing];
    [self loadRequestMoreCompanyPositions];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self loadRequestMoreCompanyPositions];
}

// 更多职位
- (void)loadRequestMoreCompanyPositions {
    GBHomePageViewModel *homeVM = [[GBHomePageViewModel alloc] init];
    [homeVM loadRequestMoreCompanyPositions:self.companyModel.id companyName:self.companyModel.companyName pageNo:page pageSize:10 minSalary:self.filtrateModel.minSalary maxSalary:self.filtrateModel.maxSalary experienceCode:self.filtrateModel.experienceCode];
    [homeVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBPositionModel mj_objectArrayWithKeyValuesArray:returnValue[@"positions"]];
        if (self.loadingStyle == LoadingDataRefresh) {
            self.count = returnValue[@"count"];
            [self setupSubTitle:GBNSStringFormat(@"%@个",self.count)];
            
            // 刷新数据
            self.positions = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.positions addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        
        if (self.positions.count) {
            [self removeNoDataImage];
        }else {
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
    return self.positions.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBAssuredPositionCell *assuredPosititionCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!assuredPosititionCell) {
        assuredPosititionCell = [[GBAssuredPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssuredPositionCellID];
    }
    
    assuredPosititionCell.positionCellType = PositionCellTypeCompanySearch;
    
    [self configureAssuredPositionCell:assuredPosititionCell atIndexPath:indexPath];
    
    return assuredPosititionCell;
}

- (void)configureAssuredPositionCell:(GBAssuredPositionCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.positionModel = self.positions[indexPath.row];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GBPositonDetailsViewController *positionDetailVC = [[GBPositonDetailsViewController alloc] init];
    positionDetailVC.positionModel.id = [self.positions objectAtIndex:indexPath.row].id;
    [[GBAppHelper getPushNavigationContr] pushViewController:positionDetailVC animated:YES];
}

- (NSMutableArray *)positions {
    if (!_positions) {
        _positions = [[NSMutableArray alloc] init];
    }
    
    return _positions;
}

#pragma mark - # Getters and Setters
- (GBPersonalHeadView *)personalHeadView:(CompanyModel *)positionModel {
    if (!_personalHeadView) {
        _personalHeadView = [[GBPersonalHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Fit_W_H(150)) name:positionModel.companyFullName position:GBNSStringFormat(@"%@ · %@",positionModel.financingScaleName,positionModel.personelScaleName) company:GBNSStringFormat(@"%@ · 已有%@名员工认证",positionModel.regionName,@"") headImage:positionModel.companyLogo];
    }
    
    return _personalHeadView;
}

- (NSArray *)experienceList {
    if (!_experienceList) {
        _experienceList = @[@"不限", @"应届生", @"1年以下", @"1-3年", @"3-5年", @"5-10年", @"10年以上"];
    }
    
    return _experienceList;
}

- (NSArray *)experienceCodeList {
    if (!_experienceCodeList) {
        _experienceCodeList = @[@"JOB_WORK_YEAR_NO", @"JOB_WORK_YEAR_GT_0LT_0", @"JOB_WORK_YEAR_LT_0", @"JOB_WORK_YEAR_GT_1_LT_0", @"JOB_WORK_YEAR_GT_5_LT_3", @"JOB_WORK_YEAR_GT_10_LT_5", @"JOB_WORK_YEAR_GT_10"];
    }
    
    return _experienceCodeList;
}

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [[NSMutableArray alloc] initWithArray:@[@"薪资",@"经验"]];
    }
    
    return _tags;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] init];
        
    }
    
    return _tagsView;
}

- (GBFiltrateModel *)filtrateModel {
    if (!_filtrateModel) {
        _filtrateModel = [[GBFiltrateModel alloc] init];
    }
    
    return _filtrateModel;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
