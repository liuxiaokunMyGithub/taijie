//
//  IndustryModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/84.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndustryModel : GBBaseModel

/**
 industryId = 1;
 industryName = "\U6d4b\U8bd5\U884c\U4e1a1";
 isHot = 0;
 */

@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, copy) NSString *industryName;
@property (nonatomic, copy) NSString *isHot;
@property (nonatomic, assign) NSInteger isSelect;
/* <#describe#> */
@property (nonatomic, copy) NSString *industryTypeName;
@property (nonatomic, copy) NSString *industryTypeId;

@end
