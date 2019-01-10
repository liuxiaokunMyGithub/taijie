//
//  GBMineViewModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/3.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBMineViewModel : GBBassViewModel
// MARK: 个人信息
- (void)loadRequestPersonalInfo:(NSString *)targetUserId;
// MARK: 编辑页带技能个人信息
- (void)loadRequestPersonalEditInfo;
// MARK: 更新个人资料
- (void)loadRequestPersonalEditInfoUpdate:(NSDictionary *)param;

/** 余额 */
- (void)loadRequestBalance;

/** 交易流水
 serviceType: @"MONEY_RECORD_TYPE_JM"(解密)|@"MONEY_RECORD_TYPE_BG"(保过)
 payDirection: IN(收益)|OUT(支出)
 */
- (void)loadRequestUserMoneyRecordList:(NSInteger )pageNo
                              pageSize:(NSInteger )pageSize
                           serviceType:(NSString *)serviceType
                          payDirection:(NSString *)payDirection;

/** 内购充值 */
- (void)loadRequestInAppPurchase:(NSString *)receipt;

/** 已购订单 */
- (void)loadRequestPurchasedOrderList:(NSInteger )pageNo
                             pageSize:(NSInteger )pageSize
                               status:(NSString *)status
                          serviceType:(NSString *)serviceType;

/** 服务订单列表 */
- (void)loadRequestIncumbentOrderList:(NSInteger )pageNo
                             pageSize:(NSInteger )pageSize
                               status:(NSString *)status
                          serviceType:(NSString *)serviceType;
/** 解密订单详情 */
- (void)loadRequestDecryptOrderDetails:(NSInteger )decryptId;
/** 保过订单详情 */
- (void)loadRequestAssurePassOrderDetails:(NSInteger )assurePassId;
/** 订单小红点
 userType : SUBSCRIBER(购买者)|VENDOR（提供者）
 serviceType : GOODS_TYPE_BG(保过)|GOODS_TYPE_JM（解密）
 */
- (void)loadRequestOrderNoticeStatusRenewal:(NSString *)userType
                                serviceType:(NSString *)serviceType
                                  serviceId:(NSInteger )serviceId;
/** 检查订单总状态及分TAB状态 */
- (void)loadRequestMineOrderNewStatus;

/** 更新用户手机号 */
- (void)loadRequestUserTelRenewal:(NSString *)tel
                          smsCode:(NSString *)smsCode;

/** 更新支付密码 */
- (void)loadRequestPayPwdRenewal:(NSString *)payPwd
                         smsCode:(NSString *)smsCode;

/** 更新登录密码 */
- (void)loadRequestLoginPasswordRenewal:(NSString *)tel
                               password:(NSString *)password
                                smsCode:(NSString *)smsCode;
/** 更新用户支付宝账户 */
- (void)loadRequestUpdateUserAlipayAccount:(NSString *)alipayAccount
                                   smsCode:(NSString *)smsCode;

/** 认证状态 */
- (void)loadRequestMineIncumbentAuthenticationState;
/** 获取认证信息 */
- (void)loadRequestMineIncumbentAuthenticationInfo;
/** 提交认证信息 */
- (void)loadRequestMineIncumbentAuthenticationInfoSubmition:(NSDictionary *)param;
/** 提交认证信息审核 */
- (void)loadRequestMineAuditionSubmition:(NSString *)authenticationId;
/** 芝麻认证 */
- (void)loadRequestMineInitAntAuthenticate:(NSString *)certName
                                    certNo:(NSString *)certNo;
/** 新增/更新在职者解密服务  */
- (void)loadRequestMineDecryptRenewal:(NSString *)discountType
                                types:(NSArray *)types
                        originalPrice:(NSString *)originalPrice
                                price:(NSString *)price
                                title:(NSString *)title
                              details:(NSString *)details
                             isEnable:(BOOL )isEnable
                   incumbentDecryptId:(NSString *)incumbentDecryptId;
/** 新增/更新在职者保过服务  */
- (void)loadRequestMineAssureRenewal:(NSDictionary *)positionDic
                               price:(NSString *)price
                             content:(NSString *)content
                            isEnable:(BOOL )isEnable
                        assurePassId:(NSInteger )assurePassId;

/** 解密服务列表 */
- (void)loadRequestMineDecryptServiceList:(NSInteger )pageNo
                                 pageSize:(NSInteger )pageSize;
/** 保过服务列表 */
- (void)loadRequestMineAssurePasstServiceList:(NSInteger )pageNo
                                     pageSize:(NSInteger )pageSize;
/** 在职者解密服务详情  */
- (void)loadRequestMineIncumbentDecrypt:(NSInteger )incumbentDecryptId;
/** 删除解密服务 */
- (void)loadRequestMineDeleteIncumbentDecrypt:(NSInteger )incumbentDecryptId;
/** 在职者保过服务详情  */
- (void)loadRequestMineIncumbentAssurePass:(NSInteger )incumbentAssurePassId;
/** 删除保过服务 */
- (void)loadRequestMineDeleteIncumbentAssurePass:(NSInteger )incumbentAssurePassId;
/** 保过服务评价 */
- (void)loadRequestMineAssurePassEvaluate:(NSInteger )assurePassId
                                  content:(NSString *)content
                                     star:(NSString *)star
                             responseStar:(NSString *)responseStar
                          proficiencyStar:(NSString *)proficiencyStar;
/** 解密服务评价 */
- (void)loadRequestMineDecryptEvaluate:(NSInteger )decryptId
                               content:(NSString *)content
                                  star:(NSString *)star
                          responseStar:(NSString *)responseStar
                       proficiencyStar:(NSString *)proficiencyStar;

/** 接受解密 */
- (void)loadRequestMineDecryptAccept:(NSInteger )decryptId;
/** 结束解密  */
- (void)loadRequestMineDecryptFinish:(NSInteger )decryptId;
/** 拒绝解密  */
- (void)loadRequestMineDecryptReject:(NSInteger )decryptId;
/** 解密取消  */
- (void)loadRequestMineDecyptPassCancel:(NSInteger )decryptId;

/** 接受保过  */
- (void)loadRequestMineAssurePassAccept:(NSInteger )assurePassId;
/** 结束保过  */
- (void)loadRequestMineAssurePassFinish:(NSInteger )assurePassId
                             reasonType:(NSString *)reasonType
                                 remark:(NSString *)remark
                           refundAmount:(NSString *)refundAmount
                           rewardAmount:(NSString *)rewardAmount;
/** 拒绝保过  */
- (void)loadRequestMineAssurePassReject:(NSInteger )assurePassId;
/** 保过取消  */
- (void)loadRequestMineAssurePassCancel:(NSInteger )assurePassId;

/**
 我的收藏列表
 type:
    公司 @"COLLECTION_TYPE_COMPANY"
    职位 @"COLLECTION_TYPE_POSITION";
    朋友 @"COLLECTION_TYPE_USER";
 */
- (void)loadRequestMineCollectionList:(NSInteger )pageNo
                             pageSize:(NSInteger )pageSize
                                 type:(NSString *)type;

/** 提现  */
- (void)loadRequestMineWithdrawDeposit:(NSInteger )amount
                         alipayAccount:(NSString *)alipayAccount;
/** 获取支付宝账号 */
- (void)loadRequestMineUserAlipayAccount;
/** 意见反馈
 contactType WX（微信）|MOBILE（手机）|EMAIL（邮箱）
 */
- (void)loadRequestMineFeedBack:(NSString *)feedBack
                    contactType:(NSString *)contactType
                  contactDetail:(NSString *)contactDetail;
/** 提现记录 */
- (void)loadRequestMineWithdrawDepositList:(NSInteger )pageNo
                                  pageSize:(NSInteger )pageSize;

/** 过往微经验 */
- (void)loadRequestMineMicroExperienceList:(NSString *)targetUserId;

/** 编辑添加微经验 */
- (void)loadRequestUpdateMineMicroExperience:(NSString *)startTime
                                     endTime:(NSString *)endTime
                                 companyName:(NSString *)companyName
                                positionName:(NSString *)positionName
                             evaluateContent:(NSString *)evaluateContent
                                experienceId:(NSInteger )experienceId;
/** 微经验删除 */
- (void)loadRequestMineMicroExperienceDelete:(NSInteger )experienceId;
/** 保过标签 */
- (void)loadRequestMineassurePassLabels;
/** 认证重置校验 */
- (void)loadRequestReviewTimeVerification;
/** 系统消息 */
- (void)loadRequestSystemsMessages:(NSInteger )pageNo
                          pageSize:(NSInteger )pageSize;
/** 外层系统消息 */
- (void)loadRequestOuterSystemMessage;
/** 系统消息操作 */
- (void)loadRequestSystemsMessageAction:(NSString *)relatedServiceType
                                 action:(NSString *)action
                              messageId:(NSString *)messageId;



/** 省份 */
- (void)loadRequestListProvinces;
/** 大学 */
- (void)loadRequestListUniversities:(NSString *)provinceId;
/** 专业 */
- (void)loadRequestListMajors:(NSString *)universityId;
/** 新增或更新教育经历 */
- (void)loadRequestEducationExperienceRenewal:(NSString *)pcname
                               universityName:(NSString *)universityName
                                    majorName:(NSString *)majorName
                                      diploma:(NSString *)diploma
                                    startTime:(NSString *)startTime
                                      endTime:(NSString *)endTime
                                   isDomestic:(BOOL)isDomestic
                                 experienceId:(NSString *)experienceId;
/** 删除教育经历 */
- (void)loadRequestEducatiopnExerienceRemoval:(NSString *)edcationID;
/** 获取教育经历 */
- (void)loadRequestEducatiopnExerience;

@end
