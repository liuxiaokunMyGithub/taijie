//
//   GBBasePageViewSuperController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/28.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "WMPageController.h"

@interface GBBasePageViewController : WMPageController

/* 头部视图 */
@property (nonatomic, strong) UIView *pageHeadView;

@end


#import <UIKit/UIKit.h>
#import "GBBasePageViewController.h"
#import "ArtScrollView.h"
#import "GBCompanyInfoViewController.h"

typedef NS_ENUM(NSUInteger, GBPageControllerType) {
    // 公司主页
    GBPageControllerTypeCompanyHomePage = 0,
    // 个人主页
    GBPageControllerTypePersonHomePage,
    // 我的订单
    GBPageControllerTypeMineOrderPage,
    // 帖子
    GBPageControllerTypeTieba,
    // 服务
    GBPageControllerTypeService,
    // 收藏
    GBPageControllerTypeCollect,
    
};

@interface GBBasePageViewSuperController : GBBaseViewController

/* 公司信息  */
@property (nonatomic, strong)  GBCompanyInfoViewController *companyInfoVC;

@property (nonatomic, assign) GBPageControllerType pageType;

@property (nonatomic, strong) GBBasePageViewController *pageController;

@property (nonatomic, strong) ArtScrollView *containerScrollView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIView *contentView;

- (void)setPageMenuTitles:(NSArray *)titles pageControllerType:(GBPageControllerType )pageType;

/* 头部视图 */
@property (nonatomic, strong) UIView *pageHeadView;

/* 公司主页companyId */
@property (nonatomic, copy) NSString *companyId;
/** 个人主页targetUsrid */
@property (nonatomic, copy) NSString *targetUsrid;

@end

