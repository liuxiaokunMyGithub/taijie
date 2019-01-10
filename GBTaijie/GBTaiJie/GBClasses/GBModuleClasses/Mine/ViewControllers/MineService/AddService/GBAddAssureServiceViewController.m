//
//  GBAddAssureServiceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 新增保过服务
//  @discussion <#类的功能#>
//

#import "GBAddAssureServiceViewController.h"

// Controllers
/** 职位信息 */
#import "PositionSelectViewController.h"
/** 城市 */
#import "SelectCityViewController.h"
/** 薪资 */
#import "SalarySelectViewController.h"
/** 学历经验选择 */
#import "CurrentStatusPopView.h"
#import "GBAssureContentEditViewController.h"
#import "GBDiscountLimitFreeViewController.h"

// ViewModels

// Models
#import "GBServiceEditModel.h"

// Views
#import "GBPersonalSectionHeadView.h"
#import "GBSettingCell.h"
#import "GBAssureServiceContentCell.h"
#import "XKTextField.h"
#import "GBMoreButtonFooterView.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";
static NSString *const kGBAssureServiceContentCellID = @"GBAssureServiceContentCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBMoreButtonFooterViewID = @"GBMoreButtonFooterView";

@interface GBAddAssureServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) GBServiceEditModel *tempModel;

/* 标题 */
@property (nonatomic, strong) NSArray <NSArray *>*titleListArray;
/* 学历 */
@property (nonatomic, strong) NSArray *educationList;
/* 学历code */
@property (nonatomic, strong) NSArray *educationCodeList;
/* 经验 */
@property (nonatomic, strong) NSArray *experienceList;
/* 经验Code */
@property (nonatomic, strong) NSArray *experienceCodeList;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *sectionTitleListArray;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *tagsArray;
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBAssureContentTagModel *>*selectTagModels;

/* 标签视图高 */
@property (nonatomic, assign) CGFloat tagViewheight;
/** 服务内容高 */
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) HXTagsView *tagsView;
/* <#describe#> */
@property (nonatomic, copy) NSString *discountType;

/* <#describe#> */
@property (nonatomic, strong) UILabel *discountLabel;
/* <#describe#> */
@property (nonatomic, assign) BOOL isOpen;

@end


@implementation GBAddAssureServiceViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagViewheight = 40;
    
    [self setBigTitle];
    
    [self setupNaviBar];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBMoreButtonFooterView class] forHeaderFooterViewReuseIdentifier:kGBMoreButtonFooterViewID];

    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.baseTableView registerClass:[GBAssureServiceContentCell class] forCellReuseIdentifier:kGBAssureServiceContentCellID];
    
    [self.view addSubview:self.baseTableView];
    
    [self setBigTitle];
}


#pragma mark - # Setup Methods
- (void)setBigTitle {
    NSString *titleStr = nil;
    switch (self.serviceType) {
            // 新建解密服务
        case ServiceTypeNewAssured: {
            titleStr = @"新增保过";
            self.tempModel.isEnable = YES;
        }
            break;
            // 编辑解密服务
        case ServiceTypeEditAssured: {
            titleStr = @"保过编辑";
            [self headerRereshing];
            self.baseTableView.tableFooterView = [self setupDeleteButton];
        }
            break;
        default:
            break;
    }
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:titleStr];
    
}

// 在职者保过服务详情信息
- (void)headerRereshing {
    [super headerRereshing];
    [self getIncumbentAssuredInfo];
}

- (void)getIncumbentAssuredInfo {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineIncumbentAssurePass:self.serviceModel.incumbentAssurePassId];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.tempModel = [GBServiceEditModel mj_objectWithKeyValues:returnValue];
        self.tagsArray = [NSMutableArray arrayWithArray:[self.tempModel.labelNames componentsSeparatedByString:@","]];
        [self.tagsArray addObject:@"添加服务内容"];
        
        self.selectTagModels = [GBAssureContentTagModel mj_objectArrayWithKeyValuesArray:self.tempModel.labels];

        self.contentHeight = [DCSpeedy dc_calculateTextSizeWithText:self.tempModel.details WithTextFont:Fit_B_Font(16) WithMaxW:SCREEN_WIDTH - GBMargin*2].height;
        
        self.tagViewheight = [HXTagsView getHeightWithTags:self.tagsArray layout:self.tagsView.layout tagAttribute:self.tagsView.tagAttribute width:SCREEN_WIDTH - GBMargin *2];

        self.discountType = self.tempModel.discountType;
        [self.baseTableView reloadData];
    }];
    
}

- (void)setupNaviBar {
    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        // 保存保过服务
        [self saveAssuredService];
    }];
}

#pragma mark - # Event Response
- (UIView *)setupDeleteButton {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 40)];
    UIButton *deleteButton = [UIButton createButton:CGRectMake(0, 0, SCREEN_WIDTH, 40) target:self action:@selector(deleteButtonAction) textColor:[UIColor kBaseColor]];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [footerView addSubview:deleteButton];
    return footerView;
}

- (void)deleteButtonAction {
    [self AlertWithTitle:@"提示" message:@"删除该保过服务?" andOthers:@[@"取消",@"确定"] animated:YES action:^(NSInteger index) {
        if (index == 1) {
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            [mineVM loadRequestMineDeleteIncumbentAssurePass:self.serviceModel.incumbentAssurePassId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}


#pragma mark - # Privater Methods
// 保存保过服务
- (void)saveAssuredService {
    if (!ValidStr(self.tempModel.jobId) || !ValidStr(self.tempModel.jobName)) {
        return [UIView showHubWithTip:@"请选择职位"];
    }
    
    if (!ValidStr(self.tempModel.regionId)) {
        return [UIView showHubWithTip:@"请选择城市"];
    }
    
    if (!ValidStr(self.tempModel.minSalary) || !ValidStr(self.tempModel.maxSalary)) {
        return [UIView showHubWithTip:@"请输入薪资"];
    }
    
    if (!ValidStr(self.tempModel.title)) {
        return [UIView showHubWithTip:@"请输入标题"];
    }
    
    if (!ValidStr(self.tempModel.originalPrice)) {
        return [UIView showHubWithTip:@"请输入价格"];
    }
    
   
    if (!self.selectTagModels.count) {
        return [UIView showHubWithTip:@"请添加服务内容"];
    }
   
    
    if ([self.tempModel.originalPrice integerValue] <= 0) {
        return [UIView showHubWithTip:@"请输入正确金额"];
    }
    
    if ([self.tempModel.originalPrice integerValue] < [self.tempModel.price integerValue]) {
        return [UIView showHubWithTip:@"折扣价不得高于原价"];
    }
    
    NSMutableArray *tagLists = [NSMutableArray array];
    for (GBAssureContentTagModel *tagModel in self.selectTagModels) {
        NSDictionary *tempDic = @{
                                  @"labelName":tagModel.labelName,
                                  @"labelId":tagModel.labelId
                                  };
        [tagLists addObject:tempDic];
    }
    
    NSDictionary *positionDic = @{
                                  @"regionId":self.tempModel.regionId,
                                  @"experienceName":self.tempModel.experienceName,
                                  @"experienceCode":self.tempModel.experienceCode,
                                  
                                  @"dilamorName":self.tempModel.dilamorName,
                                  @"dilamorCode":self.tempModel.dilamorCode,
                                  
                                  @"jobId":self.tempModel.jobId,
                                  @"jobName":self.tempModel.jobName,
                                  
                                  @"maxSalary":self.tempModel.maxSalary,
                                  @"minSalary":self.tempModel.minSalary,
                                  @"title":self.tempModel.title,
                                  @"originalPrice":self.tempModel.originalPrice,
                                  @"discountType":self.tempModel.discountType,
                                  @"labels":tagLists
                                  };
    
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineAssureRenewal:positionDic price:self.tempModel.price content:self.tempModel.details isEnable:self.tempModel.isEnable assurePassId:self.tempModel.assurePassId];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        [self.navigationController popViewControllerAnimated:YES];
        [UIView showHubWithTip:@"保存成功"];
    }];
}

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isOpen && section == 0) {
        return 3;
    }
    if (section == 1) {
        return ValidStr(self.tempModel.details) ? 2 : 1;
    }
    return self.titleListArray[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 3 ? 0.000001 : 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? self.isOpen ? 0.0001 : 30 : 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return indexPath.row == 0 ? 150 + self.tagViewheight : [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
    
    return indexPath.section == 2 && indexPath.row == 1 ? 44 : 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = [self.sectionTitleListArray objectAtIndex:section];
    headerView.moreButton.hidden = YES;
    
    return headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    GBMoreButtonFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBMoreButtonFooterViewID];
    if (!footerView) {
        footerView = [[GBMoreButtonFooterView alloc] initWithReuseIdentifier:kGBMoreButtonFooterViewID];
    }
    footerView.moreButton.hidden = section == 0 ? self.isOpen : YES;
    footerView.moreButtonActionBlock = ^{
        self.isOpen = YES;
        [self.baseTableView reloadData];
    };
    
    return footerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        GBAssureServiceContentCell *assureServiceContentCell = [tableView cellForRowAtIndexPath:indexPath];

        if (!assureServiceContentCell) {
            assureServiceContentCell = [[GBAssureServiceContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAssureServiceContentCellID];
        }
        
        self.tagsView = assureServiceContentCell.tagsView;
        assureServiceContentCell.tagsViewHeight = self.tagViewheight;
        
        assureServiceContentCell.textView.text = self.tempModel.title;
        assureServiceContentCell.textValueChangedBlock = ^(NSString *valueStr) {
            self.tempModel.title = valueStr;
        };
        assureServiceContentCell.tagsArray = self.tagsArray;
        
        assureServiceContentCell.tagsView.completion = ^(NSArray *selectTags, NSInteger currentIndex) {
            if (currentIndex == self.tagsArray.count - 1) {
                // 添加服务
                GBAssureContentEditViewController *assureContentEditVC = [[GBAssureContentEditViewController alloc] init];
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.tagsArray];
                [tempArray removeLastObject];
                assureContentEditVC.selectTags = tempArray;
                assureContentEditVC.contentStr = self.tempModel.details;
                assureContentEditVC.completeOperationBlock = ^(NSArray<GBAssureContentTagModel *> *selectTagModels,NSArray *selectTags, NSString *textViewStr) {
                    
                    [self.tagsArray removeAllObjects];
                    [self.tagsArray addObjectsFromArray:selectTags];
                    [self.tagsArray addObject:@"添加服务内容"];
                    
                    self.selectTagModels = [NSMutableArray arrayWithArray:selectTagModels];
                    self.tempModel.details = textViewStr;
                    self.contentHeight = [DCSpeedy dc_calculateTextSizeWithText:self.tempModel.details WithTextFont:Fit_B_Font(16) WithMaxW:SCREEN_WIDTH - GBMargin*2].height;
                    
                    self.tagViewheight = [HXTagsView getHeightWithTags:self.tagsArray layout:self.tagsView.layout tagAttribute:self.tagsView.tagAttribute width:SCREEN_WIDTH - GBMargin *2];
                    
                    [self.baseTableView reloadData];
                    
                    
                };
                
                [self.navigationController pushViewController:assureContentEditVC animated:YES];
            }
        };
        
        return assureServiceContentCell;
    }
    
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(GBSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.titleLabel.text = self.titleListArray[indexPath.section][indexPath.row];
    cell.line.hidden = YES;

    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.cellType =  CellTypeDetailsLabel;
        cell.indicateButton.hidden = YES;
        cell.line.hidden = YES;
        cell.titleLabel.numberOfLines = 0;
        cell.titleLabel.textColor = [UIColor kImportantTitleTextColor];
        cell.titleLabel.font = Fit_Font(14);
        cell.titleLabel.text = self.tempModel.details;
    }
    
    if (indexPath.section == 0) {
        cell.line.hidden = NO;
        cell.contentTextField.textAlignment = NSTextAlignmentRight;
        switch (indexPath.row) {
            case 0:
            {
                cell.contentTextField.text = self.tempModel.jobName;
            }
                break;
            case 1:
            {
                cell.contentTextField.text = self.tempModel.publisherRegionName;
                
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
    
    
    if (indexPath.section == 2) {
        cell.indicateButton.hidden = YES;
        switch (indexPath.row) {
            case 0:
            {
            }
                break;
            case 1:
            {
                cell.cellType = ValidStr(self.tempModel.discountType) ? CellTypeDetailsLabel: CellTypeDetailsTextfield;
                cell.titleLabel.hidden = YES;
                cell.contentTextField.placeholder = @"请输入定价";
                cell.contentTextField.margin = 8;
                cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
                cell.contentTextField.text = self.tempModel.originalPrice;
                cell.textValueChangedBlock = ^(NSString *valueStr) {
                    self.tempModel.originalPrice = valueStr;
                    if (ValidStr(valueStr)) {
                        self.discountLabel.textColor = [UIColor kImportantTitleTextColor];
                    }
                };
                cell.line.hidden = NO;
//                GBViewBorderRadius(cell.contentTextField, 2, 0.5, [UIColor kSegmentateLineColor]);
            }
                break;
            
            case 2:
            {
                cell.indicateButton.hidden = NO;
                cell.contentTextField.text = [self.tempModel.discountType isEqualToString:@"FREE"] ? @"免费" : [self.tempModel.discountType isEqualToString:@"DISCOUNT"] ? GBNSStringFormat(@"折扣%@币",self.tempModel.price) : @"";
                cell.contentTextField.textAlignment = NSTextAlignmentRight;
                cell.titleLabel.textColor = ValidStr(self.tempModel.originalPrice) ? [UIColor kImportantTitleTextColor] : [UIColor kAssistInfoTextColor];
                self.discountLabel = (UILabel *)cell.titleLabel;
            }
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 3) {
        cell.cellType = CellTypeDetailsSwitch;
        cell.setSwitch.on = self.tempModel.isEnable;
        cell.switchChangedBlock = ^(BOOL isOpen) {
            self.tempModel.isEnable = isOpen;
        };
        
        cell.indicateButton.hidden = YES;

        cell.textLabel.font = Fit_M_Font(14);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
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
                    self.tempModel.publisherRegionName = city.regionName;
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
    
    if (indexPath.section == 2 && indexPath.row == 2) {
        if (ValidStr(self.discountType)) {
            return [UIView showHubWithTip:@"限免折扣期间不可修改"];
        }
        
        // 折扣与限免
        GBDiscountLimitFreeViewController *discountLimitFreeVC = [[GBDiscountLimitFreeViewController alloc] init];
        discountLimitFreeVC.discountType = self.tempModel.discountType;
        discountLimitFreeVC.originalPrice = self.tempModel.originalPrice;
        discountLimitFreeVC.saveBlock = ^(NSString *discountType, NSString *price) {
            self.tempModel.discountType = discountType;
            self.tempModel.price = price;
            [self.baseTableView reloadData];
        };
        [self.navigationController pushViewController:discountLimitFreeVC animated:YES];
    }
}
#pragma mark - # Getters and Setters
- (NSArray *)titleListArray {
    if (!_titleListArray) {
        _titleListArray = @[@[@"职位",@"城市",@"薪资",@"学历要求(选填)",@"经验要求(选填)"],@[@""],@[@"定价",@"",@"限免与折扣"],@[@"上线此服务"]];
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

- (NSMutableArray *)sectionTitleListArray {
    if (!_sectionTitleListArray) {
        _sectionTitleListArray = [NSMutableArray arrayWithArray:@[@"职位信息",@"保过服务内容",@"定价与折扣"]];
    }
    
    return _sectionTitleListArray;
}

- (GBServiceEditModel *)tempModel {
    if (!_tempModel) {
        _tempModel = [[GBServiceEditModel alloc] init];
    }
    
    return _tempModel;
}

- (NSMutableArray *)tagsArray {
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray arrayWithArray:@[@"添加服务内容"]];
    }
    
    return _tagsArray;
}

- (NSMutableArray *)selectTagModels {
    if (!_selectTagModels) {
        _selectTagModels = [[NSMutableArray alloc] init];
    }
    
    return _selectTagModels;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
