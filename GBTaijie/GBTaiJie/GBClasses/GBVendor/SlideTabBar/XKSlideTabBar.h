//
//  XKSlideTabBar.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/20.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HHTitleBtn : UIButton

@end

@interface XKSlideTabBar : UIView

/* <#describe#> */
@property (nonatomic, strong) NSArray *titleArray;
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

/* <#describe#> */
@property (nonatomic, copy) void(^didSelectedItemBlock)(NSInteger index);

@end
