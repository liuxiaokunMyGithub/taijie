//
//  GBHotTagModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBHotTagModel : GBBaseModel
/* <#describe#> */
@property (nonatomic, copy) NSString *jobPid;
/* <#describe#> */
@property (nonatomic, copy) NSString *jobName;
/* <#describe#> */
@property (nonatomic, copy) NSString *industryId;
/* <#describe#> */
@property (nonatomic, copy) NSString *isHot;
/* <#describe#> */
@property (nonatomic, copy) NSString *remark;
/* <#describe#> */
@property (nonatomic, copy) NSString *cascadeCode;
@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, copy) NSString *dataStatus;
@property (nonatomic, copy) NSString *priority;

@end
