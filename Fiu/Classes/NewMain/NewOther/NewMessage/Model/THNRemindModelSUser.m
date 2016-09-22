//
//	THNRemindModelSUser.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNRemindModelSUser.h"

NSString *const kTHNRemindModelSUserIdField = @"_id";
NSString *const kTHNRemindModelSUserAvatarUrl = @"avatar_url";
NSString *const kTHNRemindModelSUserNickname = @"nickname";

@interface THNRemindModelSUser ()
@end
@implementation THNRemindModelSUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNRemindModelSUserIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNRemindModelSUserIdField] integerValue];
	}

	if(![dictionary[kTHNRemindModelSUserAvatarUrl] isKindOfClass:[NSNull class]]){
		self.avatarUrl = dictionary[kTHNRemindModelSUserAvatarUrl];
	}	
	if(![dictionary[kTHNRemindModelSUserNickname] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[kTHNRemindModelSUserNickname];
	}	
	return self;
}
@end