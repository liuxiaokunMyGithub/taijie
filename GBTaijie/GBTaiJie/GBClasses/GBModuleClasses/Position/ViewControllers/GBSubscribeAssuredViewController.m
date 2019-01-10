//
//  GBSubscribeAssuredViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/22.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 预约保过
//  @discussion <#类的功能#>
//

#import "GBSubscribeAssuredViewController.h"

#import <AlipaySDK/AlipaySDK.h>

// Controllers
/** 留言 */
#import "GBSubscribeMessageViewController.h"

// ViewModels


// Models


// Views
#import "GBPersonalSectionHeadView.h"
#import "GBSettingCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

@interface GBSubscribeAssuredViewController ()<UITableViewDelegate,UITableViewDataSource>
/* 组头 */
@property (nonatomic, strong) NSMutableArray *sectionTitleListArray;

/* 留言 */
@property (nonatomic, strong) NSString *subscribeMessage;

/* 芝麻分 */
@property (nonatomic, copy) NSString *zmScore;

@end

@implementation GBSubscribeAssuredViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"预约保过";

    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 50;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"预约保过"];
    [self.view addSubview:[self setupBottomViewWithtitle:@"提交"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
    @GBStrongObj(self);
        [self saveAssuredInfoRequest];
    };
}


#pragma mark - # Setup Methods

#pragma mark - # Event Response
- (void)saveAssuredInfoRequest {
    if (!ValidStr(self.subscribeMessage)) {
        return [UIView showHubWithTip:@"请给对方留言"];
    }
    NSDictionary *positionDic = @{
                                  @"positionId": GBNSStringFormat(@"%zu",self.serviceModel.jobId) ,
                                  @"positionName":self.serviceModel.jobName,
                                  @"companyName":self.serviceModel.companyName,
                                  @"minSalary":self.serviceModel.minSalary,
                                  @"maxSalary":self.serviceModel.maxSalary,
                                  };
    
    GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
    [positionVM loadPositionsOrderAssurePass:self.subscribeMessage
                            zhimaCreditScore:self.zmScore
                             positionInfoDic:positionDic
                    incumbentAssurePassId:self.serviceModel.assurePassId];
    [positionVM setSuccessReturnBlock:^(id returnValue) {
        [self.navigationController popViewControllerAnimated:YES];
        [UIView showHubWithTip:@"预约成功"];
    }];
}

#pragma mark - # Privater Methods
/** MARK: 阿里芝麻信用分 */
- (void)loadAlipayZhiMaAuthInfo {
    GBCommonViewModel *commonVM = [[GBCommonViewModel alloc] init];
    [commonVM loadRequestAlipayAccountAuthSign];
    [commonVM setSuccessReturnBlock:^(id returnValue) {
        NSString *authInfoStr = returnValue;
        authInfoStr = [authInfoStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:@"taijieAlipay"
                                           callback:^(NSDictionary *resultDic) {
                                               NSLog(@"result = %@",resultDic);
                                               // 解析 auth code
                                               NSString *result = resultDic[@"result"];
                                               NSString *authCode = nil;
                                               if (result.length>0) {
                                                   NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                                                   for (NSString *subResult in resultArr) {
                                                       if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                                                           authCode = [subResult substringFromIndex:10];
                                                           break;
                                                       }
                                                   }
                                               }
                                               NSLog(@"授权结果 authCode = %@", authCode?:@"");
                                               [self getZMScoreWith:authCode?:@""];
                                               
                                           }];
        
    }];
}

- (void)getZMScoreWith:(NSString *)authCode {
    GBCommonViewModel *commonVM = [[GBCommonViewModel alloc] init];
    [commonVM loadRequestAlipayGetZmScore];
    [commonVM setSuccessReturnBlock:^(id returnValue) {
      NSString *codeStr = [returnValue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        self.zmScore = [NSString stringWithFormat:@"%@",codeStr];
        [self.baseTableView reloadData];
    }];
    
}

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 50 : [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = [self.sectionTitleListArray objectAtIndex:section];
    headerView.moreButton.hidden = YES;
    headerView.titleLabel.font = Fit_M_Font(17);
    
    return headerView;
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
    cell.cellType = CellTypeDetailsLabel;
    cell.contentTextField.textAlignment = NSTextAlignmentRight;
    cell.line.hidden = indexPath.section == 0 ? NO : YES;
    cell.titleLabel.numberOfLines = 0;
    cell.indicateButton.hidden = (indexPath.section == 0 && indexPath.row == 1) ? NO : YES;
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = (indexPath.row == 0 ? @"目标职位" : @"芝麻信用");
        cell.contentTextField.text =  indexPath.row == 0 ?  self.serviceModel.jobName : self.zmScore;
    }else {
        cell.titleLabel.text = indexPath.row == 0 ? self.subscribeMessage : ValidStr(self.subscribeMessage) ? @"重新填写" : @"填写";
        cell.titleLabel.textColor = indexPath.row == 0 ? [UIColor kNormoalInfoTextColor] : [UIColor kBaseColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        // 进入芝麻信用
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        // 进入留言
        GBSubscribeMessageViewController *subscribeMessageVC = [[GBSubscribeMessageViewController alloc] init];
        subscribeMessageVC.saveButtonClickBlock = ^(NSString *valueStr) {
             // 保存留言
            self.subscribeMessage = valueStr;
            [self.baseTableView reloadData];
        };
        
        [self.navigationController pushViewController:subscribeMessageVC animated:YES];
    }
}

#pragma mark - # Getters and Setters
- (NSMutableArray *)sectionTitleListArray {
    if (!_sectionTitleListArray) {
        _sectionTitleListArray = [NSMutableArray arrayWithArray:@[@"基本资料",@"留言"]];
    }
    
    return _sectionTitleListArray;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
