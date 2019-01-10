//
//  GBWithdrawalRecordModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/6.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBWithdrawalRecordModel : GBBaseModel
// 用户id
@property (nonatomic, assign) NSInteger userId;
//
@property (nonatomic, assign) NSInteger amount;
// 审核状态
@property (nonatomic, assign) NSInteger stateCode;
// 用户名
@property (nonatomic, assign) NSInteger withdrawId;

// 验证码
@property (nonatomic, copy) NSString *userName;
// 验证码
@property (nonatomic, copy) NSString *state;
// 审核时间
@property (nonatomic, copy) NSString *reviewedTime;
// 标记
@property (nonatomic, copy) NSString *remark;
// 阿里账户
@property (nonatomic, copy) NSString *alipayAccount;
// 创建时间
@property (nonatomic, copy) NSString *createTime;

@end
