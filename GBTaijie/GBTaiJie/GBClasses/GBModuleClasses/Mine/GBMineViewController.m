//
//  GBMineViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 我的
//  @discussion 个人中心
//

#import "GBMineViewController.h"

// Controllers
/** 消息 */
#import "GBMessageViewController.h"
/** 认证 */
#import "GBPositionCertificationViewController.h"
/**   设置   */
#import "GBSettingViewController.h"
/** 余额 */
#import "GBBalanceViewController.h"
/** 台阶币充值 */
#import "GBTaiJieBiRechargeViewController.h"
/** 订单 */
#import "GBOrderPageViewController.h"
/** 个人信息 */
#import "GBMySelfMessageViewController.h"
/** 服务 */
#import "GBMineServicePageViewController.h"
#import "GBCommonPersonalHomePageViewController.h"

/** 帮助与反馈 */
#import "GBHelpFeedbackViewController.h"

#import "ConversationViewController.h"

/** 小红点 */
#import "RKNotificationHub.h"

// ViewModels

// Models
/** 认证信息 */
#import "AuthenticationStateModel.h"
#import "GBSystemMessageModel.h"

// Views
#import "GBSettingCell.h"
#import "GBMineHeadView.h"
#import "GBBigTitleHeadView.h"
#import "MXRGuideMaskView.h"

#define NAVBAR_COLORCHANGE_POINT -80
#define IMAGE_HEIGHT 250
#define SCROLL_DOWN_LIMIT 12
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)


static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBMineViewController ()<UITableViewDelegate, UITableViewDataSource>
/* 表头视图 */
@property (nonatomic, strong) GBMineHeadView *mineHeadView;

@property (nonatomic, strong) RKNotificationHub *hubBadgeView;

/** 单元格title */
@property (nonatomic, strong) NSArray <NSArray *> *titles;
/** 单元格icon */
@property (nonatomic, strong) NSArray <NSArray *> *subTitles;

/** 订单表头 */
@property (nonatomic, strong) GBBigTitleHeadView *bigTitleHeadView;

@property (strong, nonatomic) AuthenticationStateModel *authenticationModel;
/* <#describe#> */
@property (nonatomic, strong)  GBSystemMessageModel *systemMessageModel;

/* <#describe#> */
@property (nonatomic, assign) BOOL isOrderOuterConfirm;
@property (nonatomic, assign) BOOL isSubscriberConfirm;
@property (nonatomic, assign) BOOL isVendorConfirm;

/* <#describe#> */
@property (nonatomic, strong) NSArray *icons;

@end

@implementation GBMineViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:MineMessageBadgeRefreshNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mineHeadView.userModel = userManager.currentUser;
    
    if (![self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_SUCCESS"]) {
        NetDataServerInstance.forbidShowLoading = YES;
        
        // 未认证成功请求刷新认证状态
        [self getUserAuthenticationState];
    }
    
    NetDataServerInstance.forbidShowLoading = YES;
    
    [self loadRequestMineOrderNewStatus];
    
    [self loadLastSystemMessage];
    
    [self refreshMessageBadge];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.view.backgroundColor = [UIColor kBaseBackgroundColor];
    
    [self headerRereshing];
    
    // 设置子视图
    [self setupSubViews];
    // 设置导航条
    [self setUpNavigationBar];
    if (!ValidStr([GBUserDefaults stringForKey:UDK_Gird_Finish_Mine])) {
        [self guidPageView];
    }
    
    [GBNotificationCenter addObserver:self selector:@selector(refreshMessageBadge) name:MineMessageBadgeRefreshNotification object:nil];
}

- (void)guidPageView {
    NSArray * imageArr = @[@"newbie_guide04",@"newbie_guide05",@"newbie_guide06"];
    CGRect rect0 = self.baseTableView.frame;
    NSArray *imgFrameArr = @[[NSValue valueWithCGRect:CGRectMake(rect0.origin.x+3, CGRectGetMinY(rect0)+IMAGE_HEIGHT - 15, 326, 364)],
                              [NSValue valueWithCGRect:CGRectMake(rect0.origin.x+3, CGRectGetMinY(rect0)+IMAGE_HEIGHT+44, 333, 315)],[NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH-333, CGRectGetMinY(rect0)+ (iPhoneX ? 35 : GBMargin), 333, 568)]
                              ];
    NSArray * transparentRectArr = @[[NSValue valueWithCGRect:rect0],[NSValue valueWithCGRect:rect0],[NSValue valueWithCGRect:rect0]];
    NSArray * orderArr = @[@1,@1,@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    [maskView addImages:imageArr imageFrame:imgFrameArr TransparentRect:transparentRectArr orderArr:orderArr];
    maskView.didDismissMaskViewBlock = ^{
        [GBUserDefaults setObject:@"Gird_Finish_Mine" forKey:UDK_Gird_Finish_Mine];
        [GBUserDefaults synchronize];
    };
    [maskView showMaskViewInView:KEYWINDOW];
}

#pragma mark - # Data
- (void)refreshMessageBadge {
    BOOL refreshImMessageBadge = [JMessage setBadge:[[[IMManager sharedIMManager] getImBadge] intValue]];
    if (refreshImMessageBadge) {
        NSLog(@"成功重置角标%d",[[[IMManager sharedIMManager] getImBadge] intValue]);
    }
    
    [self.baseTableView reloadData];
}

- (void)headerRereshing {
    [super headerRereshing];
    [self getPersonalInfo];
}

/** MARK: 个人信息 */
- (void)getPersonalInfo {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestPersonalInfo:[GBUserDefaults objectForKey:UDK_UserId]];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        UserModel *user = [UserModel mj_objectWithKeyValues:returnValue[@"userInfo"]];
        [userManager saveCurrentUser:user];
        
        self.mineHeadView.userModel = user;
    }];
}

/** MARK: 认证状态 */
- (void)getUserAuthenticationState {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineIncumbentAuthenticationState];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.authenticationModel = [AuthenticationStateModel mj_objectWithKeyValues:returnValue];
        [self.baseTableView reloadData];
    }];
}

- (void)loadRequestMineOrderNewStatus {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineOrderNewStatus];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.isOrderOuterConfirm = [returnValue[@"isOrderOuterConfirm"] boolValue];
        self.isSubscriberConfirm = [returnValue[@"isSubscriberConfirm"] boolValue];
        self.isVendorConfirm = [returnValue[@"isVendorConfirm"] boolValue];
        [self.baseTableView reloadData];
    }];
}

- (void)loadLastSystemMessage {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestOuterSystemMessage];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.systemMessageModel = [GBSystemMessageModel mj_objectWithKeyValues:returnValue[@"message"]];
        self.systemMessageModel.isRead = [returnValue[@"read"] boolValue];
        [self.baseTableView reloadData];
        
        if (self.systemMessageModel.isRead) {
            [JPUSHService setBadge:1];
        }else {
            [JPUSHService setBadge:0];
        }
    }];
}

#pragma mark - # Steup Methods
// MARK: 设置头部
- (void)setupSubViews {
    self.baseTableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT-64, 0, 0, 0);
    
    [self.baseTableView addSubview:self.mineHeadView];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 48;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = GBMargin/2;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    [self.view insertSubview:self.customNavBar aboveSubview:self.baseTableView];
    // MARK: 编辑
    @GBWeakObj(self);
    [self.mineHeadView setHomePageButtonBlock:^{
        @GBStrongObj(self);
        NSLog(@"进入主页");
        if (![self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_SUCCESS"]) {
            return [UIView showHubWithTip:@"您还未通过认证"];
        }
        
        GBCommonPersonalHomePageViewController *homePageVC = [[GBCommonPersonalHomePageViewController alloc] init];
        homePageVC.targetUsrid = [GBUserDefaults stringForKey:UDK_UserId];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
}

- (void)setUpNavigationBar {
    self.customNavBar.title = @"我的";
    
    [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"mine_icon_edit")];
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        GBMySelfMessageViewController *mySelfMessageVC = [[GBMySelfMessageViewController alloc] init];
        [self.navigationController pushViewController:mySelfMessageVC animated:YES];
    }];
    
    if (@available(iOS 11.0, *)) {
        self.baseTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.customNavBar.barBackgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0];
    [self.customNavBar wr_setBackgroundAlpha:0];
    self.customNavBar.titleLabelColor = [UIColor clearColor];
    
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: scrollViewDidScroll-更新导航栏  */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        [self changeNavBarAnimateWithIsClear:NO];
    }
    else
    {
        [self changeNavBarAnimateWithIsClear:YES];
    }
    
    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }
    
    // 改变图片框的大小 (上滑的时候不改变)
    // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT)
    {
        self.mineHeadView.frame = CGRectMake(0, newOffsetY, SCREEN_WIDTH, -newOffsetY);
    }
}

- (void)changeNavBarAnimateWithIsClear:(BOOL)isClear
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.6 animations:^
     {
         __strong typeof(self) pThis = weakSelf;
         if (isClear == YES) {
             [pThis wr_setNavBarBackgroundAlpha:0];
         } else {
             [pThis wr_setNavBarBackgroundAlpha:1.0];
         }
     }];
}

/**  MARK: - tableview delegate / dataSource  */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor kSectionDividingLineColor];
    return footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGBSettingCellID];
    }
    
    cell.cellType = CellTypeIconImageView;
    cell.titleLabel.text = self.titles[indexPath.section][indexPath.row];
    cell.imageView.image = GBImageNamed(self.icons[indexPath.section][indexPath.row]);
    
    cell.textLabel.font = Fit_Font(15);
    cell.contentTextField.font = Fit_Font(14);
    cell.indicateButton.hidden = YES;
    cell.contentTextField.textAlignment = NSTextAlignmentRight;
    BOOL isMessageCell = (indexPath.section == 0 && indexPath.row == 0);
    
    // 当前是认证的cell
    BOOL isCertificationCell = (indexPath.section == 1 && indexPath.row == 0);
    
    // 当前是微简历的cell
    BOOL isResumeCell = (indexPath.section == 1 && indexPath.row == 0);
    cell.contentTextField.textColor = isCertificationCell ? [UIColor kAssistInfoTextColor] : isResumeCell ? [UIColor kBaseColor] : [UIColor kNormoalInfoTextColor];
    
    if (isMessageCell) {
        int count = self.systemMessageModel.isRead ? [[[IMManager sharedIMManager] getImBadge] intValue] +1 : [[[IMManager sharedIMManager] getImBadge] intValue];
        cell.indicateButton.hidden = NO;
        [cell.indicateButton setImage:nil forState:UIControlStateNormal];
        self.hubBadgeView = [[RKNotificationHub alloc]initWithView:cell.indicateButton];
        [self.hubBadgeView moveCircleByX:GBMargin/2 Y:17];
        [self.hubBadgeView setCircleColor:[UIColor redColor] labelColor:[UIColor whiteColor]];
        [self.hubBadgeView scaleCircleSizeBy:0.65];
        self.hubBadgeView.countLabelFont = Fit_Font(10);
        [self.hubBadgeView setCount:count];
    }
    
    if (isCertificationCell) {
        if ([self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_UNCOMMITTED"] || [self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_AUTH_REQUIRE"] || !ValidStr(self.authenticationModel.authenticationState)) {
            cell.contentTextField.text = @"未认证";
        }else if ([self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_IN_REVIEW"]) {
            cell.contentTextField.text = @"审核中";
        }else if ([self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_SUCCESS"]) {
            cell.contentTextField.text = @"已认证";
            self.mineHeadView.vFlagImageView.hidden = NO;
        }else if ([self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_FAILED"]) {
            cell.contentTextField.text = @"认证失败";
        }else if ([self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_FORCED_CANCEL"]) {
            cell.contentTextField.text = @"已撤销";
        }
    }
    
    BOOL isOrderCell = (indexPath.section == 2 && indexPath.row == 2);
    if (isOrderCell) {
        if (self.isOrderOuterConfirm) {
            cell.indicateButton.hidden = NO;
            [cell.indicateButton setImage:nil forState:UIControlStateNormal];
            self.hubBadgeView = [[RKNotificationHub alloc]initWithView:cell.contentTextField];
            [self.hubBadgeView moveCircleByX:-35 Y:8];
            [self.hubBadgeView setCircleColor:[UIColor redColor] labelColor:[UIColor redColor]];
            [self.hubBadgeView scaleCircleSizeBy:0.2];
            self.hubBadgeView.countLabelFont = Fit_Font(1);
            [self.hubBadgeView setCount:1];
        }
        
    }
    
    cell.line.hidden = indexPath.row == self.titles[indexPath.section].count - 1 ? YES : NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        GBMessageViewController *messageVC = [[GBMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.authenticationModel.status) {
                    /** 认证 */
                    GBPositionCertificationViewController *positionCertificationVC =  [[GBPositionCertificationViewController alloc] init];
                    [self.navigationController pushViewController:positionCertificationVC animated:YES];
                }else {
                    if ([self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_SUCCESS"]) {
                        return [UIView showHubWithTip:@"一个月之内不可再次认证"];
                    }
                    
                    /** 认证 */
                    GBPositionCertificationViewController *positionCertificationVC = [[GBPositionCertificationViewController alloc] init];
                    [self.navigationController pushViewController:positionCertificationVC animated:YES];
                }
            }
                break;
            case 1:
            {
                if (![self.authenticationModel.authenticationState isEqualToString:@"INCUMBENT_SUCCESS"]) {
                    return [UIView showHubWithTip:@"认证成功后才能添加服务"];
                }
                
                /** 服务 */
                GBMineServicePageViewController *servicePageVC = [[GBMineServicePageViewController alloc] init];
                servicePageVC.pageController.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
                [servicePageVC setPageMenuTitles:@[@"私聊解密",@"入职保过"] pageControllerType:GBPageControllerTypeService];
                [self.navigationController pushViewController:servicePageVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                /** 余额 */
                GBBalanceViewController *balaceVC = [[GBBalanceViewController alloc] init];
                [self.navigationController pushViewController:balaceVC animated:YES];
                
            }
                break;
            case 1:
            {
                /** 充值台阶币 */
                GBTaiJieBiRechargeViewController *taijiebiRechargeVC = [[GBTaiJieBiRechargeViewController alloc] init];
                [self.navigationController pushViewController:taijiebiRechargeVC animated:YES];
                
            }
                break;
            case 2:
            {
                /** 订单 */
                GBOrderPageViewController *mineOrderPageVC = [[ GBOrderPageViewController alloc] init];
                mineOrderPageVC.isSubscriberConfirm = self.isSubscriberConfirm;
                mineOrderPageVC.isVendorConfirm = self.isVendorConfirm;
                mineOrderPageVC.pageController.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
                [mineOrderPageVC setPageMenuTitles:@[@"已购",@"服务"] pageControllerType:GBPageControllerTypeMineOrderPage];
                mineOrderPageVC.pageHeadView = self.bigTitleHeadView;
                self.bigTitleHeadView.titleLabel.text =  @"订单";
                
                [self.navigationController pushViewController:mineOrderPageVC animated:YES];
            }
                break;
            case 3:
            {
                /** 收藏 */
                GBBasePageViewSuperController *mineOrderPageVC = [[ GBBasePageViewSuperController alloc] init];
                mineOrderPageVC.pageController.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
                [mineOrderPageVC setPageMenuTitles:@[@"朋友",@"职位",@"企业"] pageControllerType:GBPageControllerTypeCollect];
                mineOrderPageVC.pageHeadView = self.bigTitleHeadView;
                self.bigTitleHeadView.titleLabel.text =  @"收藏";
                [self.navigationController pushViewController:mineOrderPageVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:
            {
                /** 帮助与反馈 */
                GBHelpFeedbackViewController *helpVC = [[GBHelpFeedbackViewController alloc] init];
                [self.navigationController pushViewController:helpVC animated:YES];
            }
                break;
            case 1:
            {
                /** 设置 */
                GBSettingViewController *settingVC = [[GBSettingViewController alloc] init];
                [self.navigationController pushViewController:settingVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - # Getters and Setters
- (NSArray <NSArray *> *)titles {
    if (!_titles) {
        // _titles = @[@[@"认证",@"服务"],@[@"微简历",@"收藏"],@[@"余额",@"订单"],@[@"帮组与反馈",@"设置"]];
        _titles = @[@[@"消息中心"],@[@"认证",@"发布服务"],@[@"余额",@"充值",@"订单",@"收藏"],@[@"帮助与反馈",@"设置"]];
        // _titles = @[@[@"余额",@"充值"],@[@"设置"]];
    }
    
    return _titles;
}

- (NSArray <NSArray *> *)subTitles {
    if (!_subTitles) {
        _subTitles = [[NSMutableArray alloc] initWithArray:@[@[@"",@"1"],@[@"未填写",@"12"],@[@"999",@"888",@"123"],@[@"",@""]]];
    }
    
    return _subTitles;
}

- (GBMineHeadView *)mineHeadView {
    if (!_mineHeadView) {
        _mineHeadView = [[GBMineHeadView alloc] initWithFrame:CGRectMake(0, -IMAGE_HEIGHT, SCREEN_WIDTH, IMAGE_HEIGHT)];
    }
    
    return _mineHeadView;
}

- (GBBigTitleHeadView *)bigTitleHeadView {
    if (!_bigTitleHeadView) {
        _bigTitleHeadView = [[GBBigTitleHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    }
    
    return _bigTitleHeadView;
}

- (NSArray *)icons {
    if (!_icons) {
        _icons = @[@[@"mine_icon_message"],@[@"mine_icon_certification",@"mien_icon_service"],@[@"mine_icon_balance",@"icon_Recharge",@"mine_icon_menu",@"mine_icon_collection"],@[@"mine_icon_help",@"mien_icon_setting"]];
    }
    
    return _icons;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
