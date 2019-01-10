//
// GBBasePageViewSuperController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/28.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBasePageViewSuperController.h"

#import "GBBasePageViewController.h"
#import "GBReportViewController.h"
/** 收藏 */
#import "GBMineCollectionViewController.h"

// 个人主页相关
#import "GBMoreCommentViewController.h"

// 订单相关
#import "GBOrderServiceViewController.h"

// 帖子相关
#import "GBTiebaViewController.h"

// 我的服务相关
#import "GBDecryptionServiceViewController.h"
#import "GBAssuredServiceViewController.h"

/** 收藏 */
#import "GBMineCollectionViewController.h"

// 头视图
#import "GBPersonalHeadView.h"
#import "DCSildeBarView.h"

#import "GBBigTitleHeadView.h"

@interface  GBBasePageViewSuperController ()<UIScrollViewDelegate,WMPageControllerDataSource>

@end

@implementation  GBBasePageViewSuperController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo((self.navigationController.childViewControllers.count != 1) ? @(SafeAreaTopHeight) : @0);
        make.bottom.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.trailing.bottom.equalTo(self.containerScrollView);
        make.width.equalTo(self.containerScrollView);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    if ((self.navigationController.childViewControllers.count != 1)) {
        self.containerScrollView.contentSize = CGSizeMake(self.containerScrollView.frame.size.width, self.containerScrollView.frame.size.height + self.pageHeadView.height);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.customNavBar wr_setBackgroundAlpha:0];
    [self setupView];
    
    self.containerScrollView.scrollEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupView {
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView addSubview:self.contentView];
}

- (void)setPageMenuTitles:(NSArray *)titles pageControllerType:(GBPageControllerType )pageType {
    self.titleArray = titles;
    self.pageType = pageType;
    
    [self setupNavigationBar:pageType];
    self.pageController.dataSource = self;
}

- (void)setPageHeadView:(UIView *)pageHeadView {
    if (_pageHeadView != pageHeadView) {
        [_pageHeadView removeFromSuperview];
        _pageHeadView = pageHeadView;
        
        self.pageController.pageHeadView = self.pageHeadView;
        
        [self.contentView addSubview:self.pageController.view];
        
        [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.contentView);
            make.width.equalTo(self.contentView);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
    }
}

#pragma mark - # Private Methods
- (void)setupNavigationBar:(GBPageControllerType )pageType {
}

#pragma mark - notification

#pragma mark - WMPageController Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (self.pageType) {
        case GBPageControllerTypeCompanyHomePage:
        {
            // MARK: 公司主页
            if (index == 0) {
                return self.companyInfoVC;
            }
        }
            break;
        case GBPageControllerTypePersonHomePage:
        {
            /** TA的服务 */
            GBMoreCommentViewController *personalServiceVC = [[GBMoreCommentViewController alloc] init];
            personalServiceVC.targetUsrid = self.targetUsrid;
            return personalServiceVC;
            
        }
            break;
        case GBPageControllerTypeMineOrderPage:
        {
            // MARK: 我的订单
            GBOrderServiceViewController *orderVC = [[GBOrderServiceViewController alloc] init];
            orderVC.roleOrderType = (index == 0 ? RoleOrderTypeBuyersPurchased : RoleOrderTypeSellerService);
            return orderVC;
        }
            break;
        case GBPageControllerTypeTieba:
        {
            // MARK: 贴吧
            GBTiebaViewController *tiebaVC = [[GBTiebaViewController alloc] init];
            tiebaVC.orderType = index == 0 ? @"NEW" : @"HOT";
            return tiebaVC;
        }
            break;
        case GBPageControllerTypeService:
        {
            // MARK: 我的服务
            if (index == 0) {
                /** 私聊解密 */
                GBDecryptionServiceViewController *decryptServiceVC = [[GBDecryptionServiceViewController alloc] init];
                return decryptServiceVC;
            }
            
            /** 入职保过 */
            GBAssuredServiceViewController *assuredServiceVC = [[GBAssuredServiceViewController alloc] init];
            return assuredServiceVC;
        }
            break;
        case GBPageControllerTypeCollect:
        {
            /** 收藏 */
            GBMineCollectionViewController *mineCollectVC = [[GBMineCollectionViewController alloc] init];
            mineCollectVC.collectionType = index;
            return mineCollectVC;
        }
            break;
            
        default:
            break;
    }
    
    return [UIViewController new];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return [self.titleArray objectAtIndex:index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    CGFloat leftMargin = self.pageController.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.pageController.showOnNavigationBar ? 0 : CGRectGetMaxY(self.pageController.pageHeadView.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.pageController.menuView]);
    
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat maxOffsetY =  self.pageHeadView.height;
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY>=maxOffsetY) {
//        self.containerScrollView.contentOffset = CGPointMake(0, maxOffsetY);
////        NSLog(@"滑动到顶端offsetY%f",offsetY);
//    } else {
////     NSLog(@"离开顶端offsetY%f",offsetY);
//        if (offsetY <= 0) {
//            self.containerScrollView.contentOffset = CGPointMake(0, self.pageHeadView.height);
//        }
//    }
//}

#pragma mark - getter setter
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray new];
    }
    
    return _titleArray;
}

- (ArtScrollView *)containerScrollView {
    if (!_containerScrollView) {
        _containerScrollView = [[ArtScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.showsVerticalScrollIndicator = NO;
        _containerScrollView.backgroundColor = [UIColor whiteColor];

    }
    return _containerScrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (GBBasePageViewController *)pageController {
    if (!_pageController) {
        _pageController = [[GBBasePageViewController alloc] init];
    }
    
    return _pageController;
}

- (GBCompanyInfoViewController *)companyInfoVC {
    if (!_companyInfoVC) {
        _companyInfoVC = [[GBCompanyInfoViewController alloc] init];
    }
    
    return _companyInfoVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end


@implementation GBBasePageViewController

- (void)dealloc {
    NSLog(@"page页销毁");
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.menuViewStyle = WMMenuViewStyleLine;
        self.automaticallyCalculatesItemWidths = YES;
        self.titleColorSelected = [UIColor kBaseColor];
        self.titleColorNormal = [UIColor kImportantTitleTextColor];
        self.titleFontName = @"PingFangSC-Regular";
        self.titleSizeSelected = 16;
        self.titleSizeNormal = 15;
        self.progressViewBottomSpace = 1;
        self.progressHeight = 2.5;
    }
    
    return self;
}

//视图加载完成获取到导航栏最下面的黑线
- (void)viewDidLoad {
    [super viewDidLoad];
    // 菜单栏下划线
    UIView *cellAcrossPartingLine = [[UIView alloc] init];
    cellAcrossPartingLine.backgroundColor = [UIColor kSegmentateLineColor];
    [self.menuView addSubview:cellAcrossPartingLine];
    
    [cellAcrossPartingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.menuView).offset(GBMargin);
        make.bottom.mas_equalTo(self.menuView).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
    }];
}
#pragma mark - 导航栏设置
- (void)setPageHeadView:(UIView *)pageHeadView {
    if (_pageHeadView != pageHeadView) {
        [_pageHeadView removeFromSuperview];
        _pageHeadView = pageHeadView;
        [self.view addSubview:_pageHeadView];
    }
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    
    return width;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index {
    return index == 0 ? GBMargin : GBMargin*2;
}


@end
