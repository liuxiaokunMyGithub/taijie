//
//	GBFindModel.m
//
//	Create by 小坤 刘 on 23/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "GBFindModel.h"

NSString *const kGBFindModelClassifiedName = @"classifiedName";
NSString *const kGBFindModelCompanyFullName = @"companyFullName";
NSString *const kGBFindModelCompanyName = @"companyName";
NSString *const kGBFindModelDetail = @"detail";
NSString *const kGBFindModelDiscountEnable = @"discountEnable";
NSString *const kGBFindModelEvaluateRate = @"evaluateRate";
NSString *const kGBFindModelHeadImg = @"headImg";
NSString *const kGBFindModelInServiceTime = @"inServiceTime";
NSString *const kGBFindModelIncumbentDecryptId = @"incumbentDecryptId";
NSString *const kGBFindModelLabelIds = @"labelIds";
NSString *const kGBFindModelLabelNamesIds = @"labelNamesIds";
NSString *const kGBFindModelLikeCount = @"likeCount";
NSString *const kGBFindModelNickName = @"nickName";
NSString *const kGBFindModelOrderCount = @"orderCount";
NSString *const kGBFindModelOriginalPrice = @"originalPrice";
NSString *const kGBFindModelPositionName = @"positionName";
NSString *const kGBFindModelPrice = @"price";
NSString *const kGBFindModelSex = @"sex";
NSString *const kGBFindModelTitle = @"title";
NSString *const kGBFindModelTypes = @"types";
NSString *const kGBFindModelUserId = @"userId";

@interface GBFindModel ()
@end
@implementation GBFindModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kGBFindModelClassifiedName] isKindOfClass:[NSNull class]]){
		self.classifiedName = dictionary[kGBFindModelClassifiedName];
	}	
	if(![dictionary[kGBFindModelCompanyFullName] isKindOfClass:[NSNull class]]){
		self.companyFullName = dictionary[kGBFindModelCompanyFullName];
	}	
	if(![dictionary[kGBFindModelCompanyName] isKindOfClass:[NSNull class]]){
		self.companyName = dictionary[kGBFindModelCompanyName];
	}	
	if(![dictionary[kGBFindModelDetail] isKindOfClass:[NSNull class]]){
		self.detail = dictionary[kGBFindModelDetail];
	}	
	if(![dictionary[kGBFindModelDiscountEnable] isKindOfClass:[NSNull class]]){
		self.discountEnable = [dictionary[kGBFindModelDiscountEnable] boolValue];
	}

	if(![dictionary[kGBFindModelEvaluateRate] isKindOfClass:[NSNull class]]){
		self.evaluateRate = [dictionary[kGBFindModelEvaluateRate] integerValue];
	}

	if(![dictionary[kGBFindModelHeadImg] isKindOfClass:[NSNull class]]){
		self.headImg = dictionary[kGBFindModelHeadImg];
	}	
	if(![dictionary[kGBFindModelInServiceTime] isKindOfClass:[NSNull class]]){
		self.inServiceTime = dictionary[kGBFindModelInServiceTime];
	}	
	if(![dictionary[kGBFindModelIncumbentDecryptId] isKindOfClass:[NSNull class]]){
		self.incumbentDecryptId = [dictionary[kGBFindModelIncumbentDecryptId] integerValue];
	}

	if(![dictionary[kGBFindModelLabelIds] isKindOfClass:[NSNull class]]){
		self.labelIds = dictionary[kGBFindModelLabelIds];
	}	
	if(![dictionary[kGBFindModelLabelNamesIds] isKindOfClass:[NSNull class]]){
		self.labelNamesIds = dictionary[kGBFindModelLabelNamesIds];
	}	
	if(![dictionary[kGBFindModelLikeCount] isKindOfClass:[NSNull class]]){
		self.likeCount = [dictionary[kGBFindModelLikeCount] integerValue];
	}

	if(![dictionary[kGBFindModelNickName] isKindOfClass:[NSNull class]]){
		self.nickName = dictionary[kGBFindModelNickName];
	}	
	if(![dictionary[kGBFindModelOrderCount] isKindOfClass:[NSNull class]]){
		self.orderCount = [dictionary[kGBFindModelOrderCount] integerValue];
	}

	if(![dictionary[kGBFindModelOriginalPrice] isKindOfClass:[NSNull class]]){
		self.originalPrice = [dictionary[kGBFindModelOriginalPrice] integerValue];
	}

	if(![dictionary[kGBFindModelPositionName] isKindOfClass:[NSNull class]]){
		self.positionName = dictionary[kGBFindModelPositionName];
	}	
	if(![dictionary[kGBFindModelPrice] isKindOfClass:[NSNull class]]){
		self.price = [dictionary[kGBFindModelPrice] integerValue];
	}

	if(![dictionary[kGBFindModelSex] isKindOfClass:[NSNull class]]){
		self.sex = dictionary[kGBFindModelSex];
	}	
	if(![dictionary[kGBFindModelTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kGBFindModelTitle];
	}	
	if(dictionary[kGBFindModelTypes] != nil && [dictionary[kGBFindModelTypes] isKindOfClass:[NSArray class]]){
		NSArray * typesDictionaries = dictionary[kGBFindModelTypes];
		NSMutableArray * typesItems = [NSMutableArray array];
		for(NSDictionary * typesDictionary in typesDictionaries){
			GBType * typesItem = [[GBType alloc] initWithDictionary:typesDictionary];
			[typesItems addObject:typesItem];
		}
		self.types = typesItems;
	}
	if(![dictionary[kGBFindModelUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kGBFindModelUserId] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.classifiedName != nil){
		dictionary[kGBFindModelClassifiedName] = self.classifiedName;
	}
	if(self.companyFullName != nil){
		dictionary[kGBFindModelCompanyFullName] = self.companyFullName;
	}
	if(self.companyName != nil){
		dictionary[kGBFindModelCompanyName] = self.companyName;
	}
	if(self.detail != nil){
		dictionary[kGBFindModelDetail] = self.detail;
	}
	dictionary[kGBFindModelDiscountEnable] = @(self.discountEnable);
	dictionary[kGBFindModelEvaluateRate] = @(self.evaluateRate);
	if(self.headImg != nil){
		dictionary[kGBFindModelHeadImg] = self.headImg;
	}
	if(self.inServiceTime != nil){
		dictionary[kGBFindModelInServiceTime] = self.inServiceTime;
	}
	dictionary[kGBFindModelIncumbentDecryptId] = @(self.incumbentDecryptId);
	if(self.labelIds != nil){
		dictionary[kGBFindModelLabelIds] = self.labelIds;
	}
	if(self.labelNamesIds != nil){
		dictionary[kGBFindModelLabelNamesIds] = self.labelNamesIds;
	}
	dictionary[kGBFindModelLikeCount] = @(self.likeCount);
	if(self.nickName != nil){
		dictionary[kGBFindModelNickName] = self.nickName;
	}
	dictionary[kGBFindModelOrderCount] = @(self.orderCount);
	dictionary[kGBFindModelOriginalPrice] = @(self.originalPrice);
	if(self.positionName != nil){
		dictionary[kGBFindModelPositionName] = self.positionName;
	}
	dictionary[kGBFindModelPrice] = @(self.price);
	if(self.sex != nil){
		dictionary[kGBFindModelSex] = self.sex;
	}
	if(self.title != nil){
		dictionary[kGBFindModelTitle] = self.title;
	}
	if(self.types != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(GBType * typesElement in self.types){
			[dictionaryElements addObject:[typesElement toDictionary]];
		}
		dictionary[kGBFindModelTypes] = dictionaryElements;
	}
	dictionary[kGBFindModelUserId] = @(self.userId);
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.classifiedName != nil){
		[aCoder encodeObject:self.classifiedName forKey:kGBFindModelClassifiedName];
	}
	if(self.companyFullName != nil){
		[aCoder encodeObject:self.companyFullName forKey:kGBFindModelCompanyFullName];
	}
	if(self.companyName != nil){
		[aCoder encodeObject:self.companyName forKey:kGBFindModelCompanyName];
	}
	if(self.detail != nil){
		[aCoder encodeObject:self.detail forKey:kGBFindModelDetail];
	}
	[aCoder encodeObject:@(self.discountEnable) forKey:kGBFindModelDiscountEnable];	[aCoder encodeObject:@(self.evaluateRate) forKey:kGBFindModelEvaluateRate];	if(self.headImg != nil){
		[aCoder encodeObject:self.headImg forKey:kGBFindModelHeadImg];
	}
	if(self.inServiceTime != nil){
		[aCoder encodeObject:self.inServiceTime forKey:kGBFindModelInServiceTime];
	}
	[aCoder encodeObject:@(self.incumbentDecryptId) forKey:kGBFindModelIncumbentDecryptId];	if(self.labelIds != nil){
		[aCoder encodeObject:self.labelIds forKey:kGBFindModelLabelIds];
	}
	if(self.labelNamesIds != nil){
		[aCoder encodeObject:self.labelNamesIds forKey:kGBFindModelLabelNamesIds];
	}
	[aCoder encodeObject:@(self.likeCount) forKey:kGBFindModelLikeCount];	if(self.nickName != nil){
		[aCoder encodeObject:self.nickName forKey:kGBFindModelNickName];
	}
	[aCoder encodeObject:@(self.orderCount) forKey:kGBFindModelOrderCount];	[aCoder encodeObject:@(self.originalPrice) forKey:kGBFindModelOriginalPrice];	if(self.positionName != nil){
		[aCoder encodeObject:self.positionName forKey:kGBFindModelPositionName];
	}
	[aCoder encodeObject:@(self.price) forKey:kGBFindModelPrice];	if(self.sex != nil){
		[aCoder encodeObject:self.sex forKey:kGBFindModelSex];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kGBFindModelTitle];
	}
	if(self.types != nil){
		[aCoder encodeObject:self.types forKey:kGBFindModelTypes];
	}
	[aCoder encodeObject:@(self.userId) forKey:kGBFindModelUserId];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.classifiedName = [aDecoder decodeObjectForKey:kGBFindModelClassifiedName];
	self.companyFullName = [aDecoder decodeObjectForKey:kGBFindModelCompanyFullName];
	self.companyName = [aDecoder decodeObjectForKey:kGBFindModelCompanyName];
	self.detail = [aDecoder decodeObjectForKey:kGBFindModelDetail];
	self.discountEnable = [[aDecoder decodeObjectForKey:kGBFindModelDiscountEnable] boolValue];
	self.evaluateRate = [[aDecoder decodeObjectForKey:kGBFindModelEvaluateRate] integerValue];
	self.headImg = [aDecoder decodeObjectForKey:kGBFindModelHeadImg];
	self.inServiceTime = [aDecoder decodeObjectForKey:kGBFindModelInServiceTime];
	self.incumbentDecryptId = [[aDecoder decodeObjectForKey:kGBFindModelIncumbentDecryptId] integerValue];
	self.labelIds = [aDecoder decodeObjectForKey:kGBFindModelLabelIds];
	self.labelNamesIds = [aDecoder decodeObjectForKey:kGBFindModelLabelNamesIds];
	self.likeCount = [[aDecoder decodeObjectForKey:kGBFindModelLikeCount] integerValue];
	self.nickName = [aDecoder decodeObjectForKey:kGBFindModelNickName];
	self.orderCount = [[aDecoder decodeObjectForKey:kGBFindModelOrderCount] integerValue];
	self.originalPrice = [[aDecoder decodeObjectForKey:kGBFindModelOriginalPrice] integerValue];
	self.positionName = [aDecoder decodeObjectForKey:kGBFindModelPositionName];
	self.price = [[aDecoder decodeObjectForKey:kGBFindModelPrice] integerValue];
	self.sex = [aDecoder decodeObjectForKey:kGBFindModelSex];
	self.title = [aDecoder decodeObjectForKey:kGBFindModelTitle];
	self.types = [aDecoder decodeObjectForKey:kGBFindModelTypes];
	self.userId = [[aDecoder decodeObjectForKey:kGBFindModelUserId] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	GBFindModel *copy = [GBFindModel new];

	copy.classifiedName = [self.classifiedName copy];
	copy.companyFullName = [self.companyFullName copy];
	copy.companyName = [self.companyName copy];
	copy.detail = [self.detail copy];
	copy.discountEnable = self.discountEnable;
	copy.evaluateRate = self.evaluateRate;
	copy.headImg = [self.headImg copy];
	copy.inServiceTime = [self.inServiceTime copy];
	copy.incumbentDecryptId = self.incumbentDecryptId;
	copy.labelIds = [self.labelIds copy];
	copy.labelNamesIds = [self.labelNamesIds copy];
	copy.likeCount = self.likeCount;
	copy.nickName = [self.nickName copy];
	copy.orderCount = self.orderCount;
	copy.originalPrice = self.originalPrice;
	copy.positionName = [self.positionName copy];
	copy.price = self.price;
	copy.sex = [self.sex copy];
	copy.title = [self.title copy];
	copy.types = [self.types copy];
	copy.userId = self.userId;

	return copy;
}
@end