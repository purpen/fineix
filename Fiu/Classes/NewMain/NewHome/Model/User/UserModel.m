//
//	UserModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "UserModel.h"

NSString *const kUserModelCurrentUserId = @"current_user_id";
NSString *const kUserModelData = @"data";
NSString *const kUserModelIsError = @"is_error";
NSString *const kUserModelMessage = @"message";
NSString *const kUserModelStatus = @"status";
NSString *const kUserModelSuccess = @"success";

@interface UserModel ()
@end
@implementation UserModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kUserModelCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kUserModelCurrentUserId] integerValue];
	}

	if(![dictionary[kUserModelData] isKindOfClass:[NSNull class]]){
		self.data = [[UserModelData alloc] initWithDictionary:dictionary[kUserModelData]];
	}

	if(![dictionary[kUserModelIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kUserModelIsError] boolValue];
	}

	if(![dictionary[kUserModelMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kUserModelMessage];
	}	
	if(![dictionary[kUserModelStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kUserModelStatus];
	}	
	if(![dictionary[kUserModelSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kUserModelSuccess] boolValue];
	}

	return self;
}
@end