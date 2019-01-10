//
//  GBAssureContentEditViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/18.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"
#import "GBAssureContentTagModel.h"

@interface GBAssureContentEditViewController : GBBaseViewController
/* 意向标签 */
@property (nonatomic,strong) NSMutableArray *selectTags;
/* <#describe#> */
@property (nonatomic, copy) NSString *contentStr;

/* <#describe#> */
@property (nonatomic, copy) void(^completeOperationBlock)(NSArray <GBAssureContentTagModel*> *selectTagModels,NSArray *selectTags,NSString *textViewStr);


@end
