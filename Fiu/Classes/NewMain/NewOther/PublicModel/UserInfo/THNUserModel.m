//
//	THNUserModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNUserModel.h"

NSString *const kTHNUserModelCurrentUserId = @"current_user_id";
NSString *const kTHNUserModelData = @"data";
NSString *const kTHNUserModelIsError = @"is_error";
NSString *const kTHNUserModelMessage = @"message";
NSString *const kTHNUserModelStatus = @"status";
NSString *const kTHNUserModelSuccess = @"success";

@interface THNUserModel ()
@end
@implementation THNUserModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNUserModelCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNUserModelCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNUserModelData] isKindOfClass:[NSNull class]]){
		self.data = [[THNUserModelData alloc] initWithDictionary:dictionary[kTHNUserModelData]];
	}

	if(![dictionary[kTHNUserModelIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNUserModelIsError] boolValue];
	}

	if(![dictionary[kTHNUserModelMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNUserModelMessage];
	}	
	if(![dictionary[kTHNUserModelStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNUserModelStatus];
	}	
	if(![dictionary[kTHNUserModelSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNUserModelSuccess] boolValue];
	}

	return self;
}
@end