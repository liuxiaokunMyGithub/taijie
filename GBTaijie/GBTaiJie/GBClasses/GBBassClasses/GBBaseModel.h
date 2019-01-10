//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface GBBaseModel : NSObject
@property(nonatomic,strong) NSString *errorCode;
@property(nonatomic,strong) NSString *errMsg;
@property(nonatomic,strong) NSMutableArray *arrData;

- (id)initWithDic:(NSDictionary *)data;

- (NSData*)keyedArchiverObject;
+ (instancetype)unarchiveObjectWithDate:(NSData*)data;

@end
