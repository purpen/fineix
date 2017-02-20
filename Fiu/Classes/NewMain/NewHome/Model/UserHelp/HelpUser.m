//
//	HelpUser.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HelpUser.h"

NSString *const kHelpUserCurrentUserId = @"current_user_id";
NSString *const kHelpUserData = @"data";
NSString *const kHelpUserIsError = @"is_error";
NSString *const kHelpUserMessage = @"message";
NSString *const kHelpUserStatus = @"status";
NSString *const kHelpUserSuccess = @"success";

@interface HelpUser ()
@end
@implementation HelpUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHelpUserCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kHelpUserCurrentUserId] integerValue];
	}

	if(![dictionary[kHelpUserData] isKindOfClass:[NSNull class]]){
		self.data = [[HelpUserData alloc] initWithDictionary:dictionary[kHelpUserData]];
	}

	if(![dictionary[kHelpUserIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kHelpUserIsError] boolValue];
	}

	if(![dictionary[kHelpUserMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kHelpUserMessage];
	}	
	if(![dictionary[kHelpUserStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kHelpUserStatus];
	}	
	if(![dictionary[kHelpUserSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kHelpUserSuccess] boolValue];
	}

	return self;
}
@end
