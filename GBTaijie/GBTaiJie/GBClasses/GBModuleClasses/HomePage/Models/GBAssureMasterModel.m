//
//	GBAssureMasterModel.m
//
//	Create by 小坤 刘 on 15/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "GBAssureMasterModel.h"

NSString *const kGBAssureMasterModelAssureCount = @"assureCount";
NSString *const kGBAssureMasterModelBadgeAuth = @"badgeAuth";
NSString *const kGBAssureMasterModelCollectCount = @"collectCount";
NSString *const kGBAssureMasterModelCompanyEmailAuth = @"companyEmailAuth";
NSString *const kGBAssureMasterModelCompanyLogo = @"companyLogo";
NSString *const kGBAssureMasterModelCompanyName = @"companyName";
NSString *const kGBAssureMasterModelDecryptCount = @"decryptCount";
NSString *const kGBAssureMasterModelEvaluateCount = @"evaluateCount";
NSString *const kGBAssureMasterModelEvaluateRate = @"evaluateRate";
NSString *const kGBAssureMasterModelEvaluateStar = @"evaluateStar";
NSString *const kGBAssureMasterModelHasAssure = @"hasAssure";
NSString *const kGBAssureMasterModelHasDecrypt = @"hasDecrypt";
NSString *const kGBAssureMasterModelHelpCount = @"helpCount";
NSString *const kGBAssureMasterModelIdField = @"id";
NSString *const kGBAssureMasterModelIncumbencyAuth = @"incumbencyAuth";
NSString *const kGBAssureMasterModelLaborContractAuth = @"laborContractAuth";
NSString *const kGBAssureMasterModelPositionName = @"positionName";
NSString *const kGBAssureMasterModelRealNameAuth = @"realNameAuth";

@interface GBAssureMasterModel ()
@end
@implementation GBAssureMasterModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kGBAssureMasterModelAssureCount] isKindOfClass:[NSNull class]]){
		self.assureCount = [dictionary[kGBAssureMasterModelAssureCount] integerValue];
	}

	if(![dictionary[kGBAssureMasterModelBadgeAuth] isKindOfClass:[NSNull class]]){
		self.badgeAuth = [dictionary[kGBAssureMasterModelBadgeAuth] boolValue];
	}

	if(![dictionary[kGBAssureMasterModelCollectCount] isKindOfClass:[NSNull class]]){
		self.collectCount = [dictionary[kGBAssureMasterModelCollectCount] integerValue];
	}

	if(![dictionary[kGBAssureMasterModelCompanyEmailAuth] isKindOfClass:[NSNull class]]){
		self.companyEmailAuth = [dictionary[kGBAssureMasterModelCompanyEmailAuth] boolValue];
	}

	if(![dictionary[kGBAssureMasterModelCompanyLogo] isKindOfClass:[NSNull class]]){
		self.companyLogo = dictionary[kGBAssureMasterModelCompanyLogo];
	}	
	if(![dictionary[kGBAssureMasterModelCompanyName] isKindOfClass:[NSNull class]]){
		self.companyName = dictionary[kGBAssureMasterModelCompanyName];
	}	
	if(![dictionary[kGBAssureMasterModelDecryptCount] isKindOfClass:[NSNull class]]){
		self.decryptCount = [dictionary[kGBAssureMasterModelDecryptCount] integerValue];
	}

	if(![dictionary[kGBAssureMasterModelEvaluateCount] isKindOfClass:[NSNull class]]){
		self.evaluateCount = [dictionary[kGBAssureMasterModelEvaluateCount] integerValue];
	}

	if(![dictionary[kGBAssureMasterModelEvaluateRate] isKindOfClass:[NSNull class]]){
		self.evaluateRate = dictionary[kGBAssureMasterModelEvaluateRate];
	}	
	if(![dictionary[kGBAssureMasterModelEvaluateStar] isKindOfClass:[NSNull class]]){
		self.evaluateStar = [dictionary[kGBAssureMasterModelEvaluateStar] integerValue];
	}

	if(![dictionary[kGBAssureMasterModelHasAssure] isKindOfClass:[NSNull class]]){
		self.hasAssure = [dictionary[kGBAssureMasterModelHasAssure] boolValue];
	}

	if(![dictionary[kGBAssureMasterModelHasDecrypt] isKindOfClass:[NSNull class]]){
		self.hasDecrypt = [dictionary[kGBAssureMasterModelHasDecrypt] boolValue];
	}

	if(![dictionary[kGBAssureMasterModelHelpCount] isKindOfClass:[NSNull class]]){
		self.helpCount = [dictionary[kGBAssureMasterModelHelpCount] integerValue];
	}

	if(![dictionary[kGBAssureMasterModelIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kGBAssureMasterModelIdField] integerValue];
	}

	if(![dictionary[kGBAssureMasterModelIncumbencyAuth] isKindOfClass:[NSNull class]]){
		self.incumbencyAuth = [dictionary[kGBAssureMasterModelIncumbencyAuth] boolValue];
	}

	if(![dictionary[kGBAssureMasterModelLaborContractAuth] isKindOfClass:[NSNull class]]){
		self.laborContractAuth = [dictionary[kGBAssureMasterModelLaborContractAuth] boolValue];
	}

	if(![dictionary[kGBAssureMasterModelPositionName] isKindOfClass:[NSNull class]]){
		self.positionName = dictionary[kGBAssureMasterModelPositionName];
	}	
	if(![dictionary[kGBAssureMasterModelRealNameAuth] isKindOfClass:[NSNull class]]){
		self.realNameAuth = [dictionary[kGBAssureMasterModelRealNameAuth] boolValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kGBAssureMasterModelAssureCount] = @(self.assureCount);
	dictionary[kGBAssureMasterModelBadgeAuth] = @(self.badgeAuth);
	dictionary[kGBAssureMasterModelCollectCount] = @(self.collectCount);
	dictionary[kGBAssureMasterModelCompanyEmailAuth] = @(self.companyEmailAuth);
	if(self.companyLogo != nil){
		dictionary[kGBAssureMasterModelCompanyLogo] = self.companyLogo;
	}
	if(self.companyName != nil){
		dictionary[kGBAssureMasterModelCompanyName] = self.companyName;
	}
	dictionary[kGBAssureMasterModelDecryptCount] = @(self.decryptCount);
	dictionary[kGBAssureMasterModelEvaluateCount] = @(self.evaluateCount);
	if(self.evaluateRate != nil){
		dictionary[kGBAssureMasterModelEvaluateRate] = self.evaluateRate;
	}
	dictionary[kGBAssureMasterModelEvaluateStar] = @(self.evaluateStar);
	dictionary[kGBAssureMasterModelHasAssure] = @(self.hasAssure);
	dictionary[kGBAssureMasterModelHasDecrypt] = @(self.hasDecrypt);
	dictionary[kGBAssureMasterModelHelpCount] = @(self.helpCount);
	dictionary[kGBAssureMasterModelIdField] = @(self.idField);
	dictionary[kGBAssureMasterModelIncumbencyAuth] = @(self.incumbencyAuth);
	dictionary[kGBAssureMasterModelLaborContractAuth] = @(self.laborContractAuth);
	if(self.positionName != nil){
		dictionary[kGBAssureMasterModelPositionName] = self.positionName;
	}
	dictionary[kGBAssureMasterModelRealNameAuth] = @(self.realNameAuth);
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
	[aCoder encodeObject:@(self.assureCount) forKey:kGBAssureMasterModelAssureCount];	[aCoder encodeObject:@(self.badgeAuth) forKey:kGBAssureMasterModelBadgeAuth];	[aCoder encodeObject:@(self.collectCount) forKey:kGBAssureMasterModelCollectCount];	[aCoder encodeObject:@(self.companyEmailAuth) forKey:kGBAssureMasterModelCompanyEmailAuth];	if(self.companyLogo != nil){
		[aCoder encodeObject:self.companyLogo forKey:kGBAssureMasterModelCompanyLogo];
	}
	if(self.companyName != nil){
		[aCoder encodeObject:self.companyName forKey:kGBAssureMasterModelCompanyName];
	}
	[aCoder encodeObject:@(self.decryptCount) forKey:kGBAssureMasterModelDecryptCount];	[aCoder encodeObject:@(self.evaluateCount) forKey:kGBAssureMasterModelEvaluateCount];	if(self.evaluateRate != nil){
		[aCoder encodeObject:self.evaluateRate forKey:kGBAssureMasterModelEvaluateRate];
	}
	[aCoder encodeObject:@(self.evaluateStar) forKey:kGBAssureMasterModelEvaluateStar];	[aCoder encodeObject:@(self.hasAssure) forKey:kGBAssureMasterModelHasAssure];	[aCoder encodeObject:@(self.hasDecrypt) forKey:kGBAssureMasterModelHasDecrypt];	[aCoder encodeObject:@(self.helpCount) forKey:kGBAssureMasterModelHelpCount];	[aCoder encodeObject:@(self.idField) forKey:kGBAssureMasterModelIdField];	[aCoder encodeObject:@(self.incumbencyAuth) forKey:kGBAssureMasterModelIncumbencyAuth];	[aCoder encodeObject:@(self.laborContractAuth) forKey:kGBAssureMasterModelLaborContractAuth];	if(self.positionName != nil){
		[aCoder encodeObject:self.positionName forKey:kGBAssureMasterModelPositionName];
	}
	[aCoder encodeObject:@(self.realNameAuth) forKey:kGBAssureMasterModelRealNameAuth];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.assureCount = [[aDecoder decodeObjectForKey:kGBAssureMasterModelAssureCount] integerValue];
	self.badgeAuth = [[aDecoder decodeObjectForKey:kGBAssureMasterModelBadgeAuth] boolValue];
	self.collectCount = [[aDecoder decodeObjectForKey:kGBAssureMasterModelCollectCount] integerValue];
	self.companyEmailAuth = [[aDecoder decodeObjectForKey:kGBAssureMasterModelCompanyEmailAuth] boolValue];
	self.companyLogo = [aDecoder decodeObjectForKey:kGBAssureMasterModelCompanyLogo];
	self.companyName = [aDecoder decodeObjectForKey:kGBAssureMasterModelCompanyName];
	self.decryptCount = [[aDecoder decodeObjectForKey:kGBAssureMasterModelDecryptCount] integerValue];
	self.evaluateCount = [[aDecoder decodeObjectForKey:kGBAssureMasterModelEvaluateCount] integerValue];
	self.evaluateRate = [aDecoder decodeObjectForKey:kGBAssureMasterModelEvaluateRate];
	self.evaluateStar = [[aDecoder decodeObjectForKey:kGBAssureMasterModelEvaluateStar] integerValue];
	self.hasAssure = [[aDecoder decodeObjectForKey:kGBAssureMasterModelHasAssure] boolValue];
	self.hasDecrypt = [[aDecoder decodeObjectForKey:kGBAssureMasterModelHasDecrypt] boolValue];
	self.helpCount = [[aDecoder decodeObjectForKey:kGBAssureMasterModelHelpCount] integerValue];
	self.idField = [[aDecoder decodeObjectForKey:kGBAssureMasterModelIdField] integerValue];
	self.incumbencyAuth = [[aDecoder decodeObjectForKey:kGBAssureMasterModelIncumbencyAuth] boolValue];
	self.laborContractAuth = [[aDecoder decodeObjectForKey:kGBAssureMasterModelLaborContractAuth] boolValue];
	self.positionName = [aDecoder decodeObjectForKey:kGBAssureMasterModelPositionName];
	self.realNameAuth = [[aDecoder decodeObjectForKey:kGBAssureMasterModelRealNameAuth] boolValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	GBAssureMasterModel *copy = [GBAssureMasterModel new];

	copy.assureCount = self.assureCount;
	copy.badgeAuth = self.badgeAuth;
	copy.collectCount = self.collectCount;
	copy.companyEmailAuth = self.companyEmailAuth;
	copy.companyLogo = [self.companyLogo copy];
	copy.companyName = [self.companyName copy];
	copy.decryptCount = self.decryptCount;
	copy.evaluateCount = self.evaluateCount;
	copy.evaluateRate = [self.evaluateRate copy];
	copy.evaluateStar = self.evaluateStar;
	copy.hasAssure = self.hasAssure;
	copy.hasDecrypt = self.hasDecrypt;
	copy.helpCount = self.helpCount;
	copy.idField = self.idField;
	copy.incumbencyAuth = self.incumbencyAuth;
	copy.laborContractAuth = self.laborContractAuth;
	copy.positionName = [self.positionName copy];
	copy.realNameAuth = self.realNameAuth;

	return copy;
}
@end