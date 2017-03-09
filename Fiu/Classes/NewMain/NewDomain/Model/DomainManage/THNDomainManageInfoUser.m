//
//	THNDomainManageInfoUser.m
// on 9/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDomainManageInfoUser.h"

NSString *const kTHNDomainManageInfoUserIdField = @"_id";
NSString *const kTHNDomainManageInfoUserAvatarUrl = @"avatar_url";
NSString *const kTHNDomainManageInfoUserExpertInfo = @"expert_info";
NSString *const kTHNDomainManageInfoUserExpertLabel = @"expert_label";
NSString *const kTHNDomainManageInfoUserIsExpert = @"is_expert";
NSString *const kTHNDomainManageInfoUserLabel = @"label";
NSString *const kTHNDomainManageInfoUserNickname = @"nickname";

@interface THNDomainManageInfoUser ()
@end
@implementation THNDomainManageInfoUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDomainManageInfoUserIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNDomainManageInfoUserIdField] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoUserAvatarUrl] isKindOfClass:[NSNull class]]){
		self.avatarUrl = dictionary[kTHNDomainManageInfoUserAvatarUrl];
	}	
	if(![dictionary[kTHNDomainManageInfoUserExpertInfo] isKindOfClass:[NSNull class]]){
		self.expertInfo = dictionary[kTHNDomainManageInfoUserExpertInfo];
	}	
	if(![dictionary[kTHNDomainManageInfoUserExpertLabel] isKindOfClass:[NSNull class]]){
		self.expertLabel = dictionary[kTHNDomainManageInfoUserExpertLabel];
	}	
	if(![dictionary[kTHNDomainManageInfoUserIsExpert] isKindOfClass:[NSNull class]]){
		self.isExpert = [dictionary[kTHNDomainManageInfoUserIsExpert] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoUserLabel] isKindOfClass:[NSNull class]]){
		self.label = dictionary[kTHNDomainManageInfoUserLabel];
	}	
	if(![dictionary[kTHNDomainManageInfoUserNickname] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[kTHNDomainManageInfoUserNickname];
	}	
	return self;
}
@end