//
//  GBAddPastExperienceViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/7.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseViewController.h"
#import "GBPastExperienceModel.h"

// 添加类型
typedef NS_ENUM (NSInteger , AddPastExperienceType) {
    // 新增
    AddPastExperienceTypeNew  =  0,
    // 编辑
    AddPastExperienceTypeEdit
};

@interface GBAddPastExperienceViewController : GBBaseViewController

/* 经验 */
@property (nonatomic, strong) GBPastExperienceModel *pastExperienceModel;

/* 添加类型 */
@property (nonatomic, assign) AddPastExperienceType addPastExperienceType;

@end
