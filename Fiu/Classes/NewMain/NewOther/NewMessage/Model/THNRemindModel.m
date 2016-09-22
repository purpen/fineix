//
//	THNRemindModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNRemindModel.h"

NSString *const kTHNRemindModelCurrentUserId = @"current_user_id";
NSString *const kTHNRemindModelData = @"data";
NSString *const kTHNRemindModelIsError = @"is_error";
NSString *const kTHNRemindModelMessage = @"message";
NSString *const kTHNRemindModelStatus = @"status";
NSString *const kTHNRemindModelSuccess = @"success";

@interface THNRemindModel ()
@end
@implementation THNRemindModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNRemindModelCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNRemindModelCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNRemindModelData] isKindOfClass:[NSNull class]]){
		self.data = [[THNRemindModelData alloc] initWithDictionary:dictionary[kTHNRemindModelData]];
	}

	if(![dictionary[kTHNRemindModelIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNRemindModelIsError] boolValue];
	}

	if(![dictionary[kTHNRemindModelMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNRemindModelMessage];
	}	
	if(![dictionary[kTHNRemindModelStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNRemindModelStatus];
	}	
	if(![dictionary[kTHNRemindModelSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNRemindModelSuccess] boolValue];
	}

	return self;
}
@end