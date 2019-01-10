//
//  JobModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/84.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobModel : GBBaseModel

/**
 industryId = 1;
 isHot = 0;
 jobId = 1;
 jobName = "\U6d4b\U8bd5\U804c\U4f4d1";
 jobPid = "<null>";
 */

@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, copy) NSString *isHot;
@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, copy) NSString *jobName;
@property (nonatomic, copy) NSString *jobPid;

@property (nonatomic, assign) NSInteger isSelect;

@end
