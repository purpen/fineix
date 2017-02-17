//
//	DominInfo.m
// on 17/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DominInfo.h"

NSString *const kDominInfoCurrentUserId = @"current_user_id";
NSString *const kDominInfoData = @"data";
NSString *const kDominInfoIsError = @"is_error";
NSString *const kDominInfoMessage = @"message";
NSString *const kDominInfoStatus = @"status";
NSString *const kDominInfoSuccess = @"success";

@interface DominInfo ()
@end
@implementation DominInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDominInfoCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kDominInfoCurrentUserId] integerValue];
	}

	if(![dictionary[kDominInfoData] isKindOfClass:[NSNull class]]){
		self.data = [[DominInfoData alloc] initWithDictionary:dictionary[kDominInfoData]];
	}

	if(![dictionary[kDominInfoIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kDominInfoIsError] boolValue];
	}

	if(![dictionary[kDominInfoMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kDominInfoMessage];
	}	
	if(![dictionary[kDominInfoStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kDominInfoStatus];
	}	
	if(![dictionary[kDominInfoSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kDominInfoSuccess] boolValue];
	}

	return self;
}
@end
