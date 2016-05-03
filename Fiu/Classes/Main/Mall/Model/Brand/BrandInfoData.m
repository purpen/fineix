//
//	BrandInfoData.m
// on 3/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "BrandInfoData.h"

@interface BrandInfoData ()
@end
@implementation BrandInfoData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[@"_id"];
	}	
	if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[@"cover_url"];
	}	
	if(![dictionary[@"created_at"] isKindOfClass:[NSNull class]]){
		self.createdAt = dictionary[@"created_at"];
	}	
	if(![dictionary[@"current_user_id"] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[@"current_user_id"] integerValue];
	}

	if(![dictionary[@"des"] isKindOfClass:[NSNull class]]){
		self.des = dictionary[@"des"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"used_count"] isKindOfClass:[NSNull class]]){
		self.usedCount = [dictionary[@"used_count"] integerValue];
	}

	return self;
}
@end