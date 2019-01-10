//
//  GBPositionCertificationViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBPositionCertificationViewController.h"

// Controllers
/** 搜索公司 */
#import "GBSearchCompanyViewController.h"
/** 职位类别 */
#import "PositionSelectViewController.h"
/** 输入修改信息 */
#import "GBChangeMineInfoViewController.h"
/** 选择城市 */
#import "SelectCityViewController.h"
/** 在职时间 */
#import "TimeSelectViewController.h"

#import "GBUploadCertificationInformationViewController.h"

// ViewModels


// Models
/** 公司 */
#import "CompanyModel.h"
/** 职位 */
#import "JobModel.h"
/** 城市 */
#import "CityModel.h"

// Views
#import "GBSettingCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBPositionCertificationViewController ()<UITableViewDelegate,UITableViewDataSource>

/* titles */
@property (nonatomic, strong) NSArray *textListArray;

@property (nonatomic, strong) CompanyModel *company;
@property (nonatomic, strong) JobModel *job;
@property (nonatomic, strong) CityModel *city;

@end

@implementation GBPositionCertificationViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"职位认证";

    [self headerRereshing];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 48;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) title:@"职位认证"];
    [self.view addSubview:[self setupBottomViewWithtitle:@"下一步"]];
    
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
        @GBStrongObj(self);
        [self nextButtonButtonTouchUpInside];
    };
}

#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self getIncumbentAuthenticationInfo];
}

/** Data */
// MARK: 查询在职者认证信息
- (void)getIncumbentAuthenticationInfo {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineIncumbentAuthenticationInfo];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.authenModel = [AuthenticationModel mj_objectWithKeyValues:returnValue];
        [self.baseTableView reloadData];
    }];
}


#pragma mark - # Event Response
/** MARK: 通知-Response */
- (void)SearchCityBlock:(NSNotification *)notification {
    // 得到传递的参数
    NSDictionary *dict = [notification userInfo];
    // 重新选择收货地址后，走此条件
    CityModel *city = [dict objectForKey:@"city"];
    
    self.city = city;
}

/** MARK: 下一步 */
- (void)nextButtonButtonTouchUpInside {
    if (!ValidStr(self.authenModel.companyName)) {
        return [UIView showHubWithTip:@"请输入公司名称"];
    }
    
    if (!ValidStr(self.authenModel.jobName)) {
        return [UIView showHubWithTip:@"请选择职位类别"];
    }
    
    if (!ValidStr(self.authenModel.positionName)) {
        return [UIView showHubWithTip:@"请输入职位名称"];
    }
    
//    if (!ValidStr(self.authenModel.regionName)) {
//        return [UIView showHubWithTip:@"请选择工作城市"];
//    }
    
    if (!ValidStr(self.authenModel.entryTime)) {
        return [UIView showHubWithTip:@"请选择在职时间"];
    }
    
    if (!ValidStr(self.authenModel.companyEmail)) {
        return [UIView showHubWithTip:@"请输入企业邮箱"];
    }
    
    GBUploadCertificationInformationViewController *certificaitonInfoVC = [[GBUploadCertificationInformationViewController alloc] init];
    self.authenModel.realName = userManager.currentUser.nickName;
    certificaitonInfoVC.authenModel = self.authenModel;
    [self.navigationController pushViewController:certificaitonInfoVC animated:YES];
}

#pragma mark - # Privater Methods

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textListArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    GBSettingCell *cell = [GBSettingCell cellForTableView:tableView indexPath:indexPath cellType:CellTypeDetailsLabel];
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    cell.titleLabel.text = self.textListArray[indexPath.row];
    cell.contentTextField.textAlignment = NSTextAlignmentRight;

    switch (indexPath.row) {
        case 0:
        {
            cell.contentTextField.text = self.authenModel.companyName;
        }
            break;
        case 1:
        {
            cell.contentTextField.text = self.authenModel.jobName;

        }
            break;
        case 2:
        {
            cell.contentTextField.text = self.authenModel.positionName;

        }
            break;
//        case 3:
//        {
//            cell.contentTextField.text = self.authenModel.regionName;
//
//        }
            break;
        case 3:
        {
            cell.contentTextField.text = self.authenModel.entryTime;

        }
            break;
        case 4:
        {
            cell.contentTextField.text = self.authenModel.companyEmail;

        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            GBSearchCompanyViewController *scVC = [[GBSearchCompanyViewController alloc] init];
            scVC.index = 1;
            scVC.companyBlock = ^(CompanyModel *company) {
                self.company = company;
                self.authenModel.companyName = company.companyFullName;
                self.authenModel.companyId = company.companyId;
                
                [self.baseTableView reloadData];
            };
            [self.navigationController pushViewController:scVC animated:YES];
        }
            break;
        case 1:
        {
            PositionSelectViewController *psVC = [[PositionSelectViewController alloc] init];
            psVC.selectBlock = ^(JobModel *job) {
                self.job = job;
                self.authenModel.jobName = job.jobName;
                self.authenModel.jobId = job.jobId;
                
                [self.baseTableView reloadData];
            };
            [self.navigationController pushViewController:psVC animated:YES];
        }
            break;
        case 2:
        {
          GBChangeMineInfoViewController *changeInfoVC = [[GBChangeMineInfoViewController alloc] init];
            changeInfoVC.changeInfoType = ChangeInfoTypeCommon;
            changeInfoVC.placeholderStr = self.authenModel.positionName;
            changeInfoVC.saveBlock = ^(NSString *inputStr) {
                self.authenModel.positionName = inputStr;
                
                [self.baseTableView reloadData];
            };
            [self.navigationController pushViewController:changeInfoVC animated:YES];
        }
            break;
//        case 3:
//        {
//            SelectCityViewController *scVC = [[SelectCityViewController alloc] init];
//            scVC.cityBlock = ^(CityModel *city) {
//                self.city = city;
//                self.authenModel.regionName = city.regionName;
//                self.authenModel.region = city.regionId;
//
//                [self.baseTableView reloadData];
//            };
//
//            [self.navigationController pushViewController:scVC animated:YES];
//        }
//            break;
        case 3:
        {
            TimeSelectViewController *time = [[TimeSelectViewController alloc] init];
            
            time.timeSelectBlock = ^(NSString *minTime, NSString *maxTime) {
                self.authenModel.minTime = minTime;
                self.authenModel.maxTime = maxTime;
                self.authenModel.entryTime = [NSString stringWithFormat:@"%@-%@", minTime, maxTime];
                
                [self.baseTableView reloadData];
            };
            // 核心代码
            self.definesPresentationContext = YES;
            time.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self.navigationController presentViewController:time animated:NO completion:nil];
        }
            break;
        case 4:
        {
            GBChangeMineInfoViewController *changeInfoVC = [[GBChangeMineInfoViewController alloc] init];
            changeInfoVC.changeInfoType = ChangeInfoTypeEmail;
            changeInfoVC.placeholderStr = self.authenModel.companyEmail;
            changeInfoVC.saveBlock = ^(NSString *inputStr) {
                self.authenModel.companyEmail = inputStr;
                
                [self.baseTableView reloadData];
            };
            
            [self.navigationController pushViewController:changeInfoVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - # Getters and Setters
- (NSArray *)textListArray {
    if (!_textListArray) {
        _textListArray = @[@"公司名称",@"职位类别",@"职位名称",@"在职时间",@"企业邮箱(重要)"];
    }
    return _textListArray;
}

- (AuthenticationModel *)authenModel {
    if (!_authenModel) {
        _authenModel = [[AuthenticationModel alloc] init];
    }
    
    return _authenModel;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
