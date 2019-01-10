//
//  GBAddPastExperienceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/7.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBAddPastExperienceViewController.h"

// Controllers


// ViewModels


// Models


// Views
#import "GBPersonalSectionHeadView.h"
#import "GBPastExperienceCell.h"
#import "FSTextView.h"

static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBPastExperienceCellID = @"GBPastExperienceCell";

@interface GBAddPastExperienceViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/* 输入公司 */
@property (nonatomic, strong) UITextField *companyTextField;

/* 输入职位 */
@property (nonatomic, strong) UITextField *positionTextField;

/* 评价 */
@property (nonatomic, strong) FSTextView *wordTextView;

@end

@implementation GBAddPastExperienceViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 编辑
    if (self.addPastExperienceType == AddPastExperienceTypeEdit) {
        [self setupNaviBar];
    }
    
    //    [self <#data#>];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 180;
    self.baseTableView.sectionHeaderHeight = 20;
    self.baseTableView.sectionFooterHeight = 20;
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBPastExperienceCell class] forCellReuseIdentifier:kGBPastExperienceCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"过往经验"];
    
    self.baseTableView.tableFooterView = [self setupBottomViewWithtitle:@"保存"];
    self.baseBottomlineView.hidden = YES;
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
        @GBStrongObj(self);
        if (!ValidStr(self.pastExperienceModel.startTime)) {
            return [UIView showHubWithTip:@"请选择开始时间"];
        }
        
        if (!ValidStr(self.pastExperienceModel.endTime)) {
            return [UIView showHubWithTip:@"请选择结束时间"];
        }
        
        if (!ValidStr(self.companyTextField.text)) {
            return [UIView showHubWithTip:@"请输入公司名称"];
        }
        
        if (!ValidStr(self.positionTextField.text)) {
            return [UIView showHubWithTip:@"请输入职位"];
        }
        
        //        if (!ValidStr(self.wordTextView.text)) {
        //            return [UIView showHubWithTip:@"请输入简要评价"];
        //        }
        
        
        // 保存
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestUpdateMineMicroExperience:self.pastExperienceModel.startTime endTime:self.pastExperienceModel.endTime companyName:self.companyTextField.text positionName:self.positionTextField.text evaluateContent:self.wordTextView.text experienceId:self.pastExperienceModel.id];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"保存成功"];
            if (self.addPastExperienceType == AddPastExperienceTypeNew) {
                UserModel *userModel = userManager.currentUser;
                userModel.microExperienceCount += 1;
                [userManager saveCurrentUser:userModel];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    };
}


#pragma mark - # Setup Methods
- (void)setupNaviBar {
    [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_delete")];
    @GBWeakObj(self);
    self.customNavBar.onClickRightButton = ^{
        @GBStrongObj(self);
        // 删除
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestMineMicroExperienceDelete:self.pastExperienceModel.id];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"删除成功"];
            UserModel *userModel = userManager.currentUser;
            userModel.microExperienceCount -= 1;
            [userManager saveCurrentUser:userModel];

            [self.navigationController popViewControllerAnimated:YES];
        }];
    };
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    
    headerView.moreButton.hidden = YES;
    
    UIView *shortLine = [[UIView alloc] init];
    shortLine.backgroundColor = [UIColor kBaseColor];
    [headerView addSubview:shortLine];
    [shortLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(GBMargin);
        make.centerY.equalTo(headerView);
        make.height.equalTo(@2);
        make.width.equalTo(@20);
    }];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBPastExperienceCell *settingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCell) {
        settingCell = [[GBPastExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBPastExperienceCellID];
    }
    
    [self configureCell:settingCell atIndexPath:indexPath];
    
    return settingCell;
}

- (void)configureCell:(GBPastExperienceCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.datePickerClickedBlock = ^(NSString *dateStr,NSString *timeType) {
        if ([timeType isEqualToString:@"timeStart"]) {
            self.pastExperienceModel.startTime = dateStr;
        }else if ([timeType isEqualToString:@"timeEnd"]) {
            self.pastExperienceModel.endTime = dateStr;
        }
        
        [self.baseTableView reloadData];
    };
    
    cell.isEdit = YES;
    self.companyTextField = cell.companyTextField;
    self.positionTextField = cell.positionTextField;
//    self.wordTextView = cell.wordTextView;
    
    cell.pastExperienceModel = self.pastExperienceModel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

#pragma mark - # Getters and Setters

- (GBPastExperienceModel *)pastExperienceModel {
    if (!_pastExperienceModel) {
        _pastExperienceModel = [[GBPastExperienceModel alloc] init];
    }
    
    return _pastExperienceModel;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
