//
//  GBMineServicePageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 我的服务
//  @discussion 保过、解密
//

#import "GBMineServicePageViewController.h"
#import "YCXMenu.h"

// Controllers
/** 私聊解密编辑 */
#import "GBDecryptionEditorViewController.h"
/** 提现 */
#import "GBWithdrawalViewController.h"
/** 收益明细 */
#import "GBEarningsSignificantlyViewController.h"
/** 提现记录 */
#import "GBWithdrawalRecordViewController.h"
#import "YQPayKeyWordVC.h"
/** 设置支付密码 */
#import "GBModifyViewController.h"
#import "GBAddAssureServiceViewController.h"
#import "GBAddDecryptionServiceViewController.h"
#import "GBDecryptionServiceViewController.h"
#import "GBAssuredServiceViewController.h"

// ViewModels


// Models
#import "GBBalanceModel.h"

// Views
#import "GBMineServiceHeadView.h"
#import "DCPathButton.h"

@interface GBMineServicePageViewController ()<DCPathButtonDelegate>
/* 标题头 */
@property (nonatomic, strong) GBMineServiceHeadView *bigTitleHeadView;
/** 扇形按钮菜单 */
@property (strong, nonatomic) DCPathButton *dcPathButton;
/* 余额模型 */
@property (nonatomic, strong) GBBalanceModel *balanceModel;
// 下拉菜单数据
@property (nonatomic,strong) NSArray *menuItemNames;

/* 半透明遮罩视图 */
@property (nonatomic, strong) UIView *maskView;

/* 支付密码输入框 */
@property (nonatomic, strong) YQPayKeyWordVC *payPsdVC;

@end

@implementation GBMineServicePageViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:YCXMenuWillDisappearNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NetDataServerInstance.forbidShowLoading = YES;
    if (self.pageController.selectIndex == 0) {
            GBDecryptionServiceViewController *decryptVC = (GBDecryptionServiceViewController *)self.pageController.currentViewController;
            [decryptVC.baseTableView.mj_header beginRefreshing];
    }else {
            GBAssuredServiceViewController *assuredVC = (GBAssuredServiceViewController *)self.pageController.currentViewController;
            [assuredVC.baseTableView.mj_header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"我的服务";
    
    // 下拉菜单通知
    [GBNotificationCenter addObserver:self selector:@selector(menuWillDisappear) name:YCXMenuWillDisappearNotification object:nil];
    
    [self getEarningsData];
    
    self.pageHeadView = self.bigTitleHeadView;
    
    [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_more")];
    
    @GBWeakObj(self);
    // 功能菜单
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        [self menuFunction];
    }];
    
    // 进入提现箭头按钮事件
    [self.bigTitleHeadView setRightButtonClickBlock:^{
        @GBStrongObj(self);
        GBWithdrawalViewController *withDrawalVC = [[GBWithdrawalViewController alloc] init];
        withDrawalVC.balanceModel = self.balanceModel;
        [self.navigationController pushViewController:withDrawalVC animated:YES];
    }];
    
    // 发布服务按钮
    [self configureDCPathButton];
}

#pragma mark - # Setup Methods
/** MARK: Data */

// 收益
- (void)getEarningsData {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestBalance];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.balanceModel = [GBBalanceModel mj_objectWithKeyValues:returnValue];
        self.bigTitleHeadView.priceLabel.text = GBNSStringFormat(@"￥%.f",self.balanceModel.currentTotalEarning);
    }];
}

- (void)configureDCPathButton {
    // Configure center button
    //
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"position_Add"]
                                                         highlightedImage:[UIImage imageNamed:@"position_Add"]];
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"icon_service_add_decryption"]
                                                           highlightedImage:[UIImage imageNamed:@"icon_service_add_decryption"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"icon_service_add_ausered"] highlightedImage:[UIImage imageNamed:@"icon_service_add_ausered"] backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    [dcPathButton addPathItems:@[
                                 itemButton_1,
                                 itemButton_2,
                                 ]];
    
    
    dcPathButton.bloomRadius = 80.0f;
    
    dcPathButton.allowSounds = YES;
    dcPathButton.allowCenterButtonRotation = YES;
    
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTopLeft;
    dcPathButton.dcButtonCenter = CGPointMake(SCREEN_WIDTH - dcPathButton.frame.size.width/2-GBMargin, self.view.frame.size.height - dcPathButton.frame.size.height/2 - SafeTabBarHeight);
    
    [self.view addSubview:dcPathButton];
    
}

#pragma mark - # Event Response
/** 右侧下拉菜单按钮将要消失通知 */
- (void)menuWillDisappear {
    self.maskView.alpha = 0;
}

/**
 右侧下拉菜单按钮功能
 */
- (void)menuFunction {
    
    self.maskView.alpha = 0.5;
    
    [YCXMenu setTintColor:[UIColor whiteColor]];
    [YCXMenu setCornerRadius:2];
    [YCXMenu setTitleFont:Fit_Font(15)];
    [YCXMenu setSelectedColor:[UIColor whiteColor]];
    [YCXMenu setSeparatorColor:[UIColor kSegmentateLineColor]];
    
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 60, SafeAreaTopHeight, 50, 0) menuItems:self.menuItemNames selected:^(NSInteger index, YCXMenuItem *item) {
        
        self.maskView.alpha = 0;
        
        switch (index) {
            case 0:
            {
                GBEarningsSignificantlyViewController *earningsSignificantlyVC = [[GBEarningsSignificantlyViewController alloc] init];
                [self.navigationController pushViewController:earningsSignificantlyVC animated:YES];
            }
                break;
            case 1:
            {
                GBCommonViewModel *mineVM = [[GBCommonViewModel alloc] init];
                [mineVM loadRequestCheckUserHasPayPwd];
                [mineVM setSuccessReturnBlock:^(id returnValue) {
                    if ([returnValue[@"hasPayPwd"] integerValue] == 1) {
                        self.payPsdVC = [[YQPayKeyWordVC alloc] init];
                        [self.payPsdVC showInViewController:self];
                        self.payPsdVC.keyWordView.priceLabel.text = @"请输入您的支付密码";
                        @GBWeakObj(self);
                        self.payPsdVC.payPassWordBlock = ^(NSString *passWord) {
                            @GBStrongObj(self);
                            GBCommonViewModel *commonVM = [[GBCommonViewModel alloc] init];
                            [commonVM loadRequestPayPwdVerification:passWord];
                            [commonVM setSuccessReturnBlock:^(id returnValue) {
                                GBWithdrawalRecordViewController *withdrawalRecordVC = [[GBWithdrawalRecordViewController alloc] init];
                                [self.navigationController pushViewController:withdrawalRecordVC animated:YES];
                            }];
                        };
                    }else {
                        [self AlertWithTitle:nil message:@"请先设置支付密码" andOthers:@[@"取消",@"去设置"] animated:YES action:^(NSInteger index) {
                            if (index == 1) {
                                GBModifyViewController *modifyPhoneVC = [[GBModifyViewController alloc] init];
                                modifyPhoneVC.modifyType = ModifyControllerTypePayPassWord;
                                [self.navigationController pushViewController:modifyPhoneVC animated:YES];
                            }
                        }];
                    }
                }];
            }
                break;
            case 2:
            {
                NSString *url = [NSString stringWithFormat:@"%@%@",URL_GB_HTML,@"withdraw.html"];
//                NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                GBBaseWebViewController *webView = [[GBBaseWebViewController alloc] initWithUrl:url];
                webView.titleStr = @"服务指南";
                [self.navigationController pushViewController:webView animated:YES];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - # Privater Methods

#pragma mark - # Delegate
#pragma mark - DCPathButtonDelegate
- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@"You tap at index : %tu", itemButtonIndex);
    if (itemButtonIndex == 0) {
        GBAddDecryptionServiceViewController *addDecryptionServiceVC = [[GBAddDecryptionServiceViewController alloc] init];
        addDecryptionServiceVC.serviceType = ServiceTypeNewDecryption;
        [self.navigationController pushViewController:addDecryptionServiceVC animated:YES];
        return;
    }
    
        GBAddAssureServiceViewController *addAssureServiceVC = [[GBAddAssureServiceViewController alloc] init];
        addAssureServiceVC.serviceType = ServiceTypeNewAssured;
        [self.navigationController pushViewController:addAssureServiceVC animated:YES];
    
    //    if (itemButtonIndex == 0) {
//    GBDecryptionEditorViewController *decryptionEditorVC = [[GBDecryptionEditorViewController alloc] init];
//    decryptionEditorVC.serviceType = itemButtonIndex == 0 ?ServiceTypeNewDecryption : ServiceTypeNewAssured;
//    [self.navigationController pushViewController:decryptionEditorVC animated:YES];
    //    }
}


#pragma mark - # Getters and Setters
- (GBMineServiceHeadView *)bigTitleHeadView {
    if (!_bigTitleHeadView) {
        _bigTitleHeadView = [[GBMineServiceHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeAreaTopHeight + 120)];
        _bigTitleHeadView.titleLabel.text = @"服务";
    }
    
    return _bigTitleHeadView;
}

- (NSArray *)menuItemNames {
    if (!_menuItemNames) {
        //set item
        YCXMenuItem *item1 = [YCXMenuItem menuItem:@"收益明细"
                                             image:nil
                                               tag:100
                                          userInfo:@{@"title":@"Menu"}];
        item1.foreColor = [UIColor kImportantTitleTextColor];
        
        YCXMenuItem *item2 = [YCXMenuItem menuItem:@"提现记录"
                                             image:nil
                                               tag:101
                                          userInfo:@{@"title":@"Menu"}];
        item2.foreColor = [UIColor kImportantTitleTextColor];
        
        YCXMenuItem *item3 = [YCXMenuItem menuItem:@"服务指南"
                                             image:nil
                                               tag:102
                                          userInfo:@{@"title":@"Menu"}];
        item3.foreColor = [UIColor kImportantTitleTextColor];
        
        _menuItemNames = @[item1,item2,item3];
    }
    
    return _menuItemNames;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
        [self.view addSubview:_maskView];
    }
    
    return _maskView;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
