//
//  UserModel.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/23.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,UserGender){
    UserGenderUnKnow = 0,
    UserGenderMale, //男
    UserGenderFemale //女
};

@interface UserModel : GBBaseModel

// 登录信息
@property(nonatomic,copy) NSString *userId;//用户ID
@property (nonatomic,copy) NSString *headImg;//头像
@property (nonatomic,copy) NSString *story;//故事

@property (nonatomic,copy) NSString *mobile;// 手机号
@property (nonatomic,copy) NSString *nickName;//昵称
// 状态 0:没有意向id
@property (nonatomic,assign) NSInteger  role;//用户等级
@property (nonatomic,copy) NSString *token;//用户登录后分配的登录Token

// 个人信息
@property (nonatomic, copy) NSString *sex;//性别
@property (nonatomic, copy) NSString *tel;//电话
@property (nonatomic, copy) NSString *age;//年龄
/* 生日 */
@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, strong) NSArray *skills;//技能
/* 过往经验 */
@property (nonatomic, assign) NSInteger microExperienceCount;

@property(nonatomic,assign)NSInteger helpedCount;//帮助人数
@property(nonatomic,copy)NSString *adeptSkill;//技能
@property(nonatomic,copy)NSString *companyInfo;//公司信息
/** 收益 */
@property (nonatomic, assign) NSInteger currentTotalEarning;
/** 安卓余额 */
@property (nonatomic, assign) NSInteger leftBalance;
/** 台阶币余额 */
@property (nonatomic, assign) NSInteger leftToken;
/** (暂时无用) */
@property (nonatomic, assign) NSInteger totalBalance;
@property (nonatomic, assign) NSInteger totalEarning;
@property (nonatomic, assign) NSInteger totalToken;
/** 满意度 */
@property (nonatomic, assign) NSInteger degreeOfSatisfaction;
/** 收藏 */
@property (nonatomic, assign) NSInteger isCollected;
/* <#describe#> */
@property (nonatomic, assign) BOOL schoolFilled;
/* <#describe#> */
@property (nonatomic, copy) NSString *city;

@end
