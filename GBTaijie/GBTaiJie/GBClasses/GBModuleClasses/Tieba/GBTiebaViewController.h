//
//  GBTiebaViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>

// 帖子cell显示样式
typedef NS_ENUM(NSInteger,GBShowTiebaCellType) {
    //无图
    GBShowTiebaCellTypeNoPic = 1,
    //一个图
    GBShowTiebaCellTypeOnePic,
};

@interface GBTiebaViewController : GBBaseViewController

@property (nonatomic, assign) GBShowTiebaCellType showTiebaCellType;
/* <#describe#> */
@property (nonatomic, copy) NSString *orderType;


@end
