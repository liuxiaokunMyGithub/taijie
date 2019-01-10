//
//  GBBaseViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract Base控制器
//  @discussion 封装控制器共性
//

#import "GBBaseViewController.h"

// Controllers
#import "GBBasePageViewSuperController.h"


// ViewModels


// Models


// Views


@interface GBBaseViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
/* 返回按钮 */
@property (nonatomic, strong) NSArray *backItems;
/* <#describe#> */
@property (nonatomic, strong) UIImageView *noDataImageView;
/* 头部刷新 */
@property (nonatomic, strong) MJRefreshNormalHeader *header;
/* 底部刷新 */
@property (nonatomic, strong) MJRefreshAutoNormalFooter *mjRefreshFooter;
@end

@implementation GBBaseViewController

#pragma mark - LifeCyle -
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // MARK: 极光统计埋点 - 页面结束
    [GBAppDelegate stopLogPageView:self.customNavBar.title];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (kIsNetwork != YES) {
        // 无网络 二级及子视图提示
        if (self.navigationController.childViewControllers.count != 1) {
            self.emptyDataType = GBEmptyDataTypeNotNetwork;
            [self.view addSubview:self.baseTableView];
            [self.view bringSubviewToFront:self.baseTableView];
            self.baseTableView.emptyDataSetSource = self;
            self.baseTableView.emptyDataSetDelegate = self;
            [self.baseTableView reloadEmptyDataSet];
        }else {
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // MARK: 极光统计埋点 - 页面出现
    [GBAppDelegate startLogPageView:self.customNavBar.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    page = 1;
    
    // 设置导航l
    [self setupNavBar];
}

#pragma mark - Initial Methods
/** MARK: 修改状态栏颜色 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return _StatusBarStyle;
}

//动态更新状态栏颜色
- (void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

// 导航栏
- (void)setupNavBar {
    [self.view addSubview:self.customNavBar];
    if (self.navigationController.childViewControllers.count != 1) {
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"icon_back"]];
        
        @GBWeakObj(self);
        [self.customNavBar setOnClickLeftButton:^{
            @GBStrongObj(self);
            // 返回
            [self backButtonClicked];
        }];
    }
    
    self.customNavBar.barBackgroundColor = [UIColor whiteColor];
    self.customNavBar.titleLabelColor = [UIColor clearColor];
    self.customNavBar.titleLabelFont = Fit_M_Font(18);
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [self.customNavBar wr_setBottomLineHidden:YES];
}

- (void)setupCustomNavBarRightButton:(NSString *)rightButtonStr {
    [self.customNavBar wr_setRightButtonWithTitle:rightButtonStr titleColor:[UIColor kBaseColor]];
    
    CGFloat width = [DCSpeedy dc_calculateTextSizeWithText:rightButtonStr WithTextFont:Fit_M_Font(16) WithMaxW:SCREEN_WIDTH].width;
    [self.customNavBar.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.customNavBar).offset(-GBMargin);
        make.width.equalTo(@(width));
        make.height.equalTo(@44);
        make.top.equalTo(@(StatusBarHeight));
    }];
}

// 大标题
- (GBBigTitleHeadView *)setupBigTitleHeadViewWithFrame:(CGRect)frame title:(NSString *)title
{
    GBBigTitleHeadView *bigBassTitleHeadView = [[GBBigTitleHeadView alloc] initWithFrame:frame];
    bigBassTitleHeadView.titleLabel.text = title;
    self.bigBassTitleHeadView = bigBassTitleHeadView;
    return bigBassTitleHeadView;
}

/* 大标题头 - 右侧子标题 */
- (void)setupSubTitle:(NSString *)subTitle {
    self.bigBassTitleHeadView.subTitleLabel.text = subTitle;
}

/* 大标题头 - 底部子标题 */
- (void)setupBottomSubTitle:(NSString *)bottomSubTitle {
    self.bigBassTitleHeadView.bottomSubTitleLabel.text = bottomSubTitle;
}

/* 大标题头 - 顶部偏移 */
- (void)setupBigTitleTopMargin:(NSInteger )topMargin {
    self.bigBassTitleHeadView.topMargin = topMargin;
}

/** MARK: 设置底部按钮 */
- (UIView *)setupBottomViewWithtitle:(NSString *)title {
    [self.baseBottomButton setTitle:title forState:UIControlStateNormal];
    [self.baseBottomView addSubview:self.baseBottomlineView];
    [self.baseBottomView addSubview:self.baseBottomButton];
    return self.baseBottomView;
}

#pragma mark - # Event Response
// 下拉刷新 - 子类可覆写
- (void)headerRereshing {
    NetDataServerInstance.forbidShowLoading = YES;
    // 重置没有更多数据状态
    [self.baseTableView.mj_footer resetNoMoreData];
    self.loadingStyle = LoadingDataRefresh;
    page = 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.header.state == MJRefreshStateIdle) {
            return ;
        }
        
        [self.baseTableView.mj_header endRefreshing];
    });
}

// 上拉加载更多刷新 - 子类可覆写
- (void)footerRereshing {
    NetDataServerInstance.forbidShowLoading = YES;
    self.baseTableView.mj_footer.automaticallyChangeAlpha = NO;
    
    self.loadingStyle = LoadingDataGetMore;
    page ++;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.mjRefreshFooter.state == MJRefreshStateIdle || self.mjRefreshFooter.state == MJRefreshStateNoMoreData) {
            return ;
        }
        
        [self.baseTableView.mj_footer endRefreshing];
    });
}

// 底部按钮点击block
- (void)baseBottomButtonAction {
    !_didClickBaseBottomButton ? : _didClickBaseBottomButton();
}
// MARK: 无数据空白小视图
- (void)showNoDataImage {
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
    }
    
    if (self.noDataImageView) {
        [self.noDataImageView removeFromSuperview];
    }
    
    [self.noDataView addSubview:self.noDataImageView];
    @GBWeakObj(self);
    [self.view.subviews enumerateObjectsUsingBlock:^(UIScrollView *obj, NSUInteger idx, BOOL *stop) {
        @GBStrongObj(self);
        if ([obj isKindOfClass:[UITableView class]] || [obj isKindOfClass:[UICollectionView class]]) {
            [self.noDataView setFrame:self.baseTableView.frame];
            [obj addSubview:self.noDataView];
            self.noDataView.center = self.baseTableView.center;
            self.noDataImageView.centerX = self.noDataView.centerX;
            //            imageView.centerY = self.noDataView.centerY-(SCREEN_HEIGHT - self.baseTableView.height)/2;
            self.noDataImageView.centerY = Fit_W_H(185);
            //            if (self.noDataViewTopMargin) {
            //                self.noDataView.top = self.noDataViewTopMargin;
            //            }
        }
    }];
}

// 移除空白小视图
- (void)removeNoDataImage {
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}

#pragma mark - Privater Methods
- (void)backButtonClicked {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.baseTableView.numberOfSections <= 1) {
        return;
    }
    //取消表头表尾悬挂
    UITableView *tableview = (UITableView *)scrollView;
    CGFloat sectionHeaderHeight = self.baseTableView.sectionHeaderHeight > 0 ? self.baseTableView.sectionHeaderHeight : 80;
    CGFloat sectionFooterHeight = self.baseTableView.sectionFooterHeight > 0 ? self.baseTableView.sectionFooterHeight : 15;
    
    CGFloat offsetY = tableview.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
    {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
    }
}

#pragma mark - DZNEmptyDataSetSource Methods
// 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = nil;
    
    switch (self.emptyDataType) {
        case GBEmptyDataTypeCommon:
        {
            imageName = @"img_nothing";
        }
            break;
            // 无网络
        case GBEmptyDataTypeNotNetwork:
        {
            imageName = @"Nowifi_defaultpage";
        }
            break;
        default:
            return nil;
    }
    
    UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    
    return image;
    
}

// 空白页显示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    switch (self.emptyDataType) {
        case GBEmptyDataTypeNotNetwork:
        {
            text = @"网络连接失败";
            font = Fit_Font(16);
            textColor = [UIColor kImportantTitleTextColor];
        }
            break;
        default:
            return nil;
    }
    
    if (!ValidStr(text)) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 空白页显示描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    switch (self.emptyDataType) {
        case GBEmptyDataTypeCommon:
        {
            text = @"暂无数据";
            font = Fit_Font(14);
            textColor = [UIColor kAssistInfoTextColor];
        }
            break;
        case GBEmptyDataTypeNotNetwork:
        {
            text = @"请检查您的网络重新加载吧";
            font = Fit_Font(14);
            textColor = [UIColor kAssistInfoTextColor];
        }
            break;
        default:
            return nil;
    }
    
    if (!ValidStr(text)) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 空白页显示按钮
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    switch (self.emptyDataType) {
        case GBEmptyDataTypeNotNetwork:
        {
            text = @"重新加载";
            font = Fit_Font(16);
            textColor = [UIColor kBaseColor];
        }
            break;
        default:
            return nil;
    }
    
    if (!text) {
        return nil;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 按钮事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [GBLoadingWaitView showCircleJoinView:self.view isClearBackgoundColor:YES margin:0];
    
    // 处理按钮点击事件...
    if (kIsNetwork != YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GBLoadingWaitView hide];
        });
        
        return [self.baseTableView reloadEmptyDataSet];
    }
    
    [self headerRereshing];
    
    [GBLoadingWaitView hide];
    
    if (self.reloadNetWorkingClickedBlock) {
        self.reloadNetWorkingClickedBlock();
    }
}

#pragma mark - Getter Setter Methods
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)baseTableView {
    if (_baseTableView == nil) {
        _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.navigationController.childViewControllers.count == 1) ? 0 : SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ((self.navigationController.childViewControllers.count == 1) ? SafeTabBarHeight : SafeAreaBottomHeight+SafeAreaTopHeight)) style:UITableViewStylePlain];
        _baseTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _baseTableView.estimatedRowHeight = 0;
        _baseTableView.estimatedSectionHeaderHeight = 0;
        _baseTableView.estimatedSectionFooterHeight = 0;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _baseTableView.mj_header = header;
        _header = header;
        //底部刷新
        MJRefreshAutoNormalFooter *mjRefreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        //        _baseTableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
        _baseTableView.mj_footer.ignoredScrollViewContentInsetBottom = 44;
        mjRefreshFooter.automaticallyChangeAlpha = YES;
        [mjRefreshFooter setTitle:@"我是有底线的" forState:MJRefreshStateNoMoreData];
        _baseTableView.mj_footer = mjRefreshFooter;
        _baseTableView.scrollsToTop = YES;
        _baseTableView.tableFooterView = [[UIView alloc] init];
        _mjRefreshFooter = mjRefreshFooter;
        
        // 空数据代理设置
        //  _baseTableView.emptyDataSetSource = self;
        //  _baseTableView.emptyDataSetDelegate = self;
        
    }
    
    return _baseTableView;
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)baseCollectionView {
    if (!_baseCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _baseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (self.navigationController.childViewControllers.count == 1) ? 0 : SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ((self.navigationController.childViewControllers.count == 1) ? SafeTabBarHeight : SafeAreaBottomHeight+SafeAreaTopHeight)) collectionViewLayout:flow];
        _baseCollectionView.backgroundColor = [UIColor whiteColor];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _baseCollectionView.mj_header = header;
        
        //底部刷新
        MJRefreshBackNormalFooter *refreshBackFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [refreshBackFooter setTitle:@"我是有底线的" forState:MJRefreshStateNoMoreData];
        refreshBackFooter.automaticallyChangeAlpha = YES;
        _baseCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        _baseCollectionView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
        _baseCollectionView.mj_footer = refreshBackFooter;
        
        // 空数据代理设置
        //        _baseCollectionView.emptyDataSetSource = self;
        //        _baseCollectionView.emptyDataSetDelegate = self;
        
#ifdef kiOS11Before
        
#else
        if (@available(iOS 11.0, *)) {
            _baseCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        //        _baseCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        //        _baseCollectionView.scrollIndicatorInsets = _baseCollectionView.contentInset;
#endif
        
        _baseCollectionView.scrollsToTop = YES;
    }
    
    return _baseCollectionView;
}

// 自定义导航栏
- (WRCustomNavigationBar *)customNavBar {
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}

// 底部视图
- (UIView *)baseBottomView {
    if (!_baseBottomView) {
        _baseBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BottomViewFitHeight(72), SCREEN_WIDTH, 72)];
        _baseBottomView.backgroundColor = [UIColor whiteColor];
    }
    return _baseBottomView;
}

// 底部分割线
- (UIView *)baseBottomlineView {
    if (!_baseBottomlineView) {
        _baseBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _baseBottomlineView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    return _baseBottomlineView;
}

// 底部按钮
- (UIButton *)baseBottomButton {
    if (!_baseBottomButton) {
        _baseBottomButton = [[UIButton alloc] initWithFrame:CGRectMake(GBMargin, 15, SCREEN_WIDTH - GBMargin*2, 44)];
        [_baseBottomButton addTarget:self action:@selector(baseBottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _baseBottomButton.titleLabel.font = Fit_B_Font(17);
        [_baseBottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_baseBottomButton setBackgroundImage:[UIImage imageNamed:@"button_bg_long"] forState:UIControlStateNormal];
    }
    
    return _baseBottomButton;
}

- (UIImageView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[UIImageView alloc] init];
        _noDataView.backgroundColor = [UIColor whiteColor];
    }
    
    return _noDataView;
}

- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 183, 169)];
        _noDataImageView.image = [UIImage imageNamed:@"img_nothing"];
    }
    
    return _noDataImageView;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
