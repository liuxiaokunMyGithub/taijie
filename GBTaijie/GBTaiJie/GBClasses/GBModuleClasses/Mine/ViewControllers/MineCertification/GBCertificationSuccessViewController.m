//
//  GBCertificationSuccessViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 芝麻认证成功
//  @discussion <#类的功能#>
//

#import "GBCertificationSuccessViewController.h"

// Controllers


// ViewModels


// Models


// Views


@interface GBCertificationSuccessViewController ()


@end

@implementation GBCertificationSuccessViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"认证成功";

   [self.view addSubview:[self setupBigTitleHeadViewWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 100) title:@"芝麻认证"]];
    
    [self setupCenterView];
    
    [self.view addSubview:[self setupBottomViewWithtitle:@"确定"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
    @GBStrongObj(self);
      // 底部确定按钮点击
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}


#pragma mark - # Setup Methods
- (void)setupCenterView {
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-52/2, SCREEN_HEIGHT/2 -50-8-52, 52, 52)];
    iconImageView.image = GBImageNamed(@"icon_success");
    [self.view addSubview:iconImageView];
    GBViewRadius(iconImageView, 52/2);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(GBMargin, SCREEN_HEIGHT/2 -50, SCREEN_WIDTH - GBMargin*2, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"认证成功";
    label.font = Fit_M_Font(17);
    label.textColor = [UIColor kBaseColor];
    [self.view addSubview:label];

    UILabel *flagLabel = [[UILabel alloc] init];
    flagLabel.frame = CGRectMake(GBMargin, SCREEN_HEIGHT/2 , SCREEN_WIDTH - GBMargin*2, 16);
    flagLabel.textAlignment = NSTextAlignmentCenter;
    flagLabel.text = @"恭喜你，已经完成芝麻认证";
    flagLabel.font = Fit_Font(12);
    flagLabel.textColor = [UIColor kAssistInfoTextColor];
    [self.view addSubview:flagLabel];
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
