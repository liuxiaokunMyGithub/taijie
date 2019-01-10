//
//  GBAssureContentTagModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBAssureContentTagModel : GBBaseModel
/** id */
@property (nonatomic, assign) NSInteger id;

/* 状态 */
@property (nonatomic, copy) NSString *dataStatus;

/* 热门 */
@property (nonatomic, assign) NSInteger isHot;

/* 标签名 */
@property (nonatomic, copy) NSString *labelName;
/* <#describe#> */
@property (nonatomic, copy) NSString *labelId;
/* <#describe#> */
@property (nonatomic, copy) NSString *isCustomized;


@property (nonatomic, assign) BOOL isSelected;

@end
