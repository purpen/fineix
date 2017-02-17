//
//	DominInfoUser.m
// on 17/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DominInfoUser.h"

NSString *const kDominInfoUserIdField = @"_id";
NSString *const kDominInfoUserAvatarUrl = @"avatar_url";
NSString *const kDominInfoUserExpertInfo = @"expert_info";
NSString *const kDominInfoUserExpertLabel = @"expert_label";
NSString *const kDominInfoUserIsExpert = @"is_expert";
NSString *const kDominInfoUserLabel = @"label";
NSString *const kDominInfoUserNickname = @"nickname";

@interface DominInfoUser ()
@end
@implementation DominInfoUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDominInfoUserIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kDominInfoUserIdField] integerValue];
	}

	if(![dictionary[kDominInfoUserAvatarUrl] isKindOfClass:[NSNull class]]){
		self.avatarUrl = dictionary[kDominInfoUserAvatarUrl];
	}	
	if(![dictionary[kDominInfoUserExpertInfo] isKindOfClass:[NSNull class]]){
		self.expertInfo = dictionary[kDominInfoUserExpertInfo];
	}	
	if(![dictionary[kDominInfoUserExpertLabel] isKindOfClass:[NSNull class]]){
		self.expertLabel = dictionary[kDominInfoUserExpertLabel];
	}	
	if(![dictionary[kDominInfoUserIsExpert] isKindOfClass:[NSNull class]]){
		self.isExpert = [dictionary[kDominInfoUserIsExpert] integerValue];
	}

	if(![dictionary[kDominInfoUserLabel] isKindOfClass:[NSNull class]]){
		self.label = dictionary[kDominInfoUserLabel];
	}	
	if(![dictionary[kDominInfoUserNickname] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[kDominInfoUserNickname];
	}	
	return self;
}
@end
