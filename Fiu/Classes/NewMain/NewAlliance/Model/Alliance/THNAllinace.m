//
//	THNAllinace.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNAllinace.h"

NSString *const kTHNAllinaceCurrentUserId = @"current_user_id";
NSString *const kTHNAllinaceData = @"data";
NSString *const kTHNAllinaceIsError = @"is_error";
NSString *const kTHNAllinaceMessage = @"message";
NSString *const kTHNAllinaceStatus = @"status";
NSString *const kTHNAllinaceSuccess = @"success";

@interface THNAllinace ()
@end
@implementation THNAllinace




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNAllinaceCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNAllinaceCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNAllinaceData] isKindOfClass:[NSNull class]]){
		self.data = [[THNAllinaceData alloc] initWithDictionary:dictionary[kTHNAllinaceData]];
	}

	if(![dictionary[kTHNAllinaceIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNAllinaceIsError] boolValue];
	}

	if(![dictionary[kTHNAllinaceMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNAllinaceMessage];
	}	
	if(![dictionary[kTHNAllinaceStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNAllinaceStatus];
	}	
	if(![dictionary[kTHNAllinaceSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNAllinaceSuccess] boolValue];
	}

	return self;
}
@end
