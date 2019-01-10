//
//  GBMineCollectionViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/14.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger , MineCollectionType) {
    /** 收藏朋友 */
    MineCollectionTypeFriend  =  0,
    /** 收藏职位 */
    MineCollectionTypePosition,
    /** 收藏企业 */
    MineCollectionTypeCompany
};

@interface GBMineCollectionViewController : GBBaseViewController

/* 收藏类型 */
@property (nonatomic, assign) MineCollectionType collectionType;

@end
