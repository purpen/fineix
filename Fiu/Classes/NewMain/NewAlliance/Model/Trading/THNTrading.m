//
//	THNTrading.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNTrading.h"

NSString *const kTHNTradingCurrentUserId = @"current_user_id";
NSString *const kTHNTradingData = @"data";
NSString *const kTHNTradingIsError = @"is_error";
NSString *const kTHNTradingMessage = @"message";
NSString *const kTHNTradingStatus = @"status";
NSString *const kTHNTradingSuccess = @"success";

@interface THNTrading ()
@end
@implementation THNTrading




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNTradingCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNTradingCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNTradingData] isKindOfClass:[NSNull class]]){
		self.data = [[THNTradingData alloc] initWithDictionary:dictionary[kTHNTradingData]];
	}

	if(![dictionary[kTHNTradingIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNTradingIsError] boolValue];
	}

	if(![dictionary[kTHNTradingMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNTradingMessage];
	}	
	if(![dictionary[kTHNTradingStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNTradingStatus];
	}	
	if(![dictionary[kTHNTradingSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNTradingSuccess] boolValue];
	}

	return self;
}
@end