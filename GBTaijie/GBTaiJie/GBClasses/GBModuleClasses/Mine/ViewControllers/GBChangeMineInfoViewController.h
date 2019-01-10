//
//  GBChangeMineInfoViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/5.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef NS_ENUM(NSUInteger, ChangeInfoType) {
    // 通用
    ChangeInfoTypeCommon = 0,
    // 昵称
    ChangeInfoTypeNick ,
    // 擅长技能领域
    ChangeInfoTypeEmail,
};

typedef void(^SaveBlock) (NSString *inputStr);

@interface GBChangeMineInfoViewController : GBBaseViewController

@property (nonatomic, copy) SaveBlock saveBlock;

/* 占位字符 */
@property (nonatomic, copy) NSString *placeholderStr;

/* 个人信息 */
@property (strong , nonatomic) UserModel *userModel;
/* 修改类型 */
@property (nonatomic, assign) ChangeInfoType changeInfoType;

@end
