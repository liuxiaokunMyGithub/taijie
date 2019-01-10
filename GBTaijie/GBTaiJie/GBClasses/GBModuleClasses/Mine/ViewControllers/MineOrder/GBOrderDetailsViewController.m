//
//  GBOrderDetailsViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/12.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 订单详情
//  @discussion 展示解密及已购订单
//

#import "GBOrderDetailsViewController.h"

// Controllers
/** 评价 */
#import "GBOrderServiceEvaluationViewController.h"
/** 支付 */
#import "YQPayKeyWordVC.h"
/** 支付密码修改 */
#import "GBModifyViewController.h"
/** 台阶币 */
#import "GBTaiJieBiRechargeViewController.h"
/** 结束服务 */
#import "GBEndServiceViewController.h"
#import "GBCommonPersonalHomePageViewController.h"
// ViewModels


// Models
#import "GBOrderDetailsModel.h"

// Views
#import "GBPersonalSectionHeadView.h"
#import "GBSettingCell.h"
#import "GBOrderDetailsPersonalInfoCell.h"

static NSString *const kGBOrderDetailsPersonalInfoCellID = @"GBOrderDetailsPersonalInfoCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 组标题 */
@property (nonatomic, strong) NSMutableArray *sectionTitleListArray;
/* 列表内容 */
@property (nonatomic, strong) NSMutableArray *detailsContentListArray;
@property (nonatomic, strong) NSMutableArray *detailsTitleListArray;

/* 订单详情 */
@property (nonatomic, strong) GBOrderDetailsModel *orderDeailsModel;
/* 底部按钮视图 */
@property (nonatomic, strong) UIView *bottomView;

/* 分割线 */
@property (nonatomic, strong) UIView *lineView;

/* 底部确认按钮 */
@property (nonatomic, strong) UIButton *confirmButton;
/* 底部按钮标题 */
@property (nonatomic, copy) NSString *confirmButtonStateTitle;

/* 订单按钮 */
@property (nonatomic, strong) UIButton *orderButton;
/* 订单按钮标题 */
@property (nonatomic, copy) NSString *orderButtonTitle;

/* 底部状态 */
@property (nonatomic, copy) NSString *bottomStateStr;

/* 价格 */
@property (nonatomic, strong) UILabel *priceLabel;

/* 支付 */
@property (nonatomic, strong)  YQPayKeyWordVC *payPsdVC;

/* <#describe#> */
@property (nonatomic, copy) NSString *targetUserId;

@end

@implementation GBOrderDetailsViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self headerRereshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"订单详情";
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBOrderDetailsPersonalInfoCell class] forCellReuseIdentifier:kGBOrderDetailsPersonalInfoCellID];
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableFooterView = [self setupTableViewFooterView];
    self.baseTableView.height = SCREEN_HEIGHT - SafeAreaTopHeight - BottomViewFitHeight(80);
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.lineView];
    [self.bottomView addSubview:self.confirmButton];
    [self.bottomView addSubview:self.priceLabel];
    
    [self p_addMasonry];
}

#pragma mark - # Setup Methods
/** MARK: Data */
- (void)headerRereshing {
    [super headerRereshing];
    [self getOrderDetailsData];
}

// 订单详情
- (void)getOrderDetailsData {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    if (self.orderDetailsType == OrderDetailsTypeDecrypt) {
        [mineVM loadRequestDecryptOrderDetails:self.orderId];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            self.orderDeailsModel = [GBOrderDetailsModel mj_objectWithKeyValues:returnValue];
            /* 用户既可以是服务购买者（已购订单），又可以是服务提供者（服务订单）
             在同一状态下区分两者角色，进行不同的状态处理               */
            if ([self.orderDeailsModel.decryptStatus isEqualToString:@"TO_BE_CONFIRMED"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButtonTitle = @"取消订单";
                    self.confirmButtonStateTitle = @"等待确认";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButtonTitle = @"拒绝订单";
                    self.confirmButtonStateTitle = @"确认订单";
                }
            }else if ([self.orderDeailsModel.decryptStatus isEqualToString:@"DUE_TO_PAY"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButtonTitle = @"取消订单";
                    self.confirmButtonStateTitle = @"立即支付";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"耐心等待";
                }
            }else if ([self.orderDeailsModel.decryptStatus isEqualToString:@"ONGOING"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButtonTitle = @"结束服务";
                    self.confirmButtonStateTitle = @"立即沟通";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"立即沟通";
                }
            }else if ([self.orderDeailsModel.decryptStatus isEqualToString:@"FINISHED"]) {
                self.bottomStateStr = @"已结束";
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    if ([self.orderDeailsModel.subscribeEvaluted isEqualToString:@"0"]) {
                        self.confirmButtonStateTitle = @"立即评价";
                    }else {
                        self.confirmButtonStateTitle = @"已评价";
                        self.confirmButton.userInteractionEnabled = NO;
                    }
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    if ([self.orderDeailsModel.subscribeEvaluted isEqualToString:@"0"]) {
                        self.confirmButtonStateTitle = @"等待评价";
                    }else {
                        self.confirmButtonStateTitle = @"服务完成";
                        self.confirmButton.userInteractionEnabled = NO;
                    }
                }
            }else if ([self.orderDeailsModel.decryptStatus isEqualToString:@"REFUSE"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = @"已拒绝";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"我知道了";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = @"已拒绝";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已拒绝";
                }
            }else if ([self.orderDeailsModel.decryptStatus isEqualToString:@"CANCELLED"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = @"已取消";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已取消";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = @"对方已取消";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"对方已取消";
                }
            }else if ([self.orderDeailsModel.decryptStatus isEqualToString:@"OVERDUE"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = @"已过期";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已过期";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = @"已过期";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已过期";
                }
            }else if ([self.orderDeailsModel.assurePassStatus isEqualToString:@"REFUNDED"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = @"已退款";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已退款";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = @"已退款";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已退款";
                }
            }
            
            // 设置数据源
            [self setupDataSource];
            // 底部状态标题
            [self setupBottomViewTitle];
            
            [self.baseTableView reloadData];
        }];
    }else {
        [mineVM loadRequestAssurePassOrderDetails:self.orderId];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            self.orderDeailsModel = [GBOrderDetailsModel mj_objectWithKeyValues:returnValue];
            /* 用户既可以是服务购买者（已购订单），又可以是服务提供者（服务订单）
             在同一状态下区分两者角色，进行不同的状态处理               */
            if ([self.orderDeailsModel.assurePassStatus isEqualToString:@"TO_BE_CONFIRMED"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButtonTitle = @"取消订单";
                    self.confirmButtonStateTitle = @"等待确认";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButtonTitle = @"拒绝订单";
                    self.confirmButtonStateTitle = @"确认订单";
                }
            }else if ([self.orderDeailsModel.assurePassStatus isEqualToString:@"DUE_TO_PAY"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButtonTitle = @"取消订单";
                    self.confirmButtonStateTitle = @"立即支付";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"耐心等待";
                }
            }else if ([self.orderDeailsModel.assurePassStatus isEqualToString:@"ONGOING"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButtonTitle = @"结束服务";
                    self.confirmButtonStateTitle = @"立即沟通";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime);
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"立即沟通";
                }
            }else if ([self.orderDeailsModel.assurePassStatus isEqualToString:@"FINISHED"]) {
                self.bottomStateStr = @"已结束";
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    if ([self.orderDeailsModel.subscribeEvaluted isEqualToString:@"0"]) {
                        self.confirmButtonStateTitle = @"立即评价";
                    }else {
                        self.confirmButtonStateTitle = @"已评价";
                        self.confirmButton.userInteractionEnabled = NO;
                    }
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    if ([self.orderDeailsModel.subscribeEvaluted isEqualToString:@"0"]) {
                        self.confirmButtonStateTitle = @"等待评价";
                    }else {
                        self.confirmButtonStateTitle = @"服务完成";
                        self.confirmButton.userInteractionEnabled = NO;
                    }
                }
            }else if ([self.orderDeailsModel.assurePassStatus isEqualToString:@"REFUSE"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = @"已拒绝";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"我知道了";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = @"已拒绝";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已拒绝";
                }
            }else if ([self.orderDeailsModel.assurePassStatus isEqualToString:@"CANCELLED"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    // 已购订单（购买者）
                    self.bottomStateStr = @"已取消";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已取消";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = @"对方已取消";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"对方已取消";
                }
            }else if ([self.orderDeailsModel.assurePassStatus isEqualToString:@"OVERDUE"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = @"已过期";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已过期";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = @"已过期";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已过期";
                }
            }else if ([self.orderDeailsModel.assurePassStatus isEqualToString:@"REFUNDED"]) {
                if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
                    
                    // 已购订单（购买者）
                    self.bottomStateStr = @"已退款";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已退款";
                }else if (self.roleOrderType == RoleOrderTypeSellerService) {
                    
                    // 服务订单（服务提供的卖者）
                    self.bottomStateStr = @"已退款";
                    self.orderButton.hidden = YES;
                    self.confirmButtonStateTitle = @"已退款";
                }
            }
            
            // 设置数据源
            [self setupDataSource];
            // 底部状态标题
            [self setupBottomViewTitle];
            
            [self.baseTableView reloadData];
        }];
    }
}

/** MARK: UI */
- (UIView *)setupTableViewFooterView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIButton *orderButton = [UIButton createButton:CGRectMake(GBMargin, GBMargin, 80, 30) target:self action:@selector(orderButtonAction:) textColor:[UIColor kBaseColor]];
    [orderButton setTitle:@"取消订单" forState:UIControlStateNormal];
    orderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    orderButton.titleLabel.font = Fit_Font(14);
    self.orderButton = orderButton;
    [footView addSubview:orderButton];
    
    return footView;
}

#pragma mark - # Event Response
/** MARK: 订单按钮 */
- (void)orderButtonAction:(UIButton *)orderButton {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    if (self.orderDetailsType == OrderDetailsTypeDecrypt) {
        // 解密订单
        if ([self.orderButtonTitle isEqualToString:@"取消订单"]) {
            [mineVM loadRequestMineDecyptPassCancel:self.orderDeailsModel.decryptId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [self.navigationController popViewControllerAnimated:YES];
                [UIView showHubWithTip:@"订单已取消"];
            }];
            
            return;

        }
        
        if ([self.orderButtonTitle isEqualToString:@"拒绝订单"]) {
            [mineVM loadRequestMineDecryptReject:self.orderDeailsModel.decryptId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [self.navigationController popViewControllerAnimated:YES];
                [UIView showHubWithTip:@"订单已拒绝"];
            }];
            
            return;
        }
        
        if ([self.orderButtonTitle isEqualToString:@"结束服务"]) {
            [mineVM loadRequestMineDecryptFinish:self.orderDeailsModel.decryptId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [self.navigationController popViewControllerAnimated:YES];
                [UIView showHubWithTip:@"服务结束"];
            }];
            
            return;

        }
    }else if (self.orderDetailsType == OrderDetailsTypeAssurePass) {
        // 服务订单
        if ([self.orderButtonTitle isEqualToString:@"取消订单"]) {
            [mineVM loadRequestMineAssurePassCancel:self.orderDeailsModel.assurePassId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [self.navigationController popViewControllerAnimated:YES];
                [UIView showHubWithTip:@"订单已取消"];
            }];
            
            return;

        }
        
        if ([self.orderButtonTitle isEqualToString:@"拒绝订单"]) {
            [mineVM loadRequestMineAssurePassReject:self.orderDeailsModel.assurePassId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [self.navigationController popViewControllerAnimated:YES];
                [UIView showHubWithTip:@"订单已拒绝"];
            }];
            
            return;
        }
        
        if ([self.orderButtonTitle isEqualToString:@"结束服务"]) {
            GBEndServiceViewController *endSerViceVC = [[GBEndServiceViewController alloc] init];
            endSerViceVC.orderDeailsModel = self.orderDeailsModel;
            endSerViceVC.orderDetailsType = self.orderDetailsType;
            [self.navigationController pushViewController:endSerViceVC animated:YES];
        }
    }
}

/** MARK: 底部按钮 */
- (void)confirmButtonTouchUpInside:(UIButton *)confirmButton {
    if ([self.confirmButtonStateTitle isEqualToString:@"确认订单"]) {
        if (self.orderDetailsType == OrderDetailsTypeDecrypt) {
            // 解密订单
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            [mineVM loadRequestMineDecryptAccept:self.orderDeailsModel.decryptId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [self.navigationController popViewControllerAnimated:YES];
                [UIView showHubWithTip:@"已确认"];
            }];
        }else if (self.orderDetailsType == OrderDetailsTypeAssurePass) {
            // 保过订单
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            
            [mineVM loadRequestMineAssurePassAccept:self.orderDeailsModel.assurePassId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [self.navigationController popViewControllerAnimated:YES];
                [UIView showHubWithTip:@"已确认"];
            }];
        }
        
        return;
    }

    if ([self.confirmButtonStateTitle isEqualToString:@"立即支付"]) {
        _payPsdVC = [[YQPayKeyWordVC alloc] init];
        [_payPsdVC showInViewController:self];
        _payPsdVC.keyWordView.priceLabel.text = [NSString stringWithFormat:@"%zu台阶币",self.orderDeailsModel.price];
        @GBWeakObj(self);
        _payPsdVC.payPassWordBlock = ^(NSString *passWord) {
            @GBStrongObj(self);
                // 支付
                GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
            if (self.orderDetailsType == OrderDetailsTypeDecrypt) {
                // 解密
                [positionVM loadPositionPayWithType:@"GOODS_TYPE_JM" relatedId:GBNSStringFormat(@"%zu",self.orderDeailsModel.decryptId) payPwd:passWord discountType:nil];
                [positionVM setSuccessReturnBlock:^(id returnValue) {
                    NSDictionary *param = @{
                                            @"goodsID":GBNSStringFormat(@"%zu",self.orderDeailsModel.decryptId), @"price":GBNSStringFormat(@"%zu",self.orderDeailsModel.price),
                                            @"goodsName":@"GOODS_TYPE_JM",
                                            @"goodsType":@"PAY_TYPE_PG_TJB",
                                            
                                            };
                    [GBAppDelegate setupJAnalyticsPurchaseEvent:param];
                    
                }];
            }else if (self.orderDetailsType == OrderDetailsTypeAssurePass) {
                // 保过
                [positionVM loadPositionPayWithType:@"GOODS_TYPE_BG" relatedId:GBNSStringFormat(@"%zu",self.orderDeailsModel.assurePassId) payPwd:passWord discountType:nil];
                [positionVM setSuccessReturnBlock:^(id returnValue) {
                    NSDictionary *param = @{
                                            @"goodsID":GBNSStringFormat(@"%zu",self.orderDeailsModel.assurePassId), @"price":GBNSStringFormat(@"%zu",self.orderDeailsModel.price),
                                            @"goodsName":@"GOODS_TYPE_BG",
                                            @"goodsType":@"PAY_TYPE_PG_TJB",
                                            
                                            };
                    [GBAppDelegate setupJAnalyticsPurchaseEvent:param];
                                      
                }];
            }
                [positionVM setSuccessReturnBlock:^(id returnValue) {
                    if ([returnValue[@"result"] integerValue] == 0) {
                        [UIView showHubWithTip:returnValue[@"msg"]];
                        if ([returnValue[@"msg"] isEqualToString:@"未设置支付密码"]) {
                            GBModifyViewController *modifyPhoneVC = [[GBModifyViewController alloc] init];
                            modifyPhoneVC.modifyType = ModifyControllerTypePayPassWord;
                            [self.navigationController pushViewController:modifyPhoneVC animated:YES];
                        }
                        
                    }else if ([returnValue[@"result"] integerValue] == 1) {
                        // 成功
                        [UIView showHubWithTip:@"支付成功"];
                        [self.payPsdVC disMissKeyWordView];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else if([returnValue[@"result"] integerValue] == 2) {
                        [self AlertWithTitle:@"余额不足" message:@"您的台阶币余额不足，请充值" andOthers:@[@"取消",@"充值"] animated:YES action:^(NSInteger index) {
                            GBTaiJieBiRechargeViewController *taijiebiVC = [[GBTaiJieBiRechargeViewController alloc]init];
                            [GBRootViewController presentViewController:taijiebiVC animated:YES completion:nil];
                        }];
                        
                    }else {
                        [UIView showHubWithTip:@"支付失败,请稍后重试"];
                    }
                }];
        };
        
        return;
    }
    
    if ([self.confirmButtonStateTitle isEqualToString:@"立即沟通"]) {
        NSLog(@"沟通");
        JMSGConversation *conversation = [JMSGConversation singleConversationWithUsername:self.roleOrderType == RoleOrderTypeBuyersPurchased ? GBNSStringFormat(@"%zu",self.orderDeailsModel.publisherId): GBNSStringFormat(@"%zu",self.orderDeailsModel.purchaserId)];
        if (conversation == nil) {
            [JMSGConversation createSingleConversationWithUsername:self.roleOrderType == RoleOrderTypeBuyersPurchased ? GBNSStringFormat(@"%zu",self.orderDeailsModel.publisherId): GBNSStringFormat(@"%zu",self.orderDeailsModel.purchaserId) completionHandler:^(id resultObject, NSError *error) {
                if (error) {
                    NSLog(@"创建会话失败 error%@",error);
                    [UIView showHubWithTip:@"error"];
                    return ;
                }
                
                ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
                conversationVC.conversation = resultObject;
                [self.navigationController pushViewController:conversationVC animated:YES];
            }];
        }else {
            ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
            conversationVC.conversation = conversation;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
        return;
    }
    
    if ([self.confirmButtonStateTitle isEqualToString:@"立即评价"]) {
        GBOrderServiceEvaluationViewController *evaluationVC = [[GBOrderServiceEvaluationViewController alloc] init];
        evaluationVC.orderDetailsType = self.orderDetailsType;
        evaluationVC.orderDeailsModel = self.orderDeailsModel;
        [self.navigationController pushViewController:evaluationVC animated:YES];
    }
}

#pragma mark - # Privater Methods
/** MARK: 设置数据源 */
- (void)setupDataSource {
    [self.detailsTitleListArray addObject:@[@""]];
    NSString *describe = @"";
    if (self.orderDetailsType == OrderDetailsTypeDecrypt) {
        // 问题
         [self.detailsTitleListArray addObject:@[self.orderDeailsModel.question]];
        [self.detailsContentListArray addObjectsFromArray:@[@[@""],@[@""]]];
        //  描述
        describe = self.orderDeailsModel.personalSituation;
    }else {
        // 入职保过 目标职位
         [self.detailsTitleListArray addObject:@[GBNSStringFormat(@"%@/%zuk-%zuk",self.orderDeailsModel.positionName,self.orderDeailsModel.minSalary,self.orderDeailsModel.maxSalary), self.orderDeailsModel.companyName]];
        [self.detailsContentListArray addObjectsFromArray:@[@[@""],@[@"",@""]]];
        //  描述
        describe = self.orderDeailsModel.leaveMesseges;
    }
    
    [self.detailsTitleListArray addObject:@[describe,@"订单号",@"提交时间",@"状态",@"金额"]];

    [self.detailsContentListArray addObject:@[@"",self.orderDeailsModel.orderNo,self.orderDeailsModel.submitTime,self.bottomStateStr,GBNSStringFormat(@"%zu币",self.orderDeailsModel.price)]];
}

/** MARK: 设置底部状态标题 */
- (void)setupBottomViewTitle {
    UIColor *changeColor;
    if ([self.bottomStateStr isEqualToString:GBNSStringFormat(@"%@ 关闭",self.orderDeailsModel.closeTime)]) {
        changeColor = [UIColor kYellowBgColor];
    }else {
        changeColor = [UIColor kAssistInfoTextColor];
    }
    
    NSString *priceStr = GBNSStringFormat(@"%zu币\n%@",self.orderDeailsModel.price,self.bottomStateStr);
    NSMutableAttributedString *priceAttributedStr = [DCSpeedy dc_setSomeOneChangeColor:changeColor changeFont:Fit_Font(12) totalString:priceStr changeString:self.bottomStateStr];

    self.priceLabel.attributedText = priceAttributedStr;
    
    [self.orderButton setTitle:self.orderButtonTitle forState:UIControlStateNormal];

    [self.confirmButton setTitle:self.confirmButtonStateTitle forState:UIControlStateNormal];
}

- (void)p_addMasonry {
    // 底部按钮
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
        make.height.mas_equalTo(72);
    }];
    // 分割线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
    }];
    // 确认按钮
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Fit_W_H(160));
        make.right.mas_equalTo(-24);
        make.centerY.mas_equalTo(self.bottomView);
    }];
    
    // 价格按钮
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.centerX.mas_equalTo(self.bottomView);
        make.centerY.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(Fit_W_H(180));
    }];
}

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : (section == 1 ? self.orderDetailsType == OrderDetailsTypeDecrypt ? 1 : 2 : 4);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 80 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    + (self.orderDetailsType == OrderDetailsTypeDecrypt ? 0 : -GBMargin/2)
    return indexPath.section == 0 ? [tableView fd_heightForCellWithIdentifier:kGBOrderDetailsPersonalInfoCellID cacheByIndexPath:indexPath configuration:^(GBOrderDetailsPersonalInfoCell *cell) {
        [self configurePersonalInfoCell:cell atIndexPath:indexPath];
    }]  : [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }] + GBMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.moreButton.hidden = YES;
    headerView.titleLabel.text = [self.sectionTitleListArray objectAtIndex:section];
    if (section == 0) {
        headerView.titleLabel.font = Fit_M_Font(28);
        headerView.subTitleLabel.text = self.orderDetailsType == OrderDetailsTypeDecrypt ? @" / 私聊解密" : @" / 入职保过";
    }else {
        headerView.subTitleLabel.text = @"";
        headerView.titleLabel.font = Fit_M_Font(17);
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GBOrderDetailsPersonalInfoCell *personalInfoCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!personalInfoCell) {
            personalInfoCell = [[GBOrderDetailsPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBOrderDetailsPersonalInfoCellID];
        }
        
        [self configurePersonalInfoCell:personalInfoCell atIndexPath:indexPath];

        return personalInfoCell;
    }
    
    GBSettingCell *settingCel = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCel) {
        settingCel = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    [self configureCell:settingCel atIndexPath:indexPath];
    
    return settingCel;
}

- (void)configurePersonalInfoCell:(GBOrderDetailsPersonalInfoCell *)personalInfoCell atIndexPath:(NSIndexPath *)indexPath {
//    personalInfoCell.starView.value = self.orderDeailsModel.star;
    
    if (self.roleOrderType == RoleOrderTypeBuyersPurchased) {
        // 已购
        self.targetUserId = GBNSStringFormat(@"%zu",self.orderDeailsModel.publisherId);
        [personalInfoCell.iconImageView sd_setImageWithURL:GBImageURL(self.orderDeailsModel.publisherHeadImg) placeholderImage:PlaceholderHeadImage];
        
        personalInfoCell.titleLabel.text = self.orderDeailsModel.publisher;
        personalInfoCell.subTitleLabel.text = self.orderDeailsModel.publisherPosition;
        personalInfoCell.subTitleLabel1.text = self.orderDeailsModel.publisherCompany;

    }else if(self.roleOrderType == RoleOrderTypeSellerService) {
        // 服务
        self.targetUserId = GBNSStringFormat(@"%zu",self.orderDeailsModel.purchaserId);
        [personalInfoCell.iconImageView sd_setImageWithURL:GBImageURL(self.orderDeailsModel.purchaserHeadImg) placeholderImage:PlaceholderHeadImage];
        
        personalInfoCell.titleLabel.text = self.orderDeailsModel.purchaser;
        personalInfoCell.subTitleLabel.text = self.orderDeailsModel.positionName;

        personalInfoCell.subTitleLabel1.text = self.orderDeailsModel.companyName;

    }

//    personalInfoCell.subTitleLabel1.text = self.orderDetailsType == OrderDetailsTypeDecrypt ? GBNSStringFormat(@"已解密%zu次",self.orderDeailsModel.purchaseCount) : GBNSStringFormat(@"已保过%zu次",self.orderDeailsModel.purchaseCount);

        personalInfoCell.decryptionLabel.text = self.orderDeailsModel.title;
//    personalInfoCell.starView.value = self.orderDeailsModel.star;
        personalInfoCell.orderDetailsType = self.orderDetailsType;
    
//        personalInfoCell.decryptionLabel.hidden = self.orderDetailsType == OrderDetailsTypeDecrypt ? NO : YES;
//        personalInfoCell.line.hidden = self.orderDetailsType == OrderDetailsTypeDecrypt ? NO : YES;
   
}

- (void)configureCell:(GBSettingCell *)settingCell atIndexPath:(NSIndexPath *)indexPath {
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    settingCell.line.hidden = indexPath.section == 0 || indexPath.section == 1 ? YES : NO;
    settingCell.indicateButton.hidden = YES;
    settingCell.titleLabel.numberOfLines = 0;
    
    if (self.detailsTitleListArray.count) {
        // 标题
        settingCell.titleLabel.text = self.detailsTitleListArray[indexPath.section][indexPath.row];
    }
    
    settingCell.titleLabel.textColor = indexPath.row == 0 || indexPath.section == 1 ? [UIColor kNormoalInfoTextColor] : [UIColor kImportantTitleTextColor];
    settingCell.titleLabel.font = indexPath.row == 0 || indexPath.section == 0 ? Fit_Font(14) : Fit_Font(15);
    
    if (self.detailsContentListArray.count) {
        // 内容
        settingCell.contentTextField.text = self.detailsContentListArray[indexPath.section][indexPath.row];
    }
    
    settingCell.contentTextField.textAlignment = NSTextAlignmentRight;
    
    settingCell.contentTextField.textColor = [UIColor kNormoalInfoTextColor];
    settingCell.contentTextField.font = Fit_Font(12);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section == 0 && self.roleOrderType == RoleOrderTypeBuyersPurchased) ||  (indexPath.section == 0 && self.roleOrderType == RoleOrderTypeSellerService && self.orderDeailsModel.purchaserIsIncumbent)) {
        GBCommonPersonalHomePageViewController *homePageVC = [[GBCommonPersonalHomePageViewController alloc] init];
        homePageVC.targetUsrid = self.targetUserId;
        [[GBAppHelper getPushNavigationContr] pushViewController:homePageVC animated:YES];
    }
}

#pragma mark - # Getters and Setters
- (NSMutableArray *)sectionTitleListArray {
    if (!_sectionTitleListArray) {
        if (self.orderDetailsType == OrderDetailsTypeDecrypt) {
            _sectionTitleListArray = [NSMutableArray arrayWithArray:@[@"订单详情",@"想请教的问题",@"个人情况描述"]];
        }else {
            _sectionTitleListArray = [NSMutableArray arrayWithArray:@[@"订单详情",@"目标职位",@"个人情况描述"]];
        }
    }
    
    return _sectionTitleListArray;
}
- (NSMutableArray *)detailsTitleListArray {
    if (!_detailsTitleListArray) {
        _detailsTitleListArray = [[NSMutableArray alloc] init];
    }
    
    return _detailsTitleListArray;
}

- (NSMutableArray *)detailsContentListArray {
    if (!_detailsContentListArray) {
        _detailsContentListArray = [[NSMutableArray alloc] init];
    }
    
    return _detailsContentListArray;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    return _lineView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.numberOfLines = 2;
        _priceLabel.font = Fit_M_Font(20);
        _priceLabel.textColor = [UIColor kPromptRedColor];
    }
    
    return _priceLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton addTarget:self action:@selector(confirmButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.titleLabel.font = Fit_B_Font(17);
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage imageNamed:@"button_bg_long"] forState:UIControlStateNormal];
    }
    return _confirmButton;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
