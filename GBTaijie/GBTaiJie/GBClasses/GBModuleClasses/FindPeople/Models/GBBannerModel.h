//
//	GBBannerModel.h
//
//	Create by 小坤 刘 on 26/6/2018
//	Copyright © 2018. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GBBannerModel : NSObject
/** 广告id */
@property (nonatomic, assign) NSInteger advertisementId;
/** 广告图片 */
@property (nonatomic, strong) NSString * advertisementImg;
/** 标题 */
@property (nonatomic, strong) NSString * title;
/** 类型 */
@property (nonatomic, strong) NSString * type;
/** 广告链接 */
@property (nonatomic, strong) NSString * url;
/* 时间 */
@property (nonatomic, copy) NSString *createTime;
/* <#describe#> */
@property (nonatomic, copy) NSString *lastUpdateTime;
/* <#describe#> */
@property (nonatomic, copy) NSString *dataStatus;
/* <#describe#> */
@property (nonatomic, copy) NSString *sort;
/* <#describe#> */
@property (nonatomic, copy) NSString *fromId;
/* <#describe#> */
@property (nonatomic, copy) NSString *detail;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;

@end
