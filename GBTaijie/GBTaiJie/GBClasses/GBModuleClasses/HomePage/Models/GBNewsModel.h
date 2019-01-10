//
//  GBNewsModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/15.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBNewsModel : GBBaseModel
/* <#describe#> */
@property (nonatomic, copy) NSString *id;
/* <#describe#> */
@property (nonatomic, copy) NSString *title;
/* <#describe#> */
@property (nonatomic, copy) NSString *picture;
/* <#describe#> */
@property (nonatomic, copy) NSString *detail;
/* <#describe#> */
@property (nonatomic, copy) NSString *watchCount;
/* <#describe#> */
@property (nonatomic, copy) NSString *starCount;
@property (nonatomic, assign) BOOL dataStatus;
/* <#describe#> */
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
/* <#describe#> */
@property (nonatomic, copy) NSString *sort;
/* <#describe#> */
@property (nonatomic, copy) NSString *link;

@end
