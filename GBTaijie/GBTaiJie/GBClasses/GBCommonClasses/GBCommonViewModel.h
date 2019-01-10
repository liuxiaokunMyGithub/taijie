//
//  GBCommonViewModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/22.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBCommonViewModel : GBBassViewModel
/** 阿里芝麻信用认证签名 */
- (void)loadRequestAlipayAccountAuthSign;
/** 阿里芝麻信用分 */
- (void)loadRequestAlipayGetZmScore;
/** 获取技能列表 */
- (void)loadRequestSkills:(NSString *)skillPid;
/** 新增更新技能 */
- (void)loadRequestUpdateSkills:(NSArray *)skills;
/** 校验支付密码 */
- (void)loadRequestPayPwdVerification:(NSString *)payPwd;
/** 检查用户是否有支付密码 */
- (void)loadRequestCheckUserHasPayPwd;
/** 关注保过职位V1 */
- (void)loadRequestWatchPosition:(NSString *)incumbentAssurePassId;
/** 关注解密V1 */
- (void)loadRequestWatchDecrypt:(NSString *)incumbentDecryptId;
/** 极光推送id更新 */
- (void)loadRequestRegIdRenewal:(NSString *)registrationId;
/** 红包弹出校验 */
- (void)loadRequestCheckRedPacketOpened;
/** 红包领取 */
- (void)loadRequestOpenRedPacket;

@end
