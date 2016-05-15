//
//	FiuPeopleUser.m
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FiuPeopleUser.h"

@interface FiuPeopleUser ()
@end
@implementation FiuPeopleUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"_id"] integerValue];
	}

	if(![dictionary[@"areas"] isKindOfClass:[NSNull class]]){
		self.areas = dictionary[@"areas"];
	}	
	if(![dictionary[@"birthday"] isKindOfClass:[NSNull class]]){
		self.birthday = dictionary[@"birthday"];
	}	
	if(![dictionary[@"counter"] isKindOfClass:[NSNull class]]){
		self.counter = [[FiuPeopleCounter alloc] initWithDictionary:dictionary[@"counter"]];
	}

	if(![dictionary[@"created_on"] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[@"created_on"] integerValue];
	}

	if(![dictionary[@"district_id"] isKindOfClass:[NSNull class]]){
		self.districtId = [dictionary[@"district_id"] integerValue];
	}

	if(![dictionary[@"fans_count"] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[@"fans_count"] integerValue];
	}

	if(![dictionary[@"first_login"] isKindOfClass:[NSNull class]]){
		self.firstLogin = [dictionary[@"first_login"] integerValue];
	}

	if(![dictionary[@"follow_count"] isKindOfClass:[NSNull class]]){
		self.followCount = [dictionary[@"follow_count"] integerValue];
	}

	if(![dictionary[@"identify"] isKindOfClass:[NSNull class]]){
		self.identify = [[FiuPeopleIdentify alloc] initWithDictionary:dictionary[@"identify"]];
	}

	if(![dictionary[@"im_qq"] isKindOfClass:[NSNull class]]){
		self.imQq = dictionary[@"im_qq"];
	}	
	if(![dictionary[@"is_love"] isKindOfClass:[NSNull class]]){
		self.isLove = [dictionary[@"is_love"] integerValue];
	}

	if(![dictionary[@"medium_avatar_url"] isKindOfClass:[NSNull class]]){
		self.mediumAvatarUrl = dictionary[@"medium_avatar_url"];
	}	
	if(![dictionary[@"nickname"] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[@"nickname"];
	}	
	if(![dictionary[@"province_id"] isKindOfClass:[NSNull class]]){
		self.provinceId = [dictionary[@"province_id"] integerValue];
	}

	if(![dictionary[@"scene_count"] isKindOfClass:[NSNull class]]){
		self.sceneCount = [dictionary[@"scene_count"] integerValue];
	}

	if(![dictionary[@"scene_sight"] isKindOfClass:[NSNull class]]){
		self.sceneSight = dictionary[@"scene_sight"];
	}	
	if(![dictionary[@"sex"] isKindOfClass:[NSNull class]]){
		self.sex = [dictionary[@"sex"] integerValue];
	}

	if(![dictionary[@"sight_count"] isKindOfClass:[NSNull class]]){
		self.sightCount = [dictionary[@"sight_count"] integerValue];
	}

	if(![dictionary[@"sight_love_count"] isKindOfClass:[NSNull class]]){
		self.sightLoveCount = [dictionary[@"sight_love_count"] integerValue];
	}

	if(![dictionary[@"state"] isKindOfClass:[NSNull class]]){
		self.state = [dictionary[@"state"] integerValue];
	}

	if(![dictionary[@"subscription_count"] isKindOfClass:[NSNull class]]){
		self.subscriptionCount = [dictionary[@"subscription_count"] integerValue];
	}

	if(![dictionary[@"summary"] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[@"summary"];
	}	
	if(![dictionary[@"true_nickname"] isKindOfClass:[NSNull class]]){
		self.trueNickname = dictionary[@"true_nickname"];
	}	
	if(![dictionary[@"weixin"] isKindOfClass:[NSNull class]]){
		self.weixin = dictionary[@"weixin"];
	}	
	return self;
}
@end