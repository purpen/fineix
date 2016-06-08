//
//	SceneInfoUserInfo.m
// on 25/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "SceneInfoUserInfo.h"

@interface SceneInfoUserInfo ()
@end
@implementation SceneInfoUserInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"account"] isKindOfClass:[NSNull class]]){
		self.account = dictionary[@"account"];
	}	
	if(![dictionary[@"avatar_url"] isKindOfClass:[NSNull class]]){
		self.avatarUrl = dictionary[@"avatar_url"];
	}	
	if(![dictionary[@"counter"] isKindOfClass:[NSNull class]]){
		self.counter = [[SceneInfoCounter alloc] initWithDictionary:dictionary[@"counter"]];
	}

	if(![dictionary[@"fans_count"] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[@"fans_count"] integerValue];
	}

	if(![dictionary[@"follow_count"] isKindOfClass:[NSNull class]]){
		self.followCount = [dictionary[@"follow_count"] integerValue];
	}

	if(![dictionary[@"love_count"] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[@"love_count"] integerValue];
	}

	if(![dictionary[@"nickname"] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[@"nickname"];
	}	
	if(![dictionary[@"summary"] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[@"summary"];
	}	
	if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[@"user_id"] integerValue];
	}
    if(![dictionary[@"is_expert"] isKindOfClass:[NSNull class]]){
        self.isExpert = [dictionary[@"is_expert"] integerValue];
    }
    
    if(![dictionary[@"label"] isKindOfClass:[NSNull class]]){
        self.userLable = dictionary[@"label"];
    }
    
    if(![dictionary[@"expert_label"] isKindOfClass:[NSNull class]]){
        self.expertLabel = dictionary[@"expert_label"];
    }
    
    if(![dictionary[@"expert_info"] isKindOfClass:[NSNull class]]){
        self.expertInfo = dictionary[@"expert_info"];
    }
	if(![dictionary[@"user_rank"] isKindOfClass:[NSNull class]]){
		self.userRank = dictionary[@"user_rank"];
	}	
	return self;
}
@end