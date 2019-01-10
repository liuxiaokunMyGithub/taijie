//
//  GBBaseWebViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseWebViewController.h"

@interface GBBaseWebViewController ()<WKNavigationDelegate>

@property (nonatomic,assign) double lastProgress;//上次进度条位置
@end

@implementation GBBaseWebViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)updateNavigationItems {
    if (_isShowCloseBtn) {
        if (self.webView.canGoBack) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;

            }
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

