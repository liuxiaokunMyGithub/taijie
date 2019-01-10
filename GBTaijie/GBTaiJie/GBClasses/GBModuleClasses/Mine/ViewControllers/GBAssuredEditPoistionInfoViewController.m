//
//  GBAssuredEditPoistionInfoViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBAssuredEditPoistionInfoViewController.h"

// Controllers
/** 职位信息 */
#import "PositionSelectViewController.h"
/** 城市 */
#import "SelectCityViewController.h"
/** 薪资 */
#import "SalarySelectViewController.h"
/** 学历经验选择 */
#import "CurrentStatusPopView.h"

// ViewModels


// Models


// Views
#import "GBSettingCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBAssuredEditPoistionInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 标题 */
@property (nonatomic, strong) NSArray *titleListArray;
/* 学历 */
@property (nonatomic, strong) NSArray *educationList;
/* 学历code */
@property (nonatomic, strong) NSArray *educationCodeList;
/* 经验 */
@property (nonatomic, strong) NSArray *experienceList;
/* 经验Code */
@property (nonatomic, strong) NSArray *experienceCodeList;

@end

@implementation GBAssuredEditPoistionInfoViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"保过编辑";

//    [self <#data#>];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 56;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"职位信息"];
    [self.view addSubview:[self setupBottomViewWithtitle:@"保存"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
    @GBStrongObj(self);
        // 保存
        if (!ValidStr(self.tempModel.jobId) || !ValidStr(self.tempModel.jobName)) {
            return [UIView showHubWithTip:@"请选择职位"];
        }
        
        if (!ValidStr(self.tempModel.regionId) || !ValidStr(self.tempModel.regionId)) {
            return [UIView showHubWithTip:@"请选择城市"];
        }
        
        if (!ValidStr(self.tempModel.minSalary) || !ValidStr(self.tempModel.maxSalary)) {
            return [UIView showHubWithTip:@"请输入薪资"];
        }
        
        !self.didClickSaveButtonBlock ? : self.didClickSaveButtonBlock(self.tempModel);
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    
}


#pragma mark - # Setup Methods


#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleListArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSettingCell *settingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCell) {
        settingCell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    [self configureCell:settingCell atIndexPath:indexPath];
    
    return settingCell;
}

- (void)configureCell:(GBSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = self.titleListArray[indexPath.row];
    cell.contentTextField.textAlignment = NSTextAlignmentRight;
    switch (indexPath.row) {
        case 0:
            {
                cell.contentTextField.text = self.tempModel.jobName;
            }
            break;
        case 1:
        {
            cell.contentTextField.text = self.tempModel.regionName;

        }
            break;
        case 2:
        {
            if (ValidStr(self.tempModel.minSalary) && ValidStr(self.tempModel.maxSalary)) {
                cell.contentTextField.text = GBNSStringFormat(@"%@k-%@k",self.tempModel.minSalary,self.tempModel.maxSalary);
            }

        }
            break;
        case 3:
        {
            cell.contentTextField.text = self.tempModel.dilamorName;

        }
            break;
        case 4:
        {
            cell.contentTextField.text = self.tempModel.experienceName;

        }
            break;
        default:
            break;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            PositionSelectViewController *select = [[PositionSelectViewController alloc] init];
            
            @GBWeakObj(self);
            select.selectBlock = ^(JobModel *job) {
                @GBStrongObj(self);
                self.tempModel.jobName = job.jobName;
                self.tempModel.jobId = job.jobId;
                [self.baseTableView reloadData];

            };
            [self.navigationController pushViewController:select animated:YES];
        }
            break;
        case 1:
        {
            SelectCityViewController *scVC = [[SelectCityViewController alloc] init];
            @GBWeakObj(self);
            scVC.cityBlock = ^(CityModel *city) {
                
                @GBStrongObj(self);
                self.tempModel.regionId = city.regionId;
                self.tempModel.regionName = city.regionName;
                [self.baseTableView reloadData];
                
            };
            [self.navigationController pushViewController:scVC animated:YES];
        }
            break;
        case 2:
        {
            SalarySelectViewController *salary = [[SalarySelectViewController alloc] init];
            salary.selectBlock = ^(NSString *minSalary, NSString *maxSalary) {
                self.tempModel.minSalary = minSalary;
                self.tempModel.maxSalary = maxSalary;
                [self.baseTableView reloadData];
            };
            
            // 核心代码
            self.definesPresentationContext = YES;
            salary.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self.navigationController presentViewController:salary animated:NO completion:nil];
        }
            break;
        case 3:
        {
            CurrentStatusPopView *statusV = [[CurrentStatusPopView alloc] initWithStatusArray:self.educationList andSelectedStatus:self.tempModel.dilamorName];
            statusV.titleStr = @"学历";
            [statusV setSelectBlock:^(NSString *dilamorName) {
                self.tempModel.dilamorName = dilamorName;
                for (NSInteger i = 0; i < self.educationCodeList.count; i++) {
                    if ([self.educationList[i] isEqualToString:dilamorName]) {
                        self.tempModel.dilamorCode = self.educationCodeList[i];
                        break;
                    }
                }
                
                [self.baseTableView reloadData];
                
            }];
            
            [statusV show];
        }
            break;
        case 4:
        {
            CurrentStatusPopView *statusV = [[CurrentStatusPopView alloc] initWithStatusArray:self.experienceList andSelectedStatus:self.tempModel.experienceName];
            statusV.titleStr = @"经验年限";
            [statusV setSelectBlock:^(NSString *experienceName) {
                self.tempModel.experienceName = experienceName;
                for (NSInteger i = 0; i < self.experienceCodeList.count; i++) {
                    if ([self.experienceList[i] isEqualToString:experienceName]) {
                        self.tempModel.experienceCode = self.experienceCodeList[i];
                        break;
                    }
                }
                
                [self.baseTableView reloadData];
                
            }];
            [statusV show];
        }
            break;
        default:
            break;
    }
}


#pragma mark - # Getters and Setters
- (NSArray *)titleListArray {
    if (!_titleListArray) {
        _titleListArray = @[@"职位",@"城市",@"薪资",@"学历要求(选填)",@"经验要求(选填)"];
    }
    
    return _titleListArray;
}

- (NSArray *)educationList {
    if (!_educationList) {
        _educationList = @[@"不限", @"中专及以下", @"高中", @"大专", @"本科", @"硕士", @"博士"];
    }

    return _educationList;
}

- (NSArray *)educationCodeList {
    if (!_educationCodeList) {
        _educationCodeList = @[@"EDUCATION_NO", @"EDUCATION_ZH", @"EDUCATION_GZ", @"EDUCATION_ZK", @"EDUCATION_XS", @"EDUCATION_SX", @"EDUCATION_BS"];
    }
    
    return _educationCodeList;
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

- (GBServiceEditModel *)tempModel {
    if (!_tempModel) {
        _tempModel = [[GBServiceEditModel alloc] init];
    }
    
    return _tempModel;
}
// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end

