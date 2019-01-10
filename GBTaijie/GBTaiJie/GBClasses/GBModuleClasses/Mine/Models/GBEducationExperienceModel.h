//
//  GBEducationExperienceModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBEducationExperienceModel : GBBaseModel
/* <#describe#> */
@property (nonatomic, copy) NSString *majorName;
/* <#describe#> */
@property (nonatomic, copy) NSString *professionaleId;

/* <#describe#> */
@property (nonatomic, copy) NSString *pcname;
/* <#describe#> */
@property (nonatomic, copy) NSString *provinceId;
/* <#describe#> */
@property (nonatomic, copy) NSString *universityName;
/* <#describe#> */
@property (nonatomic, copy) NSString *universityId;

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
/* <#describe#> */
@property (nonatomic, copy) NSString *diploma;

@property (nonatomic, assign) BOOL isDomestic;
/* <#describe#> */
@property (nonatomic, copy) NSString *id;

@end
