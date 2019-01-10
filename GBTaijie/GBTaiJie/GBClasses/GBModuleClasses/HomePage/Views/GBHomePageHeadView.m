//
//  GBHomePageHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBHomePageHeadView.h"
#import "GBLIRLButton.h"
#import "SelectCityViewController.h"

@interface GBHomePageHeadView ()
/* 背景图 */
@property (nonatomic, strong) UIImageView *bgView;
/* 定位 */
@property (nonatomic, strong) GBLIRLButton *positioningButton;

@end

@implementation GBHomePageHeadView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self addSubview:self.positioningButton];
        [self addSubview:self.searchBar];
        [self addSubview:self.numberTitleLabel];

        [self p_addMasonry];
        
        GBViewRadius(self.searchBar, 2);        
    }
    
    return self;
}

#pragma mark - # Event Response
- (void)positioningButtonTouchUpInside:(UIButton *)sender {
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    selectCityVC.cityBlock = ^(CityModel *city) {
    };
    
    [[GBAppHelper getPushNavigationContr] pushViewController:selectCityVC animated:YES];
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    // 背景图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 定位
    [self.positioningButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self)setOffset:GBMargin+GBMargin/2];
        [make.left.mas_equalTo(self)setOffset:GBMargin];
        make.width.mas_equalTo(60);
    }];
    
    // 数据提示Label
    [self.numberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.bottom.equalTo(self.positioningButton)setOffset:0];
        [make.left.equalTo(self.positioningButton.mas_right)setOffset:3];
        make.right.mas_equalTo(self).offset(-GBMargin);
        make.height.equalTo(@20);
    }];
    
    // 数据提示Label
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.bottom.mas_equalTo(self)setOffset:-GBMargin];
        [make.left.mas_equalTo(self)setOffset:GBMargin];
        make.right.mas_equalTo(self).offset(-GBMargin);
        make.height.mas_equalTo(40);
    }];
}
///**
// 右侧下拉菜单按钮功能
// */
//- (void)menuFunction {
//    
//    self.maskView.alpha = 0.5;
//    
//    [YCXMenu setTintColor:[UIColor whiteColor]];
//    [YCXMenu setCornerRadius:2];
//    [YCXMenu setTitleFont:Fit_Font(15)];
//    [YCXMenu setSelectedColor:[UIColor whiteColor]];
//    [YCXMenu setSeparatorColor:[UIColor kSegmentateLineColor]];
//    
//    [YCXMenu showMenuInView:self fromRect:self.searchBar.typeBtn.frame menuItems:self.menuItemNames selected:^(NSInteger index, YCXMenuItem *item) {
//        
//    }];
//}
//
//#pragma mark - Setter Getter Methods
//- (NSArray *)menuItemNames {
//    if (!_menuItemNames) {
//        //set item
//        YCXMenuItem *item1 = [YCXMenuItem menuItem:@"职位"
//                                             image:nil
//                                               tag:100
//                                          userInfo:@{@"title":@"Menu"}];
//        item1.foreColor = [UIColor kImportantTitleTextColor];
//        
//        YCXMenuItem *item2 = [YCXMenuItem menuItem:@"公司"
//                                             image:nil
//                                               tag:101
//                                          userInfo:@{@"title":@"Menu"}];
//        item2.foreColor = [UIColor kImportantTitleTextColor];
//        
//        _menuItemNames = @[item1,item2];
//    }
//    
//    return _menuItemNames;
//}
#pragma mark - # Getters and Setters
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = GBImageNamed(@"Home_Head_img_background");
        _bgView.contentMode = UIViewContentModeScaleAspectFill;

    }
    
    return _bgView;
}

- (UIButton *)positioningButton {
    if (!_positioningButton) {
        _positioningButton = [[GBLIRLButton alloc] init];
        [_positioningButton addTarget:self action:@selector(positioningButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_positioningButton setImage:GBImageNamed(@"icon_location") forState:UIControlStateNormal];
        [_positioningButton setTitle:@"大连" forState:UIControlStateNormal];
        [_positioningButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _positioningButton.titleLabel.font = Fit_Font(16);
    }
    
    return _positioningButton;
}

- (UILabel *)numberTitleLabel {
    if (!_numberTitleLabel) {
        _numberTitleLabel = [[UILabel alloc] init];
        _numberTitleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _numberTitleLabel.font = Fit_Font(10);
        _numberTitleLabel.text = @"0位认证员工，已帮助0加入理想公司";
    }
    return _numberTitleLabel;
}

- (GBNavSearchBarView *)searchBar {
    if (!_searchBar) {
        _searchBar = [[GBNavSearchBarView alloc] init];
        _searchBar.backgroundColor = [UIColor whiteColor];
    }
    return _searchBar;
}

@end
