//
//	GBSystemMessageModel.h
//
//	Create by 小坤 刘 on 14/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface GBSystemMessageModel : NSObject

@property (nonatomic, strong) NSString * action;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, assign) BOOL dataStatus;
@property (nonatomic, assign) BOOL isAnonymous;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, strong) NSObject * lastUpdateTime;
@property (nonatomic, strong) NSString * messageDetailType;
@property (nonatomic, strong) NSString * messageType;
@property (nonatomic, strong) NSString * orderDirection;
@property (nonatomic, assign) NSInteger relatedServiceId;
@property (nonatomic, strong) NSString * relatedServiceType;
@property (nonatomic, assign) NSInteger relatedUserId;
@property (nonatomic, strong) NSString * titie;
@property (nonatomic, assign) NSInteger userId;
/* <#describe#> */
@property (nonatomic, strong) NSString *messageId;

@end
