//
//	THNTradingInfo.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNTradingInfo.h"

NSString *const kTHNTradingInfoCurrentUserId = @"current_user_id";
NSString *const kTHNTradingInfoData = @"data";
NSString *const kTHNTradingInfoIsError = @"is_error";
NSString *const kTHNTradingInfoMessage = @"message";
NSString *const kTHNTradingInfoStatus = @"status";
NSString *const kTHNTradingInfoSuccess = @"success";

@interface THNTradingInfo ()
@end
@implementation THNTradingInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNTradingInfoCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNTradingInfoCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNTradingInfoData] isKindOfClass:[NSNull class]]){
		self.data = [[THNTradingInfoData alloc] initWithDictionary:dictionary[kTHNTradingInfoData]];
	}

	if(![dictionary[kTHNTradingInfoIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNTradingInfoIsError] boolValue];
	}

	if(![dictionary[kTHNTradingInfoMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNTradingInfoMessage];
	}	
	if(![dictionary[kTHNTradingInfoStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNTradingInfoStatus];
	}	
	if(![dictionary[kTHNTradingInfoSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNTradingInfoSuccess] boolValue];
	}

	return self;
}
@end
