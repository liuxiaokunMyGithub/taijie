//
//  GBAddEducationExperienceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBAddEducationExperienceViewController.h"
// Controllers
#import "GBProvincesViewController.h"

// ViewModels


// Models
#import "GBEducationExperienceModel.h"

// Views
#import "GBUniversitiesProfessionalTableViewCell.h"
#import "GBSettingCell.h"
#import "GBMoreButtonFooterView.h"
#import "CurrentStatusPopView.h"

static NSString *const kGBUniversitiesProfessionalTableViewCellID = @"GBUniversitiesProfessionalTableViewCell";
static NSString *const kGBSettingCellID = @"GBSettingCell";
static NSString *const kGBMoreButtonFooterViewID = @"GBMoreButtonFooterView";

@interface GBAddEducationExperienceViewController ()<UITableViewDelegate,UITableViewDataSource>

/* <#describe#> */
@property (nonatomic, strong) NSArray *titleArray;
/* <#describe#> */
@property (nonatomic, strong) GBUniversitiesProfessionalTableViewCell *universitiesProfessionalCell;
/* <#describe#> */
@property (nonatomic, assign) BOOL isDomestic;

/* 国内 */
@property (nonatomic, strong) GBEducationExperienceModel *educationDomesticModel;
/* 海外 */
@property (nonatomic, strong) GBEducationExperienceModel *educationOverseasModel;

/* <#describe#> */
@property (nonatomic, strong) NSArray *educationList;
/* <#describe#> */
@property (nonatomic, strong) NSArray *entranceTimes;
/* <#describe#> */
@property (nonatomic, strong) NSArray *graduationTimes;


@end

@implementation GBAddEducationExperienceViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:EducationExperienceRefreshNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDomestic = YES;
    
    [self headerRereshing];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 50;
     self.baseTableView.estimatedRowHeight = 0;
     self.baseTableView.estimatedSectionHeaderHeight = 0;
     self.baseTableView.estimatedSectionFooterHeight = 0;
    [self.baseTableView registerClass:[GBUniversitiesProfessionalTableViewCell class] forCellReuseIdentifier:kGBUniversitiesProfessionalTableViewCellID];
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.baseTableView registerClass:[GBMoreButtonFooterView class] forHeaderFooterViewReuseIdentifier:kGBMoreButtonFooterViewID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"教育经历"];
    [self setupSubTitle:@"最高学历"];
    
    [GBNotificationCenter addObserver:self selector:@selector(educationExperienceRefreshNotification:) name:EducationExperienceRefreshNotification object:nil];
    
    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        GBEducationExperienceModel *educationExperienceModel = nil;
        if (!self.isDomestic) {
            // 海外
            if (ValidStr(self.universitiesProfessionalCell.overseasItemCell.valueTextField1.text)) {
                self.educationOverseasModel.pcname = self.universitiesProfessionalCell.overseasItemCell.valueTextField1.text;
            }
            
            if (ValidStr(self.universitiesProfessionalCell.overseasItemCell.valueTextField2.text)) {
                self.educationOverseasModel.universityName = self.universitiesProfessionalCell.overseasItemCell.valueTextField2.text;
            }
            
            if (ValidStr(self.universitiesProfessionalCell.overseasItemCell.valueTextField3.text)) {
                self.educationOverseasModel.majorName = self.universitiesProfessionalCell.overseasItemCell.valueTextField3.text;
            }
            
            educationExperienceModel = [GBEducationExperienceModel mj_objectWithKeyValues:self.educationOverseasModel];
            if (ValidStr(self.educationDomesticModel.id)) {
                educationExperienceModel.id = self.educationDomesticModel.id;
            }

        }else {
           educationExperienceModel = [GBEducationExperienceModel mj_objectWithKeyValues:self.educationDomesticModel];
            if (ValidStr(self.educationOverseasModel.id)) {
                educationExperienceModel.id = self.educationOverseasModel.id;
            }
        }
        
        
        if (!ValidStr(educationExperienceModel.pcname)) {
            return [UIView showHubWithTip:@"请设置国家省份"];
        }
        
        if (!ValidStr(educationExperienceModel.universityName)) {
            return [UIView showHubWithTip:@"请设置大学"];
        }
        
        if (!ValidStr(educationExperienceModel.majorName)) {
            return [UIView showHubWithTip:@"请设置专业"];
        }
        
        if (!ValidStr(educationExperienceModel.diploma)) {
            return [UIView showHubWithTip:@"请设置学历"];
        }
        
        if (!ValidStr(educationExperienceModel.startTime)) {
            return [UIView showHubWithTip:@"请设置入学时间"];
        }
        
        if (!ValidStr(educationExperienceModel.endTime)) {
            return [UIView showHubWithTip:@"请设置毕业时间"];
        }
    
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestEducationExperienceRenewal:educationExperienceModel.pcname universityName:educationExperienceModel.universityName majorName:educationExperienceModel.majorName diploma:educationExperienceModel.diploma startTime:educationExperienceModel.startTime endTime:educationExperienceModel.endTime isDomestic:educationExperienceModel.isDomestic experienceId:educationExperienceModel.id];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            UserModel *userModel = userManager.currentUser;
            userModel.schoolFilled = YES;
            [userManager saveCurrentUser:userModel];
            [self.navigationController popViewControllerAnimated:YES];
            [UIView showHubWithTip:@"保存成功"];
        }];
    }];
}

- (void)headerRereshing {
    [super headerRereshing];
    [self loadRequestEducatiopnExerience];
}

#pragma mark - # Setup Methods
- (void)educationExperienceRefreshNotification:(NSNotification *)notification
{
    self.educationDomesticModel = [GBEducationExperienceModel mj_objectWithKeyValues:notification.object];
    [UIView performWithoutAnimation:^{
        [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - # Event Response
- (void)loadRequestEducatiopnExerience {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestEducatiopnExerience];
    [mineVM setSuccessReturnBlock:^(NSArray *returnValue) {
        if (returnValue.count) {
            GBEducationExperienceModel *educationExperienceModel = [GBEducationExperienceModel mj_objectWithKeyValues:returnValue[0]];
            self.isDomestic = educationExperienceModel.isDomestic;
            if (self.isDomestic) {
                self.educationDomesticModel = educationExperienceModel;
            }else {
                self.educationOverseasModel = educationExperienceModel;
            }
            
            [self.baseTableView reloadData];
        }
    }];
}

#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 170 : 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    GBMoreButtonFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBMoreButtonFooterViewID];
    if (!footerView) {
        footerView = [[GBMoreButtonFooterView alloc] initWithReuseIdentifier:kGBMoreButtonFooterViewID];
    }
    
    footerView.moreButton.hidden = section == 0 ? NO : YES;
    [footerView.moreButton setTitle:nil forState:UIControlStateNormal];
    [footerView.moreButton setImage:self.isDomestic ? GBImageNamed(@"Overseas_right") : GBImageNamed(@"Domestic_left")  forState:UIControlStateNormal];
    footerView.buttonActionBlock = ^(GBLLRIButton *button) {
        self.isDomestic = !self.isDomestic;

        [self.universitiesProfessionalCell.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.isDomestic ? 0 : 1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [button setImage:self.isDomestic ? GBImageNamed(@"Overseas_right") : GBImageNamed(@"Domestic_left")  forState:UIControlStateNormal];
        
        [UIView performWithoutAnimation:^{
            [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }];
    };
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GBUniversitiesProfessionalTableViewCell *universitiesProfessionalCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!universitiesProfessionalCell) {
            universitiesProfessionalCell = [[GBUniversitiesProfessionalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBUniversitiesProfessionalTableViewCellID];
        }
        self.universitiesProfessionalCell = universitiesProfessionalCell;
        universitiesProfessionalCell.educationDomesticModel = self.educationDomesticModel;
        universitiesProfessionalCell.educationOverseasModel = self.educationOverseasModel;
        [universitiesProfessionalCell.collectionView reloadData];
        if (!self.isDomestic) {
            [self.universitiesProfessionalCell.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.educationOverseasModel.isDomestic ? 0 : 1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        
        return universitiesProfessionalCell;
    }
    
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGBSettingCellID];
    }
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.contentTextField.textAlignment = NSTextAlignmentRight;
    if (self.isDomestic) {
        cell.contentTextField.text = indexPath.row == 0 ? self.educationDomesticModel.diploma : indexPath.row == 1 ? self.educationDomesticModel.startTime : self.educationDomesticModel.endTime;
    }else {
        cell.contentTextField.text = indexPath.row == 0 ? self.educationOverseasModel.diploma : indexPath.row == 1 ? self.educationOverseasModel.startTime : self.educationOverseasModel.endTime;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                CurrentStatusPopView *statusV = [[CurrentStatusPopView alloc] initWithStatusArray:self.educationList andSelectedStatus:self.isDomestic ?self.educationDomesticModel.diploma : self.educationOverseasModel.diploma];
                statusV.titleStr = @"学历";
                [statusV setSelectBlock:^(NSString *dilamorName) {
                    if (self.isDomestic) {
                        self.educationDomesticModel.diploma = dilamorName;
                    }else {
                        self.educationOverseasModel.diploma = dilamorName;
                    }
                    [UIView performWithoutAnimation:^{
                        [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }];
                }];
                
                [statusV show];
            }
                break;
            case 1:
            {
                CurrentStatusPopView *statusV = [[CurrentStatusPopView alloc] initWithStatusArray:self.entranceTimes andSelectedStatus:self.isDomestic  ?self.educationDomesticModel.startTime : self.educationOverseasModel.startTime];
                statusV.titleStr = @"入学时间";
                [statusV setSelectBlock:^(NSString *startTime) {
                    if (self.isDomestic) {
                        self.educationDomesticModel.startTime = startTime;
                    }else {
                        self.educationOverseasModel.startTime = startTime;
                    }
                    [UIView performWithoutAnimation:^{
                        [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }];
                }];
                
                [statusV show];
            }
                break;
            case 2:
            {
                CurrentStatusPopView *statusV = [[CurrentStatusPopView alloc] initWithStatusArray:self.graduationTimes andSelectedStatus:self.isDomestic ?  self.educationDomesticModel.endTime : self.educationOverseasModel.endTime];
                statusV.titleStr = @"毕业时间";
                [statusV setSelectBlock:^(NSString *endTime) {
                    if (self.isDomestic) {
                        self.educationDomesticModel.endTime = endTime;
                    }else {
                        self.educationOverseasModel.endTime = endTime;
                    }
                    [UIView performWithoutAnimation:^{
                        [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }];
                }];
                
                [statusV show];
            }
                break;
            default:
                break;
        }
    }
    
}


#pragma mark - # Getters and Setters
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"学历",@"入学时间",@"毕业时间"];
    }
    
    return _titleArray;
}

- (GBEducationExperienceModel *)educationDomesticModel {
    if (!_educationDomesticModel) {
        _educationDomesticModel = [[GBEducationExperienceModel alloc] init];
    }
    
    return _educationDomesticModel;
}

- (GBEducationExperienceModel *)educationOverseasModel {
    if (!_educationOverseasModel) {
        _educationOverseasModel = [[GBEducationExperienceModel alloc] init];
    }
    
    return _educationOverseasModel;
}


- (NSArray *)educationList {
    if (!_educationList) {
        _educationList = @[@"高中/中专", @"大学专科", @"大学本科", @"硕士研究生", @"博士及以上"];
    }
    
    return _educationList;
}

- (NSArray *)entranceTimes {
    if (!_entranceTimes) {
        _entranceTimes = @[@"1985年", @"1986年", @"1987年", @"1988年", @"1989年", @"1990年", @"1991年",@"1992年", @"1993年", @"1994年", @"1995年", @"1996年", @"1997年", @"1998年", @"1999年", @"2000年", @"2001年", @"2002年", @"2003年", @"2004年",@"2005年", @"2006年", @"2007年", @"2008年", @"2009年", @"2010年", @"2011年",@"2012年", @"2013年", @"2014年", @"2015年", @"2016年", @"2017年", @"2018年"];
    }
    
    return _entranceTimes;
}

- (NSArray *)graduationTimes {
    if (!_graduationTimes) {
        _graduationTimes = @[@"1985年", @"1986年", @"1987年", @"1988年", @"1989年", @"1990年", @"1991年",@"1992年", @"1993年", @"1994年", @"1995年", @"1996年", @"1997年", @"1998年", @"1999年", @"2000年", @"2001年", @"2002年", @"2003年", @"2004年",@"2005年", @"2006年", @"2007年", @"2008年", @"2009年", @"2010年", @"2011年",@"2012年", @"2013年", @"2014年", @"2015年", @"2016年", @"2017年", @"2018年",@"在读"];
    }
    
    return _graduationTimes;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
