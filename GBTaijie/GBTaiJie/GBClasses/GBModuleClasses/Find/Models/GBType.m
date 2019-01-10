//
//	GBType.m
//
//	Create by 小坤 刘 on 23/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "GBType.h"

NSString *const kGBTypeCode = @"code";
NSString *const kGBTypeIsCustomized = @"isCustomized";
NSString *const kGBTypeName = @"name";

@interface GBType ()
@end
@implementation GBType




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kGBTypeCode] isKindOfClass:[NSNull class]]){
		self.code = dictionary[kGBTypeCode];
	}	
	if(![dictionary[kGBTypeIsCustomized] isKindOfClass:[NSNull class]]){
		self.isCustomized = [dictionary[kGBTypeIsCustomized] boolValue];
	}

	if(![dictionary[kGBTypeName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kGBTypeName];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.code != nil){
		dictionary[kGBTypeCode] = self.code;
	}
	dictionary[kGBTypeIsCustomized] = @(self.isCustomized);
	if(self.name != nil){
		dictionary[kGBTypeName] = self.name;
	}
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
	if(self.code != nil){
		[aCoder encodeObject:self.code forKey:kGBTypeCode];
	}
	[aCoder encodeObject:@(self.isCustomized) forKey:kGBTypeIsCustomized];	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kGBTypeName];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.code = [aDecoder decodeObjectForKey:kGBTypeCode];
	self.isCustomized = [[aDecoder decodeObjectForKey:kGBTypeIsCustomized] boolValue];
	self.name = [aDecoder decodeObjectForKey:kGBTypeName];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	GBType *copy = [GBType new];

	copy.code = [self.code copy];
	copy.isCustomized = self.isCustomized;
	copy.name = [self.name copy];

	return copy;
}
@end