//
//  GBOrderPageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/25.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 订单分页
//  @discussion <#类的功能#>
//

#import "GBOrderPageViewController.h"

// Controllers


// ViewModels


// Models


// Views
#import "DCSildeBarView.h"
#import "RKNotificationHub.h"

@interface GBOrderPageViewController ()

@property (nonatomic, strong) RKNotificationHub *hubBadgeView1;
@property (nonatomic, strong) RKNotificationHub *hubBadgeView2;


@end

@implementation GBOrderPageViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:OrderNewStatusNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateOrderNewStatusNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"服务订单";
    
    // MARK: 订单页导航条
    [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"mine_order_filtrate")];
    [self.customNavBar setOnClickRightButton:^{
        // MARK: 订单筛选
        [DCSildeBarView dc_showSildBarViewController];
        
    }];
    
    [GBNotificationCenter addObserver:self selector:@selector(loadRequestMineOrderNewStatus) name:OrderNewStatusNotification object:nil];
}

- (void)loadRequestMineOrderNewStatus {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineOrderNewStatus];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.isSubscriberConfirm = [returnValue[@"isSubscriberConfirm"] boolValue];
        self.isVendorConfirm = [returnValue[@"isVendorConfirm"] boolValue];
        [self updateOrderNewStatusNotification];
    }];
}

#pragma mark - # Setup Methods
- (void)updateOrderNewStatusNotification {
    if (self.isSubscriberConfirm) {
        self.hubBadgeView1 = [[RKNotificationHub alloc]initWithView:[self.pageController.menuView itemAtIndex:0]];
        
        [self.hubBadgeView1 moveCircleByX:GBMargin/2 Y:20];
        [self.hubBadgeView1 setCircleColor:[UIColor redColor] labelColor:[UIColor redColor]];
        [self.hubBadgeView1 scaleCircleSizeBy:0.2];
        self.hubBadgeView1.countLabelFont = Fit_Font(1);
        [self.hubBadgeView1 setCount:1];
    }else {
        [self.hubBadgeView1 decrement];
    }
    
    if (self.isVendorConfirm) {
        self.hubBadgeView2 = [[RKNotificationHub alloc]initWithView:[self.pageController.menuView itemAtIndex:1]];
        
        [self.hubBadgeView2 moveCircleByX:GBMargin/2 Y:20];
        [self.hubBadgeView2 setCircleColor:[UIColor redColor] labelColor:[UIColor redColor]];
        [self.hubBadgeView2 scaleCircleSizeBy:0.2];
        self.hubBadgeView2.countLabelFont = Fit_Font(1);
        [self.hubBadgeView2 setCount:1];
    }else {
        [self.hubBadgeView2 decrement];
    }
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate


#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
