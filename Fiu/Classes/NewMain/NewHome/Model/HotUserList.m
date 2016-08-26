//
//	HotUserList.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HotUserList.h"

NSString *const kHotUserListCurrentUserId = @"current_user_id";
NSString *const kHotUserListData = @"data";
NSString *const kHotUserListIsError = @"is_error";
NSString *const kHotUserListMessage = @"message";
NSString *const kHotUserListStatus = @"status";
NSString *const kHotUserListSuccess = @"success";

@interface HotUserList ()
@end
@implementation HotUserList




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHotUserListCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kHotUserListCurrentUserId] integerValue];
	}

	if(![dictionary[kHotUserListData] isKindOfClass:[NSNull class]]){
		self.data = [[HotUserListData alloc] initWithDictionary:dictionary[kHotUserListData]];
	}

	if(![dictionary[kHotUserListIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kHotUserListIsError] boolValue];
	}

	if(![dictionary[kHotUserListMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kHotUserListMessage];
	}	
	if(![dictionary[kHotUserListStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kHotUserListStatus];
	}	
	if(![dictionary[kHotUserListSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kHotUserListSuccess] boolValue];
	}

	return self;
}
@end