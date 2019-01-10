//
//  CompanyModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/825.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "CompanyModel.h"

@implementation CompanyModel

- (NSMutableArray *)scores {
    if (!_scores) {
        _scores = [[NSMutableArray alloc] init];
    }
    return _scores;
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"scores":[CompanyScoreModel class]};
//}

@end
