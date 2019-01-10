//
//  GBSkillsModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBSkillsModel : GBBaseModel

@property (nonatomic, copy) NSString *skillId;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *isHot;
@property (nonatomic, assign) NSInteger isSelect;
/* id */
@property (nonatomic, copy) NSString *skillRelatedId;

/* describe */
@property (nonatomic, copy) NSString *skillName;
@property (nonatomic, copy) NSString *skillPid;

@end
