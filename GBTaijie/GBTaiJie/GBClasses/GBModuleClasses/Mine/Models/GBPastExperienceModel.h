//
//  GBPastExperienceModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/7.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBPastExperienceModel : GBBaseModel
/** id */
@property (nonatomic, assign) NSInteger id;

/* 公司 */
@property (nonatomic, copy) NSString *companyName;

/* 职位 */
@property (nonatomic, copy) NSString *positionName;

/* 评价 */
@property (nonatomic, copy) NSString *evaluateContent;

/* 开始时间 */
@property (nonatomic, copy) NSString *startTime;

/* 结束时间 */
@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) BOOL isOpen;

@property (assign, nonatomic, readonly)CGFloat height;

@end
