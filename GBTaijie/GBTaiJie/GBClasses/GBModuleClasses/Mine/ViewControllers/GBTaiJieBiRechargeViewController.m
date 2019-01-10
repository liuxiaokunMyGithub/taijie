//
//  GBTaiJieBiRechargeViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBTaiJieBiRechargeViewController.h"
#import "IAPManager.h"
// Controllers


// ViewModels


// Models


// Views
#import "GBTaijiebiCell.h"


#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 160
#define NAV_HEIGHT 64

static NSString *const kGBTaijiebiCellID = @"GBTaijiebiCell";

@interface GBTaiJieBiRechargeViewController ()<UITableViewDelegate, UITableViewDataSource,IApRequestResultsDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** 记录列表 */
@property (nonatomic, strong) NSMutableArray *arrData;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <SKProduct *> *products;

/* 表头视图 */
@property (nonatomic, strong) UIView *blanceHeadView;
@property (nonatomic, strong) UIImageView *headBgView;
@property (nonatomic, strong) UILabel *headTitleLabel;
@property (nonatomic, strong) UILabel *promptleLabel;

/* <#describe#> */
@property (nonatomic, assign) NSInteger tag;

@end

@implementation GBTaiJieBiRechargeViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"台阶币充值";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchasedSuccess:) name:kProductPurchasedSuccessNotification object:nil];
    
    // 设置子视图
    [self setupSubViews];
    // 设置导航条
    [self setUpNavigationBar];
    
    [self walletMoney];
    
    self.arrData = [NSMutableArray array];
    [self.arrData addObject:@{@"name":@"4台阶币",@"price":@"6",@"id":@"com.taijie.6"}];
    [self.arrData addObject:@{@"name":@"12台阶币",@"price":@"18",@"id":@"com.taijie.18"}];
    [self.arrData addObject:@{@"name":@"30台阶币",@"price":@"45",@"id":@"com.taijie.45"}];
    [self.arrData addObject:@{@"name":@"74台阶币",@"price":@"108",@"id":@"com.taijie.108"}];
    [self.arrData addObject:@{@"name":@"225台阶币",@"price":@"328",@"id":@"com.taijie.328"}];
    [self.arrData addObject:@{@"name":@"478台阶币",@"price":@"698",@"id":@"com.taijie.698"}];
    [self IAP];
}

#pragma mark - # Data
- (void)walletMoney {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestBalance];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.headTitleLabel.text = [NSString stringWithFormat:@"%@币",returnValue[@"leftToken"]];
    }];
}

#pragma mark - # Setup Methods
// MARK: 设置头部
- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.blanceHeadView;
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
}

- (void)setUpNavigationBar {
    [self.customNavBar wr_setLeftButtonWithImage:GBImageNamed(@"icon_back_gold")];
    [self.customNavBar setBarBackgroundColor:[[UIColor colorWithHexString:@"#1F1F24"]colorWithAlphaComponent:0.95]];
    self.customNavBar.titleLabelColor = [UIColor kGoldTintColor];
    
    self.StatusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - # Event Response

//*------------------
// MARK: 内购
//-------------------*

// MARK：初始化
- (void)IAP{
    [[IAPManager sharedIAPManager] startManager];
    [IAPManager sharedIAPManager].delegate = self;
}

// MARK: 点击开始购买
- (void)applePayNow:(UIButton *)button {
    [GBLoadingWaitView showCircleJoinView:KEYWINDOW isClearBackgoundColor:YES margin:0];
    self.tag = button.tag;
    NSDictionary *dic = self.arrData[self.tag];
    NSString *currentProId = dic[@"id"];
    // 请求商品
    [[IAPManager sharedIAPManager] requestProductWithId:currentProId];
}

// 购买成功通知 - 刷新余额
- (void)productPurchasedSuccess:(NSNotification *)notification {
    [GBLoadingWaitView hide];
    // 极光统计内购充值
    NSDictionary *dic = self.arrData[self.tag];
    NSString *currentProId = dic[@"id"];
    [GBAppDelegate setupJAnalyticsCountEvent:currentProId];
    // 刷新余额
    [self walletMoney];
}

#pragma mark 购买失败 - IApRequestResultsDelegate
- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error {
    NSString *errorStr = @"支付失败";
    switch (errorCode) {
        case IAP_FILEDCOED_APPLECODE:
            NSLog(@"用户禁止应用内付费购买:%@",error);
            errorStr = GBNSStringFormat(@"用户禁止应用内付费购买%@",error);
            break;
            
        case IAP_FILEDCOED_NORIGHT:
            errorStr = @"用户禁止应用内付费购买";
            NSLog(@"用户禁止应用内付费购买");
            break;
            
        case IAP_FILEDCOED_EMPTYGOODS:
            errorStr = @"商品为空";
            NSLog(@"商品为空");
            break;
            
        case IAP_FILEDCOED_CANNOTGETINFORMATION:
            errorStr = @"无法获取产品信息，请重试";
            NSLog(@"无法获取产品信息，请重试");
            break;
            
        case IAP_FILEDCOED_BUYFILED:
            errorStr = @"购买失败，请重试";
            NSLog(@"购买失败，请重试");
            break;
            
        case IAP_FILEDCOED_USERCANCEL:
            errorStr = @"用户取消交易";
            NSLog(@"用户取消交易");
            break;
            
        default:
            break;
    }
    
    [GBLoadingWaitView hide];
    
    [UIView showHubWithTip:errorStr];
}

#pragma mark - # Delegate

#pragma mark - # Getters and Setters
/**  MARK: - tableview delegate / dataSource  */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBTaijiebiCell *cell = [tableView dequeueReusableCellWithIdentifier:kGBTaijiebiCellID];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.arrData[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    [cell.priceButton setTitle:[NSString stringWithFormat:@"¥%@",dic[@"price"]] forState:UIControlStateNormal];
    cell.indexPath = indexPath;
    cell.priceButton.tag = indexPath.row;
    [cell.priceButton addTarget:self action:@selector(applePayNow:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - # Getters and Setters

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] initWithArray:@[]];
    }
    
    return _arrData;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0, SafeAreaTopHeight, self.view.frame.size.width, self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:frame                                                  style:UITableViewStyleGrouped];
        [_tableView registerClass:[GBTaijiebiCell class] forCellReuseIdentifier:kGBTaijiebiCellID];
        _tableView.rowHeight = 56;
       _tableView.sectionHeaderHeight = GBMargin/2;
        _tableView.sectionFooterHeight = 0.0000001;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (UIView *)blanceHeadView {
    if (!_blanceHeadView) {
        _blanceHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IMAGE_HEIGHT)];
        [_blanceHeadView addSubview:self.headBgView];
        [_blanceHeadView addSubview:self.headTitleLabel];
        [_blanceHeadView addSubview:self.promptleLabel];
    }
    
    return _blanceHeadView;
}

- (UIImageView *)headBgView {
    if (!_headBgView) {
        _headBgView = [[UIImageView alloc] initWithFrame:CGRectMake(-GBMargin, 0, SCREEN_WIDTH+GBMargin*2, IMAGE_HEIGHT)];
        _headBgView.image = GBImageNamed(@"glob_head_bg_icon");
        [_headBgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _headBgView.contentMode =  UIViewContentModeScaleAspectFill;
        _headBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _headBgView.clipsToBounds  = YES;
    }
    
    return _headBgView;
}

- (UILabel *)headTitleLabel {
    if (!_headTitleLabel) {
        CGRect frame = CGRectMake(GBMargin, IMAGE_HEIGHT/2-30, SCREEN_WIDTH-GBMargin*2, 30);
        _headTitleLabel = [UILabel createLabelWithFrame:frame
                                                   text:@"0币"
                                                   font:Fit_B_Font(38)
                                              textColor:[UIColor kImportantTitleTextColor]
                                          textAlignment:NSTextAlignmentCenter];
    }
    
    return _headTitleLabel;
}

- (UILabel *)promptleLabel {
    if (!_promptleLabel) {
        CGRect frame = CGRectMake(GBMargin, CGRectGetMaxY(self.headTitleLabel.frame)+GBMargin/2, SCREEN_WIDTH-GBMargin*2, 16);
        _promptleLabel = [UILabel createLabelWithFrame:frame
                                                  text:@"当前剩余台阶币"
                                                  font:Fit_B_Font(11)
                                             textColor:[[UIColor colorWithHexString:@"#453B31"]colorWithAlphaComponent:0.5]                                         textAlignment:NSTextAlignmentCenter];
    }
    
    return _promptleLabel;
}

- (NSMutableArray *)products {
    if (!_products) {
        _products = [[NSMutableArray alloc] init];
    }
    
    return _products;
}
// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
