//
//  AuthenticationModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/821.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationModel : GBBaseModel

@property (nonatomic, copy) NSString *authenticationId;
@property (nonatomic, copy) NSString *zhimaCreditScore;
@property (nonatomic, assign) BOOL realNameAuthentication;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, copy) NSString *jobName;
@property (nonatomic, copy) NSString *positionName;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, copy) NSString *companyEmail;
@property (nonatomic, copy) NSString *entryTime;
@property (nonatomic, strong) NSMutableArray *imgs;

/** 增加三个真实姓名字段字段 */
@property (nonatomic, copy) NSString *realName;
/** 在职时间 */
@property (nonatomic, copy) NSString *minTime;
@property (nonatomic, copy) NSString *maxTime;

@end
