//
//	THNBalance.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNBalance.h"

NSString *const kTHNBalanceCurrentUserId = @"current_user_id";
NSString *const kTHNBalanceData = @"data";
NSString *const kTHNBalanceIsError = @"is_error";
NSString *const kTHNBalanceMessage = @"message";
NSString *const kTHNBalanceStatus = @"status";
NSString *const kTHNBalanceSuccess = @"success";

@interface THNBalance ()
@end
@implementation THNBalance




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNBalanceCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNBalanceCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNBalanceData] isKindOfClass:[NSNull class]]){
		self.data = [[THNBalanceData alloc] initWithDictionary:dictionary[kTHNBalanceData]];
	}

	if(![dictionary[kTHNBalanceIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNBalanceIsError] boolValue];
	}

	if(![dictionary[kTHNBalanceMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNBalanceMessage];
	}	
	if(![dictionary[kTHNBalanceStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNBalanceStatus];
	}	
	if(![dictionary[kTHNBalanceSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNBalanceSuccess] boolValue];
	}

	return self;
}
@end