//
//  DCFiltrateViewController.h
//  LiChi
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCFiltrateItem.h"

@interface DCFiltrateViewController : UIViewController

@property (nonatomic , strong) NSMutableArray<DCFiltrateItem *> *filtrateItem;

/** 点击已选回调 */
@property (nonatomic , copy) void(^sureClickBlock)(NSArray *selectArray);
/* 多选 */
@property (nonatomic, assign) BOOL isMutableSelect;
/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;

@end
