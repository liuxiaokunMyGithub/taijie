//
//	GBType.h
//
//	Create by 小坤 刘 on 23/8/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface GBType : NSObject

@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) BOOL isCustomized;
@property (nonatomic, strong) NSString * name;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end