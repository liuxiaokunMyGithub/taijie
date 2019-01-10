//
//	GBBannerModel.m
//
//	Create by 小坤 刘 on 26/6/2018
//	Copyright © 2018. All rights reserved.

#import "GBBannerModel.h"

NSString *const kGBBannerModelAdvertisementId = @"advertisementId";
NSString *const kGBBannerModelAdvertisementImg = @"advertisementImg";
NSString *const kGBBannerModelTitle = @"title";
NSString *const kGBBannerModelType = @"type";
NSString *const kGBBannerModelUrl = @"url";

@interface GBBannerModel ()
@end
@implementation GBBannerModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kGBBannerModelAdvertisementId] isKindOfClass:[NSNull class]]){
		self.advertisementId = [dictionary[kGBBannerModelAdvertisementId] integerValue];
	}

	if(![dictionary[kGBBannerModelAdvertisementImg] isKindOfClass:[NSNull class]]){
		self.advertisementImg = dictionary[kGBBannerModelAdvertisementImg];
	}	
	if(![dictionary[kGBBannerModelTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kGBBannerModelTitle];
	}	
	if(![dictionary[kGBBannerModelType] isKindOfClass:[NSNull class]]){
		self.type = dictionary[kGBBannerModelType];
	}	
	if(![dictionary[kGBBannerModelUrl] isKindOfClass:[NSNull class]]){
		self.url = dictionary[kGBBannerModelUrl];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kGBBannerModelAdvertisementId] = @(self.advertisementId);
	if(self.advertisementImg != nil){
		dictionary[kGBBannerModelAdvertisementImg] = self.advertisementImg;
	}
	if(self.title != nil){
		dictionary[kGBBannerModelTitle] = self.title;
	}
	if(self.type != nil){
		dictionary[kGBBannerModelType] = self.type;
	}
	if(self.url != nil){
		dictionary[kGBBannerModelUrl] = self.url;
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
	[aCoder encodeObject:@(self.advertisementId) forKey:kGBBannerModelAdvertisementId];	if(self.advertisementImg != nil){
		[aCoder encodeObject:self.advertisementImg forKey:kGBBannerModelAdvertisementImg];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kGBBannerModelTitle];
	}
	if(self.type != nil){
		[aCoder encodeObject:self.type forKey:kGBBannerModelType];
	}
	if(self.url != nil){
		[aCoder encodeObject:self.url forKey:kGBBannerModelUrl];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.advertisementId = [[aDecoder decodeObjectForKey:kGBBannerModelAdvertisementId] integerValue];
	self.advertisementImg = [aDecoder decodeObjectForKey:kGBBannerModelAdvertisementImg];
	self.title = [aDecoder decodeObjectForKey:kGBBannerModelTitle];
	self.type = [aDecoder decodeObjectForKey:kGBBannerModelType];
	self.url = [aDecoder decodeObjectForKey:kGBBannerModelUrl];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	GBBannerModel *copy = [GBBannerModel new];

	copy.advertisementId = self.advertisementId;
	copy.advertisementImg = [self.advertisementImg copy];
	copy.title = [self.title copy];
	copy.type = [self.type copy];
	copy.url = [self.url copy];

	return copy;
}
@end
