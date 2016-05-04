//
//	LikeOrSuPeopleRow.m
// on 3/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "LikeOrSuPeopleRow.h"

@interface LikeOrSuPeopleRow ()
@end
@implementation LikeOrSuPeopleRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[@"_id"];
	}	
	if(![dictionary[@"event"] isKindOfClass:[NSNull class]]){
		self.event = [dictionary[@"event"] integerValue];
	}

	if(![dictionary[@"ip"] isKindOfClass:[NSNull class]]){
		self.ip = dictionary[@"ip"];
	}	
	if(![dictionary[@"target_id"] isKindOfClass:[NSNull class]]){
		self.targetId = [dictionary[@"target_id"] integerValue];
	}

	if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[@"type"] integerValue];
	}

	if(![dictionary[@"user"] isKindOfClass:[NSNull class]]){
		self.user = [[LikeOrSuPeopleUser alloc] initWithDictionary:dictionary[@"user"]];
	}

	if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[@"user_id"] integerValue];
	}

	return self;
}
@end