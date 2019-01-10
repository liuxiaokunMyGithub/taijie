//
//  GBUploadCertificationInformationViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 上传认证资料
//  @discussion <#类的功能#>
//

#import "GBUploadCertificationInformationViewController.h"

// Controllers
/** 认证信息 */
#import "GBPositionCertificationViewController.h"
/** 认证成功 */
#import "GBCertificationSuccessViewController.h"

#import "GBZhiMaRealNameCertificationViewController.h"
// ViewModels


// Models


// Views
#import "GBUpdateCertificationInfoHeadView.h"
#import "GBPersonalSectionHeadView.h"
#import "GBUploadInfoCell.h"

static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBUploadInfoCellID = @"GBUploadInfoCell";

@interface GBUploadCertificationInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 组头 */
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) GBUpdateCertificationInfoHeadView *headView;
/* 内容标题 */
@property (nonatomic, strong) NSArray *contentTitleArray;

// 图片Url
@property (nonatomic, strong) NSMutableDictionary *imageUrlsSectionDic;
@property (nonatomic, strong) NSMutableDictionary *hiddenStateSectionDic;

@end

@implementation GBUploadCertificationInformationViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"上传认证信息";

    [self setupNavi];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 120;
    self.baseTableView.sectionHeaderHeight = 50;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBUploadInfoCell class] forCellReuseIdentifier:kGBUploadInfoCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = self.headView;
    @GBWeakObj(self);
    self.headView.didClickEdictBlock = ^{
    @GBStrongObj(self);
        GBPositionCertificationViewController *positionCertificateVC = [[GBPositionCertificationViewController alloc] init];
        positionCertificateVC.authenModel = self.authenModel;
        [self.navigationController pushViewController:positionCertificateVC animated:YES];
    };
}


#pragma mark - # Setup Methods
- (void)setupNavi {
    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        // 保存
        if (!self.imageUrlsSectionDic.allKeys.count) {
            return [UIView showHubWithTip:@"请上传资料"];
        }
        
        NSMutableArray *imgs = [NSMutableArray array];
        
        // 劳动合同
        BOOL laborContract = NO;
        // 工作牌
        BOOL badgeAuthentication = NO;
        // 在职证明
        BOOL incumbencyCertification = NO;
        // 邮箱
        BOOL emailScreenshot = NO;

        if (ValidArray([self.imageUrlsSectionDic objectForKey:@"0"])) {
            // 工牌照
            NSMutableDictionary *imgDict = [NSMutableDictionary dictionary];
            imgDict[@"imgKey"] = [self.imageUrlsSectionDic objectForKey:@"0"][0];
            imgDict[@"type"] = @"INCUMBENT_AUTHENTICATION_WORK_CARD";
            [imgs addObject:imgDict];
            
            badgeAuthentication = YES;
        }
        
        if (ValidArray([self.imageUrlsSectionDic objectForKey:@"1"])) {
            // 公司邮箱照
            NSMutableDictionary *imgDict = [NSMutableDictionary dictionary];
            imgDict[@"imgKey"] = [self.imageUrlsSectionDic objectForKey:@"1"][0];
            imgDict[@"type"] = @"INCUMBENT_AUTHENTICATION_COMPANY_EMAIL";
            [imgs addObject:imgDict];
            
            emailScreenshot = YES;
        }
        
        if (ValidArray([self.imageUrlsSectionDic objectForKey:@"2"])) {
            // 在职证明照
            NSMutableDictionary *imgDict = [NSMutableDictionary dictionary];
            imgDict[@"imgKey"] = [self.imageUrlsSectionDic objectForKey:@"2"][0];
            imgDict[@"type"] = @"INCUMBENT_AUTHENTICATION_INCUMBENCY_CERTIFICATION";
            [imgs addObject:imgDict];
            
            incumbencyCertification = YES;
        }
        if (ValidArray([self.imageUrlsSectionDic objectForKey:@"3"])) {
            // 劳动合同照
            NSMutableDictionary *imgDict = [NSMutableDictionary dictionary];
            imgDict[@"imgKey"] = [self.imageUrlsSectionDic objectForKey:@"3"][0];
            imgDict[@"type"] = @"INCUMBENT_AUTHENTICATION_LABOR_CONTRACT";
            [imgs addObject:imgDict];
            
            laborContract = YES;
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        // 是否已实名认证,认证ID
        if (self.authenModel.authenticationId) {
            params[@"realNameAuthentication"] = self.authenModel.realNameAuthentication ? @"1" : @"0";
            params[@"authenticationId"] = self.authenModel.authenticationId;
        }
        
        params[@"laborContract"] = [NSNumber numberWithBool:laborContract];
        params[@"badgeAuthentication"] = [NSNumber numberWithBool:badgeAuthentication];
        params[@"incumbencyCertification"] = [NSNumber numberWithBool:incumbencyCertification];
        params[@"emailScreenshot"] = [NSNumber numberWithBool:emailScreenshot];

        
        params[@"companyId"] = self.authenModel.companyId;
        params[@"jobId"] = self.authenModel.jobId;
        params[@"positionName"] = self.authenModel.positionName;
//        params[@"region"] = self.authenModel.region;
        
        //            NSInteger entryTime = 0;
        //            if ([self.authenModel.maxTime isEqualToString:@"至今"]) {
        //                NSDateFormatter *ft = [[NSDateFormatter alloc] init];
        //                [ft setDateFormat:@"YYYY"];
        //                NSDate *dateNow = [NSDate date];
        //                NSString *currentTimeStr = [ft stringFromDate:dateNow];
        //                entryTime = [currentTimeStr integerValue] - [self.authenModel.minTime integerValue];
        //            }else {
        //                entryTime = [self.authenModel.maxTime integerValue] - [self.authenModel.minTime integerValue];
        //            }
        params[@"entryTime"] = self.authenModel.minTime;  // 在职时间
        params[@"companyEmail"] = self.authenModel.companyEmail; // 邮箱
        params[@"imgs"] = imgs;
        
        GBZhiMaRealNameCertificationViewController *zhimaRealNameCertificationVC = [[GBZhiMaRealNameCertificationViewController alloc] init];
        zhimaRealNameCertificationVC.params = params;
        [self.navigationController pushViewController:zhimaRealNameCertificationVC animated:YES];
    }];
}

#pragma mark - # Event Response

#pragma mark - # Privater Methods
- (GBUpdateCertificationInfoHeadView *)headView {
    if (!_headView) {
        _headView = [[GBUpdateCertificationInfoHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160) name:self.authenModel.realName position:GBNSStringFormat(@"%@ · %@",self.authenModel.companyName,self.authenModel.positionName)  headImage:userManager.currentUser.headImg];
    }
    
    return _headView;
}

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = self.titleArray[section];
    headerView.moreButton.hidden = section == 1 ? YES : YES;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBUploadInfoCell *cell = [[GBUploadInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBUploadInfoCellID section:indexPath.section imageUrls:[self.imageUrlsSectionDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]];
    
    cell.titleLabel.text = self.contentTitleArray[indexPath.section];
    
    cell.updateInfoImages = ^(NSArray *imagesUrls,NSInteger section) {
        [self.imageUrlsSectionDic setObject:imagesUrls forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        [self.baseTableView reloadData];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"工作牌",@"公司邮箱",@"在职证明",@"劳动合同"];
    }
    
    return _titleArray;
}

- (NSArray *)contentTitleArray {
    if (!_contentTitleArray) {
        _contentTitleArray = @[@"拍摄自己的工牌，要求头像、职位名称、公司名称清晰，无遮挡。",@"上传邮箱截图",@"拍摄自己的公司开具的在职证明，要求姓名、公司名、章印清晰，无遮挡。",@"拍摄自己的入职劳动合同，要求拍摄签名盖章页。签名清晰，章印清晰，无遮挡。"];
    }
    
    return _contentTitleArray;
}

#pragma mark - # Getters and Setters
- (NSMutableDictionary *)imageUrlsSectionDic {
    if (!_imageUrlsSectionDic) {
        _imageUrlsSectionDic = [[NSMutableDictionary alloc] init];
    }
    
    return _imageUrlsSectionDic;
}

- (NSMutableDictionary *)hiddenStateSectionDic {
    if (!_hiddenStateSectionDic) {
        _hiddenStateSectionDic = [[NSMutableDictionary alloc] init];
    }
    
    return _hiddenStateSectionDic;
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
