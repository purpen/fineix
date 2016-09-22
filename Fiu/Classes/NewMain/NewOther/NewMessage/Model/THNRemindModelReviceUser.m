//
//	THNRemindModelReviceUser.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNRemindModelReviceUser.h"

NSString *const kTHNRemindModelReviceUserIdField = @"_id";
NSString *const kTHNRemindModelReviceUserAvatarUrl = @"avatar_url";
NSString *const kTHNRemindModelReviceUserNickname = @"nickname";

@interface THNRemindModelReviceUser ()
@end
@implementation THNRemindModelReviceUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNRemindModelReviceUserIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNRemindModelReviceUserIdField] integerValue];
	}

	if(![dictionary[kTHNRemindModelReviceUserAvatarUrl] isKindOfClass:[NSNull class]]){
		self.avatarUrl = dictionary[kTHNRemindModelReviceUserAvatarUrl];
	}	
	if(![dictionary[kTHNRemindModelReviceUserNickname] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[kTHNRemindModelReviceUserNickname];
	}	
	return self;
}
@end