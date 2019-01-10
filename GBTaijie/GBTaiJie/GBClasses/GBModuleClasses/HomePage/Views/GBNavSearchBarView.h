//
//  GBNavSearchBarView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBLLRIButton.h"

typedef NS_ENUM (NSInteger , SearchBarViewType) {
    /** 常用样式 */
    SearchBarViewTypeNormal  =  0,
    /** 筛选 */
    SearchBarViewTypeFiltrate
};

@interface GBNavSearchBarView : UIView
/* <#describe#> */
@property (nonatomic, assign) SearchBarViewType searchBarViewType;

/* 类型选择按钮按钮 */
@property (strong , nonatomic) GBLLRIButton *typeBtn;
/* 搜索按钮 */
@property (strong , nonatomic) UIButton *searchImageBtn;
/* 占位文字 */
@property (strong , nonatomic) UILabel *placeholdLabel;
/* <#describe#> */
@property (nonatomic, strong) UIImageView *line;
/** 搜索类型 */
@property (nonatomic, copy) dispatch_block_t filtrateButtonClickBlock;

// 下拉菜单数据
@property (nonatomic,strong) NSArray *menuItemNames;

/* <#describe#> */
@property (nonatomic, copy) dispatch_block_t serchBarDidClickBlock;

@end
