//
//  GBBaseViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WRCustomNavigationBar.h"
#import "GBBigTitleHeadView.h"
/** 无数据占位 */
#import "UIScrollView+EmptyDataSet.h"

//数据加载类型枚举
typedef NS_ENUM(NSInteger,LoadingDataStyle) {
    //下拉刷新
    LoadingDataRefresh = 0,
    //上拉加载
    LoadingDataGetMore
};

// 空数据页面类型枚举
typedef NS_ENUM(NSUInteger, GBEmptyDataType) {
    GBEmptyDataTypeCommon = 0,
    // 断网
    GBEmptyDataTypeNotNetwork
};

@interface GBBaseViewController : UIViewController {
    /* 数据加载页码 */
    NSInteger page;
}
// 数据加载类型
@property (assign,nonatomic) LoadingDataStyle loadingStyle;
// 空白页类型
@property (nonatomic, assign) GBEmptyDataType emptyDataType;

/** 自定义导航栏 */
@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

/* <#describe#> */
@property (nonatomic, strong) GBBigTitleHeadView *bigBassTitleHeadView;

@property (nonatomic,strong) UIImageView* noDataView;

/* 底部按钮点击 */
@property (nonatomic, copy) dispatch_block_t didClickBaseBottomButton;

/* 网络连接失败重试按钮点击 */
@property (nonatomic, copy) dispatch_block_t reloadNetWorkingClickedBlock;
/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;

/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;

@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, strong) UICollectionView *baseCollectionView;
/* 底部视图 */
@property (nonatomic, strong) UIView *baseBottomView;

/* 分割线 */
@property (nonatomic, strong) UIView *baseBottomlineView;

/* 底部按钮 */
@property (nonatomic, strong) UIButton *baseBottomButton;
/**
 *  显示没有数据页面
 */
-(void)showNoDataImage;

/* 无数据视图顶部 */
@property (nonatomic, assign) CGFloat noDataViewTopMargin;

/* 大标题头 */
- (GBBigTitleHeadView *)setupBigTitleHeadViewWithFrame:(CGRect )frame
                                                 title:(NSString *)title;
/* 大标题头 - 右侧子标题 */
- (void)setupSubTitle:(NSString *)subTitle;
/* 大标题头 - 底部子标题 */
- (void)setupBottomSubTitle:(NSString *)bottomSubTitle;
/* 大标题头 - 顶部偏移 */
- (void)setupBigTitleTopMargin:(NSInteger )topMargin;
/** 设置底部按钮 */
- (UIView *)setupBottomViewWithtitle:(NSString *)title;
/** 下拉刷新 */
- (void)headerRereshing;
/** 上拉加载 */
- (void)footerRereshing;
/**
 *  移除无数据页面
 */
- (void)removeNoDataImage;

/**
 设置导航栏右侧按钮
 */
- (void)setupCustomNavBarRightButton:(NSString *)rightButtonStr;

@end
