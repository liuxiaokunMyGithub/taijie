//
//  CityModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/84.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : GBBaseModel

/**
 characters = dalian;
 firstCharacters = DL;
 isHot = 1;
 regionId = 1;
 regionName = "\U5927\U8fde";
 */

@property (nonatomic, copy) NSString *characters;
@property (nonatomic, copy) NSString *firstCharacters;
@property (nonatomic, copy) NSString *isHot;
@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, copy) NSString *regionName;


@end
