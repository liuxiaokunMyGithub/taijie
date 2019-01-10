//
//	GBFindModel.h
//
//	Create by 小坤 刘 on 23/8/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "GBType.h"

@interface GBFindModel : NSObject
/* <#describe#> */
@property (nonatomic, copy) NSString *discountType;

@property (nonatomic, strong) NSString * classifiedName;
@property (nonatomic, strong) NSString * companyFullName;
@property (nonatomic, strong) NSString * companyName;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, assign) BOOL discountEnable;
@property (nonatomic, assign) NSInteger evaluateRate;
@property (nonatomic, strong) NSString * headImg;
@property (nonatomic, strong) NSString * inServiceTime;
@property (nonatomic, assign) NSInteger incumbentDecryptId;
@property (nonatomic, strong) NSString * labelIds;
@property (nonatomic, strong) NSString * labelNamesIds;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, assign) NSInteger orderCount;
@property (nonatomic, assign) NSInteger originalPrice;
@property (nonatomic, strong) NSString * positionName;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
