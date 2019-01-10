//
//	GBOrderDetailsModel.h
//
//	Create by 小坤 刘 on 12/7/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface GBOrderDetailsModel : NSObject
/* <#describe#> */
@property (nonatomic, assign) BOOL purchaserIsIncumbent;

/* 职位 */
@property (nonatomic, copy) NSString *positionName;
/* <#describe#> */
@property (nonatomic, assign) NSInteger minSalary;
@property (nonatomic, assign) NSInteger maxSalary;
/* <#describe#> */
@property (nonatomic, copy) NSString *companyName;
/* <#describe#> */
@property (nonatomic, strong) NSString *leaveMesseges;
@property (nonatomic, strong) NSString * cancelReason;
@property (nonatomic, strong) NSString * cancelRemark;
@property (nonatomic, strong) NSString * closeTime;
@property (nonatomic, assign) NSInteger decryptId;
@property (nonatomic, assign) NSInteger assurePassId;
@property (nonatomic, strong) NSString * decryptStatus;
@property (nonatomic, strong) NSString * decryptStatusName;
@property (nonatomic, strong) NSString * assurePassStatus;
@property (nonatomic, strong) NSString * assurePassStatusName;
@property (nonatomic, strong) NSString * details;
@property (nonatomic, assign) NSInteger evaluateCount;
@property (nonatomic, assign) NSInteger incumbentDecryptId;
@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSString * personalSituation;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString * publisher;
@property (nonatomic, strong) NSString * publisherCompany;
@property (nonatomic, assign) NSInteger publisherCompanyId;
@property (nonatomic, strong) NSString * publisherEvaluted;
@property (nonatomic, strong) NSString * publisherEvalutedContent;
@property (nonatomic, strong) NSString * publisherHeadImg;
@property (nonatomic, assign) NSInteger publisherId;
@property (nonatomic, strong) NSString * publisherPosition;
@property (nonatomic, assign) NSInteger purchaseCount;
@property (nonatomic, strong) NSString * purchaser;
@property (nonatomic, assign) NSInteger purchaserDegreeOfSatisfaction;
@property (nonatomic, strong) NSString * purchaserHeadImg;
@property (nonatomic, assign) NSInteger purchaserId;
@property (nonatomic, assign) NSInteger quantityPurchased;
@property (nonatomic, strong) NSString * question;
@property (nonatomic, strong) NSString * rejectReason;
@property (nonatomic, strong) NSString * rejectRemark;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, strong) NSString * submitTime;
@property (nonatomic, strong) NSString * subscribeEvaluted;
@property (nonatomic, strong) NSString * subscribeEvalutedContent;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * typeName;
@end
