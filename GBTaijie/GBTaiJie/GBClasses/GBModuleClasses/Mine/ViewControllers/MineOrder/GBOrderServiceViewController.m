//
//  GBOrderServiceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBOrderServiceViewController.h"

// Controllers
#import "GBOrderDetailsViewController.h"

// ViewModels


// Models
#import "BuyOrderModel.h"

// Views
#import "GBOrderRecodCell.h"

static NSString *const kGBOrderRecodCellID = @"GBOrderRecodCell";

@interface GBOrderServiceViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 记录列表 */
@property (strong, nonatomic)  NSMutableArray <BuyOrderModel *> *orderList;

/* 订单状态 */
@property (nonatomic, strong) NSString *stateStr;
/** 订单类型 */
@property (nonatomic, strong) NSString *typeStr;

@end

@implementation GBOrderServiceViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:OrderFiltrateNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [GBNotificationCenter removeObserver:self name:OrderFiltrateNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [GBNotificationCenter addObserver:self selector:@selector(getOrderData:) name:OrderFiltrateNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateStr = @"";
    self.typeStr = @"";
    
    [self getOrderData];
    
    // 设置子视图
    [self setupSubViews];
    
}

#pragma mark - # Data
- (void)getOrderData:(NSNotification *)notification {
    NSArray <NSArray *>*filtrateArray = notification.object;
    NSLog(@"filtrateArray%@",filtrateArray);
    if ([filtrateArray[0][0] isEqualToString:@"私聊解密"]) {
        self.typeStr = @"GOODS_TYPE_JM";
    }else if ([filtrateArray[0][0] isEqualToString:@"入职保过"]) {
        self.typeStr = @"GOODS_TYPE_BG";
    }else {
        self.typeStr = @"";
    }
    
    if ([filtrateArray[1][0] isEqualToString:@"待确认"]) {
        self.stateStr = @"TO_BE_CONFIRMED";

    }else if ([filtrateArray[0][0] isEqualToString:@"进行中"]) {
        self.stateStr = @"ONGOING";
    }else if ([filtrateArray[0][0] isEqualToString:@"已结束"]) {
        self.stateStr = @"FINISHED";
    }else if ([filtrateArray[0][0] isEqualToString:@"已退款"]) {
        self.stateStr = @"REFUNDED";
    }else {
        self.stateStr = @"";
    }
    
    page = 1;
    
    if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
        // 已购订单
        [self getPurchasedOrderListData];
    }else if (self.roleOrderType == RoleOrderTypeSellerService){
        // 服务订单
        [self getIncumbentOrderListData];
    }
}

- (void)headerRereshing {
    [super headerRereshing];
    [self getOrderData];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getOrderData];
}

- (void)getOrderData {
    if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
        // 已购订单
        [self getPurchasedOrderListData];
    }else {
        // 服务订单
        [self getIncumbentOrderListData];
    }
}

// MARK: 已购订单
- (void)getPurchasedOrderListData {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestPurchasedOrderList:page pageSize:10 status:self.stateStr serviceType:self.typeStr];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [BuyOrderModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.orderList = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.orderList addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        if (self.orderList.count) {
            [self removeNoDataImage];
        }else {
            self.noDataViewTopMargin = Fit_W_H(120);
            [self showNoDataImage];
        }
    }];
}

// MARK: 服务订单
- (void)getIncumbentOrderListData {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestIncumbentOrderList:page pageSize:10 status:self.stateStr serviceType:self.typeStr];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [BuyOrderModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.orderList = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.orderList addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        if (self.orderList.count) {
            [self removeNoDataImage];
        }else {
            self.noDataViewTopMargin = Fit_W_H(120);
            [self showNoDataImage];
        }
    }];
}

#pragma mark - # Setup Methods
// MARK: 设置头部
- (void)setupSubViews {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 80;
    self.baseTableView.sectionHeaderHeight = 0.0000001;
    self.baseTableView.sectionFooterHeight = 0.0000001;
    [self.baseTableView registerClass:[GBOrderRecodCell class] forCellReuseIdentifier:kGBOrderRecodCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.top = 0;
    self.baseTableView.height = (SCREEN_HEIGHT - SafeAreaTopHeight - 80 - 44 - SafeAreaBottomHeight);
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods

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
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBOrderRecodCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBOrderRecodCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGBOrderRecodCellID];
    }
    cell.roleOrderType = self.roleOrderType;
    cell.orderModel = self.orderList[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestOrderNoticeStatusRenewal:self.roleOrderType == RoleOrderTypeBuyersPurchased ? @"SUBSCRIBER" : @"VENDOR" serviceType:self.orderList[indexPath.row].serviceType serviceId:self.orderList[indexPath.row].relatedId];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        [GBNotificationCenter postNotificationName:OrderNewStatusNotification object:nil];
        self.orderList[indexPath.row].isSubscriberConfirm = 0;
        self.orderList[indexPath.row].isVendorConfirm = 0;
        
        [self.baseTableView reloadData];
    }];
    
    GBOrderDetailsViewController *orderDetailsVC = [[GBOrderDetailsViewController alloc] init];
    orderDetailsVC.roleOrderType = self.roleOrderType;
    if ([self.orderList[indexPath.row].serviceType isEqualToString:@"GOODS_TYPE_BG"]) {
        orderDetailsVC.orderDetailsType = OrderDetailsTypeAssurePass;
    }else {
        orderDetailsVC.orderDetailsType = OrderDetailsTypeDecrypt;
    }
    orderDetailsVC.orderId = self.orderList[indexPath.row].relatedId;
    [[GBAppHelper getPushNavigationContr] pushViewController:orderDetailsVC animated:YES];
}

#pragma mark - # Getters and Setters

- (NSMutableArray *)orderList {
    if (!_orderList) {
        _orderList = [[NSMutableArray alloc] initWithArray:@[]];
    }
    
    return _orderList;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
