//
//  GBSystemMessageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 系统消息
//  @discussion <#类的功能#>
//

#import "GBSystemMessageViewController.h"
// Controllers
#import "GBSystemMessageModel.h"
#import "GBRedPacketsView.h"
#import "GBOrderDetailsViewController.h"
#import "GBBalanceViewController.h"
// ViewModels


// Models


// Views
#import "GBSystemMessageCell.h"

static NSString *const kGBSystemMessageCellID = @"GBSystemMessageCell";

@interface GBSystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBSystemMessageModel *>*systemMessageList;

@end

@implementation GBSystemMessageViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:SystemMessageRefreshNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getSystemMessages];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 110;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 16;
    [self.baseTableView registerClass:[GBSystemMessageCell class] forCellReuseIdentifier:kGBSystemMessageCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"系统消息"];
    
    [GBNotificationCenter addObserver:self selector:@selector(headerRereshing) name:SystemMessageRefreshNotification object:nil];
}

- (void)headerRereshing {
    [super headerRereshing];
    [self getSystemMessages];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getSystemMessages];
}

#pragma mark - # Setup Methods
- (void)getSystemMessages {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestSystemsMessages:page pageSize:10];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBSystemMessageModel mj_objectArrayWithKeyValuesArray:returnValue];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.systemMessageList = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.systemMessageList addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        
        [self reloadNoDataImage];
    }];
}

#pragma mark - # Event Response
- (void)reloadNoDataImage {
    if (self.systemMessageList.count) {
        [self removeNoDataImage];
    }else {
        [self showNoDataImage];
    }
}

#pragma mark - # Privater Methods


#pragma mark - # Delegate


#pragma mark - # Getters and Setters
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.systemMessageList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSystemMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSystemMessageCellID];
    }
    cell.systemMessageModel = self.systemMessageList[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//添加删除按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        GBSystemMessageModel *systemModel = self.systemMessageList[indexPath.section];
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestSystemsMessageAction:systemModel.relatedServiceType action:@"DELETE" messageId:systemModel.messageId];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [self.systemMessageList removeObjectAtIndex:indexPath.section];
            [self.baseTableView reloadData];
            [self reloadNoDataImage];
        }];
    }];
    
    return  @[deleteRow];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 修改已读状态刷新列表
    GBSystemMessageModel *systemModel = self.systemMessageList[indexPath.section];
    NetDataServerInstance.forbidShowLoading = YES;
    if ([systemModel.relatedServiceType isEqualToString:@"GOODS_TYPE_RP"]) {
        if ([systemModel.action isEqualToString:@"GET"]) {
            // 红包
            [GBRedPacketsView showRedPacketJoinView:KEYWINDOW margin:0];
        }else {
            if (!systemModel.isRead) {
                GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
                [mineVM loadRequestSystemsMessageAction:systemModel.relatedServiceType action:systemModel.action messageId:systemModel.messageId];
                [mineVM setSuccessReturnBlock:^(id returnValue) {
                }];
                systemModel.isRead = YES;
                [self.baseTableView reloadData];
            }
            
            if ([systemModel.action isEqualToString:@"VIEW"]) {
                GBBalanceViewController *balanceVC = [[GBBalanceViewController alloc] init];
                [self.navigationController pushViewController:balanceVC animated:YES];
            }
        }
    }else if (ValidStr(systemModel.relatedServiceType)){
        if (!systemModel.isRead) {
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            [mineVM loadRequestSystemsMessageAction:systemModel.relatedServiceType action:systemModel.action messageId:systemModel.messageId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
            }];
            systemModel.isRead = YES;
            [self.baseTableView reloadData];
        }
        GBOrderDetailsViewController *orderDetailsVC = [[GBOrderDetailsViewController alloc] init];
        NSInteger roleOrderType = [systemModel.orderDirection isEqualToString:@"P"] ? RoleOrderTypeBuyersPurchased:[systemModel.orderDirection isEqualToString:@"S"] ? RoleOrderTypeSellerService : -1;
        orderDetailsVC.roleOrderType = roleOrderType;
        if ([self.systemMessageList[indexPath.section].relatedServiceType isEqualToString:@"GOODS_TYPE_BG"]) {
            orderDetailsVC.orderDetailsType = OrderDetailsTypeAssurePass;
        }else if ([systemModel.relatedServiceType isEqualToString:@"GOODS_TYPE_JM"]) {
            orderDetailsVC.orderDetailsType = OrderDetailsTypeDecrypt;
        }
        orderDetailsVC.orderId = systemModel.relatedServiceId;
        [self.navigationController pushViewController:orderDetailsVC animated:YES];
    }else {
        //        if ([systemModel.action isEqualToString:@"VIEW"]) {
        if (!systemModel.isRead) {
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            [mineVM loadRequestSystemsMessageAction:systemModel.relatedServiceType action:systemModel.action messageId:systemModel.messageId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
            }];
            systemModel.isRead = YES;
            [self.baseTableView reloadData];
        }
        //        }
    }
}

- (NSMutableArray *)systemMessageList {
    if (!_systemMessageList) {
        _systemMessageList = [[NSMutableArray alloc] init];
    }
    
    return _systemMessageList;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
