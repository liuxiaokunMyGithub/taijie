//
//  BuyOrderModel.h
//  GBTaiJie
//
//  Created by jiaming yan on 2018/824.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


@interface BuyOrderModel : GBBaseModel
@property (nonatomic, strong) NSObject * accepted;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString * closeTime;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSString * payStatus;
@property (nonatomic, strong) NSString * payStatusName;
@property (nonatomic, strong) NSString * publisher;
@property (nonatomic, strong) NSString * publisherHeadImg;
@property (nonatomic, assign) NSInteger publisherId;
@property (nonatomic, strong) NSString * purchaser;
@property (nonatomic, assign) BOOL purchaserEvaluated;
@property (nonatomic, strong) NSString * purchaserHeadImg;
@property (nonatomic, assign) NSInteger purchaserId;
@property (nonatomic, assign) NSInteger relatedId;
@property (nonatomic, strong) NSString * serviceStatus;
@property (nonatomic, strong) NSString * serviceStatusName;
@property (nonatomic, strong) NSString * serviceType;
@property (nonatomic, strong) NSString * serviceTypeName;
@property (nonatomic, assign) BOOL venderEvaluated;
/* <#describe#> */
@property (nonatomic, assign) BOOL isSubscriberConfirm;
/* <#describe#> */
@property (nonatomic, assign) BOOL isVendorConfirm;

/* <#describe#> */
@property (nonatomic, copy) NSString *title;

@end
