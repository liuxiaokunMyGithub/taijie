//
//  GBMoreMastersViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/15.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBMoreMastersViewController.h"

// Controllers
#import "GBCommonPersonalHomePageViewController.h"

// ViewModels


// Models
#import "GBAssureMasterModel.h"


// Views
#import "GBAssureMasterCardCell.h"

static NSString *const kGBAssureMasterCardCellID = @"GBAssureMasterCardCell";

@interface GBMoreMastersViewController ()<UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 大师 */
@property (nonatomic, strong) NSMutableArray <GBAssureMasterModel *> *assureMasters;

/* <#describe#> */
@property (nonatomic, copy) NSString *orderBy;
// 下拉菜单数据
@property (nonatomic,strong) NSArray *menuItemNames;
/* 半透明遮罩视图 */
@property (nonatomic, strong) UIView *maskView;

@end

@implementation GBMoreMastersViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:YCXMenuWillDisappearNotification object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAssureMasters];
    [self loadRequestMastersCount];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH - GBMargin*2, 160);
    self.baseCollectionView.collectionViewLayout = layout;
    [self.baseCollectionView registerClass:[GBAssureMasterCardCell class] forCellWithReuseIdentifier:kGBAssureMasterCardCellID];
    self.baseCollectionView.dataSource = self;
    self.baseCollectionView.delegate = self;
    [self.view addSubview:self.baseCollectionView];
    self.baseCollectionView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    [self.baseCollectionView addSubview:[self setupBigTitleHeadViewWithFrame:CGRectMake(0, -80, SCREEN_WIDTH, 80) title:@"保过大师"]];

    [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_more")];
    
    @GBWeakObj(self);
    // 功能菜单
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        [self menuFunction];
    }];
    
    // 下拉菜单通知
    [GBNotificationCenter addObserver:self selector:@selector(menuWillDisappear) name:YCXMenuWillDisappearNotification object:nil];

}

#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self loadAssureMasters];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self loadAssureMasters];
}
- (void)loadAssureMasters {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestMoreMasters:page pageSize:10 orderBy:self.orderBy];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBAssureMasterModel mj_objectArrayWithKeyValuesArray:returnValue];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.assureMasters = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseCollectionView reloadData];
            [self.baseCollectionView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.assureMasters addObjectsFromArray:returnDataArray];
            
            [self.baseCollectionView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseCollectionView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseCollectionView.mj_footer endRefreshing];
            }
        }
        
        if (self.assureMasters.count) {
            [self removeNoDataImage];
        }else {
            [self showNoDataImage];
        }
    }];
}

- (void)loadRequestMastersCount {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init]; [homePageVM loadRequestMastersCount];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        [self setupSubTitle:GBNSStringFormat(@"为您推荐%@位保过大师",returnValue)];
    }];
}
#pragma mark - # Event Response
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.baseCollectionView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
}

#pragma mark - # Privater Methods
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
    [YCXMenu setHasShadow:YES];
    
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 60, SafeAreaTopHeight, 50, 0) menuItems:self.menuItemNames selected:^(NSInteger index, YCXMenuItem *item) {
        self.maskView.alpha = 0;

        switch (index) {
            case 0:
            {
                self.orderBy = @"RATE";
            }
                break;
            case 1:
            {
                self.orderBy = @"HELP";
            }
                break;
            default:
                break;
        }
        
        [self headerRereshing];
    }];
}

#pragma mark - # Delegate

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assureMasters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GBAssureMasterCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGBAssureMasterCardCellID forIndexPath:indexPath];
    cell.assureMasterModel = self.assureMasters[indexPath.row];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了%zd",indexPath.row);
    GBCommonPersonalHomePageViewController *homePageVC = [[GBCommonPersonalHomePageViewController alloc] init];
    homePageVC.targetUsrid = self.assureMasters[indexPath.row].userId;
    [[GBAppHelper getPushNavigationContr] pushViewController:homePageVC animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}


#pragma mark - # Getters and Setters

- (NSArray *)menuItemNames {
    if (!_menuItemNames) {
        //set item
        YCXMenuItem *item1 = [YCXMenuItem menuItem:@"好评优先"
                                             image:nil
                                               tag:100
                                          userInfo:@{@"title":@"Menu"}];
        item1.foreColor = [UIColor kImportantTitleTextColor];
        
        YCXMenuItem *item2 = [YCXMenuItem menuItem:@"保过数优先"
                                             image:nil
                                               tag:101
                                          userInfo:@{@"title":@"Menu"}];
        item2.foreColor = [UIColor kImportantTitleTextColor];
        
        _menuItemNames = @[item1,item2];
    }
    
    return _menuItemNames;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor lightGrayColor];
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
