//
//  GBTiebaPageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/9.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBTiebaPageViewController.h"
#import "GBPostArticleViewController.h"
#import "GBTiebaViewController.h"

#import "GBBigTitleHeadView.h"

@interface GBTiebaPageViewController ()
/* 头视图 */
@property (nonatomic, strong) GBBigTitleHeadView *bigTitleHeadView;

@end

@implementation GBTiebaPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    NetDataServerInstance.forbidShowLoading = YES;
    //
    //    GBTiebaViewController *tiebaView = (GBTiebaViewController *)self.pageController.currentViewController;
    //    [tiebaView.baseTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"吾聊";

    self.pageHeadView = self.bigTitleHeadView;
    
    @GBWeakObj(self);
    [self.bigTitleHeadView setRightButtonClickBlock:^{
    @GBStrongObj(self);
        if (!userManager.currentUser) {
            GBPostNotification(LoginStateChangeNotification, @NO);
            return [UIView showHubWithTip:@"当前操作需要您先注册登录" timeintevel:2.0];
        }
        
        // 发帖
        GBPostArticleViewController *postArticleVC = [[GBPostArticleViewController alloc] init];
        [self.navigationController pushViewController:postArticleVC animated:YES];
    }];
//    UIView *test = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeAreaTopHeight)];
//    test.backgroundColor = [UIColor redColor];
//    [self.view addSubview:test];
}

- (GBBigTitleHeadView *)bigTitleHeadView {
    if (!_bigTitleHeadView) {
        _bigTitleHeadView = [[GBBigTitleHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60+SafeAreaTopHeight)];
        _bigTitleHeadView.topMargin = SafeAreaTopHeight;
        _bigTitleHeadView.titleLabel.text = @"吾聊";
        [_bigTitleHeadView.rightButton setImage:GBImageNamed(@"tieba_post") forState:UIControlStateNormal];
    }
    
    return _bigTitleHeadView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
